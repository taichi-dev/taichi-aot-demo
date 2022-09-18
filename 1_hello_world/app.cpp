#include <thread>
#include <chrono>
#include <iostream>
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

struct App1_hello_world : public App {
  ti::NdArray<float> points;
  std::unique_ptr<GraphicsTask> draw_points;

  const char* app_name() const {
    return "1_hello_world";
  }
  void initialize() {
    points = F.allocate_vertex_buffer(2, 5);
    draw_points = F.create_draw_points_task(points);

    std::cout << "initialized!" << std::endl;
  }
  bool update(double t, double dt) {
    std::this_thread::sleep_for(std::chrono::seconds(1));
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
