#include <cstdlib>
#include <utility>
#include <sstream>
#include <iostream>
#include <string>
#include <assert.h>

// C-API
#include "taichi_core_impl.h"
#include "taichi/taichi_core.h"

// GUI
#include <taichi/ui/gui/gui.h>
#include <taichi/ui/backends/vulkan/renderer.h>

constexpr int img_h = 680;
constexpr int img_w = 680;
constexpr int img_c = 4;

static taichi::Arch get_taichi_arch(const std::string& arch_name_) {
    if(arch_name_ == "cuda") {
        return taichi::Arch::cuda;
    }

    if(arch_name_ == "x64") {
        return taichi::Arch::x64;
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
    
    TI_ERROR("Unkown arch_name");
    return taichi::ui::FieldSource::TaichiX64;
}


struct guiHelper {
    std::shared_ptr<taichi::ui::vulkan::Gui> gui_{nullptr};
    std::unique_ptr<taichi::ui::vulkan::Renderer> renderer{nullptr};
    GLFWwindow *window{nullptr};
    taichi::ui::SetImageInfo img_info;

    explicit guiHelper(taichi::lang::DeviceAllocation& devalloc, 
                       const std::string& arch_name) {
      glfwInit();
      glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
      window = glfwCreateWindow(img_h, img_w, "Taichi show", NULL, NULL);
      if (window == NULL) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
      }
    
      // Create a GGUI configuration
      taichi::ui::AppConfig app_config;
      app_config.name = "TaichiSparse";
      app_config.width = img_w;
      app_config.height = img_h;
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

      // Describe information to render the image
      taichi::ui::FieldInfo f_info;
      f_info.valid = true;
      f_info.field_type = taichi::ui::FieldType::Scalar;
      f_info.matrix_rows = 1;
      f_info.matrix_cols = 1;
      f_info.shape = { img_h, img_w, img_c };

      f_info.field_source = get_field_source(arch_name);
      f_info.dtype = taichi::lang::PrimitiveType::f32;
      f_info.snode = nullptr;
      f_info.dev_alloc = devalloc;
      
      img_info.img = std::move(f_info);
    }

    void step() {
      if (!glfwWindowShouldClose(window)) {
        // Render elements
        renderer->set_image(img_info);
        renderer->draw_frame(gui_.get());
        renderer->swap_chain().surface().present_image();
        renderer->prepare_for_next_frame();

        glfwSwapBuffers(window);
        glfwPollEvents();
      }
    }

    ~guiHelper() {
      gui_.reset();
      renderer.reset();
    }
};

static void comet_run(const std::string& arch_name, const std::string& folder_dir) {
  TiRuntime runtime = ti_create_runtime(get_c_api_arch(arch_name));

  // Load Aot and Kernel
  TiAotModule aot_mod = ti_load_aot_module(runtime, folder_dir.c_str());

  TiComputeGraph g_init = ti_get_aot_module_compute_graph(aot_mod, "init");
  TiComputeGraph g_update = ti_get_aot_module_compute_graph(aot_mod, "update");
  
  constexpr uint32_t arg_count = 1;
  
  // k_img_to_ndarray(args)
  TiMemoryAllocateInfo alloc_info;
  alloc_info.size = img_h * img_w * img_c * sizeof(float);
  alloc_info.host_write = false;
  alloc_info.host_read = false;
  alloc_info.export_sharing = false;
  alloc_info.usage = TiMemoryUsageFlagBits::TI_MEMORY_USAGE_STORAGE_BIT;

  TiMemory memory = ti_allocate_memory(runtime, &alloc_info);
  TiNdArray arg_array = {.memory = memory,
                         .shape = {.dim_count = 3, .dims = {img_h, img_w, img_c}},
                         .elem_shape = {.dim_count = 0, .dims = {0}},
                         .elem_type = TiDataType::TI_DATA_TYPE_F32};

  TiArgumentValue arg_value = {.ndarray = std::move(arg_array)};

  TiArgument arr_arg = {.type = TiArgumentType::TI_ARGUMENT_TYPE_NDARRAY,
                         .value = std::move(arg_value)};
  TiNamedArgument arr_named_arg = { .name = "arr", .argument = std::move(arr_arg) };;
  TiNamedArgument args[1] = { std::move(arr_named_arg) };

  Runtime* real_runtime = (Runtime *)runtime;
  taichi::lang::DeviceAllocation devalloc = devmem2devalloc(*real_runtime, memory);
  guiHelper gui_helper(devalloc, arch_name);

  ti_launch_compute_graph(runtime, g_init, 0, &args[0]);
  ti_wait(runtime);
  for (int i = 0; i < 10000; i++) {
    ti_launch_compute_graph(runtime, g_update, 1, &args[0]); 
    ti_wait(runtime);
    
    gui_helper.step();
  }

  ti_destroy_aot_module(aot_mod);
  ti_destroy_runtime(runtime);
}

int main(int argc, char *argv[]) {
    assert(argc == 3);
    std::string folder_dir = argv[1];
    std::string arch_name = argv[2];

    comet_run(arch_name, folder_dir);

    return 0;
}
