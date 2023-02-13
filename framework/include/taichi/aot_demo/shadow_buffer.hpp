#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {

class Renderer;

enum class ShadowBufferUsage {
  VertexBuffer,
  IndexBuffer,
  StorageBuffer,
};
class ShadowBuffer {
  friend class Renderer;
 public:
  ShadowBuffer(const std::shared_ptr<Renderer> &renderer,
               const ti::Memory &client_memory,
               ShadowBufferUsage usage);
  virtual ~ShadowBuffer();

  // Copy data in `client_memory_` to `memory_`.
  void update();

 private:
  std::shared_ptr<Renderer> renderer_;
  ShadowBufferUsage usage_;
  // Owned memory that is accessed by draw shaders. Always `TI_ARCH_VULKAN`.
  ti::Memory memory_;
  // Reference to data source. Follows `Renderer::client_arch()`.
  ti::Memory client_memory_;

  void copy_from_vulkan_();
  void copy_from_cpu_();
  void copy_from_cuda_();
  void copy_from_opengl_();
};

} // namespace aot_demo
} // namespace ti
