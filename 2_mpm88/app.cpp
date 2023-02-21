#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/vulkan/interop/cross_device_copy.hpp"

using namespace ti::aot_demo;

static std::string get_aot_file_dir(TiArch arch) {
    switch(arch) {
        case TI_ARCH_VULKAN: {
            return "2_mpm88/assets/mpm88_vulkan";
        }
        case TI_ARCH_X64: {
            return "2_mpm88/assets/mpm88_x64";
        }
        case TI_ARCH_CUDA: {
            return "2_mpm88/assets/mpm88_cuda";
        }
        case TI_ARCH_OPENGL: {
            return "2_mpm88/assets/mpm88_opengl";
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
        case TI_ARCH_OPENGL: {
            InteropHelper<T>::copy_from_opengl(dst_runtime, dst, src_runtime, src);
            break;
        }
        default: {
            throw std::runtime_error("Unable to perform NdArray memory copy");
        }
    }
}

struct App2_mpm88 : public App {
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t GRID_SIZE = 128;

  ti::Runtime runtime_;
  ti::AotModule module_;
  TiArch arch_;

  ti::ComputeGraph g_init_;
  ti::ComputeGraph g_update_;

  ti::NdArray<float> x_;
  ti::NdArray<float> v_;
  ti::NdArray<float> pos_;
  ti::NdArray<float> C_;
  ti::NdArray<float> J_;
  ti::NdArray<float> grid_v_;
  ti::NdArray<float> grid_m_;
  
  ti::NdArray<float> render_x_;

  std::unique_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "2_mpm88";
    out.framebuffer_width = 256;
    out.framebuffer_height = 256;
    return out;
  }


  virtual void initialize(TiArch arch) override final{
    if(arch != TI_ARCH_VULKAN && arch != TI_ARCH_X64 && arch != TI_ARCH_CUDA && arch != TI_ARCH_OPENGL) {
        std::cout << "1_hello_world_with_interop only supports cuda, x64, vulkan, opengl backends" << std::endl;
        exit(0);
    }
    arch_ = arch;
    
    GraphicsRuntime& g_runtime = F_->runtime();
    if(arch_ == TI_ARCH_VULKAN) {
        // Reuse the vulkan runtime from renderer framework
        runtime_ = ti::Runtime(arch_, F_->runtime(), false);;
    } else {
        runtime_ = ti::Runtime(arch_);
    }

    // 2. Load AOT module
#ifdef TI_AOT_DEMO_ANDROID_APP
    std::vector<uint8_t> tcm;
    F_->asset_mgr().load_file("E2_mpm88.tcm", tcm);
    module_ = runtime_.create_aot_module(tcm);
#else
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime_.load_aot_module(aot_file_path);
#endif

    g_init_ = module_.get_compute_graph("init");
    g_update_ = module_.get_compute_graph("update");

    render_x_ = g_runtime.allocate_vertex_buffer(NPARTICLE, 2, false/*host_access*/);

    x_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {2}, false/*host_access*/);
    v_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {2});
    pos_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {3});
    C_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {2, 2});
    J_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {});
    grid_v_ = runtime_.allocate_ndarray<float>({GRID_SIZE, GRID_SIZE}, {2});
    grid_m_ = runtime_.allocate_ndarray<float>({GRID_SIZE, GRID_SIZE}, {});

    draw_points = g_runtime.draw_points(render_x_)
      .point_size(3.0f)
      .color(glm::vec3(0,0,1))
      .build();

    g_init_["x"] = x_;
    g_init_["v"] = v_;
    g_init_["J"] = J_;
    g_init_.launch();

    g_update_["x"] = x_;
    g_update_["v"] = v_;
    g_update_["pos"] = pos_;
    g_update_["C"] = C_;
    g_update_["J"] = J_;
    g_update_["grid_v"] = grid_v_;
    g_update_["grid_m"] = grid_m_;

    Renderer& renderer = F_->renderer();
    renderer.set_framebuffer_size(256, 256);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    g_update_.launch();

    auto& g_runtime = F_->runtime();
    copy_to_vulkan_ndarray<float>(render_x_, g_runtime, x_, runtime_, arch_);
    runtime_.wait();
    
    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App2_mpm88>();
}
