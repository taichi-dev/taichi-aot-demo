#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

namespace {
void ti_check_error(const std::string& msg) {
  TiError error = ti_get_last_error(0, nullptr);
  if (error < TI_ERROR_SUCCESS) {
    throw std::runtime_error(msg);
  }
}
}

struct App2_mpm88 : public App {
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t GRID_SIZE = 128;

  ti::AotModule module_;
  ti::ComputeGraph g_init_;
  ti::ComputeGraph g_update_;

  ti::NdArray<float> x_;
  ti::NdArray<float> v_;
  ti::NdArray<float> pos_;
  ti::NdArray<float> C_;
  ti::NdArray<float> J_;
  ti::NdArray<float> grid_v_;
  ti::NdArray<float> grid_m_;

  std::unique_ptr<GraphicsTask> draw_points;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "2_mpm88";
    out.framebuffer_width = 256;
    out.framebuffer_height = 256;
    return out;
  }
  virtual void initialize() override final {
    GraphicsRuntime& runtime = F.runtime();

    module_ = runtime.load_aot_module("2_mpm88/assets/mpm88");
    ti_check_error("load_aot_module failed");

    g_init_ = module_.get_compute_graph("init");
    g_update_ = module_.get_compute_graph("update");
    ti_check_error("get_compute_graph failed");

    x_ = runtime.allocate_vertex_buffer(NPARTICLE, 2);
    v_ = runtime.allocate_ndarray<float>({NPARTICLE}, {2});
    pos_ = runtime.allocate_ndarray<float>({NPARTICLE}, {3});
    C_ = runtime.allocate_ndarray<float>({NPARTICLE}, {2, 2});
    J_ = runtime.allocate_ndarray<float>({NPARTICLE}, {});
    grid_v_ = runtime.allocate_ndarray<float>({GRID_SIZE, GRID_SIZE}, {2});
    grid_m_ = runtime.allocate_ndarray<float>({GRID_SIZE, GRID_SIZE}, {});
    ti_check_error("allocate_ndarray failed");

    draw_points = runtime.draw_points(x_)
      .point_size(3.0f)
      .color(glm::vec3(0,0,1))
      .build();

    g_init_["x"] = x_;
    g_init_["v"] = v_;
    g_init_["J"] = J_;
    g_init_.launch();

    g_update_["x"] = x_;
    g_update_["v"] = v_;
    g_update_["pos"] = pos_;
    g_update_["C"] = C_;
    g_update_["J"] = J_;
    g_update_["grid_v"] = grid_v_;
    g_update_["grid_m"] = grid_m_;

    Renderer& renderer = F.renderer();
    renderer.set_framebuffer_size(256, 256);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    g_update_.launch();
    std::cout << "stepped! (fps=" << F.fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F.renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App2_mpm88);
}
