#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "glm/ext.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

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
  TiArch arch_;
    
  ti::ComputeGraph g_init_;
  ti::ComputeGraph g_update_;
  
  ti::NdArray<float> arr_;

  ti::Texture tex_;
  std::shared_ptr<GraphicsTask> draw_texture;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "7_comet";
    out.framebuffer_width = img_w;
    out.framebuffer_height = img_h;
    out.supported_archs = {
      TI_ARCH_X64,
      TI_ARCH_CUDA,
    };
    return out;
  }

  virtual void initialize() override final{

    // 1. Create runtime
    Renderer& renderer = F_->renderer();
    const ti::Runtime& runtime = F_->runtime();
    
    // 2. Load AOT module
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime.load_aot_module(aot_file_path);
    
    // 3. Load compute graphs
    g_init_ = module_.get_compute_graph("init");
    g_update_ = module_.get_compute_graph("update");

    // 4. Create kernel arguments - Ndarrays
    arr_ = runtime.allocate_ndarray<float>({img_w, img_h}, {}, false/*host_access*/);
    
    // 5. Handle image presentation
    draw_texture = renderer.draw_texture(arr_).build();

    // 6. Setup taichi kernels
    g_update_["arr"] = arr_;
    
    // 7. Run initialization kernels
    g_init_.launch();
    runtime.wait();

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    // 8. Run compute kernels
    g_update_.launch();
    F_->runtime().wait();
    
    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(draw_texture);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App7_comet>();
}
