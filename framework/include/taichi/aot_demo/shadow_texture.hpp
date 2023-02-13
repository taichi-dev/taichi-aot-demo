#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {

class Renderer;

enum class ShadowTextureUsage {
  SampledImage,
};
class ShadowTexture {
  friend class Renderer;
 public:
  ShadowTexture(const std::shared_ptr<Renderer> &renderer,
               const ti::Image &client_image,
               ShadowTextureUsage usage);
  virtual ~ShadowTexture();

  // Copy data in `client_memory_` to `memory_`.
  void update();

 private:
  std::shared_ptr<Renderer> renderer_;
  ShadowTextureUsage usage_;
  // Owned memory that is accessed by draw shaders. Always `TI_ARCH_VULKAN`.
  ti::Image image_;
  // Reference to data source. Follows `Renderer::client_arch()`.
  ti::Image client_image_;

  void copy_from_vulkan_();
  void copy_from_cpu_();
  void copy_from_cuda_();
  void copy_from_opengl_();
};

} // namespace aot_demo
} // namespace ti
