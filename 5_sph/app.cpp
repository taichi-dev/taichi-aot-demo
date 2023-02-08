#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "glm/ext.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/interop/cross_device_copy.hpp"

using namespace ti::aot_demo;

static std::string get_aot_file_dir(TiArch arch) {
    switch(arch) {
        case TI_ARCH_VULKAN: {
            return "5_sph/assets/sph_vulkan";
        }
        case TI_ARCH_X64: {
            return "5_sph/assets/sph_x64";
        }
        case TI_ARCH_CUDA: {
            return "5_sph/assets/sph_cuda";
        }
        default: {
            throw std::runtime_error("Unrecognized arch");
        }
    }
}

template<typename T>
static void copy_to_vulkan_ndarray(ti::NdArray<T>& dst, 
                                   GraphicsRuntime& dst_runtime,
                                   ti::NdArray<T>& src, 
                                   ti::Runtime& src_runtime, TiArch src_arch) {
    
    switch(src_arch) {
        case TI_ARCH_VULKAN: {
            InteropHelper<T>::copy_from_vulkan(dst_runtime, dst, src_runtime, src);
            break;
        }
        case TI_ARCH_X64: {
            InteropHelper<T>::copy_from_cpu(dst_runtime, dst, src_runtime, src);
            break;
        }
        case TI_ARCH_CUDA: {
            InteropHelper<T>::copy_from_cuda(dst_runtime, dst, src_runtime, src);
            break;
        }
        default: {
            throw std::runtime_error("Unable to perform NdArray memory copy");
        }
    }
}

struct App5_sph : public App {
  static const uint32_t NR_PARTICLES = 8000;
  static const uint32_t SUBSTEPS = 5;

  ti::Runtime runtime_;
  ti::AotModule module_;
  TiArch arch_;

  ti::Kernel k_initialize_;
  ti::Kernel k_initialize_particle_;
  ti::Kernel k_update_density_;
  ti::Kernel k_update_force_;
  ti::Kernel k_advance_;
  ti::Kernel k_boundary_handle_;

  ti::NdArray<int> N_;
  ti::NdArray<float> den_;
  ti::NdArray<float> pre_;
  ti::NdArray<float> vel_;
  ti::NdArray<float> acc_;
  ti::NdArray<float> boundary_box_;
  ti::NdArray<float> spawn_box_;
  ti::NdArray<float> gravity_;
  ti::NdArray<float> pos_;

  ti::NdArray<float> render_pos_;
  std::unique_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "5_sph";
    out.framebuffer_width = 512;
    out.framebuffer_height = 512;
    return out;
  }

  virtual void initialize(TiArch arch) override final{

    if(arch != TI_ARCH_VULKAN && arch != TI_ARCH_X64 && arch != TI_ARCH_CUDA) {
        std::cout << "5_sph only supports cuda, x64, vulkan backends" << std::endl;
        exit(0);
    }
    arch_ = arch;
    
    // 1. Create runtime
    GraphicsRuntime& g_runtime = F_->runtime();

    if(arch_ == TI_ARCH_VULKAN) {
        // Reuse the vulkan runtime from renderer framework
        runtime_ = ti::Runtime(arch_, F_->runtime(), false);;
    } else {
        runtime_ = ti::Runtime(arch_);
    }
    
    // 2. Load AOT module
#ifdef TI_AOT_DEMO_WITH_ANDROID_APP
    std::vector<uint8_t> tcm;
    F_->asset_mgr().load_file("E5_sph.tcm", tcm);
    module_ = runtime_.create_aot_module(tcm);
#else
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime_.load_aot_module(aot_file_path);
#endif
    
    // 3. Load kernels
    k_initialize_ = module_.get_kernel("initialize");
    k_initialize_particle_ = module_.get_kernel("initialize_particle");
    k_update_density_ = module_.get_kernel("update_density");
    k_update_force_ = module_.get_kernel("update_force");
    k_advance_ = module_.get_kernel("advance");
    k_boundary_handle_ = module_.get_kernel("boundary_handle");

    // 4. Create kernel arguments - Ndarrays
    const std::vector<uint32_t> shape_1d = {NR_PARTICLES};
    const std::vector<uint32_t> vec3_shape = {3};
  
    N_   = runtime_.allocate_ndarray<int>(shape_1d, vec3_shape);
    den_ = runtime_.allocate_ndarray<float>(shape_1d, {});
    pre_ = runtime_.allocate_ndarray<float>(shape_1d, {});
    vel_ = runtime_.allocate_ndarray<float>(shape_1d, vec3_shape);
    acc_ = runtime_.allocate_ndarray<float>(shape_1d, vec3_shape);
    boundary_box_ = runtime_.allocate_ndarray<float>(shape_1d, vec3_shape);
    spawn_box_ = runtime_.allocate_ndarray<float>(shape_1d, vec3_shape);
    gravity_ = runtime_.allocate_ndarray<float>({}, vec3_shape);
    pos_ = runtime_.allocate_ndarray<float>(shape_1d, vec3_shape, false/*host_access*/);
    
    render_pos_ = g_runtime.allocate_vertex_buffer(shape_1d[0], vec3_shape[0], false/*host_access*/);
    
    // 5. Handle image presentation
    Renderer& renderer = F_->renderer();
    glm::mat4 model2world = glm::mat4(1.0f);
    model2world = glm::scale(model2world, glm::vec3(5.0f));
    glm::mat4 world2view = glm::lookAt(glm::vec3(10, 10, 10), glm::vec3(0, 0, 0), glm::vec3(0, -1, 0));
    glm::mat4 view2clip = glm::perspective(glm::radians(45.0f), renderer.width() / (float)renderer.height(), 0.1f, 1000.0f);
    draw_points = g_runtime.draw_particles(render_pos_)
      .model2world(model2world)
      .world2view(world2view)
      .view2clip(view2clip)
      .color(glm::vec3(0.3,0.7,0.6))
      .build();

    // 6. Setup taichi kernels
    k_initialize_[0] = boundary_box_;
    k_initialize_[1] = spawn_box_;
    k_initialize_[2] = N_;

    k_initialize_particle_[0] = pos_;
    k_initialize_particle_[1] = vel_;
    k_initialize_particle_[2] = spawn_box_;
    k_initialize_particle_[3] = N_;
    k_initialize_particle_[4] = gravity_;

    k_update_density_[0] = pos_;
    k_update_density_[1] = den_;
    k_update_density_[2] = pre_;

    k_update_force_[0] = pos_;
    k_update_force_[1] = vel_;
    k_update_force_[2] = den_;
    k_update_force_[3] = pre_;
    k_update_force_[4] = acc_;
    k_update_force_[5] = gravity_;

    k_advance_[0] = pos_;
    k_advance_[1] = vel_;
    k_advance_[2] = acc_;

    k_boundary_handle_[0] = pos_;
    k_boundary_handle_[1] = vel_;
    k_boundary_handle_[2] = boundary_box_;

    k_initialize_.launch();
    runtime_.wait();
    k_initialize_particle_.launch();
    runtime_.wait();

    // 7. Run initialization kernels
    renderer.set_framebuffer_size(512, 512);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    // 8. Run compute kernels
    for(int i = 0; i < SUBSTEPS; i++) {
        k_update_density_.launch();
        runtime_.wait();
        k_update_force_.launch();
        runtime_.wait();
        k_advance_.launch();
        runtime_.wait();
        k_boundary_handle_.launch();
        runtime_.wait();
    }

    // 9. Update vertex buffer
    auto& g_runtime = F_->runtime();
    copy_to_vulkan_ndarray<float>(render_pos_, g_runtime, pos_, runtime_, arch_);

    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App5_sph>();
}
