#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/interop/cross_device_copy.hpp"

using namespace ti::aot_demo;

struct App1_hello_world_with_cpu_interop : public App {
  // Runtime/Ndarray to perform computations
  ti::Runtime cpu_runtime;
  ti::NdArray<float> cpu_points;

  // Ndarray to perform rendering
  ti::NdArray<float> render_points;
  ti::NdArray<float> colors;

  std::unique_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "1_hello_world_with_cpu_interop";
    return out;
  }
  virtual void initialize() override final{
    // Prepare Ndarray to store computation results
    cpu_runtime = ti::Runtime(TiArch::TI_ARCH_X64);
    cpu_points = cpu_runtime.allocate_ndarray<float>({3}, {2}, true);

    // Prepare vertex buffers for the renderer
    GraphicsRuntime& g_runtime = F.runtime();
    render_points = g_runtime.allocate_vertex_buffer(3, 2, true);
    colors = g_runtime.allocate_ndarray<float>({3}, {4}, true);

    // Renderer renders with data from "render_points" in each frame
    draw_points = g_runtime.draw_points(render_points)
      .point_size(10.0f)
      .color(colors)
      .build();
  }
  virtual bool update() override final {
    Renderer& renderer = F.renderer();

    // Store the computation results to "cpu_points"
    std::vector<float> points_data {
      -0.5f, -0.5f,
       0.0f, 0.0f,
       0.5f, 0.5f,
    };
    cpu_points.write(points_data);

    std::vector<glm::vec4> colors_data {
      { 1.0f, 0.0f, 0.0f, 1.0f },
      { 0.0f, 1.0f, 0.0f, 1.0f },
      { 0.0f, 0.0f, 1.0f, 1.0f },
    };
    colors.write(colors_data);

    // Copy data from "cpu_points" to "render_points"
    InteropHelper<float>::copy_from_cpu(F.runtime(), render_points, cpu_runtime, cpu_points);

    std::cout << "stepped! (fps=" << F.fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App1_hello_world_with_cpu_interop);
}
