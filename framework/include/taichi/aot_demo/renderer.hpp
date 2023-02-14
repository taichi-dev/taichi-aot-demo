#pragma once
#include <memory>
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/draws/draw_points.hpp"
#include "taichi/aot_demo/draws/draw_particles.hpp"
#include "taichi/aot_demo/draws/draw_mesh.hpp"
#include "taichi/aot_demo/draws/draw_texture.hpp"

#define check_vulkan_result(x) \
  if (x < VK_SUCCESS) { \
    uint32_t x2 = (uint32_t)x; \
    std::printf("File \"%s\", line %d, in %s:\n", __FILE__, __LINE__, __func__); \
    std::printf("  vulkan failed: %d\n", x2); \
    std::fflush(stdout); \
    throw std::runtime_error("vulkan failed"); \
  }

namespace ti {
namespace aot_demo {

class Renderer;

struct RendererConfig {
  TiArch client_arch;
  uint32_t framebuffer_width;
  uint32_t framebuffer_height;
  bool debug;
};

// Implemented by renderer backends.
struct RendererState;
class Renderer : public std::enable_shared_from_this<Renderer> {
  friend class ShadowBuffer;
  friend class ShadowTexture;

  std::unique_ptr<RendererState> state_;

  // This runtime always has `TI_ARCH_VULKAN`. This is used for internal interop
  // only. DO NOT EXPOSE AS PUBLIC.
  ti::Runtime runtime_;
  // This runtime has `RendererConfig::client_arch`.
  ti::Runtime client_runtime_;

  std::vector<std::shared_ptr<GraphicsTask>> graphics_tasks_;

  ti::NdArray<float> rect_vertex_buffer_;
  ti::NdArray<float> rect_texcoord_buffer_;

  // Staging buffers will be released in `next_frame` so they can be repeatedly
  // allocated in each `update`.
  std::vector<ti::Memory> staging_buffers_;

public:
  constexpr bool is_valid() const {
    return state_ != nullptr;
  }
  void destroy();

  Renderer(const RendererConfig &config);
  ~Renderer();

  ti::Memory allocate_staging_buffer(size_t size) {
    ti::Memory staging_buffer = runtime_.allocate_memory(size, true);
    ti::Memory out = staging_buffer.borrow();
    staging_buffers_.emplace_back(std::move(staging_buffer));
    return out;
  }

  // Add your drawing functions here.
  DrawPointsBuilder draw_points(
    const ti::NdArray<float>& positions
  ) {
    return DrawPointsBuilder(shared_from_this(), positions);
  }
  DrawParticlesBuilder draw_particles(
    const ti::NdArray<float>& positions
  ) {
    return DrawParticlesBuilder(shared_from_this(), positions);
  }
  DrawMeshBuilder draw_mesh(
    const ti::NdArray<float>& positions,
    const ti::NdArray<uint32_t>& indices
  ) {
    return DrawMeshBuilder(shared_from_this(), positions, indices);
  }
  DrawTextureBuilder draw_texture(
    const ti::Texture& texture
  ) {
    return DrawTextureBuilder(shared_from_this(), texture);
  }
  DrawTextureBuilder draw_texture(const ti::NdArray<float> &texture) {
    return DrawTextureBuilder(shared_from_this(), texture);
  }

  // In a frame.
  void begin_render();
  void end_render();
  void enqueue_graphics_task(const std::shared_ptr<GraphicsTask> &graphics_task);

  // After a frame. You MUST call one of them between frames for the renderer to
  // work properly
  void present_to_surface();
  ti::NdArray<uint8_t> present_to_ndarray();

  // After all the works of a frame. DO NOT call this unless you know what you
  // are doing.
  void next_frame();

  // The renderer's representation as Taichi objects.
  constexpr RendererState *state() const {
    return state_.get();
  }

  constexpr const ti::Runtime &renderer_runtime() const {
    return runtime_;
  }
  constexpr const ti::Runtime &client_runtime() const {
    return client_runtime_;
  }

  const ti::NdArray<float>& rect_vertex_buffer() const {
    return rect_vertex_buffer_;
  }
  const ti::NdArray<float>& rect_texcoord_buffer() const {
    return rect_texcoord_buffer_;
  }
};


} // namespace aot_demo
} // namespace ti
