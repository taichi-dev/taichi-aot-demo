#include <memory>
#include <sstream>
#include <vulkan/vulkan.h>
#include "taichi/aot_demo/renderer.hpp"
#include "taichi/aot_demo/draws/draw_texture.hpp"

namespace ti {
namespace aot_demo {

std::unique_ptr<GraphicsTask> DrawTextureBuilder::build() {
  const char* uniform_buffer_declr = R"(
    layout(binding=0) uniform Uniform {
      float dummy_;
    } u;
  )";
  struct UniformBuffer {
    float dummy_;
  } u;

  std::vector<GraphicsTaskResource> rscs;
  {
    rect_vertices_ = create_shadow_buffer(renderer_->rect_texcoord_buffer().memory(),
                                          ShadowBufferUsage::VertexBuffer);
    rscs.emplace_back(rect_vertices_);
  }
  {
    rscs.emplace_back(texture_);
  }

  std::string vert;
  {
    std::stringstream ss;
    ss << R"(
      #version 460
      layout(location=0) out vec2 v_uv;
      layout(location=0) in vec2 pos;
      )" <<
      uniform_buffer_declr << R"(
      layout(binding=1) readonly buffer _1 {
        vec2 uvs[];
      };
      void main() {
        gl_Position = vec4(pos, 0.0, 1.0);
        v_uv = uvs[gl_VertexIndex];
      }
    )";
    vert = ss.str();
  }
  const char* frag = R"(
    #version 460
    layout(location=0) in vec2 v_uv;
    layout(location=0) out vec4 color;

    layout(binding=2) uniform sampler2D maintex;
    void main() {
      color = texture(maintex, v_uv);
    }
  )";

  GraphicsTaskConfig config {};
  config.vertex_shader_glsl = vert;
  config.fragment_shader_glsl = frag;
  config.uniform_buffer_data = &u;
  config.uniform_buffer_size = sizeof(u);
  config.vertex_buffer = rect_vertices_;
  config.resources = std::move(rscs);
  config.vertex_component_count = 2;
  config.vertex_count = 6;
  config.instance_count = 1;
  config.primitive_topology = L_PRIMITIVE_TOPOLOGY_TRIANGLE;

  return std::make_unique<GraphicsTask>(renderer_, config);
}

} // namespace aot_demo
} // namespace ti
