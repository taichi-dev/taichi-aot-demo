#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

struct App1_hello_world : public App {
  ti::NdArray<float> points;
  ti::NdArray<float> colors;

  std::unique_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "1_hello_world";
    return out;
  }
  virtual void initialize(TiArch arch) override final{
    if(arch != TI_ARCH_VULKAN) {
        std::cout << "1_hello_world only supports vulkan backend" << std::endl;
        exit(0);
    }

    GraphicsRuntime& runtime = F_->runtime();

    points = runtime.allocate_vertex_buffer(3, 2, true);
    colors = runtime.allocate_ndarray<float>({3}, {4}, true);

    draw_points = runtime.draw_points(points)
      .point_size(10.0f)
      .color(colors)
      .build();

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    Renderer& renderer = F_->renderer();

    std::vector<glm::vec2> points_data {
      { -0.5f, -0.5f },
      { 0.0f, 0.0f },
      { 0.5f, 0.5f },
    };
    points.write(points_data);

    std::vector<glm::vec4> colors_data {
      { 1.0f, 0.0f, 0.0f, 1.0f },
      { 0.0f, 1.0f, 0.0f, 1.0f },
      { 0.0f, 0.0f, 1.0f, 1.0f },
    };
    colors.write(colors_data);

    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App1_hello_world);
}
