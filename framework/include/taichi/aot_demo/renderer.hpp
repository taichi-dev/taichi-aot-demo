#pragma once
#include "taichi/aot_demo/graphics_task.hpp"

namespace ti {
namespace aot_demo {


class Renderer_ {
public:
  virtual bool is_valid() const = 0;
  virtual void destroy() = 0;

  Renderer_() {}
  Renderer_(bool debug, uint32_t width, uint32_t height) {}
  virtual ~Renderer_() = 0;

  virtual TiArch arch() const = 0;
  virtual TiRuntime runtime() const = 0;

  // In a frame.
  virtual void begin_render() = 0;
  virtual void end_render() = 0;
  virtual void enqueue_graphics_task(const GraphicsTask& graphics_task) = 0;

  // After a frame. You MUST call one of them between frames for the renderer to
  // work properly.
  virtual void present_to_surface() = 0;
  virtual void present_to_ndarray(ti::NdArray<uint8_t>& dst) = 0;

  // After all the works of a frame. DO NOT call this unless you know what you
  // are doing.
  virtual void next_frame() = 0;
};


} // namespace aot_demo
} // namespace ti


// -----------------------------------------------------------------------------
// (penguinliong) Alias the renderers and graphics tasks based on framework
// backend, so that we don't have to dynamic cast in draw implementations.

#if TI_FRAMEWORK_BACKEND_VULKAN
#include "taichi/aot_demo/vulkan/vulkan_renderer.hpp"
#endif // TI_FRAMEWORK_BACKEND_VULKAN

#if TI_FRAMEWORK_BACKEND_METAL
#include "taichi/aot_demo/metal/metal_renderer.hpp"
#endif // TI_FRAMEWORK_BACKEND_METAL
