#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "glm/ext.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/interop/texture_utils.hpp"
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
            return "7_comet/assets/comet_vulkan";
        }
        case TI_ARCH_X64: {
            return "7_comet/assets/comet_x64";
        }
        case TI_ARCH_CUDA: {
            return "7_comet/assets/comet_cuda";
        }
        default: {
            throw std::runtime_error("Unrecognized arch");
        }
    }
}

struct App7_comet : public App {
  static const uint32_t img_w = 680;
  static const uint32_t img_h = 680;

  ti::AotModule module_;
  ti::Runtime runtime_;
  TiArch arch_;
    
  ti::ComputeGraph g_init_;
  ti::ComputeGraph g_update_;
  
  ti::NdArray<float> arr_;

  ti::Texture tex_;
  std::unique_ptr<GraphicsTask> draw_texture;

  App7_comet(TiArch arch) {
    arch_ = arch;
  }

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "7_comet";
    out.framebuffer_width = img_w;
    out.framebuffer_height = img_h;
    return out;
  }

  virtual void initialize() override final {
    // 1. Create runtime
    GraphicsRuntime& g_runtime = F.runtime();
    runtime_ = ti::Runtime(arch_);
    
    // 2. Load AOT module
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime_.load_aot_module(aot_file_path);
    
    // 3. Load compute graphs
    g_init_ = module_.get_compute_graph("init");
    g_update_ = module_.get_compute_graph("update");

    // 4. Create kernel arguments - Ndarrays
    arr_ = runtime_.allocate_ndarray<float>({img_w, img_h}, {}, false/*host_access*/);
    
    // 5. Handle image presentation
    tex_ = g_runtime.allocate_texture2d(img_w, img_h, TI_FORMAT_R32F, TI_NULL_HANDLE);
    draw_texture = g_runtime.draw_texture(tex_).build();

    // 6. Setup taichi kernels
    g_update_["arr"] = arr_;
    
    // 7. Run initialization kernels
    g_init_.launch();
    runtime_.wait();

    Renderer& renderer = F.renderer();
    renderer.set_framebuffer_size(img_w, img_h);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    // 8. Run compute kernels
    g_update_.launch();
    runtime_.wait();
    
    std::cout << "stepped! (fps=" << F.fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    auto& g_runtime = F.runtime();
    
    // 9. Update to texture
    if(arch_ == TI_ARCH_CUDA) {
        TextureHelper<float>::copy_from_cuda_ndarray(g_runtime, tex_, runtime_, arr_);
    } else if(arch_ == TI_ARCH_X64) {
        TextureHelper<float>::copy_from_cpu_ndarray(g_runtime, tex_, runtime_, arr_);
    } else {
        throw std::runtime_error("Unrecognized architecture");
    }
    g_runtime.wait();
    runtime_.wait();
    
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_texture);
  }
};

std::unique_ptr<App> create_app() {
  auto arch = get_target_arch();
  if(arch == TI_ARCH_VULKAN) {
    std::cout << "Comet does not support Vulkan backend" << std::endl;
    exit(0);
  } 

  return std::make_unique<App7_comet>(arch);
}
