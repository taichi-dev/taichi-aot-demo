#include <sstream>
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/renderer.hpp"
#include "taichi/aot_demo/draws/draw_points.hpp"

namespace ti {
namespace aot_demo {

std::unique_ptr<GraphicsTask> DrawPointsBuilder::build() {
  const char* vertex_declr;
  const char* vertex_get;
  switch (position_component_count_) {
  case 1:
    vertex_declr = "layout(location=0) in float pos;";
    vertex_get = "vec4(pos * 2.0 - 1.0, 0.0f, 0.0f, 1.0f)";
    break;
  case 2:
    vertex_declr = "layout(location=0) in vec2 pos;";
    vertex_get = "vec4(pos.x * 2.0 - 1.0, (1.0 - pos.y) * 2.0 - 1.0, 0.0f, 1.0f)";
    break;
  case 3:
    vertex_declr = "layout(location=0) in vec3 pos;";
    vertex_get = "vec4(pos, 1.0f)";
    break;
  case 4:
    vertex_declr = "layout(location=0) in vec4 pos;";
    vertex_get = "pos";
    break;
  default:
    throw std::logic_error("vertex position can only `float`, `vec2`, `vec3` or `vec4`");
  }

  const char* uniform_buffer_declr = R"(
    layout(binding=0) uniform Uniform {
      vec4 color;
      float point_size;
    } u;
  )";
  struct UniformBuffer {
    glm::vec4 color;
    float point_size;
  } u;
  u.color = color_;
  u.point_size = point_size_;

  std::vector<GraphicsTaskResource> rscs;

  bool is_color_per_vertex = colors_ != nullptr;
  std::string color_buffer_declr;
  const char* color_get;
  if (is_color_per_vertex) {
    size_t irsc = rscs.size() + 1;
    {
      std::stringstream ss;
      ss << 
        "layout(binding=" << irsc << ")"
        "readonly buffer _" << irsc << " { vec4 colors[]; };";
      color_buffer_declr = ss.str();
    }
    color_get = "colors[gl_VertexIndex]";

    rscs.emplace_back(colors_);
  } else {
    color_get = "u.color";
  }

  bool is_point_size_per_vertex = point_sizes_ != nullptr;
  std::string point_size_buffer_declr;
  const char* point_size_get;
  if (is_point_size_per_vertex) {
    size_t irsc = rscs.size() + 1;
    {
      std::stringstream ss;
      ss <<
        "layout(binding=" << irsc << ")"
        "readonly buffer _" << irsc << " { vec4 point_sizes[]; };";
      point_size_buffer_declr = ss.str();
    }
    point_size_get = "point_sizes[gl_VertexIndex]";

    rscs.emplace_back(point_sizes_);
  } else {
    point_size_get = "u.point_size";
  }

  std::string vert;
  {
    std::stringstream ss;
    ss << R"(
      #version 460
      layout(location=0) out vec4 v_color;)" <<
      vertex_declr <<
      uniform_buffer_declr <<
      color_buffer_declr << R"(
      void main() {
        gl_PointSize = )" << point_size_get << R"(;
        gl_Position = )" <<  vertex_get << R"(;
        v_color = )" << color_get << R"(;
      }
    )";
    vert = ss.str();
  }
  const char* frag = R"(
    #version 460
    layout(location=0) in vec4 v_color;
    layout(location=0) out vec4 color;
    void main() {
      if (length(gl_PointCoord * 2.0 - 1.0) > 1.0) { discard; }
      color = v_color;
    }
  )";

  GraphicsTaskConfig config {};
  config.vertex_shader_glsl = vert;
  config.fragment_shader_glsl = frag;
  config.uniform_buffer_data = &u;
  config.uniform_buffer_size = sizeof(u);
  config.vertex_buffer = positions_;
  config.resources = std::move(rscs);
  config.vertex_component_count = position_component_count_;
  config.vertex_count = position_count_;
  config.instance_count = 1;
  config.primitive_topology = L_PRIMITIVE_TOPOLOGY_POINT;

  return std::make_unique<GraphicsTask>(renderer_, config);
}

} // namespace aot_demo
} // namespace ti
