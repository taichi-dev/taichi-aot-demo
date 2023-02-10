#pragma once
#include "taichi/aot_demo/shadow_buffer.hpp"
#include "taichi/aot_demo/graphics_task.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawPointsBuilder : public GraphicsTaskBuilder {
  using Self = DrawPointsBuilder;
  std::shared_ptr<Renderer> renderer_;

  uint32_t position_count_ = 0;
  uint32_t position_component_count_ = 0;
  std::shared_ptr<ShadowBuffer> positions_ = {};

  glm::vec4 color_ = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);
  std::shared_ptr<ShadowBuffer> colors_ = {};

  float point_size_ = 1.0f;
  std::shared_ptr<ShadowBuffer> point_sizes_ = {};

 public:
  DrawPointsBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::NdArray<float>& positions
  ) : GraphicsTaskBuilder(renderer) {
    assert(positions.is_valid());
    assert(positions.shape.dim_count == 1);
    assert(positions.shape.dims[0] != 0);
    assert(positions.elem_shape.dim_count == 1);
    assert(positions.elem_shape.dims[0] > 0 &&
           positions.elem_shape.dims[0] <= 4);

    position_count_ = positions.shape().dims[0];
    position_component_count_ = positions.elem_shape().dims[0];
    positions_ = create_shadow_buffer(positions.memory(),
                                      ShadowBufferUsage::VertexBuffer);
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
    assert(colors.shape.dim_count == 1);
    assert(colors.shape.dims[0] != 0);
    assert(colors.elem_shape.dim_count == 1);
    assert(colors.elem_shape.dims[0] == 4);

    colors_ =
        create_shadow_buffer(colors.memory(), ShadowBufferUsage::StorageBuffer);
    return *this;
  }

  Self& point_size(float point_size) {
    point_size_ = point_size;
    return *this;
  }
  Self& point_size(const ti::NdArray<float>& point_sizes) {
    assert(point_sizes.is_valid());
    point_sizes_ = create_shadow_buffer(point_sizes.memory(),
                                        ShadowBufferUsage::StorageBuffer);

    assert(colors_.shape.dim_count == 1);
    assert(colors_.shape.dims[0] != 0);
    assert(colors_.elem_shape.dim_count == 0);
    return *this;
  }

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
