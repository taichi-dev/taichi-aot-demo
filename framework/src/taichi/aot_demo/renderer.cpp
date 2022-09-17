// A minimalist renderer.
// @PENGUINLIONG
#include <cassert>
#include <array>
#include <stdexcept>
#include <iostream>
#include <vulkan/vulkan.h>
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

// Implemented in glslang.cpp
std::vector<uint32_t> vert2spv(const std::string& vert);
std::vector<uint32_t> frag2spv(const std::string& frag);

inline void check_vulkan_result(VkResult result) {
  if (result < VK_SUCCESS) {
    throw std::runtime_error("vulkan failed");
  }
}

inline void check_taichi_error() {
  TiError error = ti_get_last_error(0, nullptr);
  if (error < TI_ERROR_SUCCESS) {
    throw std::runtime_error("taichi failed");
  }
}

VKAPI_ATTR VkBool32 VKAPI_CALL vulkan_validation_callback(
  VkDebugUtilsMessageSeverityFlagBitsEXT severity,
  VkDebugUtilsMessageTypeFlagsEXT type,
  const VkDebugUtilsMessengerCallbackDataEXT *data,
  void *user_data
) {
  if (severity > VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT) {
    std::cout << "Vulkan Validation: " << data->pMessage << std::endl;
  }
  return VK_FALSE;
}

Renderer::Renderer(bool debug) {
  VkResult res = VK_SUCCESS;

  uint32_t nlep = 0;
  vkEnumerateInstanceExtensionProperties(nullptr, &nlep, nullptr);
  std::vector<VkExtensionProperties> leps(nlep);
  res = vkEnumerateInstanceExtensionProperties(nullptr, &nlep, leps.data());
  check_vulkan_result(res);

  std::vector<const char*> llns {};
  std::vector<const char*> lens(nlep);
  for (size_t i = 0; i < leps.size(); ++i) {
    lens.at(i) = leps.at(i).extensionName;
  }

  if (debug) {
    llns.emplace_back("VK_LAYER_KHRONOS_validation");
    lens.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
  }

  uint32_t api_version = VK_API_VERSION_1_0;

  VkApplicationInfo ai {};
  ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
  ai.apiVersion = api_version;
  ai.pApplicationName = "TaichiAotDemo";
  ai.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
  ai.pEngineName = "Taichi";
  ai.engineVersion = VK_MAKE_VERSION(0, 0, 0);

  VkInstanceCreateInfo ici {};
  ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
  ici.pApplicationInfo = &ai;
  ici.enabledLayerCount = (uint32_t)llns.size();
  ici.ppEnabledLayerNames = llns.data();
  ici.enabledExtensionCount = (uint32_t)lens.size();
  ici.ppEnabledExtensionNames = lens.data();

  VkDebugUtilsMessengerCreateInfoEXT dumci {};
  if (debug) {
    dumci.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
    dumci.messageSeverity =
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
    dumci.messageType =
      VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
      VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
      VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
    dumci.pfnUserCallback = &vulkan_validation_callback;
    dumci.pUserData = nullptr;

    ici.pNext = &dumci;
  }

  VkInstance instance = VK_NULL_HANDLE;
  res = vkCreateInstance(&ici, nullptr, &instance);
  check_vulkan_result(res);

  uint32_t npd = 1;
  std::vector<VkPhysicalDevice> pds(npd);
  res = vkEnumeratePhysicalDevices(instance, &npd, pds.data());
  check_vulkan_result(res);

  VkPhysicalDevice physical_device = pds.at(0);

  VkPhysicalDeviceFeatures pdf {};
  vkGetPhysicalDeviceFeatures(physical_device, &pdf);

  uint32_t ndep = 0;
  vkEnumerateDeviceExtensionProperties(physical_device, nullptr, &ndep, nullptr);
  std::vector<VkExtensionProperties> deps(ndep);
  res = vkEnumerateDeviceExtensionProperties(physical_device, nullptr, &ndep, deps.data());
  check_vulkan_result(res);

  std::vector<const char*> dens(ndep);
  for (size_t i = 0; i < deps.size(); ++i) {
    dens.at(i) = deps.at(i).extensionName;
  }

  uint32_t nqfp = 0;
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, &nqfp, nullptr);
  std::vector<VkQueueFamilyProperties> qfps(nqfp);
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, &nqfp, qfps.data());

  uint32_t queue_family_index = VK_QUEUE_FAMILY_IGNORED;
  for (uint32_t i = 0; i < nqfp; ++i) {
    VkQueueFlags qfs = VK_QUEUE_GRAPHICS_BIT | VK_QUEUE_COMPUTE_BIT;
    if ((qfps.at(i).queueFlags & qfs) == qfs) { queue_family_index = i; }
  }
  assert(queue_family_index != VK_QUEUE_FAMILY_IGNORED);

  VkPhysicalDeviceProperties pdp {};
  vkGetPhysicalDeviceProperties(physical_device, &pdp);

  float qp = 1.0f;

  VkDeviceQueueCreateInfo dqci {};
  dqci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
  dqci.queueFamilyIndex = queue_family_index;
  dqci.queueCount = 1;
  dqci.pQueuePriorities = &qp;

  VkDeviceCreateInfo dci {};
  dci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
  dci.pEnabledFeatures = &pdf;
  dci.enabledExtensionCount = (uint32_t)dens.size();
  dci.ppEnabledExtensionNames = dens.data();
  dci.queueCreateInfoCount = 1;
  dci.pQueueCreateInfos = &dqci;

  VkDevice device = VK_NULL_HANDLE;
  res = vkCreateDevice(physical_device, &dci, nullptr, &device);

  VkQueue queue = VK_NULL_HANDLE;
  vkGetDeviceQueue(device, queue_family_index, 0, &queue);

  VmaAllocatorCreateInfo aci {};
  aci.vulkanApiVersion = api_version;
  aci.instance = instance;
  aci.physicalDevice = physical_device;
  aci.device = device;

  VmaAllocator vma_allocator = VK_NULL_HANDLE;
  vmaCreateAllocator(&aci, &vma_allocator);

  std::array<VkAttachmentDescription, 2> ads {};
  {
    VkAttachmentDescription& ad = ads.at(0);
    ad.format = VK_FORMAT_R8G8B8A8_UNORM;
    ad.initialLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
    ad.finalLayout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
    ad.samples = VK_SAMPLE_COUNT_1_BIT;
    ad.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
    ad.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
  }
  {
    VkAttachmentDescription& ad = ads.at(1);
    ad.format = VK_FORMAT_D16_UNORM;
    ad.initialLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
    ad.finalLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
    ad.samples = VK_SAMPLE_COUNT_1_BIT;
    ad.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
    ad.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
  }

  std::array<VkAttachmentReference, 2> ars {};
  {
    VkAttachmentReference& ar = ars.at(0);
    ar.attachment = 0;
    ar.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
  }
  {
    VkAttachmentReference& ar = ars.at(1);
    ar.attachment = 1;
    ar.layout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
  }

  VkSubpassDescription sd {};
  sd.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
  sd.colorAttachmentCount = 1;
  sd.pColorAttachments = &ars.at(0);
  sd.pDepthStencilAttachment = &ars.at(1);

  VkRenderPassCreateInfo rpci {};
  rpci.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
  rpci.attachmentCount = (uint32_t)ads.size();
  rpci.pAttachments = ads.data();
  rpci.subpassCount = 1;
  rpci.pSubpasses = &sd;

  VkRenderPass render_pass = VK_NULL_HANDLE;
  res = vkCreateRenderPass(device, &rpci, nullptr, &render_pass);
  check_vulkan_result(res);

  VkCommandPoolCreateInfo cpci {};
  cpci.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
  cpci.queueFamilyIndex = queue_family_index;

  VkCommandPool command_pool = VK_NULL_HANDLE;
  res = vkCreateCommandPool(device, &cpci, nullptr, &command_pool);
  check_vulkan_result(res);

  VkCommandBufferAllocateInfo cbai {};
  cbai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
  cbai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
  cbai.commandPool = command_pool;
  cbai.commandBufferCount = 1;

  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  res = vkAllocateCommandBuffers(device, &cbai, &command_buffer);
  check_vulkan_result(res);

  VkFenceCreateInfo fci {};
  fci.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;

  VkFence fence = VK_NULL_HANDLE;
  res = vkCreateFence(device, &fci, nullptr, &fence);
  check_vulkan_result(res);

  TiVulkanRuntimeInteropInfo vrii {};
  vrii.get_instance_proc_addr = &vkGetInstanceProcAddr;
  vrii.api_version = api_version;
  vrii.instance = instance;
  vrii.physical_device = physical_device;
  vrii.device = device;
  vrii.compute_queue = queue;
  vrii.compute_queue_family_index = queue_family_index;
  vrii.graphics_queue = queue;
  vrii.graphics_queue_family_index = queue_family_index;
  TiRuntime runtime = ti_import_vulkan_runtime(&vrii);
  check_taichi_error();

  TiError err = ti_get_last_error(0, nullptr);
  assert(err >= TI_ERROR_SUCCESS);

  instance_ = instance;
  device_ = device;
  queue_family_index_ = queue_family_index;
  queue_ = queue;
  vma_allocator_ = vma_allocator;

  render_pass_ = render_pass;
  framebuffer_ = VK_NULL_HANDLE;
  set_framebuffer_size(DEFAULT_FRAMEBUFFER_WIDTH, DEFAULT_FRAMEBUFFER_HEIGHT);

  command_pool_ = command_pool;
  command_buffer_ = command_buffer;
  fence_ = fence;

  runtime_ = runtime;

  in_frame_ = false;
}
Renderer::~Renderer() {
  destroy();
}
void Renderer::destroy() {
  ti_destroy_runtime(runtime_);
  runtime_ = TI_NULL_HANDLE;

  vkDestroyFence(device_, fence_, nullptr);
  vkDestroyCommandPool(device_, command_pool_, nullptr);

  vkDestroyFramebuffer(device_, framebuffer_, nullptr);
  vkDestroyImageView(device_, depth_attachment_view_, nullptr);
  vkDestroyImageView(device_, color_attachment_view_, nullptr);
  vmaDestroyImage(vma_allocator_, depth_attachment_, depth_attachment_allocation_);
  vmaDestroyImage(vma_allocator_, color_attachment_, color_attachment_allocation_);
  vkDestroyRenderPass(device_, render_pass_, nullptr);

  vkDestroyDevice(device_, nullptr);
  vkDestroyInstance(instance_, nullptr);

  instance_ = VK_NULL_HANDLE;
  device_ = VK_NULL_HANDLE;
  queue_family_index_ = VK_QUEUE_FAMILY_IGNORED;
  queue_ = VK_NULL_HANDLE;
}

void Renderer::set_framebuffer_size(uint32_t width, uint32_t height) {
  VkResult res = VK_SUCCESS;
  assert(!in_frame_);

  if (framebuffer_ != VK_NULL_HANDLE) {
    vkDestroyFramebuffer(device_, framebuffer_, nullptr);
    vkDestroyImageView(device_, depth_attachment_view_, nullptr);
    vkDestroyImageView(device_, color_attachment_view_, nullptr);
    vmaDestroyImage(vma_allocator_, depth_attachment_, depth_attachment_allocation_);
    vmaDestroyImage(vma_allocator_, color_attachment_, color_attachment_allocation_);
  }

  VkImageCreateInfo caci {};
  caci.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
  caci.imageType = VK_IMAGE_TYPE_2D;
  caci.format = VK_FORMAT_R8G8B8A8_UNORM;
  caci.extent.width = width;
  caci.extent.height = height;
  caci.extent.depth = 1;
  caci.mipLevels = 1;
  caci.arrayLayers = 1;
  caci.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
  caci.samples = VK_SAMPLE_COUNT_1_BIT;
  caci.tiling = VK_IMAGE_TILING_OPTIMAL;
  caci.usage =
    VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT |
    VK_IMAGE_USAGE_TRANSFER_SRC_BIT;

  VmaAllocationCreateInfo aci {};
  aci.usage = VMA_MEMORY_USAGE_GPU_ONLY;

  VkImage color_attachment = VK_NULL_HANDLE;
  VmaAllocation color_attachment_allocation = VK_NULL_HANDLE;
  res = vmaCreateImage(vma_allocator_, &caci, &aci, &color_attachment, &color_attachment_allocation, nullptr);
  check_vulkan_result(res);

  VkImageCreateInfo daci {};
  daci.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
  daci.imageType = VK_IMAGE_TYPE_2D;
  daci.format = VK_FORMAT_D16_UNORM;
  daci.extent.width = width;
  daci.extent.height = height;
  daci.extent.depth = 1;
  daci.mipLevels = 1;
  daci.arrayLayers = 1;
  daci.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
  daci.samples = VK_SAMPLE_COUNT_1_BIT;
  daci.tiling = VK_IMAGE_TILING_OPTIMAL;
  daci.usage = VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;

  VkImage depth_attachment = VK_NULL_HANDLE;
  VmaAllocation depth_attachment_allocation = VK_NULL_HANDLE;
  res = vmaCreateImage(vma_allocator_, &daci, &aci, &depth_attachment, &depth_attachment_allocation, nullptr);
  check_vulkan_result(res);

  VkImageViewCreateInfo cavci {};
  cavci.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
  cavci.viewType = VK_IMAGE_VIEW_TYPE_2D;
  cavci.image = color_attachment;
  cavci.format = VK_FORMAT_R8G8B8A8_UNORM;
  cavci.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
  cavci.subresourceRange.levelCount = 1;
  cavci.subresourceRange.layerCount = 1;

  VkImageView color_attachment_view = VK_NULL_HANDLE;
  res = vkCreateImageView(device_, &cavci, nullptr, &color_attachment_view);
  check_vulkan_result(res);

  VkImageViewCreateInfo davci {};
  davci.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
  davci.viewType = VK_IMAGE_VIEW_TYPE_2D;
  davci.image = depth_attachment;
  davci.format = VK_FORMAT_D16_UNORM;
  davci.subresourceRange.aspectMask = VK_IMAGE_ASPECT_DEPTH_BIT;
  davci.subresourceRange.levelCount = 1;
  davci.subresourceRange.layerCount = 1;
  
  VkImageView depth_attachment_view = VK_NULL_HANDLE;
  res = vkCreateImageView(device_, &davci, nullptr, &depth_attachment_view);
  check_vulkan_result(res);

  std::array<VkImageView, 2> avs {};
  avs.at(0) = color_attachment_view;
  avs.at(1) = depth_attachment_view;

  VkFramebufferCreateInfo fci {};
  fci.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
  fci.renderPass = render_pass_;
  fci.attachmentCount = (uint32_t)avs.size();
  fci.pAttachments = avs.data();
  fci.width = width;
  fci.height = height;
  fci.layers = 1;

  VkFramebuffer framebuffer = VK_NULL_HANDLE;
  res = vkCreateFramebuffer(device_, &fci, nullptr, &framebuffer);
  check_vulkan_result(res);

  framebuffer_ = framebuffer;
  color_attachment_allocation_ = color_attachment_allocation;
  depth_attachment_allocation_ = depth_attachment_allocation;
  color_attachment_ = color_attachment;
  depth_attachment_ = depth_attachment;
  color_attachment_view_ = color_attachment_view;
  depth_attachment_view_ = depth_attachment_view;
  width_ = width;
  height_ = height;
}

void Renderer::begin_frame() {
  VkResult res = VK_SUCCESS;
  assert(!in_frame_);

  res = vkWaitForFences(device_, 1, &fence_, VK_TRUE, 0);
  check_vulkan_result(res);

  res = vkResetCommandBuffer(command_buffer_, 0);
  check_vulkan_result(res);

  VkCommandBufferBeginInfo cbbi {};
  cbbi.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
  res = vkBeginCommandBuffer(command_buffer_, &cbbi);
  check_vulkan_result(res);

  std::array<VkImageMemoryBarrier, 2> imbs {};
  {
    VkImageMemoryBarrier& caimb = imbs.at(0);
    caimb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    caimb.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    caimb.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    caimb.srcAccessMask = 0;
    caimb.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
    caimb.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    caimb.newLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
    caimb.image = color_attachment_;
  }
  {
    VkImageMemoryBarrier& daimb = imbs.at(0);
    daimb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    daimb.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    daimb.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    daimb.srcAccessMask = 0;
    daimb.dstAccessMask = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
    daimb.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    daimb.newLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
    daimb.image = color_attachment_;
  }

  vkCmdPipelineBarrier(command_buffer_, VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
    VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 0, nullptr, 0, nullptr,
    (uint32_t)imbs.size(), imbs.data());

  VkRenderPassBeginInfo rpbi {};
  rpbi.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
  rpbi.renderPass = render_pass_;
  rpbi.framebuffer = framebuffer_;
  rpbi.renderArea.extent.width = width_;
  rpbi.renderArea.extent.height = height_;
  vkCmdBeginRenderPass(command_buffer_, &rpbi, VK_SUBPASS_CONTENTS_INLINE);

  in_frame_ = true;
}
void Renderer::end_frame() {
  VkResult res = VK_SUCCESS;
  assert(in_frame_);

  vkCmdEndRenderPass(command_buffer_);

  res = vkEndCommandBuffer(command_buffer_);
  check_vulkan_result(res);

  VkSubmitInfo si {};
  si.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
  si.commandBufferCount = 1;
  si.pCommandBuffers = &command_buffer_;
  res = vkQueueSubmit(queue_, 1, &si, fence_);

  in_frame_ = false;
}
void Renderer::enqueue_graphics_task(const GraphicsTaskEnqueueConfig& config) {
  assert(in_frame_);

  bool is_indexed = config.index_buffer.memory != VK_NULL_HANDLE;

  VkRect2D r {};
  r.extent.width = width_;
  r.extent.height = height_;
  vkCmdSetScissor(command_buffer_, 0, 1, &r);

  vkCmdBindPipeline(command_buffer_, VK_PIPELINE_BIND_POINT_GRAPHICS,
    config.graphics_task->pipeline_);

  vkCmdBindDescriptorSets(command_buffer_, VK_PIPELINE_BIND_POINT_GRAPHICS,
    config.graphics_task->pipeline_layout_, 0, 1,
    &config.graphics_task->descriptor_set_, 0, nullptr);

  {
    const TiVulkanMemoryInteropInfo& vmii = export_ti_memory(config.vertex_buffer.memory);
    VkDeviceSize o = (VkDeviceSize)config.vertex_buffer.offset;
    vkCmdBindVertexBuffers(command_buffer_, 0, 1, &vmii.buffer, &o);
  }

  if (is_indexed) {
    const TiVulkanMemoryInteropInfo& vmii = export_ti_memory(config.index_buffer.memory);
    vkCmdBindIndexBuffer(command_buffer_, vmii.buffer,
      (VkDeviceSize)config.index_buffer.offset, VK_INDEX_TYPE_UINT32);

    vkCmdDrawIndexed(command_buffer_, config.index_count, config.instance_count, 0, 0, 0);
  } else {
    vkCmdDraw(command_buffer_, config.vertex_count, config.instance_count, 0, 0);
  }
}

const TiVulkanMemoryInteropInfo& Renderer::export_ti_memory(TiMemory memory) {
  auto it = ti_memory_interops_.find(memory);
  if (it == ti_memory_interops_.end()) {
    TiVulkanMemoryInteropInfo vmii {};
    ti_export_vulkan_memory(runtime_, memory, &vmii);
    check_taichi_error();

    it = ti_memory_interops_.emplace(std::make_pair(memory, std::move(vmii))).first;
  }
  return it->second;
}

GraphicsTask::GraphicsTask(
  const std::shared_ptr<Renderer>& renderer,
  const GraphicsTaskConfig& cfg
) : cfg_(cfg) {
  VkResult res = VK_SUCCESS;
  assert(renderer->is_valid());

  VkDevice device = renderer->device();

  std::array<std::vector<uint32_t>, 2> cs {};
  cs.at(0) = vert2spv(cfg.vert_glsl);
  cs.at(1) = frag2spv(cfg.frag_glsl);

  std::vector<VkDescriptorType> dts(cfg.rscs.size());
  for (size_t i = 0; i < cfg.rscs.size(); ++i) {
    VkDescriptorType dt;
    switch (cfg.rscs.at(i)) {
    case L_GRAPHICS_TASK_RESOURCE_UNIFORM_BUFFER:
      dt = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
      break;
    case L_GRAPHICS_TASK_RESOURCE_STORAGE_BUFFER:
      dt = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
      break;
    case L_GRAPHICS_TASK_RESOURCE_SAMPLED_IMAGE:
      dt = VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
      break;
    default:
      throw std::logic_error("unknown descriptor type");
      return;
    }
    dts.emplace_back(dt);
  }

  std::array<VkShaderModule, 2> sms {};
  for (size_t i = 0; i < cs.size(); ++i) {
    VkShaderModuleCreateInfo smci {};
    smci.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    smci.codeSize = cs.at(i).size();
    smci.pCode = cs.at(i).data();

    VkShaderModule sm = VK_NULL_HANDLE;
    res = vkCreateShaderModule(device, &smci, nullptr, &sm);
    check_vulkan_result(res);

    sms.at(i) = sm;
  }

  std::vector<VkDescriptorPoolSize> dpss {};
  for (size_t i = 0; i < dts.size(); ++i) {
    VkDescriptorType dt = dts.at(i);

    auto it = std::find_if(dpss.begin(), dpss.end(),
      [&](const VkDescriptorPoolSize& dps) { return dps.type == dt; });
    if (it == dpss.end()) {
      VkDescriptorPoolSize dps {};
      dps.type = dt;
      dps.descriptorCount = 1;
      dpss.emplace_back(std::move(dps));
    } else {
      it->descriptorCount += 1;
    }
  }

  VkDescriptorPoolCreateInfo dpci {};
  dpci.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
  dpci.maxSets = 1;
  dpci.pPoolSizes = dpss.data();
  dpci.poolSizeCount = (uint32_t)dpss.size();

  VkDescriptorPool descriptor_pool = VK_NULL_HANDLE;
  res = vkCreateDescriptorPool(device, &dpci, nullptr, &descriptor_pool);
  check_vulkan_result(res);

  std::vector<VkDescriptorSetLayoutBinding> dslbs {};
  for (size_t i = 0; i < dts.size(); ++i) {
    VkDescriptorType dt = dts.at(i);

    VkDescriptorSetLayoutBinding dslb {};
    dslb.binding = i;
    dslb.descriptorCount = 1;
    dslb.descriptorType = dt;
    dslb.stageFlags = VK_SHADER_STAGE_ALL;
    dslbs.emplace_back(std::move(dslb));
  }

  VkDescriptorSetLayoutCreateInfo dslci {};
  dslci.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
  dslci.bindingCount = (uint32_t)dslbs.size();
  dslci.pBindings = dslbs.data();

  VkDescriptorSetLayout descriptor_set_layout = VK_NULL_HANDLE;
  res = vkCreateDescriptorSetLayout(device, &dslci, nullptr, &descriptor_set_layout);
  check_vulkan_result(res);

  VkDescriptorSetAllocateInfo dsai {};
  dsai.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
  dsai.descriptorPool = descriptor_pool;
  dsai.descriptorSetCount = 1;
  dsai.pSetLayouts = &descriptor_set_layout;

  VkDescriptorSet descriptor_set = VK_NULL_HANDLE;
  res = vkAllocateDescriptorSets(device, &dsai, &descriptor_set);
  check_vulkan_result(res);

  VkPipelineLayoutCreateInfo plci {};
  plci.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
  plci.setLayoutCount = 1;
  plci.pSetLayouts = &descriptor_set_layout;

  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  res = vkCreatePipelineLayout(device, &plci, nullptr, &pipeline_layout);
  check_vulkan_result(res);

  std::array<VkPipelineShaderStageCreateInfo, 2> psscis {};
  {
    VkPipelineShaderStageCreateInfo pssci = psscis.at(0);
    pssci.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    pssci.pName = "main";
    pssci.module = sms.at(0);
    pssci.stage = VK_SHADER_STAGE_VERTEX_BIT;
  }
  {
    VkPipelineShaderStageCreateInfo pssci = psscis.at(0);
    pssci.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    pssci.pName = "main";
    pssci.module = sms.at(1);
    pssci.stage = VK_SHADER_STAGE_FRAGMENT_BIT;
  }

  VkVertexInputAttributeDescription viad {};
  viad.location = 0;
  viad.binding = 0;
  viad.format = cfg.vert_fmt;
  viad.offset = 0;

  VkVertexInputBindingDescription vibd {};
  vibd.binding = 0;
  vibd.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;
  vibd.stride = cfg.vert_stride;

  VkPipelineVertexInputStateCreateInfo pvisci {};
  pvisci.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
  pvisci.vertexAttributeDescriptionCount = 1;
  pvisci.pVertexAttributeDescriptions = &viad;
  pvisci.vertexBindingDescriptionCount = 1;
  pvisci.pVertexBindingDescriptions = &vibd;

  VkPipelineInputAssemblyStateCreateInfo piasci {};
  piasci.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
  piasci.topology = cfg.topo;

  VkViewport v {};
  v.width = 1;
  v.height = 1;
  v.x = 0;
  v.y = 0;
  v.minDepth = 0.0;
  v.maxDepth = 1.0;

  VkRect2D s {}; // Dynamic.
  s.extent.width = 1;
  s.extent.height = 1;

  VkPipelineViewportStateCreateInfo pvsci {};
  pvsci.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
  pvsci.viewportCount = 1;
  pvsci.pViewports = &v;
  pvsci.scissorCount = 1;
  pvsci.pScissors = &s;

  VkPipelineRasterizationStateCreateInfo prsci {};
  prsci.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
  prsci.lineWidth = 1.0f;
  prsci.polygonMode = VK_POLYGON_MODE_FILL;
  prsci.cullMode = VK_CULL_MODE_BACK_BIT;
  prsci.frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE;

  VkPipelineMultisampleStateCreateInfo pmsci {};
  pmsci.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
  pmsci.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;

  VkPipelineDepthStencilStateCreateInfo pdssci {};
  pdssci.sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
  pdssci.depthTestEnable = VK_TRUE;
  pdssci.depthWriteEnable = VK_TRUE;
  pdssci.depthCompareOp = VK_COMPARE_OP_LESS;

  VkPipelineColorBlendAttachmentState pcbas {};
  pcbas.blendEnable = VK_TRUE;
  pcbas.srcColorBlendFactor = VK_BLEND_FACTOR_ONE;
  pcbas.dstColorBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA; 
  pcbas.colorBlendOp = VK_BLEND_OP_ADD;
  pcbas.srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE;
  pcbas.srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
  pcbas.alphaBlendOp = VK_BLEND_OP_ADD;
  pcbas.colorWriteMask =
    VK_COLOR_COMPONENT_R_BIT |
    VK_COLOR_COMPONENT_G_BIT |
    VK_COLOR_COMPONENT_B_BIT |
    VK_COLOR_COMPONENT_A_BIT;

  VkPipelineColorBlendStateCreateInfo pcbsci {};
  pcbsci.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
  pcbsci.attachmentCount = 2;
  pcbsci.pAttachments = &pcbas;
  pcbsci.blendConstants[0] = 1.0;
  pcbsci.blendConstants[1] = 1.0;
  pcbsci.blendConstants[2] = 1.0;
  pcbsci.blendConstants[3] = 1.0;

  std::array<VkDynamicState, 1> dss {
    VK_DYNAMIC_STATE_SCISSOR,
  };

  VkPipelineDynamicStateCreateInfo pdsci {};
  pdsci.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
  pdsci.dynamicStateCount = (uint32_t)dss.size();
  pdsci.pDynamicStates = dss.data();

  VkGraphicsPipelineCreateInfo gpci {};
  gpci.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
  gpci.stageCount = psscis.size();
  gpci.pStages = psscis.data();
  gpci.pVertexInputState = &pvisci;
  gpci.pInputAssemblyState = &piasci;
  gpci.pViewportState = &pvsci;
  gpci.pRasterizationState = &prsci;
  gpci.pMultisampleState = &pmsci;
  gpci.pDepthStencilState = &pdssci;
  gpci.pColorBlendState = &pcbsci;
  gpci.pDynamicState = &pdsci;
  gpci.layout = pipeline_layout;

  VkPipeline pipeline = VK_NULL_HANDLE;
  res = vkCreateGraphicsPipelines(device, nullptr, 1, &gpci, nullptr, &pipeline);
  check_vulkan_result(res);

  // Clean up. Shader modules can be destroyed at this point.
  for (size_t i = 0; i < sms.size(); ++i) {
    vkDestroyShaderModule(device, sms.at(i), nullptr);
  }

  renderer_ = renderer;
  pipeline_ = pipeline;
  pipeline_layout_ = pipeline_layout;
  descriptor_set_layout_ = descriptor_set_layout;
  descriptor_pool_ = descriptor_pool;
  descriptor_set_ = descriptor_set;
}
GraphicsTask::~GraphicsTask() {
  destroy();
}
void GraphicsTask::destroy() {
  VkDevice device = renderer_->device();
  vkDestroyDescriptorPool(device, descriptor_pool_, nullptr);
  vkDestroyDescriptorSetLayout(device, descriptor_set_layout_, nullptr);
  vkDestroyPipelineLayout(device, pipeline_layout_, nullptr);
  vkDestroyPipeline(device, pipeline_, nullptr);

  renderer_ = nullptr;
  pipeline_ = VK_NULL_HANDLE;
  pipeline_layout_ = VK_NULL_HANDLE;
  descriptor_set_layout_ = VK_NULL_HANDLE;
  descriptor_pool_ = VK_NULL_HANDLE;
  descriptor_set_ = VK_NULL_HANDLE;
}

} // namespace aot_demo
} // namespace ti
