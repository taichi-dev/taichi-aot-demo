#pragma once
#include "taichi/aot_demo/graphics_task.hpp"

namespace ti {
namespace aot_demo {
namespace vulkan {

class VulkanRenderer : public Renderer_ {
  friend class VulkanGraphicsTask;

  template<class T>
  friend class InteropHelper;

  template<class T>
  friend class TextureHelper;

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

  PFN_vkGetInstanceProcAddr loader_;
  ti::Runtime runtime_;

  ti::NdArray<float> rect_vertex_buffer_;
  ti::NdArray<float> rect_texcoord_buffer_;

  // Within a pair of `begin_frame` and `end_frame`.
  bool in_frame_;
  VkCommandBuffer frame_command_buffer_;

  void set_swapchain();

  std::map<TiMemory, TiVulkanMemoryInteropInfo> ti_memory_interops_;
  const TiVulkanMemoryInteropInfo& export_ti_memory(TiMemory memory);

public:
  bool is_valid() const override {
    return instance_ != VK_NULL_HANDLE;
  }
  void destroy() override;

  VulkanRenderer() {}
  VulkanRenderer(bool debug, uint32_t width, uint32_t height);
  ~VulkanRenderer() override;

  // The renderer's representation as Taichi objects.
  TiArch arch() const override {
    return TI_ARCH_VULKAN;
  }
  TiRuntime runtime() const override {
    return runtime_;
  }

  // Before a frame.
#if TI_AOT_DEMO_WITH_GLFW
  void set_surface_window(GLFWwindow* window);
#endif // TI_AOT_DEMO_WITH_GLFW
#if TI_AOT_DEMO_WITH_ANDROID_APP
  void set_surface_window(ANativeWindow* state);
#endif // TI_AOT_DEMO_WITH_ANDROID_APP


  // FIXME: (penguinliong) This one is somehow deprecaeted so please simply don't use it.
  void set_framebuffer_size(uint32_t width, uint32_t height);

  void begin_render() override;
  void end_render() override;
  void enqueue_graphics_task(const GraphicsTask& graphics_task) override;

  void present_to_surface() override;
  void present_to_ndarray(ti::NdArray<uint8_t>& dst) override;

  void next_frame() override;


  constexpr VkDevice device() const {
    return device_;
  }
  constexpr VmaAllocator vma_allocator() const {
    return vma_allocator_;
  }


  constexpr PFN_vkGetInstanceProcAddr loader() const {
    return loader_;
  }
  constexpr uint32_t width() const {
    return width_;
  }
  constexpr uint32_t height() const {
    return height_;
  }

  const ti::NdArray<float>& rect_vertex_buffer() const {
    return rect_vertex_buffer_;
  }
  const ti::NdArray<float>& rect_texcoord_buffer() const {
    return rect_texcoord_buffer_;
  }
};

} // namespace vulkan

// Alias to parent scope.
using Renderer = vulkan::VulkanRenderer;

} // namespace aot_demo
} // namespace ti
