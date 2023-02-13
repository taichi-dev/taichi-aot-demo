#pragma once
#include "taichi/aot_demo/graphics_task.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawTextureBuilder : GraphicsTaskBuilder {
  using Self = DrawTextureBuilder;

  uint32_t width_ = 1;
  uint32_t height_ = 1;
  std::shared_ptr<ShadowBuffer> rect_vertices_ = nullptr;
  std::shared_ptr<ShadowBuffer> rect_texcoords_ = nullptr;
  std::shared_ptr<ShadowTexture> texture_ = nullptr;
  uint32_t texel_component_count_ = 1;
  std::shared_ptr<ShadowBuffer> texture_buffer_ = nullptr;

public:
  DrawTextureBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::Texture& texture
  ) : GraphicsTaskBuilder(renderer) {
    assert(texture.is_valid());
    assert(texture.texture().dimension == TI_IMAGE_DIMENSION_2D);
    width_ = texture.texture().extent.width;
    height_ = texture.texture().extent.height;
    texture_ = create_shadow_texture(texture.image(), ShadowTextureUsage::SampledImage);
  }
  DrawTextureBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::NdArray<float>& texture_buffer
  ) : GraphicsTaskBuilder(renderer) {
    assert(texture_buffer.is_valid());
    assert(texture_buffer.shape().dim_count == 2);
    assert(texture_buffer.elem_shape().dim_count == 1);
  
    width_ = texture_buffer.shape().dims[0];
    height_ = texture_buffer.shape().dims[1];
    texel_component_count_ = texture_buffer.elem_shape().dims[0];
    texture_buffer_ = create_shadow_buffer(texture_buffer.memory(), ShadowBufferUsage::StorageBuffer);
  }

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
