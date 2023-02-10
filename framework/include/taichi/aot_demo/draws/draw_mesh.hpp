#pragma once
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/shadow_buffer.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawMeshBuilder : public GraphicsTaskBuilder {
  using Self = DrawMeshBuilder;
  std::shared_ptr<Renderer> renderer_;

  uint32_t position_count_;
  uint32_t position_component_count_;
  std::shared_ptr<ShadowBuffer> positions_ = nullptr;

  uint32_t primitive_count_;
  uint32_t primitive_vertex_count_;
  std::shared_ptr<ShadowBuffer> indices_ = nullptr;

  glm::vec4 color_ = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);
  std::shared_ptr<ShadowBuffer> colors_ = {};

  glm::mat4 model2world_ = glm::mat4(1.0f);
  glm::mat4 world2view_ = glm::mat4(1.0f);

public:
  DrawMeshBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::NdArray<float>& positions,
    const ti::NdArray<uint32_t>& indices
  ) : GraphicsTaskBuilder(renderer) {
    assert(positions.is_valid());
    positions_ = create_shadow_buffer(positions.memory(), ShadowBufferUsage::VertexBuffer);
    indices_ = create_shadow_buffer(indices.memory(), ShadowBufferUsage::IndexBuffer);

    assert(positions_.shape.dim_count == 1);
    assert(positions_.shape.dims[0] != 0);
    assert(positions_.elem_shape.dim_count == 1);
    assert(positions_.elem_shape.dims[0] > 0 && positions_.elem_shape.dims[0] <= 4);
    assert(indices_.shape.dim_count == 1);
    assert(indices_.shape.dims[0] != 0);
    assert(indices_.elem_shape.dim_count == 1);
    assert(indices_.elem_shape.dims[0] == 3);
  }

  Self& model2world(const glm::mat4& model2world) {
    model2world_ = model2world;
    return *this;
  }
  Self& world2view(const glm::mat4& world2view) {
    world2view_ = world2view;
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

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
