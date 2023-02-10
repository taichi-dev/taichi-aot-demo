#pragma once
#include <memory>
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/shadow_texture.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawTextureBuilder : GraphicsTaskBuilder {
  using Self = DrawTextureBuilder;

  std::shared_ptr<ShadowBuffer> rect_vertices_ = nullptr;
  std::shared_ptr<ShadowTexture> texture_ = nullptr;

public:
  DrawTextureBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::Texture& texture
  ) : GraphicsTaskBuilder(renderer) {
    assert(texture.is_valid());
    texture_ = create_shadow_texture(texture.image(), ShadowTextureUsage::SampledImage);

    assert(texture.texture().dimension == TI_IMAGE_DIMENSION_2D);
  }

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
