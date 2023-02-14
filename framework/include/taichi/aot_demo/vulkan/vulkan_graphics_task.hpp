#pragma once
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/vulkan/vulkan_renderer.hpp"

namespace ti {
namespace aot_demo {

// Implemented in glslang.cpp
std::vector<uint32_t> vert2spv(const std::string& vert);
std::vector<uint32_t> frag2spv(const std::string &frag);

struct GraphicsTaskState {
  friend class Renderer;

  std::shared_ptr<Renderer> renderer_;
  GraphicsTaskConfig config_;

  VkPipeline pipeline_;
  VkPipelineLayout pipeline_layout_;
  VkDescriptorSetLayout descriptor_set_layout_;
  VkDescriptorPool descriptor_pool_;
  VkDescriptorSet descriptor_set_;
  VkBuffer uniform_buffer_;
  VmaAllocation uniform_buffer_allocation_;
  std::vector<VkImageView> texture_views_;

  GraphicsTaskState(const std::shared_ptr<Renderer> &renderer,
                    const GraphicsTaskConfig &config);
  ~GraphicsTaskState();
};

} // namespace aot_demo
} // namespace ti
