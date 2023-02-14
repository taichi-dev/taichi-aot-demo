#pragma once
#include "taichi/aot_demo/renderer.hpp"

static_assert(TI_AOT_DEMO_RENDER_WITH_VULKAN, "vulkan renderer headers are only accessible when you are using a vulkan renderer");

namespace ti {
namespace aot_demo {

struct RendererState {
  uint32_t api_version_;
  VkInstance instance_;
  VkDebugUtilsMessengerEXT debug_utils_messenger_;
  VkPhysicalDevice physical_device_;
  VkDevice device_;
  uint32_t queue_family_index_;
  VkQueue queue_;
  VmaAllocator vma_allocator_;

  VkRenderPass render_pass_;
  VkFramebuffer framebuffer_;
  VmaAllocation color_attachment_allocation_;
  VmaAllocation depth_attachment_allocation_;
  VkImage color_attachment_;
  VkImage depth_attachment_;
  VkImageView color_attachment_view_;
  VkImageView depth_attachment_view_;
  uint32_t width_;
  uint32_t height_;
  VkSampler sampler_;

  VkCommandPool command_pool_;
  VkSemaphore render_present_semaphore_;
  VkSemaphore present_surface_semaphore_;
  VkFence acquire_fence_;
  VkFence present_fence_;

  VkSurfaceKHR surface_;
  VkSwapchainKHR swapchain_;
  std::vector<VkImage> swapchain_images_;
  uint32_t swapchain_image_width_;
  uint32_t swapchain_image_height_;

  // Within a pair of `begin_frame` and `end_frame`.
  bool in_frame_;
  VkCommandBuffer frame_command_buffer_;

  RendererState(const RendererConfig &config);
  ~RendererState();

  void set_framebuffer_size(uint32_t width, uint32_t height);
  void set_swapchain();

  // Before a frame.
#if TI_AOT_DEMO_WITH_GLFW
  void set_surface_window(GLFWwindow* window);
#endif // TI_AOT_DEMO_WITH_GLFW
#if TI_AOT_DEMO_ANDROID_APP
  void set_surface_window(ANativeWindow* state);
#endif // TI_AOT_DEMO_ANDROID_APP

  std::map<TiMemory, TiVulkanMemoryInteropInfo> ti_memory_interops_;
  std::map<TiImage, TiVulkanImageInteropInfo> ti_image_interops_;
  const TiVulkanMemoryInteropInfo &export_ti_memory(
      const ti::Runtime &runtime,
      const ShadowBuffer &shadow_buffer);
  const TiVulkanImageInteropInfo &export_ti_image(
      const ti::Runtime &runtime,
      const ShadowTexture &shadow_texture);
};

}  // namespace aot_demo
}  // namespace ti
