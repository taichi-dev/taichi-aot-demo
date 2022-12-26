#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/interop/cross_device_copy.hpp"

using namespace ti::aot_demo;
  
struct App1_hello_world_with_interop : public App {
  // Runtime/Ndarray to perform computations
  TiArch arch_;
  ti::Runtime runtime;
  ti::NdArray<float> points;

  // Ndarray to perform rendering
  ti::NdArray<float> render_points;
  ti::NdArray<float> colors;

  std::unique_ptr<GraphicsTask> draw_points;
  
  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "1_hello_world_with_interop";
    return out;
  }
  virtual void initialize(TiArch arch) override final{

    if(arch != TI_ARCH_VULKAN && arch != TI_ARCH_X64 && arch != TI_ARCH_CUDA && arch != TI_ARCH_OPENGL) {
        std::cout << "1_hello_world_with_interop only supports cuda, x64, opengl, vulkan backends" << std::endl;
        exit(0);
    }
    arch_ = arch;
    
    // Prepare Ndarray to store computation results
    if(arch_ == TI_ARCH_VULKAN) {
        // Reuse the vulkan runtime from renderer framework
        runtime = ti::Runtime(arch_, F_->runtime(), false);;
    } else {
        runtime = ti::Runtime(arch_);
    }
    points = runtime.allocate_ndarray<float>({3}, {2}, true);

    // Prepare vertex buffers for the renderer
    GraphicsRuntime& g_runtime = F_->runtime();
    render_points = g_runtime.allocate_vertex_buffer(3, 2, true);
    colors = g_runtime.allocate_ndarray<float>({3}, {4}, true);

    // Renderer renders with data from "render_points" in each frame
    draw_points = g_runtime.draw_points(render_points)
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

    // Copy data from "points" to "render_points"
    if(arch_ == TI_ARCH_X64) {
        InteropHelper<float>::copy_from_cpu(F_->runtime(), render_points, runtime, points);
    } else if(arch_ == TI_ARCH_CUDA) {
        InteropHelper<float>::copy_from_cuda(F_->runtime(), render_points, runtime, points);
    } else if(arch_ == TI_ARCH_OPENGL) {
        InteropHelper<float>::copy_from_opengl(F_->runtime(), render_points, runtime, points);
    } else if(arch_ == TI_ARCH_VULKAN) {
        InteropHelper<float>::copy_from_vulkan(F_->runtime(), render_points, runtime, points);
    }

    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(*draw_points);
  }
};

std::unique_ptr<App> create_app() {
  return std::make_unique<App1_hello_world_with_interop>();
}
