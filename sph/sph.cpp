#include <chrono>
#include <iostream>
#include <signal.h>
#include <inttypes.h>
#include <unistd.h>
#include <memory>
#include <vector>

#include <taichi/gui/gui.h>
#include <taichi/ui/backends/vulkan/renderer.h>
#include "taichi_core_impl.h"
#include "taichi/taichi_core.h"
#include "taichi/taichi_vulkan.h"

#define NR_PARTICLES 8000

#include <unistd.h>

constexpr int SUBSTEPS = 5;

class Ndarray {
  public:
    Ndarray() = default;
    ~Ndarray() { }

    const TiArgument& arg() const { return arr_arg_; }
    taichi::lang::DeviceAllocation& devalloc() { return devalloc_; }

    static std::unique_ptr<Ndarray>
    Make(TiRuntime runtime, 
         TiDataType dtype,
         const std::vector<int> &arr_shape,
         const std::vector<int> &element_shape = {}, 
         bool host_read = false,
         bool host_write = false) {

      // TODO: Cannot use data_type_size() until
      // https://github.com/taichi-dev/taichi/pull/5220.
      // uint64_t_t alloc_size = taichi::lang::data_type_size(dtype);
      
      uint64_t alloc_size = 4;
      assert(dtype == TiDataType::TI_DATA_TYPE_F32 || dtype == TiDataType::TI_DATA_TYPE_I32 || dtype == TiDataType::TI_DATA_TYPE_U32);

      for (int s : arr_shape) {
        alloc_size *= s;
      }
      for (int s : element_shape) {
        alloc_size *= s;
      }
      
      auto res = std::make_unique<Ndarray>();
      
      TiMemoryAllocateInfo alloc_info;
      alloc_info.size = alloc_size;
      alloc_info.host_write = host_write;
      alloc_info.host_read = host_read;
      alloc_info.export_sharing = false;
      alloc_info.usage = TiMemoryUsageFlagBits::TI_MEMORY_USAGE_STORAGE_BIT;
      
      res->memory_ = ti_allocate_memory(runtime, &alloc_info);
      
      Runtime* real_runtime = (Runtime *)runtime;
      res->devalloc_ = devmem2devalloc(*real_runtime, res->memory_);
      
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
    TiMemory memory_;
    TiArgument arr_arg_;
    taichi::lang::DeviceAllocation devalloc_;
};

taichi::Arch get_taichi_arch(TiArch arch) {
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

taichi::ui::FieldSource get_field_source(TiArch arch) {
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
    
    auto N_ = Ndarray::Make(runtime,
                       TiDataType::TI_DATA_TYPE_I32,
                       {NR_PARTICLES}, 
                       {});
    auto den_ = Ndarray::Make(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         {NR_PARTICLES}, 
                         {});
    auto pre_ = Ndarray::Make(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         {NR_PARTICLES}, 
                         {});
    
    auto pos_ = Ndarray::Make(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         {NR_PARTICLES}, 
                         {3});
    auto vel_ = Ndarray::Make(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         {NR_PARTICLES}, 
                         {3});
    auto acc_ = Ndarray::Make(runtime,
                         TiDataType::TI_DATA_TYPE_F32,
                         {NR_PARTICLES}, 
                         {3});
    auto boundary_box_ = Ndarray::Make(runtime,
                                  TiDataType::TI_DATA_TYPE_F32,
                                  {NR_PARTICLES},
                                  {3},
                                  false/*host_read*/,
                                  false/*host_write*/);
    auto spawn_box_ = Ndarray::Make(runtime,
                               TiDataType::TI_DATA_TYPE_F32,
                               {NR_PARTICLES}, 
                               {3},
                               false/*host_read*/,
                               false/*host_write*/);
    auto gravity_ = Ndarray::Make(runtime,
                             TiDataType::TI_DATA_TYPE_F32,
                             {}, 
                             {3},
                             false/*host_read*/,
                             false/*host_write*/);
  
    TiArgument k_initialize_args[3];
    TiArgument k_initialize_particle_args[4];
    TiArgument k_update_density_args[3];
    TiArgument k_update_force_args[6];
    TiArgument k_advance_args[3];
    TiArgument k_boundary_handle_args[3];
    
    k_initialize_args[0] = boundary_box_->arg();
    k_initialize_args[1] = spawn_box_->arg();
    k_initialize_args[2] = N_->arg();

    k_initialize_particle_args[0] = pos_->arg();
    k_initialize_particle_args[1] = spawn_box_->arg();
    k_initialize_particle_args[2] = N_->arg();
    k_initialize_particle_args[3] = gravity_->arg();

    k_update_density_args[0] = pos_->arg();
    k_update_density_args[1] = den_->arg();
    k_update_density_args[2] = pre_->arg();

    k_update_force_args[0] = pos_->arg();
    k_update_force_args[1] = vel_->arg();
    k_update_force_args[2] = den_->arg();
    k_update_force_args[3] = pre_->arg();
    k_update_force_args[4] = acc_->arg();
    k_update_force_args[5] = gravity_->arg();

    k_advance_args[0] = pos_->arg();
    k_advance_args[1] = vel_->arg();
    k_advance_args[2] = acc_->arg();

    k_boundary_handle_args[0] = pos_->arg();
    k_boundary_handle_args[1] = vel_->arg();
    k_boundary_handle_args[2] = boundary_box_->arg();

    /* --------------------- */
    /* Kernel Initialization */
    /* --------------------- */
    //ti_launch_compute_graph(runtime, g_init, arg_count, &named_args[0]);
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
    f_info.dev_alloc    = pos_->devalloc();
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
        //ti_launch_compute_graph(runtime, g_update, arg_count, &named_args[0]);
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
