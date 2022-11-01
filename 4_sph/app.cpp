#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "glm/ext.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

template<typename T>
static void ndarray_memory_copy(ti::NdArray<T>& dst, TiArch dst_arch,
                                const ti::NdArray<T>& src, TiArch src_arch) {
    assert(dst_arch == TI_ARCH_VULKAN);
    
    switch(src_arch) {
        case TI_ARCH_VULKAN: {
            std::vector<float> buffer(src.memory().size());
            src.read(buffer);
            dst.write(buffer);
        }
        case TI_ARCH_X64: {
            break;
        }
        case TI_ARCH_CUDA: {
            break;
        }
        default: {
            throw std::runtime_error("Unable to perform NdArray memory copy");
        }
    }
}

struct App4_sph : public App {
  static const uint32_t NR_PARTICLES = 8000;
  static const uint32_t SUBSTEPS = 5;

  ti::AotModule module_;

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
    out.app_name = "4_sph";
    out.framebuffer_width = 512;
    out.framebuffer_height = 512;
    return out;
  }

  virtual void initialize() override final {
    // 1. Create runtime
    GraphicsRuntime& runtime = F.runtime();
    
    // 2. Load AOT module
    module_ = runtime.load_aot_module("4_sph/assets/sph");
    
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
  
    N_   = runtime.allocate_ndarray<int>(shape_1d, vec3_shape);
    den_ = runtime.allocate_ndarray<float>(shape_1d, {});
    pre_ = runtime.allocate_ndarray<float>(shape_1d, {});
    vel_ = runtime.allocate_ndarray<float>(shape_1d, vec3_shape);
    acc_ = runtime.allocate_ndarray<float>(shape_1d, vec3_shape);
    boundary_box_ = runtime.allocate_ndarray<float>(shape_1d, vec3_shape);
    spawn_box_ = runtime.allocate_ndarray<float>(shape_1d, vec3_shape);
    gravity_ = runtime.allocate_ndarray<float>({}, vec3_shape);
    pos_ = runtime.allocate_ndarray<float>(shape_1d, vec3_shape, true/*host_access*/);
    
    render_pos_ = runtime.allocate_vertex_buffer(shape_1d[0], vec3_shape[0], true/*host_access*/);
    
    // 5. Handle image presentation
    Renderer& renderer = F.renderer();
    glm::mat4 model2world = glm::mat4(1.0f);
    model2world = glm::scale(model2world, glm::vec3(5.0f));
    glm::mat4 world2view = glm::lookAt(glm::vec3(10, 10, 10), glm::vec3(0, 0, 0), glm::vec3(0, -1, 0));
    glm::mat4 view2clip = glm::perspective(glm::radians(45.0f), renderer.width() / (float)renderer.height(), 0.1f, 1000.0f);
    draw_points = runtime.draw_particles(render_pos_)
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
    k_initialize_particle_[1] = spawn_box_;
    k_initialize_particle_[2] = N_;
    k_initialize_particle_[3] = gravity_;

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
    k_initialize_particle_.launch();
    runtime.wait();
    
    // 7. Run initialization kernels
    renderer.set_framebuffer_size(512, 512);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    // 8. Run compute kernels
    auto& runtime = F.runtime();
    for(int i = 0; i < SUBSTEPS; i++) {
        k_update_density_.launch();
        k_update_force_.launch();
        k_advance_.launch();
        k_boundary_handle_.launch();
    }
    runtime.wait();

    // 9. Update vertex buffer
    ndarray_memory_copy<float>(render_pos_, TI_ARCH_VULKAN, pos_, TI_ARCH_VULKAN);

    std::cout << "stepped! (fps=" << F.fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App4_sph);
}
