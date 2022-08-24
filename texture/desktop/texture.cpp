#include <chrono>
#include <iostream>
#include <signal.h>

#include "texture.hpp"

#include <inttypes.h>
#include <taichi/aot/graph_data.h>
#include <taichi/rhi/vulkan/vulkan_common.h>
#include <taichi/rhi/vulkan/vulkan_loader.h>
#include <taichi/runtime/gfx/aot_module_loader_impl.h>
#include <taichi/runtime/program_impls/vulkan/vulkan_program.h>
#include <unistd.h>

namespace demo {

namespace{
constexpr int kX = 512;
constexpr int kY = 512;
constexpr int kTextureWidth = 128;
constexpr int kTextureHeight = 128;

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
}

class TextureDemoImpl {
public:
  TextureDemoImpl(taichi::lang::vulkan::VulkanDevice *device) : device_(device) {
    InitTaichiRuntime(device_);

    taichi::lang::gfx::AotModuleParams mod_params;
    mod_params.module_path = "../shaders/";
    mod_params.runtime = vulkan_runtime.get();
    module = taichi::lang::aot::Module::load(taichi::Arch::vulkan, mod_params);

    auto root_size = module->get_root_size();
    vulkan_runtime->add_root_buffer(root_size);

    // load graph
    g_update_ = module->get_graph("g");
    g_init_ = module->get_graph("g_init");

    const std::vector<int> vec4_shape = {4};

    pixels_ = NdarrayAndMem::Make(device_, taichi::lang::PrimitiveType::f32, {kX, kY}, vec4_shape);

    auto buffer_format = taichi::lang::BufferFormat::rgba8;
    taichi::lang::ImageParams img_params;
    img_params.dimension = taichi::lang::ImageDimension::d2D;
    img_params.format = buffer_format;
    img_params.x = kTextureHeight;
    img_params.y = kTextureWidth;
    img_params.z = 1;
    img_params.initial_layout = taichi::lang::ImageLayout::undefined;

    //taichi::lang::DeviceAllocation devalloc_tex = device_->create_image(img_params);
    taichi::lang::DeviceAllocation devalloc_tex = vulkan_runtime->create_image(img_params);
    tex_ = std::make_unique<taichi::lang::Texture>(devalloc_tex, buffer_format,
        kTextureWidth, kTextureHeight);

    args_.insert({"pixels_arr", taichi::lang::aot::IValue::create(pixels_->ndarray())});
    args_.insert({"tex", taichi::lang::aot::IValue::create(*tex_)});
    args_.insert({"rw_tex", taichi::lang::aot::IValue::create(*tex_)});
    args_.insert({"t", taichi::lang::aot::IValue::create<float>(t_)});
    Reset();
  }

  ~TextureDemoImpl() {
  }



  void debugPixel() {
    // For debugging
    auto arr = ReadDataToHost<float>(pixels_->devalloc(), pixels_->ndarray().get_nelement() * pixels_->ndarray().get_element_size());
    for (int i = 0; i < arr.size(); i++) {
     std::cout << arr[i] << std::endl;
    }
  }

  void Reset() {
    g_init_->run(args_);
    vulkan_runtime->synchronize();
    // debugPixel();
  }

  void Step() {
    t_ += 0.03;
    args_.at("t") = taichi::lang::aot::IValue::create<float>(t_);
    g_update_->run(args_);
    //vulkan_runtime->synchronize();
    //debugPixel();
  }

  const taichi::lang::DeviceAllocation &pixels() { return pixels_->devalloc(); }
private:
  class NdarrayAndMem {
  public:
    NdarrayAndMem() = default;
    ~NdarrayAndMem() { device_->dealloc_memory(devalloc_); }

    const taichi::lang::Ndarray &ndarray() const { return *ndarray_; }

    taichi::lang::DeviceAllocation &devalloc() { return devalloc_; }

    static std::unique_ptr<NdarrayAndMem>
    Make(taichi::lang::Device *device, taichi::lang::DataType dtype,
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
      taichi::lang::Device::AllocParams alloc_params;
      alloc_params.host_read = host_read;
      alloc_params.host_write = host_write;
      alloc_params.size = alloc_size;
      alloc_params.usage = taichi::lang::AllocUsage::Storage;
      auto res = std::make_unique<NdarrayAndMem>();
      res->device_ = device;
      res->devalloc_ = device->allocate_memory(alloc_params);
      res->ndarray_ = std::make_unique<taichi::lang::Ndarray>(
          res->devalloc_, dtype, arr_shape, element_shape);
      return res;
    }

  private:
    taichi::lang::Device *device_{nullptr};
    std::unique_ptr<taichi::lang::Ndarray> ndarray_{nullptr};
    taichi::lang::DeviceAllocation devalloc_;
  };

  void InitTaichiRuntime(taichi::lang::vulkan::VulkanDevice *device_) {
    // Create Vulkan runtime
    taichi::lang::gfx::GfxRuntime::Params params;
    result_buffer_.resize(taichi_result_buffer_entries);
    params.host_result_buffer = result_buffer_.data();
    params.device = device_;
    vulkan_runtime =
        std::make_unique<taichi::lang::gfx::GfxRuntime>(std::move(params));
  }

  std::unique_ptr<taichi::lang::vulkan::VulkanDeviceCreator> embedded_device_{
      nullptr};
  taichi::lang::vulkan::VulkanDevice *device_{nullptr};
  std::vector<uint64_t> result_buffer_;
  std::unique_ptr<taichi::lang::gfx::GfxRuntime> vulkan_runtime{nullptr};

  std::unique_ptr<taichi::lang::aot::Module> module{nullptr};
  float t_ = 0;
  std::unique_ptr<NdarrayAndMem> pixels_{nullptr};
  std::unique_ptr<taichi::lang::Texture> tex_{nullptr};

  std::unique_ptr<taichi::lang::aot::CompiledGraph> g_init_{nullptr};
  std::unique_ptr<taichi::lang::aot::CompiledGraph> g_update_{nullptr};

  std::unordered_map<std::string, taichi::lang::aot::IValue> args_;
};

TextureDemo::TextureDemo() {
  // Init gl window
  glfwInit();
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  window = glfwCreateWindow(kX, kY, "Taichi show", NULL, NULL);
  if (window == NULL) {
    std::cout << "Failed to create GLFW window" << std::endl;
    glfwTerminate();
  }

  // Create a GGUI configuration
  taichi::ui::AppConfig app_config;
  app_config.name = "TextureDemo";
  app_config.width = kX;
  app_config.height = kY;
  app_config.vsync = true;
  app_config.show_window = false;
  app_config.package_path = "../"; // make it flexible later
  app_config.ti_arch = taichi::Arch::vulkan;

  // Create GUI & renderer
  renderer = std::make_unique<taichi::ui::vulkan::Renderer>();
  renderer->init(nullptr, window, app_config);

  renderer->set_background_color({0.6, 0.6, 0.6});

  gui_ = std::make_shared<taichi::ui::vulkan::Gui>(
      &renderer->app_context(), &renderer->swap_chain(), window);

  // Create Taichi Device for computation
  taichi::lang::vulkan::VulkanDevice *device_ =
      &(renderer->app_context().device());

  impl_ = std::make_unique<TextureDemoImpl>(device_);

  // Describe information to render the circle with Vulkan
  f_info.valid = true;
  f_info.field_type = taichi::ui::FieldType::Scalar;
  f_info.matrix_rows = 1;
  f_info.matrix_cols = 1;
  f_info.shape = {kX, kY};
  f_info.field_source = taichi::ui::FieldSource::TaichiVulkan;
  f_info.dtype = taichi::lang::PrimitiveType::f32;
  f_info.snode = nullptr;
  f_info.dev_alloc = impl_->pixels();

  set_image_info.img = f_info;
}

void TextureDemo::Step() {
  while (!glfwWindowShouldClose(window)) {
    impl_->Step();

    // Render elements
    renderer->set_image(set_image_info);
    renderer->draw_frame(gui_.get());
    renderer->swap_chain().surface().present_image();
    renderer->prepare_for_next_frame();

    glfwSwapBuffers(window);
    glfwPollEvents();
  }
}

TextureDemo::~TextureDemo() {
    impl_.reset();
    gui_.reset();
    renderer.reset();
}
}

int main() {
  auto texture_demo = std::make_unique<demo::TextureDemo>();
  texture_demo->Step();

  return 0;
}
