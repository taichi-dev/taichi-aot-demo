#include <chrono>
#include <iostream>
#include <signal.h>
#include <inttypes.h>
#include <unistd.h>
#include <memory>
#include <vector>

#include <taichi/ui/gui/gui.h>
#include <taichi/ui/backends/vulkan/renderer.h>
#include "taichi_core_impl.h"
#include "c_api_test_utils.h"
#include "taichi/taichi_core.h"
#include "taichi/taichi_vulkan.h"

#define NR_PARTICLES 8000

#include <unistd.h>

constexpr int SUBSTEPS = 5;

static taichi::lang::DeviceAllocation get_devalloc(TiRuntime runtime, TiMemory memory) {
      Runtime* real_runtime = (Runtime *)runtime;
      return devmem2devalloc(*real_runtime, memory);
}

static taichi::lang::DeviceAllocation get_ndarray_with_imported_memory(TiRuntime runtime,
                                                                       TiDataType dtype,
                                                                       std::vector<int> arr_shape,
                                                                       std::vector<int> element_shape,
                                                                       taichi::lang::vulkan::VulkanDevice * vk_device,
                                                                       capi::utils::TiNdarrayAndMem& ndarray) {
      assert(dtype == TiDataType::TI_DATA_TYPE_F32);
      size_t alloc_size = 4;

      TiNdShape shape;
      shape.dim_count = static_cast<uint32_t>(arr_shape.size());
      for(size_t i = 0; i < arr_shape.size(); i++) {
        alloc_size *= arr_shape[i];
        shape.dims[i] = arr_shape[i];
      }
      
      TiNdShape e_shape;
      e_shape.dim_count = static_cast<uint32_t>(element_shape.size());
      for(size_t i = 0; i < element_shape.size(); i++) {
        alloc_size *= element_shape[i];
        e_shape.dims[i] = element_shape[i];
      }
      
      taichi::lang::Device::AllocParams alloc_params;
      alloc_params.host_read = false;
      alloc_params.host_write = false;
      alloc_params.size = alloc_size;
      alloc_params.usage = taichi::lang::AllocUsage::Storage;
      
      auto res = vk_device->allocate_memory(alloc_params);

      TiVulkanMemoryInteropInfo interop_info;
      interop_info.buffer = vk_device->get_vkbuffer(res).get()->buffer;
      interop_info.size = vk_device->get_vkbuffer(res).get()->size;
      interop_info.usage = vk_device->get_vkbuffer(res).get()->usage;
    
      ndarray.runtime_ = runtime;
      ndarray.memory_ = ti_import_vulkan_memory(ndarray.runtime_, &interop_info);

      TiNdArray arg_array = {.memory = ndarray.memory_,
                             .shape = std::move(shape),
                             .elem_shape = std::move(e_shape),
                             .elem_type = dtype};

      TiArgumentValue arg_value = {.ndarray = std::move(arg_array)};
        
      ndarray.arg_ = {.type = TiArgumentType::TI_ARGUMENT_TYPE_NDARRAY,
                             .value = std::move(arg_value)};
      
      return res;
}



static taichi::Arch get_taichi_arch(TiArch arch) {
    switch(arch) {
        case TiArch::TI_ARCH_VULKAN: {
            return taichi::Arch::vulkan;
        }
        case TiArch::TI_ARCH_X64: {
            return taichi::Arch::x64;
        }
        case TiArch::TI_ARCH_CUDA: {
            return taichi::Arch::cuda;
        }
        default: {
            return taichi::Arch::x64;
        }
    }
}

static taichi::ui::FieldSource get_field_source(TiArch arch) {
    switch(arch) {
        case TiArch::TI_ARCH_VULKAN: {
            return taichi::ui::FieldSource::TaichiVulkan;
        }
        case TiArch::TI_ARCH_X64: {
            return taichi::ui::FieldSource::TaichiX64;
        }
        case TiArch::TI_ARCH_CUDA: {
            return taichi::ui::FieldSource::TaichiCuda;
        }
        default: {
            return taichi::ui::FieldSource::TaichiX64;
        }
    }
}


void run(TiArch arch, const std::string& folder_dir) {
    /* --------------------- */
    /* Render Initialization */
    /* --------------------- */
    // Init gl window
    glfwInit();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    GLFWwindow* window = glfwCreateWindow(512, 512, "Taichi show", NULL, NULL);
    if (window == NULL) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return;
    }

    // Create a GGUI configuration
    taichi::ui::AppConfig app_config;
    app_config.name         = "SPH";
    app_config.width        = 512;
    app_config.height       = 512;
    app_config.vsync        = true;
    app_config.show_window  = false;
    app_config.package_path = "."; // make it flexible later
    app_config.ti_arch      = get_taichi_arch(arch);

    // Create GUI & renderer
    auto renderer  = std::make_unique<taichi::ui::vulkan::Renderer>();
    renderer->init(nullptr, window, app_config);

    /* ---------------------------------- */
    /* Runtime & Arguments Initialization */
    /* ---------------------------------- */
    TiRuntime runtime = ti_create_runtime(arch);

    // Load Aot and Kernel
    TiAotModule aot_mod = ti_load_aot_module(runtime, folder_dir.c_str());
    
    TiKernel k_initialize = ti_get_aot_module_kernel(aot_mod, "initialize");
    TiKernel k_initialize_particle = ti_get_aot_module_kernel(aot_mod, "initialize_particle");
    TiKernel k_update_density = ti_get_aot_module_kernel(aot_mod, "update_density");
    TiKernel k_update_force = ti_get_aot_module_kernel(aot_mod, "update_force");
    TiKernel k_advance = ti_get_aot_module_kernel(aot_mod, "advance");
    TiKernel k_boundary_handle = ti_get_aot_module_kernel(aot_mod, "boundary_handle");
   
    const std::vector<int> shape_1d = {NR_PARTICLES};
    const std::vector<int> vec3_shape = {3};
    
    auto N_ = capi::utils::make_ndarray(runtime,
                           TiDataType::TI_DATA_TYPE_I32,
                           shape_1d.data(), 1,
                           vec3_shape.data(), 1,
                           false /*host_read*/, false /*host_write*/
                           );
    auto den_ = capi::utils::make_ndarray(runtime,
                             TiDataType::TI_DATA_TYPE_F32,
                             shape_1d.data(), 1,
                             nullptr, 0,
                             false /*host_read*/, false /*host_write*/
                             );
    auto pre_ = capi::utils::make_ndarray(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         shape_1d.data(), 1,
                         nullptr, 0,
                         false /*host_read*/, false /*host_write*/
                         );
    
    auto vel_ = capi::utils::make_ndarray(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         shape_1d.data(), 1,
                         vec3_shape.data(), 1,
                         false /*host_read*/, false /*host_write*/
                         );
    auto acc_ = capi::utils::make_ndarray(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         shape_1d.data(), 1,
                         vec3_shape.data(), 1,
                         false /*host_read*/, false /*host_write*/
                         );
    auto boundary_box_ = capi::utils::make_ndarray(runtime,
                                  TiDataType::TI_DATA_TYPE_F32,
                                  shape_1d.data(), 1,
                                  vec3_shape.data(), 1,
                                  false /*host_read*/, false /*host_write*/
                                  );
    auto spawn_box_ = capi::utils::make_ndarray(runtime,
                               TiDataType::TI_DATA_TYPE_F32,
                               shape_1d.data(), 1,
                               vec3_shape.data(), 1,
                               false /*host_read*/, false /*host_write*/
                               );
    auto gravity_ = capi::utils::make_ndarray(runtime,
                             TiDataType::TI_DATA_TYPE_F32,
                             nullptr, 0, 
                             vec3_shape.data(), 1,
                             false/*host_read*/,
                             false/*host_write*/);
    
    capi::utils::TiNdarrayAndMem pos_;
    taichi::lang::DeviceAllocation pos_devalloc;
    if(arch == TiArch::TI_ARCH_VULKAN) {
        taichi::lang::vulkan::VulkanDevice *device = &(renderer->app_context().device());
        pos_devalloc = get_ndarray_with_imported_memory(runtime, TiDataType::TI_DATA_TYPE_F32, shape_1d, vec3_shape, device, pos_);
        
    } else {
        pos_ = capi::utils::make_ndarray(runtime,
                            TiDataType::TI_DATA_TYPE_F32,
                            shape_1d.data(), 1,
                            vec3_shape.data(), 1,
                            false /*host_read*/, false /*host_write*/
                            );
        pos_devalloc = get_devalloc(pos_.runtime_, pos_.memory_);
    }
  
    TiArgument k_initialize_args[3];
    TiArgument k_initialize_particle_args[4];
    TiArgument k_update_density_args[3];
    TiArgument k_update_force_args[6];
    TiArgument k_advance_args[3];
    TiArgument k_boundary_handle_args[3];
    
    k_initialize_args[0] = boundary_box_.arg_;
    k_initialize_args[1] = spawn_box_.arg_;
    k_initialize_args[2] = N_.arg_;

    k_initialize_particle_args[0] = pos_.arg_;
    k_initialize_particle_args[1] = spawn_box_.arg_;
    k_initialize_particle_args[2] = N_.arg_;
    k_initialize_particle_args[3] = gravity_.arg_;

    k_update_density_args[0] = pos_.arg_;
    k_update_density_args[1] = den_.arg_;
    k_update_density_args[2] = pre_.arg_;

    k_update_force_args[0] = pos_.arg_;
    k_update_force_args[1] = vel_.arg_;
    k_update_force_args[2] = den_.arg_;
    k_update_force_args[3] = pre_.arg_;
    k_update_force_args[4] = acc_.arg_;
    k_update_force_args[5] = gravity_.arg_;

    k_advance_args[0] = pos_.arg_;
    k_advance_args[1] = vel_.arg_;
    k_advance_args[2] = acc_.arg_;

    k_boundary_handle_args[0] = pos_.arg_;
    k_boundary_handle_args[1] = vel_.arg_;
    k_boundary_handle_args[2] = boundary_box_.arg_;

    /* --------------------- */
    /* Kernel Initialization */
    /* --------------------- */
    ti_launch_kernel(runtime, k_initialize, 3, &k_initialize_args[0]);
    ti_launch_kernel(runtime, k_initialize_particle, 4, &k_initialize_particle_args[0]);
    ti_wait(runtime);

    /* -------------- */
    /* Initialize GUI */
    /* -------------- */
    auto gui = std::make_shared<taichi::ui::vulkan::Gui>(&renderer->app_context(), &renderer->swap_chain(), window);

    // Describe information to render the circle with Vulkan
    taichi::ui::FieldInfo f_info;
    f_info.valid        = true;
    f_info.field_type   = taichi::ui::FieldType::Scalar;
    f_info.matrix_rows  = 1;
    f_info.matrix_cols  = 1;
    f_info.shape        = {NR_PARTICLES};
    f_info.field_source = get_field_source(arch);
    f_info.dtype        = taichi::lang::PrimitiveType::f32;
    f_info.snode        = nullptr;
    f_info.dev_alloc    = pos_devalloc;
    taichi::ui::CirclesInfo circles;
    circles.renderable_info.has_per_vertex_color = false;
    circles.renderable_info.vbo_attrs = taichi::ui::VertexAttributes::kPos;
    circles.renderable_info.vbo                  = f_info;
    circles.color                                = {0.8, 0.4, 0.1};
    circles.radius                               = 0.005f; // 0.0015f looks unclear on desktop

    renderer->set_background_color({0.6, 0.6, 0.6});

    /* --------------------- */
    /* Execution & Rendering */
    /* --------------------- */
    while (!glfwWindowShouldClose(window)) {
        for(int i = 0; i < SUBSTEPS; i++) {
            ti_launch_kernel(runtime, k_update_density, 3, &k_update_density_args[0]);
            ti_launch_kernel(runtime, k_update_force, 6, &k_update_force_args[0]);
            ti_launch_kernel(runtime, k_advance, 3, &k_advance_args[0]);
            ti_launch_kernel(runtime, k_boundary_handle, 3, &k_boundary_handle_args[0]);
        }
        ti_wait(runtime);

        // Render elements
        renderer->circles(circles);
        renderer->draw_frame(gui.get());
        renderer->swap_chain().surface().present_image();
        renderer->prepare_for_next_frame();

        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    renderer->cleanup();
}

int main(int argc, char *argv[]) {
  assert(argc == 3);
  std::string aot_path = argv[1];
  std::string arch_name = argv[2];

  TiArch arch;
  if(arch_name == "cuda") arch = TiArch::TI_ARCH_CUDA;
  else if(arch_name == "vulkan") arch = TiArch::TI_ARCH_VULKAN;
  else if(arch_name == "x64") arch = TiArch::TI_ARCH_X64;
  else assert(false);

  run(arch, aot_path);

  return 0;
}
