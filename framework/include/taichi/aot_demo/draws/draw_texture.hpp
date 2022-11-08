#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawTextureBuilder {
  using Self = DrawTextureBuilder;
  std::shared_ptr<Renderer> renderer_;

  TiTexture texture_ = {};

public:
  DrawTextureBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::Texture& texture
  ) : renderer_(renderer) {
    assert(texture.is_valid());
    texture_ = texture;

    assert(texture.texture().dimension == TI_IMAGE_DIMENSION_2D);
  }

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
