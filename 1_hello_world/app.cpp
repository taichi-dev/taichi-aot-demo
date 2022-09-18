#include <thread>
#include <chrono>
#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

extern Framework F;

ti::NdArray<float> points;
std::unique_ptr<GraphicsTask> draw_points;

const char* app_name = "1_hello_world";
void initialize() {
  points = F.allocate_vertex_buffer(2, 5);
  draw_points = F.create_draw_points_task(points);

  std::cout << "initialized!" << std::endl;
}
bool step(double t, double dt) {
  std::this_thread::sleep_for(std::chrono::seconds(1));
  Renderer& renderer = F.renderer();

  renderer.begin_frame();
  renderer.enqueue_graphics_task(*draw_points);
  renderer.end_frame();

  std::cout << "stepped! (t=" << t << "s; dt=" << dt << "s)" << std::endl;
  return true;
}

} // namespace aot_demo
} // namespace ti
