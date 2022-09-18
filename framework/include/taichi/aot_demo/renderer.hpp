#pragma once
#include <array>
#include <cstdint>
#include <string>
#include <map>
#define TI_WITH_VULKAN 1
#include <taichi/cpp/taichi.hpp>
#include <vk_mem_alloc.h>

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;

class Renderer {
  friend class GraphicsTask;

  static const uint32_t DEFAULT_FRAMEBUFFER_WIDTH = 512;
  static const uint32_t DEFAULT_FRAMEBUFFER_HEIGHT = 256;

  VkInstance instance_;
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
  VkFence fence_;

  TiRuntime runtime_;

  // Within a pair of `begin_frame` and `end_frame`.
  bool in_frame_;
  VkCommandBuffer frame_command_buffer_;

  std::map<TiMemory, TiVulkanMemoryInteropInfo> ti_memory_interops_;
  const TiVulkanMemoryInteropInfo& export_ti_memory(TiMemory memory);

public:
  constexpr bool is_valid() const {
    return instance_ != VK_NULL_HANDLE;
  }
  void destroy();

  Renderer() {}
  Renderer(bool debug);
  ~Renderer();

  void set_framebuffer_size(uint32_t width, uint32_t height);

  void begin_frame();
  void end_frame();
  void enqueue_graphics_task(const GraphicsTask& graphics_task);

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
  constexpr TiRuntime runtime() const {
    return runtime_;
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
  size_t uniform_buffer_size;
  std::vector<GraphicsTaskResource> resources;

  TiMemorySlice vertex_buffer;
  TiMemorySlice index_buffer;
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
