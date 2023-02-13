#pragma once
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/draws/draw_points.hpp"
#include "taichi/aot_demo/draws/draw_particles.hpp"
#include "taichi/aot_demo/draws/draw_mesh.hpp"
#include "taichi/aot_demo/draws/draw_texture.hpp"

#define check_vulkan_result(x) \
  if (x < VK_SUCCESS) { \
    uint32_t x2 = (uint32_t)x; \
    std::printf("File \"%s\", line %d, in %s:\n", __FILE__, __LINE__, __func__); \
    std::printf("  vulkan failed: %d\n", x2); \
    std::fflush(stdout); \
    throw std::runtime_error("vulkan failed"); \
  }

namespace ti {
namespace aot_demo {

class Renderer;
class GraphicsTask;
template <typename T>
class VertexBuffer;
template <typename T>
class IndexBuffer;

struct RendererConfig {
  TiArch client_arch;
  uint32_t framebuffer_width;
  uint32_t framebuffer_height;
  bool debug;
};

class Renderer : public std::enable_shared_from_this<Renderer> {
  friend class GraphicsTask;
  friend class ShadowBuffer;
  friend class ShadowTexture;

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
  // This runtime always has `TI_ARCH_VULKAN`. This is used for internal interop
  // only. DO NOT EXPOSE AS PUBLIC.
  ti::Runtime runtime_;
  // This runtime has `RendererConfig::client_arch`.
  ti::Runtime client_runtime_;

  ti::NdArray<float> rect_vertex_buffer_;
  ti::NdArray<float> rect_texcoord_buffer_;

  // Within a pair of `begin_frame` and `end_frame`.
  bool in_frame_;
  VkCommandBuffer frame_command_buffer_;
  // Staging buffers will be released in `next_frame` so they can be repeatedly
  // allocated in each `update`.
  std::vector<ti::Memory> staging_buffers_;

  void set_swapchain();

  std::map<TiMemory, TiVulkanMemoryInteropInfo> ti_memory_interops_;
  std::map<TiImage, TiVulkanImageInteropInfo> ti_image_interops_;
  const TiVulkanMemoryInteropInfo& export_ti_memory(const ShadowBuffer &shadow_buffer);
  const TiVulkanImageInteropInfo& export_ti_image(const ShadowTexture &shadow_texture);

public:
  constexpr bool is_valid() const {
    return instance_ != VK_NULL_HANDLE;
  }
  void destroy();

  Renderer(const RendererConfig &config);
  ~Renderer();

  ti::Memory allocate_staging_buffer(size_t size) {
    ti::Memory staging_buffer = runtime_.allocate_memory(size, true);
    ti::Memory out = staging_buffer.borrow();
    staging_buffers_.emplace_back(std::move(staging_buffer));
    return out;
  }

  // Add your drawing functions here.
  DrawPointsBuilder draw_points(
    const ti::NdArray<float>& positions
  ) {
    return DrawPointsBuilder(shared_from_this(), positions);
  }
  DrawParticlesBuilder draw_particles(
    const ti::NdArray<float>& positions
  ) {
    return DrawParticlesBuilder(shared_from_this(), positions);
  }
  DrawMeshBuilder draw_mesh(
    const ti::NdArray<float>& positions,
    const ti::NdArray<uint32_t>& indices
  ) {
    return DrawMeshBuilder(shared_from_this(), positions, indices);
  }
  DrawTextureBuilder draw_texture(
    const ti::Texture& texture
  ) {
    return DrawTextureBuilder(shared_from_this(), texture);
  }
  DrawTextureBuilder draw_texture(const ti::NdArray<float> &texture) {
    return DrawTextureBuilder(shared_from_this(), texture);
  }

  // Before a frame.
#if TI_AOT_DEMO_WITH_GLFW
  void set_surface_window(GLFWwindow* window);
#endif // TI_AOT_DEMO_WITH_GLFW
#if TI_AOT_DEMO_ANDROID_APP
  void set_surface_window(ANativeWindow* state);
#endif // TI_AOT_DEMO_ANDROID_APP

  // FIXME: (penguinliong) This one is somehow deprecaeted so please simply don't use it.
  void set_framebuffer_size(uint32_t width, uint32_t height);

  // In a frame.
  void begin_render();
  void end_render();
  void enqueue_graphics_task(GraphicsTask& graphics_task);

  // After a frame. You MUST call one of them between frames for the renderer to
  // work properly
  void present_to_surface();
  ti::NdArray<uint8_t> present_to_ndarray();

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
  constexpr PFN_vkGetInstanceProcAddr loader() const {
    return loader_;
  }
  constexpr ti::Runtime &client_runtime() {
    return client_runtime_;
  }
  constexpr const ti::Runtime &client_runtime() const {
    return client_runtime_;
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


} // namespace aot_demo
} // namespace ti
