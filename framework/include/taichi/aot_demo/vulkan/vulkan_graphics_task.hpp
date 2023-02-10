#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {
namespace vulkan {

class VulkanRenderer;

class VulkanGraphicsTask : public GraphicsTask_ {
  friend class VulkanRenderer;

  GraphicsTaskConfig config_;

  std::shared_ptr<VulkanRenderer> renderer_;
  VkPipeline pipeline_;
  VkPipelineLayout pipeline_layout_;
  VkDescriptorSetLayout descriptor_set_layout_;
  VkDescriptorPool descriptor_pool_;
  VkDescriptorSet descriptor_set_;
  VkBuffer uniform_buffer_;
  VmaAllocation uniform_buffer_allocation_;
  std::vector<VkImageView> texture_views_;

public:
  bool is_valid() const override {
    return pipeline_ != VK_NULL_HANDLE;
  }
  void destroy() override;

  VulkanGraphicsTask() {}
  VulkanGraphicsTask(
    const std::shared_ptr<VulkanRenderer>& renderer,
    const GraphicsTaskConfig& config
  );
  ~VulkanGraphicsTask() override;
};

} // namespace vulkan

// Alias to parent scope.
using GraphicsTask = vulkan::VulkanGraphicsTask;

} // namespace aot_demo
} // namespace ti
