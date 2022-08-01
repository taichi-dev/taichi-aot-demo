#include <chrono>
#include <iostream>
#include <signal.h>
#include <inttypes.h>
#include <unistd.h>

#include "mpm88.hpp"

#include "taichi_core_impl.h"
#include "taichi/taichi_core.h"
#include "taichi/taichi_vulkan.h"

namespace demo {
namespace {
constexpr int kNrParticles = 8192 * 2;
constexpr int kNGrid = 128;
    
static taichi::Arch get_taichi_arch(const std::string& arch_name_) {
    if(arch_name_ == "cuda") {
        return taichi::Arch::cuda;
    }

    if(arch_name_ == "x64") {
        return taichi::Arch::x64;
    }
    
    if(arch_name_ == "vulkan") {
        return taichi::Arch::vulkan;
    }

    TI_ERROR("Unkown arch_name");
    return taichi::Arch::x64;
}
  
static TiArch get_c_api_arch(const std::string& arch_name_) {
    if(arch_name_ == "cuda") {
        return TiArch::TI_ARCH_CUDA;
    }

    if(arch_name_ == "x64") {
        return TiArch::TI_ARCH_X64;
    }
    
    if(arch_name_ == "vulkan") {
        return TiArch::TI_ARCH_VULKAN;
    }
    
    TI_ERROR("Unkown arch_name");
    return TiArch::TI_ARCH_X64;
}
  
static taichi::ui::FieldSource get_field_source(const std::string& arch_name_) {
    if(arch_name_ == "cuda") {
        return taichi::ui::FieldSource::TaichiCuda;
    }

    if(arch_name_ == "x64") {
        return taichi::ui::FieldSource::TaichiX64;
    }
    
    if(arch_name_ == "vulkan") {
        return taichi::ui::FieldSource::TaichiVulkan;
    }
    
    TI_ERROR("Unkown arch_name");
    return taichi::ui::FieldSource::TaichiX64;
}

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
  MPM88DemoImpl(const std::string& aot_path,
                TiArch arch,
                taichi::lang::vulkan::VulkanDevice * vk_device) {
    InitTaichiRuntime(arch, vk_device);

    module_ = ti_load_aot_module(runtime_, aot_path.c_str());

    g_init_ = ti_get_aot_module_compute_graph(module_, "init");
    g_update_ = ti_get_aot_module_compute_graph(module_, "update");

    // Prepare Ndarray for model
    const std::vector<int> vec2_shape = {2};
    const std::vector<int> vec3_shape = {3};
    const std::vector<int> mat2_shape = {2, 2};

    x_ = NdarrayAndMem::Make(runtime_,
                             TiDataType::TI_DATA_TYPE_F32,
                             {kNrParticles}, vec2_shape,
                             /*host_read=*/true, /*host_write=*/true);
    v_ = NdarrayAndMem::Make(runtime_,
                             TiDataType::TI_DATA_TYPE_F32,
                             {kNrParticles}, vec2_shape);
    pos_ = NdarrayAndMem::Make(runtime_, 
                             TiDataType::TI_DATA_TYPE_F32,
                               {kNrParticles}, vec3_shape);
    C_ = NdarrayAndMem::Make(runtime_,
                             TiDataType::TI_DATA_TYPE_F32,
                             {kNrParticles}, mat2_shape);
    J_ = NdarrayAndMem::Make(runtime_,
                             TiDataType::TI_DATA_TYPE_F32,
                             {kNrParticles});

    grid_v_ = NdarrayAndMem::Make(runtime_,
                                  TiDataType::TI_DATA_TYPE_F32,
                                  {kNGrid, kNGrid}, vec2_shape);
    grid_m_ = NdarrayAndMem::Make(runtime_,
                                  TiDataType::TI_DATA_TYPE_F32,
                                  {kNGrid, kNGrid});
    TiNamedArgument x_named_arg = {.name = "x", .argument = x_->argument()};
    args_.emplace_back(std::move(x_named_arg));
    TiNamedArgument v_named_arg = {.name = "v", .argument = v_->argument()};
    args_.emplace_back(std::move(v_named_arg));
    TiNamedArgument J_named_arg = {.name = "J", .argument = J_->argument()};
    args_.emplace_back(std::move(J_named_arg));
    TiNamedArgument C_named_arg = {.name = "C", .argument = C_->argument()};
    args_.emplace_back(std::move(C_named_arg));
    TiNamedArgument grid_v_named_arg = {.name = "grid_v", .argument = grid_v_->argument()};
    args_.emplace_back(std::move(grid_v_named_arg));
    TiNamedArgument grid_m_named_arg = {.name = "grid_m", .argument = grid_m_->argument()};
    args_.emplace_back(std::move(grid_m_named_arg));
    TiNamedArgument pos_named_arg = {.name = "pos", .argument = pos_->argument()};
    args_.emplace_back(std::move(pos_named_arg));

    Reset();
  }

  ~MPM88DemoImpl() {
      ti_destroy_aot_module(module_);
      ti_destroy_runtime(runtime_);
  }

  void Reset() {
    ti_launch_compute_graph(runtime_, g_init_, args_.size(), args_.data());
    ti_wait(runtime_);

    // For debugging
    //auto arr = ReadDataToHost<float>(x_->devalloc(), x_->ndarray().get_nelement() * x_->ndarray().get_element_size());
    //for (int i = 0; i < arr.size(); i++) {
    //  std::cout << arr[i] << std::endl;
    //}
  }

  void Step() {
    ti_launch_compute_graph(runtime_, g_update_, args_.size(), args_.data());
    ti_wait(runtime_);
  }

  taichi::lang::DeviceAllocation pos() { return pos_->devalloc(); }

private:
  class NdarrayAndMem {
  public:
    NdarrayAndMem() = default;
    ~NdarrayAndMem() { }

    const TiArgument& argument() const { return arr_arg_; }

    taichi::lang::DeviceAllocation devalloc() { 
      Runtime* real_runtime = (Runtime *)runtime_;
      return devmem2devalloc(*real_runtime, memory_);
    }

    static std::unique_ptr<NdarrayAndMem>
    Make(TiRuntime runtime, 
         TiDataType dtype,
         const std::vector<int> &arr_shape,
         const std::vector<int> &element_shape = {}, bool host_read = false,
         bool host_write = false) {
      // TODO: Cannot use data_type_size() until
      // https://github.com/taichi-dev/taichi/pull/5220.
      // uint64_t_t alloc_size = taichi::lang::data_type_size(dtype);
      uint64_t alloc_size = 1;
      TI_ASSERT(dtype == TiDataType::TI_DATA_TYPE_F32 || dtype == TiDataType::TI_DATA_TYPE_I32 || dtype == TiDataType::TI_DATA_TYPE_U32);
      alloc_size = 4;

      for (int s : arr_shape) {
        alloc_size *= s;
      }
      for (int s : element_shape) {
        alloc_size *= s;
      }
      
      auto res = std::make_unique<NdarrayAndMem>();
      res->runtime_ = runtime;
      
      TiMemoryAllocateInfo alloc_info;
      alloc_info.size = alloc_size;
      alloc_info.host_write = false;
      alloc_info.host_read = false;
      alloc_info.export_sharing = false;
      alloc_info.usage = TiMemoryUsageFlagBits::TI_MEMORY_USAGE_STORAGE_BIT;

      res->memory_ = ti_allocate_memory(res->runtime_, &alloc_info);
      
      TiNdShape shape;
      shape.dim_count = static_cast<uint32_t>(arr_shape.size());
      for(size_t i = 0; i < arr_shape.size(); i++) {
        shape.dims[i] = arr_shape[i];
      }
      
      TiNdShape e_shape;
      e_shape.dim_count = static_cast<uint32_t>(element_shape.size());
      for(size_t i = 0; i < element_shape.size(); i++) {
        e_shape.dims[i] = element_shape[i];
      }

      TiNdArray arg_array = {.memory = res->memory_,
                             .shape = std::move(shape),
                             .elem_shape = std::move(e_shape),
                             .elem_type = dtype};

      TiArgumentValue arg_value = {.ndarray = std::move(arg_array)};
        
      res->arr_arg_ = {.type = TiArgumentType::TI_ARGUMENT_TYPE_NDARRAY,
                             .value = std::move(arg_value)};

      return res;
    }

  private:
    TiRuntime runtime_;
    TiMemory memory_;
    TiArgument arr_arg_;
  };

  void InitTaichiRuntime(TiArch arch, taichi::lang::vulkan::VulkanDevice * vk_device) {
    if(arch == TiArch::TI_ARCH_VULKAN) {
      interop_info.api_version =
          vk_device->get_cap(taichi::lang::DeviceCapability::vk_api_version);
      interop_info.instance = vk_device->vk_instance();
      interop_info.physical_device = vk_device->vk_physical_device();
      interop_info.device = vk_device->vk_device();
      interop_info.compute_queue = vk_device->compute_queue();
      interop_info.compute_queue_family_index = vk_device->compute_queue_family_index();
      interop_info.graphics_queue = vk_device->graphics_queue();
      interop_info.graphics_queue_family_index = vk_device->graphics_queue_family_index();

      runtime_ = ti_import_vulkan_runtime(&interop_info);

    } else {
        runtime_ = ti_create_runtime(arch);
    }
  }

  TiRuntime runtime_;
  TiAotModule module_{nullptr};
  TiVulkanRuntimeInteropInfo interop_info;
  
  std::unique_ptr<NdarrayAndMem> x_{nullptr};
  std::unique_ptr<NdarrayAndMem> v_{nullptr};
  std::unique_ptr<NdarrayAndMem> J_{nullptr};
  std::unique_ptr<NdarrayAndMem> C_{nullptr};
  std::unique_ptr<NdarrayAndMem> grid_v_{nullptr};
  std::unique_ptr<NdarrayAndMem> grid_m_{nullptr};
  std::unique_ptr<NdarrayAndMem> pos_{nullptr};
  TiComputeGraph g_init_{nullptr};
  TiComputeGraph g_update_{nullptr};
  
  std::vector<TiNamedArgument> args_;

};

MPM88Demo::MPM88Demo(const std::string& aot_path,
                     const std::string& arch_name) {
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
  app_config.ti_arch = get_taichi_arch(arch_name);
  app_config.is_packed_mode = true;

  // Create GUI & renderer
  renderer = std::make_unique<taichi::ui::vulkan::Renderer>();
  renderer->init(nullptr, window, app_config);

  renderer->set_background_color({0.6, 0.6, 0.6});

  gui_ = std::make_shared<taichi::ui::vulkan::Gui>(
      &renderer->app_context(), &renderer->swap_chain(), window);

  taichi::lang::vulkan::VulkanDevice *device =
      &(renderer->app_context().device());

  // Create Taichi Device for computation
  impl_ = std::make_unique<MPM88DemoImpl>(aot_path, get_c_api_arch(arch_name), device);

  // Describe information to render the circle with Vulkan
  f_info.valid = true;
  f_info.field_type = taichi::ui::FieldType::Scalar;
  f_info.matrix_rows = 1;
  f_info.matrix_cols = 1;
  f_info.shape = {kNrParticles};
  f_info.field_source = get_field_source(arch_name);
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
  assert(argc == 3);
  std::string aot_path = argv[1];
  std::string arch_name = argv[2];
  
  auto mpm88_demo = std::make_unique<demo::MPM88Demo>(aot_path, arch_name);
  mpm88_demo->Step();

  return 0;
}
