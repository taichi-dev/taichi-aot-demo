#pragma once
#include "taichi/aot_demo/graphics_task.hpp"

namespace ti {
namespace aot_demo {

class Renderer;

class DrawParticlesBuilder : public GraphicsTaskBuilder {
  using Self = DrawParticlesBuilder;

  uint32_t position_count_ = 0;
  uint32_t position_component_count_ = 0;
  std::shared_ptr<ShadowBuffer> positions_ = nullptr;

  glm::vec4 color_ = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);
  std::shared_ptr<ShadowBuffer> colors_ = nullptr;

  // model matrix
  glm::mat4 model2world_ = glm::mat4(1.0f);
  
  // view matrix
  glm::mat4 world2view_ = glm::mat4(1.0f);

  // projection matrix
  glm::mat4 view2clip_ = glm::mat4(1.0f);

public:
  DrawParticlesBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::NdArray<float>& positions
  ) : GraphicsTaskBuilder(renderer) {
    assert(positions.is_valid());
    assert(positions_.shape.dim_count == 1);
    assert(positions_.shape.dims[0] != 0);
    assert(positions_.elem_shape.dim_count == 1);
    assert(positions_.elem_shape.dims[0] > 0 &&
           positions_.elem_shape.dims[0] <= 4);

    position_count_ = positions.shape().dims[0];
    position_component_count_ = positions.elem_shape().dims[0];
    positions_ = create_shadow_buffer(positions.memory(),
                                      ShadowBufferUsage::VertexBuffer);
  }

  Self& model2world(const glm::mat4& model2world) {
    model2world_ = model2world;
    return *this;
  }
  Self& world2view(const glm::mat4& world2view) {
    world2view_ = world2view;
    return *this;
  }
  Self& view2clip(const glm::mat4& view2clip) {
    view2clip_ = view2clip;
    return *this;
  }

  Self& color(const glm::vec3& color) {
    color_ = glm::vec4(color, 1.0f);
    return *this;
  }
  Self& color(const glm::vec4& color) {
    color_ = color;
    return *this;
  }
  Self& color(const ti::NdArray<float>& colors) {
    assert(colors.is_valid());
    colors_ = create_shadow_buffer(colors.memory(), ShadowBufferUsage::StorageBuffer);

    assert(colors_.shape.dim_count == 1);
    assert(colors_.shape.dims[0] != 0);
    assert(colors_.elem_shape.dim_count == 1);
    assert(colors_.elem_shape.dims[0] == 4);
    return *this;
  }

  std::shared_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
