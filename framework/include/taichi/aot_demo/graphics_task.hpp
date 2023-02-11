#pragma once
#include <memory>
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/shadow_buffer.hpp"
#include "taichi/aot_demo/shadow_texture.hpp"

namespace ti {
namespace aot_demo {

class Renderer;

enum GraphicsTaskResourceType {
  L_GRAPHICS_TASK_RESOURCE_TYPE_BUFFER,
  L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE,
};

struct GraphicsTaskResource {
  GraphicsTaskResourceType type;
  std::shared_ptr<ShadowBuffer> shadow_buffer;
  std::shared_ptr<ShadowTexture> shadow_texture;

  GraphicsTaskResource(const std::shared_ptr<ShadowBuffer> &shadow_buffer)
      : type(L_GRAPHICS_TASK_RESOURCE_TYPE_BUFFER),
        shadow_buffer(std::move(shadow_buffer)) {
  }
  GraphicsTaskResource(const std::shared_ptr<ShadowTexture> &shadow_texture)
      : type(L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE),
        shadow_texture(std::move(shadow_texture)) {
  }
};

enum PrimitiveTopology {
  L_PRIMITIVE_TOPOLOGY_POINT,
  L_PRIMITIVE_TOPOLOGY_LINE,
  L_PRIMITIVE_TOPOLOGY_TRIANGLE,
};

struct GraphicsTaskConfig {
  std::string vertex_shader_glsl;
  std::string fragment_shader_glsl;
  void* uniform_buffer_data;
  size_t uniform_buffer_size;
  std::vector<GraphicsTaskResource> resources;

  std::shared_ptr<ShadowBuffer> vertex_buffer;
  std::shared_ptr<ShadowBuffer> index_buffer;
  uint32_t vertex_component_count;
  uint32_t vertex_count;
  uint32_t index_count;
  uint32_t instance_count;
  PrimitiveTopology primitive_topology;
};

class GraphicsTask {
  friend class Renderer;

  GraphicsTaskConfig config_;

  std::shared_ptr<Renderer> renderer_;
  VkPipeline pipeline_;
  VkPipelineLayout pipeline_layout_;
  VkDescriptorSetLayout descriptor_set_layout_;
  VkDescriptorPool descriptor_pool_;
  VkDescriptorSet descriptor_set_;
  VkBuffer uniform_buffer_;
  VmaAllocation uniform_buffer_allocation_;
  std::vector<VkImageView> texture_views_;

public:
  constexpr bool is_valid() const {
    return pipeline_ != VK_NULL_HANDLE;
  }
  void destroy();

  GraphicsTask(
    const std::shared_ptr<Renderer>& renderer,
    const GraphicsTaskConfig& config
  );
  ~GraphicsTask();
};

class GraphicsTaskBuilder {
 protected:
  std::shared_ptr<Renderer> renderer_;

  GraphicsTaskBuilder(const std::shared_ptr<Renderer> &renderer)
      : renderer_(renderer) {
  }

  std::shared_ptr<ShadowBuffer> create_shadow_buffer(const ti::Memory &src,
                                                     ShadowBufferUsage usage);
  std::shared_ptr<ShadowTexture> create_shadow_texture(const ti::Image &src,
                                                       ShadowTextureUsage usage);
};

} // namespace aot_demo
} // namespace ti
