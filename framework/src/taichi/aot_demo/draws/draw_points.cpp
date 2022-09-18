#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

std::unique_ptr<GraphicsTask> Framework::create_draw_points_task(
  const ti::NdArray<float>& points
) const {
  assert(points.is_valid());
  assert(points.shape().dim_count != 0);
  assert(points.shape().dims[0] != 0);

  GraphicsTaskConfig config {};
  config.vertex_shader_glsl = R"(
    #version 460
    layout(location=0) in vec2 pos;
    void main() {
      gl_PointSize = 1.0;
      gl_Position = vec4(pos, 0.0, 1.0);
    }
  )";
  config.fragment_shader_glsl = R"(
    #version 460
    layout(location=0) out vec4 color;
    void main() {
      color = vec4(1.0, 0.0, 1.0, 1.0);
    }
  )";
  config.uniform_buffer_size = sizeof(uint32_t);
  config.vertex_buffer.memory = points.memory();
  config.vertex_buffer.size = points.memory().size();

  config.vertex_component_count = 2;
  config.vertex_count = points.ndarray().shape.dims[0];
  config.instance_count = 1;
  config.primitive_topology = L_PRIMITIVE_TOPOLOGY_POINT;

  return std::make_unique<GraphicsTask>(renderer_, config);
}

} // namespace aot_demo
} // namespace ti
