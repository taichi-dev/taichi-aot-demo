#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class DrawPointsBuilder {
  using Self = DrawPointsBuilder;
  std::shared_ptr<Renderer> renderer_;

  TiNdArray positions_ = {};

  glm::vec4 color_ = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);
  TiNdArray colors_ = {};

  float point_size_ = 1.0f;
  TiNdArray point_sizes_ = {};

public:
  DrawPointsBuilder(
    const std::shared_ptr<Renderer>& renderer,
    const ti::NdArray<float>& positions
  ) : renderer_(renderer) {
    assert(positions.is_valid());
    positions_ = positions;

    assert(positions_.shape.dim_count == 1);
    assert(positions_.shape.dims[0] != 0);
    assert(positions_.elem_shape.dim_count == 1);
    assert(positions_.elem_shape.dims[0] > 0 && positions_.elem_shape.dims[0] <= 4);
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
    colors_ = colors;

    assert(colors_.shape.dim_count == 1);
    assert(colors_.shape.dims[0] != 0);
    assert(colors_.elem_shape.dim_count == 1);
    assert(colors_.elem_shape.dims[0] == 4);
    return *this;
  }

  Self& point_size(float point_size) {
    point_size_ = point_size;
    return *this;
  }
  Self& point_size(const ti::NdArray<float>& point_sizes) {
    assert(point_sizes.is_valid());
    point_sizes_ = point_sizes;

    assert(colors_.shape.dim_count == 1);
    assert(colors_.shape.dims[0] != 0);
    assert(colors_.elem_shape.dim_count == 0);
    return *this;
  }

  std::unique_ptr<GraphicsTask> build();
};

} // namespace aot_demo
} // namespace ti
