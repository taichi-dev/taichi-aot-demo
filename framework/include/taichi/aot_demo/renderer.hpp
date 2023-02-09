#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {

class GraphicsTask;

class Renderer {
  friend class GraphicsTask;

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
  constexpr bool is_valid() const {
    return instance_ != VK_NULL_HANDLE;
  }
  void destroy();

  Renderer() {}
  Renderer(bool debug, uint32_t width, uint32_t height);
  ~Renderer();

  // Before a frame.
#if TI_AOT_DEMO_WITH_GLFW
  void set_surface_window(GLFWwindow* window);
#endif // TI_AOT_DEMO_WITH_GLFW
#if TI_AOT_DEMO_WITH_ANDROID_APP
  void set_surface_window(ANativeWindow* state);
#endif // TI_AOT_DEMO_WITH_ANDROID_APP

  // FIXME: (penguinliong) This one is somehow deprecaeted so please simply don't use it.
  void set_framebuffer_size(uint32_t width, uint32_t height);

  // In a frame.
  void begin_render();
  void end_render();
  void enqueue_graphics_task(const GraphicsTask& graphics_task);

  // After a frame. You MUST call one of them between frames for the renderer to
  // work properly
  void present_to_surface();
  void present_to_ndarray(ti::NdArray<uint8_t>& dst);

  // After all the works of a frame. DO NOT call this unless you know what you
  // are doing.
  void next_frame();

  constexpr VkDevice device() const {
    return device_;
  }
  constexpr VmaAllocator vma_allocator() const {
    return vma_allocator_;
  }

  // The renderer's representation as Taichi objects.
  constexpr TiArch arch() const {
    return TI_ARCH_VULKAN;
  }
  constexpr PFN_vkGetInstanceProcAddr loader() const {
    return loader_;
  }
  constexpr TiRuntime runtime() const {
    return runtime_;
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

enum GraphicsTaskResourceType {
  L_GRAPHICS_TASK_RESOURCE_TYPE_NDARRAY,
  L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE,
};

struct GraphicsTaskResource {
  GraphicsTaskResourceType type;
  union {
    TiNdArray ndarray;
    TiTexture texture;
  };
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

  TiMemory vertex_buffer;
  TiMemory index_buffer;
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

  GraphicsTask() {}
  GraphicsTask(
    const std::shared_ptr<Renderer>& renderer,
    const GraphicsTaskConfig& config
  );
  ~GraphicsTask();
};


} // namespace aot_demo
} // namespace ti
