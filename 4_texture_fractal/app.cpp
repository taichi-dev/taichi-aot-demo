#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

struct App4_texture_fractal : public App {
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t GRID_SIZE = 128;

  ti::AotModule module_;
  ti::ComputeGraph graph_;

  ti::Texture canvas_;

  std::shared_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "4_texture_fractal";
    out.framebuffer_width = 640;
    out.framebuffer_height = 320;
    out.supported_archs = {
      TI_ARCH_VULKAN,
    };
    return out;
  }
  virtual void initialize() override final{
    ti::aot_demo::Renderer& renderer = F_->renderer();
    const ti::Runtime& runtime = F_->runtime();

    module_ = runtime.load_aot_module("4_texture_fractal/assets/fractal");
    graph_ = module_.get_compute_graph("fractal");

    canvas_ = runtime.allocate_texture2d(640, 320, TI_FORMAT_R32F, TI_NULL_HANDLE);

    draw_points = renderer.draw_texture(canvas_)
      .build();

    graph_["canvas"] = canvas_;

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    graph_["t"] = float(F_->frame() * 0.03f);
    graph_.launch();

    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App4_texture_fractal);
}
