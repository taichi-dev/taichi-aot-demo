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
            return "6_taichi_sparse/assets/taichi_sparse_vulkan";
        }
        case TI_ARCH_X64: {
            return "6_taichi_sparse/assets/taichi_sparse_x64";
        }
        case TI_ARCH_CUDA: {
            return "6_taichi_sparse/assets/taichi_sparse_cuda";
        }
        default: {
            throw std::runtime_error("Unrecognized arch");
        }
    }
}

struct App6_taichi_sparse : public App {
  static const uint32_t img_w = 680;
  static const uint32_t img_h = 680;

  ti::AotModule module_;
  TiArch arch_;
    
  ti::Kernel k_fill_img_;
  ti::Kernel k_block1_deactivate_all_;
  ti::Kernel k_activate_;
  ti::Kernel k_paint_;
  ti::Kernel k_img_to_ndarray_;
  
  ti::NdArray<float> arr_;
  float val = 0.0f;

  std::shared_ptr<GraphicsTask> draw_texture;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "6_taichi_sparse";
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
    Renderer &renderer = F_->renderer();
    const ti::Runtime& runtime = F_->runtime();
    
    // 2. Load AOT module
    auto aot_file_path = get_aot_file_dir(arch_);
    module_ = runtime.load_aot_module(aot_file_path);
    
    // 3. Load kernels
    k_fill_img_ = module_.get_kernel("fill_img");
    k_block1_deactivate_all_ = module_.get_kernel("block1_deactivate_all");
    k_activate_ = module_.get_kernel("activate");
    k_paint_ = module_.get_kernel("paint");
    k_img_to_ndarray_ = module_.get_kernel("img_to_ndarray");

    // 4. Create kernel arguments - Ndarrays
    arr_ = runtime.allocate_ndarray<float>({img_w, img_h});
    
    // 5. Handle image presentation
    draw_texture = renderer.draw_texture(arr_).build();

    // 6. Setup taichi kernels
    k_img_to_ndarray_[0] = arr_;
    
    // 7. Run initialization kernels
    k_fill_img_.launch();
    
    runtime.wait();

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    // 8. Run compute kernels
    const ti::Runtime& runtime = F_->runtime();
    val += 0.05f;
    k_activate_[0] = val;

    k_block1_deactivate_all_.launch();
    k_activate_.launch();
    k_paint_.launch();
    k_img_to_ndarray_.launch();
    
    runtime.wait();
    
    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    const ti::Runtime &runtime = F_->runtime();

    // 9. Update to texture
    runtime.wait();
    
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(draw_texture);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App6_taichi_sparse>();
}
