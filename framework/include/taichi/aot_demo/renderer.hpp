#pragma once
#include <cstdint>
#include <string>
#define TI_WITH_VULKAN 1
#include <taichi/cpp/taichi.hpp>

namespace ti {
namespace aot_demo {

class Renderer {
  VkInstance instance_;
  VkDevice device_;
  uint32_t queue_family_index_;
  VkQueue queue_;

  TiRuntime runtime_;

public:
  constexpr bool is_valid() const {
    return instance_ != VK_NULL_HANDLE;
  }
  void destroy();

  Renderer(bool debug);
  ~Renderer();

  constexpr VkDevice device() const {
    return device_;
  }

  // The renderer's representation as Taichi objects.
  constexpr TiArch arch() const {
    return TI_ARCH_VULKAN;
  }
  constexpr TiRuntime runtime() const {
    return runtime_;
  }
};

enum GraphicsTaskResource {
  L_GRAPHICS_TASK_RESOURCE_UNIFORM_BUFFER,
  L_GRAPHICS_TASK_RESOURCE_STORAGE_BUFFER,
  L_GRAPHICS_TASK_RESOURCE_SAMPLED_IMAGE,
};

struct GraphicsTaskConfig {
  std::string vert_glsl;
  std::string frag_glsl;
  std::vector<GraphicsTaskResource> rscs;
  VkFormat vert_fmt;
  size_t vert_stride;
  VkIndexType idx_ty;
  VkPrimitiveTopology topo;
};

class GraphicsTask {
  const GraphicsTaskConfig cfg_;

  std::shared_ptr<Renderer> renderer_;
  VkPipeline pipeline_;
  VkPipelineLayout pipeline_layout_;
  VkDescriptorSetLayout descriptor_set_layout_;
  VkDescriptorPool descriptor_pool_;
  VkDescriptorSet descriptor_set_;

public:
  constexpr bool is_valid() const {
    return pipeline_ != VK_NULL_HANDLE;
  }
  void destroy();

  GraphicsTask(
    const std::shared_ptr<Renderer>& renderer,
    const GraphicsTaskConfig& cfg
  );
  ~GraphicsTask();
};


} // namespace aot_demo
} // namespace ti
