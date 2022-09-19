#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

struct App1_hello_world : public App {
  ti::NdArray<float> points;
  std::unique_ptr<GraphicsTask> draw_points;

  const char* app_name() const {
    return "1_hello_world";
  }
  void initialize() {
    GraphicsRuntime& runtime = F.runtime();

    points = runtime.allocate_vertex_buffer(2, 5, true);
    draw_points = runtime.create_draw_points_task(points);

    std::cout << "initialized!" << std::endl;
  }
  bool update(double t, double dt) {
    std::vector<glm::vec2> points_data {
      { -0.5f, -0.5f },
      { 0.0f, 0.0f },
      { 0.5f, 0.5f },
    };

    points.write(points_data);

    std::cout << "stepped! (t=" << t << "s; dt=" << dt << "s)" << std::endl;
    return true;
  }
  void render() {
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App1_hello_world);
}
