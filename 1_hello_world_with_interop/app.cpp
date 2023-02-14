#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;
  
struct App1_hello_world_with_interop : public App {
  // Runtime/Ndarray to perform computations
  ti::Runtime runtime;
  ti::NdArray<float> points;

  // Ndarray to perform rendering
  ti::NdArray<float> render_points;
  ti::NdArray<float> colors;

  std::shared_ptr<GraphicsTask> draw_points;
  
  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "1_hello_world_with_interop";
    out.supported_archs = {
      TI_ARCH_VULKAN,
      TI_ARCH_CUDA,
      TI_ARCH_X64,
      TI_ARCH_OPENGL,
    };
    return out;
  }
  virtual void initialize() override final{
    Renderer &renderer = F_->renderer();
    
    // Prepare Ndarray to store computation results
    points = runtime.allocate_ndarray<float>({3}, {2}, true);

    // Renderer renders with data from "render_points" in each frame
    draw_points = renderer.draw_points(points)
      .point_size(10.0f)
      .color(colors)
      .build();
  }
  virtual bool update() override final {
    Renderer& renderer = F_->renderer();

    // Store the computation results to "points"
    std::vector<float> points_data {
      -0.5f, -0.5f,
       0.0f, 0.0f,
       0.5f, 0.5f,
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
    renderer.enqueue_graphics_task(draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App1_hello_world_with_interop>();
}
