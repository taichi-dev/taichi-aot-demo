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
      ivec2 width_height;
    } u;
  )";
  struct UniformBuffer {
    glm::ivec2 width_height;
  } u;
  u.width_height = glm::ivec2(width_, height_);

  std::vector<GraphicsTaskResource> rscs;
  {
    rect_vertices_ =
        create_shadow_buffer(renderer_->rect_vertex_buffer().memory(),
                             ShadowBufferUsage::VertexBuffer);
    rect_texcoords_ =
        create_shadow_buffer(renderer_->rect_texcoord_buffer().memory(),
                             ShadowBufferUsage::StorageBuffer);
    rscs.emplace_back(rect_texcoords_);
  }

  const char* texture_declr;
  const char* texture_get;
  if (texture_ != nullptr) {
    rscs.emplace_back(texture_);
    texture_declr = "layout(binding=2) uniform sampler2D maintex;";
    texture_get = "texture(maintex, v_uv)";
  }
  if (texture_buffer_ != nullptr) {
    const char* texture_declr;
    switch (texel_component_count_) {
    case 1:
      texture_declr = R"(
        layout(binding=2, std430) readonly buffer MainTex {
          float texels[];
        };
      )";
      texture_get = "vec4(texels[(v_uv.y * u.width + v_uv.x)], 0.0, 0.0, 1.0)";
      break;
    case 2:
      texture_declr = R"(
        layout(binding=2, std430) readonly buffer MainTex {
          vec2 texels[];
        };
      )";
      texture_get = "vec4(texels[(v_uv.y * u.width + v_uv.x)], 0.0, 1.0)";
      break;
    case 3:
      texture_declr = R"(
        layout(binding=2, std430) readonly buffer MainTex {
          float texels[];
        };
      )";
      texture_get = "vec4(texels[(v_uv.y * u.width + v_uv.x) * 3], texels[(v_uv.y * u.width + v_uv.x) * 3 + 1], texels[(v_uv.y * u.width + v_uv.x) * 3 + 2], 1.0)";
      break;
    case 4:
      texture_declr = R"(
        layout(binding=2, std430) readonly buffer MainTex {
          vec4 texels[];
        };
      )";
      texture_get = "texels[(v_uv.y * u.width + v_uv.x)]";
      break;
    default:
      throw std::logic_error("vertex position can only `float`, `vec2`, `vec3` or `vec4`");
    }
    rscs.emplace_back(texture_buffer_);
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
  std::string frag;
  {
    std::stringstream ss;
    ss << R"(
      #version 460
      layout(location=0) in vec2 v_uv;
      layout(location=0) out vec4 color;
    )" << uniform_buffer_declr
       << "\n"
       << texture_declr << R"(
      void main() {
        color = )"
       << texture_get << R"(;
      }
    )";
    frag = ss.str();
  }

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
