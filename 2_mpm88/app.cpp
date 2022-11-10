#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/interop/cross_device_copy.hpp"

using namespace ti::aot_demo;

static TiArch get_target_arch() {
  TiArch arch = TI_ARCH_VULKAN;
#ifdef TI_LIB_DIR
  // TI_LIB_DIR set by cmake
  std::string ti_lib_dir = (TI_LIB_DIR);
  setenv("TI_LIB_DIR", ti_lib_dir.c_str(), 1/*overwrite*/);
#endif

  if(const char* arch_ptr = std::getenv("TI_AOT_ARCH")) {
    std::string arch_str = arch_ptr;
    if(arch_str == "vulkan") arch = TI_ARCH_VULKAN;
    else if(arch_str == "x64") arch = TI_ARCH_X64;
    else if(arch_str == "cuda") arch = TI_ARCH_CUDA;
    else {
        std::cout << "Unrecognized TI_AOT_ARCH: " << arch_str << std::endl;
    }
  }
  
  return arch;
}

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

struct App2_mpm88 : public App {
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t GRID_SIZE = 128;

  ti::AotModule module_;
  ti::Runtime runtime_;
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
  
  App2_mpm88(TiArch arch) {
    arch_ = arch;
  }

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "2_mpm88";
    out.framebuffer_width = 256;
    out.framebuffer_height = 256;
    return out;
  }
  virtual void initialize() override final {
    GraphicsRuntime& g_runtime = F.runtime();
    runtime_ = ti::Runtime(arch_);
    
    // 2. Load AOT module
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime_.load_aot_module(aot_file_path);

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

    Renderer& renderer = F.renderer();
    renderer.set_framebuffer_size(256, 256);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    g_update_.launch();

    auto& g_runtime = F.runtime();
    copy_to_vulkan_ndarray<float>(render_x_, g_runtime, x_, runtime_, arch_);
    runtime_.wait();
    
    std::cout << "stepped! (fps=" << F.fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  auto arch = get_target_arch();
  return std::make_unique<App2_mpm88>(arch);
}
