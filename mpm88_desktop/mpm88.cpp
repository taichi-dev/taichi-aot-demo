#include <chrono>
#include <iostream>
#include <signal.h>
#include <inttypes.h>
#include <unistd.h>

#include "mpm88.hpp"
#include <taichi/aot/graph_data.h>
#include <taichi/runtime/cuda/aot_module_loader_impl.h>
#include <taichi/runtime/llvm/llvm_runtime_executor.h>
#include <taichi/rhi/cuda/cuda_driver.h>

//#include <taichi/rhi/vulkan/vulkan_common.h>
//#include <taichi/rhi/vulkan/vulkan_loader.h>
//#include <taichi/runtime/gfx/aot_module_loader_impl.h>
//#include <taichi/runtime/program_impls/vulkan/vulkan_program.h>

namespace demo {
namespace {
constexpr int kNrParticles = 8192 * 2;
constexpr int kNGrid = 128;

template <typename T>
std::vector<T> ReadDataToHost(taichi::lang::DeviceAllocation &alloc,
                    size_t size) {
  taichi::lang::Device::AllocParams alloc_params;
  alloc_params.host_write = false;
  alloc_params.host_read = true;
  alloc_params.size = size;
  alloc_params.usage = taichi::lang::AllocUsage::Storage;
  auto staging_buf = alloc.device->allocate_memory(alloc_params);
  alloc.device->memcpy_internal(staging_buf.get_ptr(), alloc.get_ptr(), size);

  char *const device_arr_ptr =
      reinterpret_cast<char *>(alloc.device->map(staging_buf));
  TI_ASSERT(device_arr_ptr);

  size_t n = size /  sizeof(T);
  std::vector<T> arr(n);

  std::memcpy(arr.data(), device_arr_ptr, size);
  alloc.device->unmap(staging_buf);
  alloc.device->dealloc_memory(staging_buf);
  return arr;
}
} // namespace

class MPM88DemoImpl {
public:
  MPM88DemoImpl(const std::string& aot_path) {
    InitTaichiRuntime();

    taichi::lang::cuda::AotModuleParams mod_params;
    mod_params.module_path = aot_path.c_str();
    mod_params.executor_ = llvm_runtime_.get();
    module_ = cuda::make_aot_module(mod_params);

    g_init_ = module_->get_graph("init");
    g_update_ = module_->get_graph("update");

    // Prepare Ndarray for model
    const std::vector<int> vec2_shape = {2};
    const std::vector<int> vec3_shape = {3};
    const std::vector<int> mat2_shape = {2, 2};

    x_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_, 
                             taichi::lang::PrimitiveType::f32,
                             {kNrParticles}, vec2_shape,
                             /*host_read=*/true, /*host_write=*/true);
    v_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_, 
                             taichi::lang::PrimitiveType::f32,
                             {kNrParticles}, vec2_shape);
    pos_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_,
                               taichi::lang::PrimitiveType::f32,
                               {kNrParticles}, vec3_shape);
    C_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_,
                             taichi::lang::PrimitiveType::f32,
                             {kNrParticles}, mat2_shape);
    J_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_, 
                             taichi::lang::PrimitiveType::f32,
                             {kNrParticles});

    grid_v_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_, 
                                  taichi::lang::PrimitiveType::f32,
                                  {kNGrid, kNGrid}, vec2_shape);
    grid_m_ = NdarrayAndMem::Make(llvm_runtime_.get(), result_buffer_, 
                                  taichi::lang::PrimitiveType::f32,
                                  {kNGrid, kNGrid});

    args_.insert({"x", taichi::lang::aot::IValue::create(x_->ndarray())});
    args_.insert({"v", taichi::lang::aot::IValue::create(v_->ndarray())});
    args_.insert({"J", taichi::lang::aot::IValue::create(J_->ndarray())});
    args_.insert({"C", taichi::lang::aot::IValue::create(C_->ndarray())});
    args_.insert(
        {"grid_v", taichi::lang::aot::IValue::create(grid_v_->ndarray())});
    args_.insert(
        {"grid_m", taichi::lang::aot::IValue::create(grid_m_->ndarray())});
    args_.insert({"pos", taichi::lang::aot::IValue::create(pos_->ndarray())});

    Reset();
  }

  ~MPM88DemoImpl() {}

  void Reset() {
    g_init_->run(args_);
    llvm_runtime_->synchronize();

    // For debugging
    //auto arr = ReadDataToHost<float>(x_->devalloc(), x_->ndarray().get_nelement() * x_->ndarray().get_element_size());
    //for (int i = 0; i < arr.size(); i++) {
    //  std::cout << arr[i] << std::endl;
    //}
  }

  void Step() {
    g_update_->run(args_);
    llvm_runtime_->synchronize();
  }

  const taichi::lang::DeviceAllocation &pos() { return pos_->devalloc(); }

private:
  class NdarrayAndMem {
  public:
    NdarrayAndMem() = default;
    ~NdarrayAndMem() { }

    const taichi::lang::Ndarray &ndarray() const { return *ndarray_; }

    taichi::lang::DeviceAllocation &devalloc() { return devalloc_; }

    static std::unique_ptr<NdarrayAndMem>
    Make(taichi::lang::LlvmRuntimeExecutor* executor, 
         uint64* result_buffer,
         taichi::lang::DataType dtype,
         const std::vector<int> &arr_shape,
         const std::vector<int> &element_shape = {}, bool host_read = false,
         bool host_write = false) {
      // TODO: Cannot use data_type_size() until
      // https://github.com/taichi-dev/taichi/pull/5220.
      // uint64_t alloc_size = taichi::lang::data_type_size(dtype);
      uint64_t alloc_size = 1;
      if (auto *prim = dtype->as<taichi::lang::PrimitiveType>()) {
        using PT = taichi::lang::PrimitiveType;
        if (prim == PT::f32 || prim == PT::i32 || prim == PT::u32) {
          alloc_size = 4;
        } else {
          TI_ERROR("Unsupported bit width!");
          return nullptr;
        }
      } else {
        TI_ERROR("Non primitive type!");
        return nullptr;
      }
      for (int s : arr_shape) {
        alloc_size *= s;
      }
      for (int s : element_shape) {
        alloc_size *= s;
      }
      
      auto res = std::make_unique<NdarrayAndMem>();
      res->executor_ = executor;
      res->devalloc_ = executor->allocate_memory_ndarray(alloc_size, result_buffer);
      res->ndarray_ = std::make_unique<taichi::lang::Ndarray>(
          res->devalloc_, dtype, arr_shape, element_shape);
      return res;
    }

  private:
    taichi::lang::LlvmRuntimeExecutor *executor_{nullptr};
    std::unique_ptr<taichi::lang::Ndarray> ndarray_{nullptr};
    taichi::lang::DeviceAllocation devalloc_;
  };

  void InitTaichiRuntime() {
    // Create Vulkan runtime
    cfg_.arch = Arch::cuda;
    cfg_.kernel_profiler = false;
    constexpr KernelProfilerBase *kNoProfiler = nullptr;
    llvm_runtime_ = std::make_unique<taichi::lang::LlvmRuntimeExecutor>(cfg, kNoProfiler);
    llvm_runtime_->materialize_runtime(nullptr, kNoProfiler, &result_buffer_);
  }

  taichi::lang::CompileConfig cfg_;
  uint64* result_buffer_;
  std::unique_ptr<taichi::lang::LlvmRuntimeExecutor> llvm_runtime_{nullptr};

  std::unique_ptr<taichi::lang::aot::Module> module_{nullptr};
  std::unique_ptr<NdarrayAndMem> x_{nullptr};
  std::unique_ptr<NdarrayAndMem> v_{nullptr};
  std::unique_ptr<NdarrayAndMem> J_{nullptr};
  std::unique_ptr<NdarrayAndMem> C_{nullptr};
  std::unique_ptr<NdarrayAndMem> grid_v_{nullptr};
  std::unique_ptr<NdarrayAndMem> grid_m_{nullptr};
  std::unique_ptr<NdarrayAndMem> pos_{nullptr};
  std::unique_ptr<taichi::lang::aot::CompiledGraph> g_init_{nullptr};
  std::unique_ptr<taichi::lang::aot::CompiledGraph> g_update_{nullptr};

  std::unordered_map<std::string, taichi::lang::aot::IValue> args_;
};

MPM88Demo::MPM88Demo(const std::string& aot_path) {
  // Init gl window
  glfwInit();
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  window = glfwCreateWindow(512, 512, "Taichi show", NULL, NULL);
  if (window == NULL) {
    std::cout << "Failed to create GLFW window" << std::endl;
    glfwTerminate();
  }

  // Create a GGUI configuration
  taichi::ui::AppConfig app_config;
  app_config.name = "MPM88";
  app_config.width = 512;
  app_config.height = 512;
  app_config.vsync = true;
  app_config.show_window = false;
  app_config.package_path = "."; // make it flexible later
  app_config.ti_arch = taichi::Arch::cuda;
  app_config.is_packed_mode = true;

  // Create GUI & renderer
  renderer = std::make_unique<taichi::ui::vulkan::Renderer>();
  renderer->init(nullptr, window, app_config);

  renderer->set_background_color({0.6, 0.6, 0.6});

  gui_ = std::make_shared<taichi::ui::vulkan::Gui>(
      &renderer->app_context(), &renderer->swap_chain(), window);

  // Create Taichi Device for computation
  impl_ = std::make_unique<MPM88DemoImpl>(aot_path);

  // Describe information to render the circle with Vulkan
  f_info.valid = true;
  f_info.field_type = taichi::ui::FieldType::Scalar;
  f_info.matrix_rows = 1;
  f_info.matrix_cols = 1;
  f_info.shape = {kNrParticles};
  f_info.field_source = taichi::ui::FieldSource::TaichiCuda;
  f_info.dtype = taichi::lang::PrimitiveType::f32;
  f_info.snode = nullptr;
  f_info.dev_alloc = impl_->pos();

  circles.renderable_info.has_per_vertex_color = false;
  circles.renderable_info.vbo_attrs = taichi::ui::VertexAttributes::kPos;
  circles.renderable_info.vbo = f_info;
  circles.color = {0.8, 0.4, 0.1};
  circles.radius = 0.005f; // 0.0015f looks unclear on desktop
}

void MPM88Demo::Step() {
  while (!glfwWindowShouldClose(window)) {
    impl_->Step();

    // Render elements
    renderer->circles(circles);
    renderer->draw_frame(gui_.get());
    renderer->swap_chain().surface().present_image();
    renderer->prepare_for_next_frame();

    glfwSwapBuffers(window);
    glfwPollEvents();
  }
}

MPM88Demo::~MPM88Demo() {
  impl_.reset();
  gui_.reset();
  // renderer owns the device so it must be destructed last.
  renderer.reset();
}

} // namespace demo

int main(int argc, char *argv[]) {
  assert(argc == 2);
  std::string aot_path = argv[1];
  
  auto mpm88_demo = std::make_unique<demo::MPM88Demo>(aot_path);
  mpm88_demo->Step();

  return 0;
}
