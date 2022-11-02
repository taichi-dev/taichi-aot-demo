// A minimalist renderer.
// @PENGUINLIONG
#include <cassert>
#include <array>
#include <stdexcept>
#include <iostream>
#include <set>
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

Renderer::Renderer(bool debug, uint32_t width, uint32_t height) {
  VkResult res = VK_SUCCESS;

  uint32_t nlep = 0;
  vkEnumerateInstanceExtensionProperties(nullptr, &nlep, nullptr);
  std::vector<VkExtensionProperties> leps(nlep);
  res = vkEnumerateInstanceExtensionProperties(nullptr, &nlep, leps.data());
  check_vulkan_result(res);

  std::vector<const char*> llns {};
  std::vector<const char*> lens {};

  if (debug) {
    llns.emplace_back("VK_LAYER_KHRONOS_validation");
    lens.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
  }

  uint32_t api_version = VK_API_VERSION_1_1;

  VkApplicationInfo ai {};
  ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
  ai.apiVersion = api_version;
  ai.pApplicationName = "TaichiAotDemo";
  ai.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
  ai.pEngineName = "Taichi";
  ai.engineVersion = VK_MAKE_VERSION(0, 0, 0);

  VkInstanceCreateInfo ici {};
  ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
#ifdef __MACH__
  ici.flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
#endif // __MACH__ 
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

  // (penguinliong) To support debug printing in shaders.
  std::array<VkValidationFeatureEnableEXT, 1> vfes {
    VK_VALIDATION_FEATURE_ENABLE_DEBUG_PRINTF_EXT,
  };
  VkValidationFeaturesEXT vf {};
  if (debug) {
    vf.sType = VK_STRUCTURE_TYPE_VALIDATION_FEATURES_EXT;
    vf.enabledValidationFeatureCount = vfes.size();
    vf.pEnabledValidationFeatures = vfes.data();

    vf.pNext = (void*)ici.pNext;
    ici.pNext = &vf;
  }

  VkInstance instance = VK_NULL_HANDLE;
  res = vkCreateInstance(&ici, nullptr, &instance);
  check_vulkan_result(res);

  uint32_t npd = 0;
  res = vkEnumeratePhysicalDevices(instance, &npd, nullptr);
  std::vector<VkPhysicalDevice> pds(npd);
  res = vkEnumeratePhysicalDevices(instance, &npd, pds.data());
  check_vulkan_result(res);

  uint32_t physical_device_index = 0;
try_another_physical_device:
  VkPhysicalDevice physical_device = pds.at(physical_device_index);

  VkPhysicalDeviceProperties pdp {};
  vkGetPhysicalDeviceProperties(physical_device, &pdp);

  // (penguinliong) Try not to be trapped by Intel's garbage integrated GPU.
  if (pdp.deviceType == VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU) {
    if (physical_device_index + 1 != pds.size()) {
      physical_device_index += 1;
      goto try_another_physical_device;
    }
  }

  uint32_t ndep = 0;
  vkEnumerateDeviceExtensionProperties(physical_device, nullptr, &ndep, nullptr);
  std::vector<VkExtensionProperties> deps(ndep);
  res = vkEnumerateDeviceExtensionProperties(physical_device, nullptr, &ndep, deps.data());
  check_vulkan_result(res);

  std::set<std::string> depens {};
  for (const VkExtensionProperties& ep : deps) {
    depens.insert(ep.extensionName);
  }
  auto has_dep = [&depens](const char* en) {
    return depens.find(en) != depens.end();
  };

  bool is_vk_1_1 = pdp.apiVersion >= VK_API_VERSION_1_1;
  bool is_vk_1_2 = pdp.apiVersion >= VK_API_VERSION_1_2;
  bool has_pdp2 = is_vk_1_1 || has_dep(VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME);
  bool has_saf = has_dep(VK_EXT_SHADER_ATOMIC_FLOAT_EXTENSION_NAME);

  VkPhysicalDeviceFeatures2KHR pdf2 {};
  pdf2.sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2;

  VkPhysicalDeviceShaderAtomicFloatFeaturesEXT pdsaff {};
  pdsaff.sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_FEATURES_EXT;

  if (has_pdp2) {
    if (has_saf) {
      pdsaff.pNext = pdf2.pNext;
      pdf2.pNext = &pdsaff;
    }
    vkGetPhysicalDeviceFeatures2(physical_device, &pdf2);
  } else {
    vkGetPhysicalDeviceFeatures(physical_device, &pdf2.features);
  }



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

  float qp = 1.0f;

  VkDeviceQueueCreateInfo dqci {};
  dqci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
  dqci.queueFamilyIndex = queue_family_index;
  dqci.queueCount = 1;
  dqci.pQueuePriorities = &qp;

  VkDeviceCreateInfo dci {};
  dci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
  dci.pEnabledFeatures = &pdf2.features;
  dci.enabledExtensionCount = (uint32_t)dens.size();
  dci.ppEnabledExtensionNames = dens.data();
  dci.queueCreateInfoCount = 1;
  dci.pQueueCreateInfos = &dqci;

  if (has_saf) {
    pdsaff.pNext = (void*)dci.pNext;
    dci.pNext = &pdsaff;
  }

  VkDevice device = VK_NULL_HANDLE;
  res = vkCreateDevice(physical_device, &dci, nullptr, &device);

  VkQueue queue = VK_NULL_HANDLE;
  vkGetDeviceQueue(device, queue_family_index, 0, &queue);

  VmaVulkanFunctions vf2 {};
  vf2.vkGetInstanceProcAddr = &vkGetInstanceProcAddr;
  vf2.vkGetDeviceProcAddr = &vkGetDeviceProcAddr;

  VmaAllocatorCreateInfo aci {};
  // FIXME: (penguinliong) Use the real Vulkan API version when device
  // capability is in.
  aci.vulkanApiVersion = api_version;
  aci.instance = instance;
  aci.physicalDevice = physical_device;
  aci.device = device;
  aci.pVulkanFunctions = &vf2;

  VmaAllocator vma_allocator = VK_NULL_HANDLE;
  vmaCreateAllocator(&aci, &vma_allocator);

  // TODO: (penguinliong) Export from Taichi?
  VkSamplerCreateInfo sci {};
  sci.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
  sci.magFilter = VK_FILTER_LINEAR;
  sci.maxLod = VK_LOD_CLAMP_NONE;

  VkSampler sampler = VK_NULL_HANDLE;
  res = vkCreateSampler(device, &sci, nullptr, &sampler);

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
    ad.format = VK_FORMAT_D32_SFLOAT;
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

  VkSemaphoreCreateInfo sci2 {};
  sci2.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

  VkSemaphore render_present_semaphore = VK_NULL_HANDLE;
  res = vkCreateSemaphore(device, &sci2, nullptr, &render_present_semaphore);

  VkFenceCreateInfo fci {};
  fci.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;

  VkFence acquire_fence = VK_NULL_HANDLE;
  res = vkCreateFence(device, &fci, nullptr, &acquire_fence);
  check_vulkan_result(res);

  VkFence present_fence = VK_NULL_HANDLE;
  res = vkCreateFence(device, &fci, nullptr, &present_fence);
  check_vulkan_result(res);

  PFN_vkGetInstanceProcAddr loader = &vkGetInstanceProcAddr;

  TiVulkanRuntimeInteropInfo vrii {};
  vrii.get_instance_proc_addr = loader;
  // FIXME: (penguinliong) Use the real Vulkan API version when device
  // capability is in.
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

  in_frame_ = false;

  instance_ = instance;
  physical_device_ = physical_device;
  device_ = device;
  queue_family_index_ = queue_family_index;
  queue_ = queue;
  vma_allocator_ = vma_allocator;
  sampler_ = sampler;

  render_pass_ = render_pass;
  framebuffer_ = VK_NULL_HANDLE;
  set_framebuffer_size(width, height);

  command_pool_ = command_pool;
  render_present_semaphore_ = render_present_semaphore;
  acquire_fence_ = acquire_fence;
  present_fence_ = present_fence;

  runtime_ = runtime;
  loader_ = loader;
}
Renderer::~Renderer() {
  destroy();
}
void Renderer::destroy() {
  ti_destroy_runtime(runtime_);

  vkDestroyFence(device_, acquire_fence_, nullptr);
  vkDestroyFence(device_, present_fence_, nullptr);
  vkDestroyCommandPool(device_, command_pool_, nullptr);
  vkDestroyFramebuffer(device_, framebuffer_, nullptr);
  vkDestroyRenderPass(device_, render_pass_, nullptr);
  vkDestroyImageView(device_, depth_attachment_view_, nullptr);
  vkDestroyImageView(device_, color_attachment_view_, nullptr);
  vmaDestroyImage(vma_allocator_, depth_attachment_, depth_attachment_allocation_);
  vmaDestroyImage(vma_allocator_, color_attachment_, color_attachment_allocation_);

  vkDestroySampler(device_, sampler_, nullptr);
  vmaDestroyAllocator(vma_allocator_);
  vkDestroyDevice(device_, nullptr);
  vkDestroyInstance(instance_, nullptr);

  instance_ = VK_NULL_HANDLE;
  physical_device_ = VK_NULL_HANDLE;
  device_ = VK_NULL_HANDLE;
  queue_family_index_ = VK_QUEUE_FAMILY_IGNORED;
  queue_ = VK_NULL_HANDLE;
  vma_allocator_ = nullptr;
  sampler_ = VK_NULL_HANDLE;

  color_attachment_ = VK_NULL_HANDLE;
  color_attachment_allocation_ = VK_NULL_HANDLE;
  depth_attachment_ = VK_NULL_HANDLE;
  depth_attachment_allocation_ = VK_NULL_HANDLE;
  render_pass_ = VK_NULL_HANDLE;
  framebuffer_ = VK_NULL_HANDLE;
  command_pool_ = VK_NULL_HANDLE;
  render_present_semaphore_ = VK_NULL_HANDLE;
  present_surface_semaphore_ = VK_NULL_HANDLE;
  acquire_fence_ = VK_NULL_HANDLE;
  present_fence_ = VK_NULL_HANDLE;

  surface_ = VK_NULL_HANDLE;
  swapchain_ = VK_NULL_HANDLE;

  runtime_ = TI_NULL_HANDLE;
}

#if TI_AOT_DEMO_WITH_GLFW
void Renderer::set_surface_window(GLFWwindow* window) {
  VkResult res = VK_SUCCESS;

  VkSurfaceKHR surface = VK_NULL_HANDLE;
  res = glfwCreateWindowSurface(instance_, window, nullptr, &surface);
  check_vulkan_result(res);

  VkSurfaceCapabilitiesKHR sc {};
  res = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device_, surface, &sc);
  check_vulkan_result(res);

  uint32_t swapchain_image_width = sc.currentExtent.width;
  uint32_t swapchain_image_height = sc.currentExtent.height;

  uint32_t nsf = 1;
  VkSurfaceFormatKHR sf {};
  vkGetPhysicalDeviceSurfaceFormatsKHR(physical_device_, surface, &nsf, &sf);

  VkSwapchainCreateInfoKHR sci {};
  sci.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
  sci.surface = surface;
  sci.minImageCount = 2;
  sci.imageFormat = sf.format;
  sci.imageColorSpace = sf.colorSpace;
  sci.imageExtent.width = swapchain_image_width;
  sci.imageExtent.height = swapchain_image_height;
  sci.imageArrayLayers = 1;
  sci.imageUsage =
    VK_IMAGE_USAGE_TRANSFER_SRC_BIT |
    VK_IMAGE_USAGE_TRANSFER_DST_BIT;
  sci.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
  sci.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
  sci.presentMode = VK_PRESENT_MODE_FIFO_KHR;
  sci.clipped = VK_TRUE;

  VkSwapchainKHR swapchain = VK_NULL_HANDLE;
  res = vkCreateSwapchainKHR(device_, &sci, nullptr, &swapchain);
  check_vulkan_result(res);

  uint32_t nswapchain_image = 0;
  vkGetSwapchainImagesKHR(device_, swapchain, &nswapchain_image, nullptr);
  std::vector<VkImage> swapchain_images(nswapchain_image);
  vkGetSwapchainImagesKHR(device_, swapchain, &nswapchain_image, swapchain_images.data());

  surface_ = surface;
  swapchain_ = swapchain;
  swapchain_images_ = std::move(swapchain_images);
  swapchain_image_width_ = swapchain_image_width;
  swapchain_image_height_ = swapchain_image_height;
}
#endif // TI_AOT_DEMO_WITH_GLFW

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
  daci.format = VK_FORMAT_D32_SFLOAT;
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
  davci.format = VK_FORMAT_D32_SFLOAT;
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

void Renderer::begin_render() {
  VkResult res = VK_SUCCESS;
  assert(!in_frame_);

  VkCommandBufferAllocateInfo cbai {};
  cbai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
  cbai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
  cbai.commandPool = command_pool_;
  cbai.commandBufferCount = 1;

  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  res = vkAllocateCommandBuffers(device_, &cbai, &command_buffer);
  check_vulkan_result(res);

  VkCommandBufferBeginInfo cbbi {};
  cbbi.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
  cbbi.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
  res = vkBeginCommandBuffer(command_buffer, &cbbi);
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
    caimb.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
    caimb.subresourceRange.levelCount = 1;
    caimb.subresourceRange.layerCount = 1;
  }
  {
    VkImageMemoryBarrier& daimb = imbs.at(1);
    daimb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    daimb.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    daimb.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    daimb.srcAccessMask = 0;
    daimb.dstAccessMask = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
    daimb.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    daimb.newLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
    daimb.image = depth_attachment_;
    daimb.subresourceRange.aspectMask = VK_IMAGE_ASPECT_DEPTH_BIT;
    daimb.subresourceRange.levelCount = 1;
    daimb.subresourceRange.layerCount = 1;
  }

  vkCmdPipelineBarrier(command_buffer, VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
    VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT, 0, 0, nullptr, 0, nullptr,
    (uint32_t)imbs.size(), imbs.data());

  std::array<VkClearValue, 2> ccvs {};
  {
    VkClearValue& ccv = ccvs.at(0);
    ccv.color.float32[0] = 0.0f;
    ccv.color.float32[1] = 0.0f;
    ccv.color.float32[2] = 0.0f;
    ccv.color.float32[3] = 1.0f;
  }
  {
    VkClearValue& ccv = ccvs.at(1);
    ccv.depthStencil.depth = 1.0f;
    ccv.depthStencil.stencil = 0;
  }

  VkRenderPassBeginInfo rpbi {};
  rpbi.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
  rpbi.renderPass = render_pass_;
  rpbi.framebuffer = framebuffer_;
  rpbi.renderArea.extent.width = width_;
  rpbi.renderArea.extent.height = height_;
  rpbi.clearValueCount = (uint32_t)ccvs.size();
  rpbi.pClearValues = ccvs.data();
  vkCmdBeginRenderPass(command_buffer, &rpbi, VK_SUBPASS_CONTENTS_INLINE);

  in_frame_ = true;
  frame_command_buffer_ = command_buffer;
}
void Renderer::end_render() {
  VkResult res = VK_SUCCESS;
  assert(in_frame_);

  vkCmdEndRenderPass(frame_command_buffer_);

  res = vkEndCommandBuffer(frame_command_buffer_);
  check_vulkan_result(res);

  VkSubmitInfo si {};
  si.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
  si.commandBufferCount = 1;
  si.pCommandBuffers = &frame_command_buffer_;
  si.signalSemaphoreCount = 1;
  si.pSignalSemaphores = &render_present_semaphore_;
  res = vkQueueSubmit(queue_, 1, &si, nullptr);

  in_frame_ = false;
  frame_command_buffer_ = VK_NULL_HANDLE;
}
void Renderer::enqueue_graphics_task(const GraphicsTask& graphics_task) {
  assert(in_frame_);

  const GraphicsTaskConfig& config  = graphics_task.config_;

  bool is_indexed = config.index_buffer != VK_NULL_HANDLE;

  VkViewport v {};
  v.width = width_;
  v.height = height_;
  v.maxDepth = 1.0f;
  vkCmdSetViewport(frame_command_buffer_, 0, 1, &v);

  VkRect2D r {};
  r.extent.width = width_;
  r.extent.height = height_;
  vkCmdSetScissor(frame_command_buffer_, 0, 1, &r);

  vkCmdBindPipeline(frame_command_buffer_, VK_PIPELINE_BIND_POINT_GRAPHICS,
    graphics_task.pipeline_);

  vkCmdBindDescriptorSets(frame_command_buffer_, VK_PIPELINE_BIND_POINT_GRAPHICS,
    graphics_task.pipeline_layout_, 0, 1,
    &graphics_task.descriptor_set_, 0, nullptr);

  {
    const TiVulkanMemoryInteropInfo& vmii = export_ti_memory(config.vertex_buffer);
    VkDeviceSize o = 0;
    vkCmdBindVertexBuffers(frame_command_buffer_, 0, 1, &vmii.buffer, &o);
  }

  if (is_indexed) {
    const TiVulkanMemoryInteropInfo& vmii = export_ti_memory(config.index_buffer);
    vkCmdBindIndexBuffer(frame_command_buffer_, vmii.buffer, 0, VK_INDEX_TYPE_UINT32);

    vkCmdDrawIndexed(frame_command_buffer_, config.index_count, config.instance_count, 0, 0, 0);
  } else {
    vkCmdDraw(frame_command_buffer_, config.vertex_count, config.instance_count, 0, 0);
  }
}

void Renderer::present_to_surface() {
  assert(swapchain_);
  VkResult res = VK_SUCCESS;

  uint32_t i = !0u;
  res = vkAcquireNextImageKHR(device_, swapchain_, 0, VK_NULL_HANDLE, acquire_fence_, &i);
  check_vulkan_result(res);

  res = VK_TIMEOUT;
  while (res > VK_SUCCESS) {
    res = vkWaitForFences(device_, 1, &acquire_fence_, VK_TRUE, 1000000000);
    check_vulkan_result(res);
  }

  vkResetFences(device_, 1, &acquire_fence_);
  check_vulkan_result(res);

  VkImage swapchain_image = swapchain_images_.at(i);

  VkCommandBufferAllocateInfo cbai {};
  cbai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
  cbai.commandPool = command_pool_;
  cbai.commandBufferCount = 1;
  cbai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;

  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  res = vkAllocateCommandBuffers(device_, &cbai, &command_buffer);

  VkCommandBufferBeginInfo cbbi {};
  cbbi.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
  cbbi.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
  res = vkBeginCommandBuffer(command_buffer, &cbbi);
  check_vulkan_result(res);

  {
    VkImageMemoryBarrier imb {};
    imb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    imb.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    imb.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    imb.image = swapchain_image;
    imb.srcAccessMask = 0;
    imb.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    imb.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    imb.newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    imb.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
    imb.subresourceRange.levelCount = 1;
    imb.subresourceRange.layerCount = 1;
    vkCmdPipelineBarrier(command_buffer,
      VK_PIPELINE_STAGE_ALL_COMMANDS_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT,
      0, 0, nullptr, 0, nullptr, 1, &imb);
  }

  VkImageBlit ib {};
  ib.srcSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
  ib.srcSubresource.layerCount = 1;
  ib.srcOffsets[1].x = width_;
  ib.srcOffsets[1].y = height_;
  ib.srcOffsets[1].z = 1;
  ib.dstSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
  ib.dstSubresource.layerCount = 1;
  ib.dstOffsets[1].x = swapchain_image_width_;
  ib.dstOffsets[1].y = swapchain_image_height_;
  ib.dstOffsets[1].z = 1;
  vkCmdBlitImage(command_buffer,
    color_attachment_, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
    swapchain_image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
    1, &ib, VK_FILTER_LINEAR);

  {
    VkImageMemoryBarrier imb {};
    imb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    imb.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    imb.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    imb.image = swapchain_image;
    imb.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    imb.dstAccessMask = 0;
    imb.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    imb.newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
    imb.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
    imb.subresourceRange.levelCount = 1;
    imb.subresourceRange.layerCount = 1;
    vkCmdPipelineBarrier(command_buffer,
      VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
      0, 0, nullptr, 0, nullptr, 1, &imb);
  }

  res = vkEndCommandBuffer(command_buffer);
  check_vulkan_result(res);

  VkPipelineStageFlags ps = VK_PIPELINE_STAGE_ALL_COMMANDS_BIT;

  VkSubmitInfo si {};
  si.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
  si.commandBufferCount = 1;
  si.pCommandBuffers = &command_buffer;
  si.waitSemaphoreCount = 1;
  si.pWaitSemaphores = &render_present_semaphore_;
  si.pWaitDstStageMask = &ps;
  res = vkQueueSubmit(queue_, 1, &si, present_fence_);
  check_vulkan_result(res);

  VkPresentInfoKHR pi {};
  pi.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
  pi.swapchainCount = 1;
  pi.pSwapchains = &swapchain_;
  pi.pImageIndices = &i;
  pi.pResults = &res;
  res = vkQueuePresentKHR(queue_, &pi);
  check_vulkan_result(res);
}

void Renderer::present_to_ndarray(ti::NdArray<uint8_t>& dst) {
  assert(!in_frame_);
  assert(dst.shape().dim_count == 2);
  assert(dst.shape().dims[0] == width_);
  assert(dst.shape().dims[1] == height_);
  assert(dst.elem_shape().dim_count == 1);
  assert(dst.elem_shape().dims[0] == 4);
  VkResult res = VK_SUCCESS;

  const TiVulkanMemoryInteropInfo& vmii = export_ti_memory(dst.memory());

  VkCommandBufferAllocateInfo cbai {};
  cbai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
  cbai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
  cbai.commandPool = command_pool_;
  cbai.commandBufferCount = 1;

  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  res = vkAllocateCommandBuffers(device_, &cbai, &command_buffer);
  check_vulkan_result(res);

  VkCommandBufferBeginInfo cbbi {};
  cbbi.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
  cbbi.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
  res = vkBeginCommandBuffer(command_buffer, &cbbi);
  check_vulkan_result(res);

  VkBufferImageCopy bic {};
  bic.bufferRowLength = dst.shape().dims[0];
  bic.bufferImageHeight = dst.shape().dims[1];
  bic.imageExtent.width = width_;
  bic.imageExtent.height = height_;
  bic.imageExtent.depth = 1;
  bic.imageSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
  bic.imageSubresource.layerCount = 1;
  vkCmdCopyImageToBuffer(command_buffer, color_attachment_, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL, vmii.buffer, 1, &bic);

  res = vkEndCommandBuffer(command_buffer);
  check_vulkan_result(res);

  VkPipelineStageFlags ps = VK_PIPELINE_STAGE_ALL_COMMANDS_BIT;

  VkSubmitInfo si {};
  si.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
  si.commandBufferCount = 1;
  si.pCommandBuffers = &command_buffer;
  si.waitSemaphoreCount = 1;
  si.pWaitSemaphores = &render_present_semaphore_;
  si.pWaitDstStageMask = &ps;
  res = vkQueueSubmit(queue_, 1, &si, present_fence_);
  check_vulkan_result(res);
}

void Renderer::next_frame() {
  VkResult res = VK_SUCCESS;

  res = VK_TIMEOUT;
  while (res > VK_SUCCESS) {
    res = vkWaitForFences(device_, 1, &present_fence_, VK_TRUE, 1000000000);
    check_vulkan_result(res);
  }

  res = vkResetFences(device_, 1, &present_fence_);
  check_vulkan_result(res);

  vkResetCommandPool(device_, command_pool_, 0);
  check_vulkan_result(res);
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
  const GraphicsTaskConfig& config
) : renderer_(renderer), config_(config) {
  VkResult res = VK_SUCCESS;
  assert(renderer->is_valid());

  VkDevice device = renderer->device();

  std::array<std::vector<uint32_t>, 2> cs {};
  cs.at(0) = vert2spv(config.vertex_shader_glsl);
  assert(!cs.at(0).empty());
  cs.at(1) = frag2spv(config.fragment_shader_glsl);
  assert(!cs.at(1).empty());


  std::vector<VkDescriptorType> dts {};
  dts.reserve(config.resources.size());
  dts.emplace_back(VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER);
  for (size_t i = 0; i < config.resources.size(); ++i) {
    VkDescriptorType dt;
    switch (config.resources.at(i).type) {
    case L_GRAPHICS_TASK_RESOURCE_TYPE_NDARRAY:
      dt = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
      break;
    case L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE:
      dt = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
      break;
    default:
      throw std::logic_error("unknown descriptor type");
      return;
    }
    dts.emplace_back(std::move(dt));
  }

  std::array<VkShaderModule, 2> sms {};
  for (size_t i = 0; i < cs.size(); ++i) {
    VkShaderModuleCreateInfo smci {};
    smci.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    smci.codeSize = cs.at(i).size() * sizeof(uint32_t);
    smci.pCode = cs.at(i).data();

    VkShaderModule sm = VK_NULL_HANDLE;
    res = vkCreateShaderModule(device, &smci, nullptr, &sm);
    check_vulkan_result(res);

    sms.at(i) = sm;
  }

  std::vector<VkDescriptorPoolSize> dpss {};
  {
    VkDescriptorPoolSize dps {};
    dps.type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
    dps.descriptorCount = 1;
    dpss.emplace_back(std::move(dps));
  }
  for (size_t i = 0; i < dts.size(); ++i) {
    VkDescriptorType dt = dts.at(i);

    auto it = dpss.begin();
    for (; it != dpss.end(); ++it) {
      if (it->type == dt) {
        it->descriptorCount += 1;
      }
    }
    if (it == dpss.end()) {
      VkDescriptorPoolSize dps {};
      dps.type = dt;
      dps.descriptorCount = 1;
      dpss.emplace_back(std::move(dps));
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

  VkBufferCreateInfo ubbci {};
  ubbci.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
  ubbci.size = config.uniform_buffer_size;
  ubbci.usage = VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;

  VmaAllocationCreateInfo aci {};
  aci.usage = VMA_MEMORY_USAGE_CPU_TO_GPU;

  VkBuffer uniform_buffer = VK_NULL_HANDLE;
  VmaAllocation uniform_buffer_allocation = VK_NULL_HANDLE;
  res = vmaCreateBuffer(renderer->vma_allocator_, &ubbci, &aci, &uniform_buffer,
    &uniform_buffer_allocation, nullptr);
  check_vulkan_result(res);

  void* ub;
  res = vmaMapMemory(renderer->vma_allocator_, uniform_buffer_allocation, &ub);
  check_vulkan_result(res);

  std::memcpy(ub, config.uniform_buffer_data, config.uniform_buffer_size);
  vmaUnmapMemory(renderer->vma_allocator_, uniform_buffer_allocation);

  std::vector<VkDescriptorBufferInfo> dbis {};
  dbis.reserve(dts.size());
  std::vector<VkDescriptorImageInfo> diis {};
  diis.reserve(dts.size());
  std::vector<VkImageView> texture_views;
  std::vector<VkWriteDescriptorSet> wdss {};
  {
    VkDescriptorBufferInfo dbi {};
    dbi.buffer = uniform_buffer;
    dbi.range = config.uniform_buffer_size;
    dbis.emplace_back(std::move(dbi));

    VkWriteDescriptorSet wds {};
    wds.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
    wds.descriptorCount = 1;
    wds.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
    wds.dstBinding = 0;
    wds.dstSet = descriptor_set;
    wds.pBufferInfo = &dbis.back();
    wdss.emplace_back(std::move(wds));
  }
  for (size_t i = 0; i < config.resources.size(); ++i) {
    const GraphicsTaskResource &resource = config.resources.at(i);
    switch (resource.type) {
    case L_GRAPHICS_TASK_RESOURCE_TYPE_NDARRAY:
    {
      const TiVulkanMemoryInteropInfo& vmii =
        renderer_->export_ti_memory(resource.ndarray.memory);

      VkDescriptorBufferInfo dbi {};
      dbi.buffer = vmii.buffer;
      dbi.range = vmii.size;
      dbis.emplace_back(std::move(dbi));

      VkWriteDescriptorSet wds {};
      wds.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
      wds.descriptorCount = 1;
      wds.descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
      wds.dstBinding = i + 1;
      wds.dstSet = descriptor_set;
      wds.pBufferInfo = &dbis.back();
      wdss.emplace_back(std::move(wds));
      break;
    }
    case L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE:
    {
      TiVulkanImageInteropInfo viii {};
      ti_export_vulkan_image(renderer_->runtime(), resource.texture.image, &viii);
      check_taichi_error();

      VkImageViewType ivt;
      switch (viii.image_type) {
      case VK_IMAGE_TYPE_1D:
        ivt = VK_IMAGE_VIEW_TYPE_1D;
        break;
      case VK_IMAGE_TYPE_2D:
        ivt = VK_IMAGE_VIEW_TYPE_2D;
        break;
      case VK_IMAGE_TYPE_3D:
        ivt = VK_IMAGE_VIEW_TYPE_3D;
        break;
      default:
        throw std::logic_error("unsupported texture image type");
      }

      VkImageViewCreateInfo ivci {};
      ivci.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
      ivci.viewType = ivt;
      ivci.image = viii.image;
      ivci.format = viii.format;
      ivci.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
      ivci.subresourceRange.levelCount = 1;
      ivci.subresourceRange.layerCount = 1;

      VkImageView texture_view {};
      res = vkCreateImageView(device, &ivci, nullptr, &texture_view);
      check_vulkan_result(res);
      texture_views.emplace_back(texture_view);

      VkDescriptorImageInfo dii {};
      dii.imageLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
      dii.imageView = texture_view;
      // TODO: (penguinliong) Export from Taichi?
      dii.sampler = renderer->sampler_;
      diis.emplace_back(std::move(dii));

      VkWriteDescriptorSet wds {};
      wds.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
      wds.descriptorCount = 1;
      wds.descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
      wds.dstBinding = i + 1;
      wds.dstSet = descriptor_set;
      wds.pImageInfo = &diis.back();
      wdss.emplace_back(std::move(wds));
      break;
    }
    default:
      throw std::logic_error("unexpected resource type");
    }
  }
  vkUpdateDescriptorSets(device, (uint32_t)wdss.size(), wdss.data(), 0, nullptr);

  VkPipelineLayoutCreateInfo plci {};
  plci.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
  plci.setLayoutCount = 1;
  plci.pSetLayouts = &descriptor_set_layout;

  VkPipelineLayout pipeline_layout = VK_NULL_HANDLE;
  res = vkCreatePipelineLayout(device, &plci, nullptr, &pipeline_layout);
  check_vulkan_result(res);

  std::array<VkPipelineShaderStageCreateInfo, 2> psscis {};
  {
    VkPipelineShaderStageCreateInfo& pssci = psscis.at(0);
    pssci.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    pssci.pName = "main";
    pssci.module = sms.at(0);
    pssci.stage = VK_SHADER_STAGE_VERTEX_BIT;
  }
  {
    VkPipelineShaderStageCreateInfo& pssci = psscis.at(1);
    pssci.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    pssci.pName = "main";
    pssci.module = sms.at(1);
    pssci.stage = VK_SHADER_STAGE_FRAGMENT_BIT;
  }

  VkFormat vf {};
  switch(config.vertex_component_count) {
  case 1:
    vf = VK_FORMAT_R32_SFLOAT;
    break;
  case 2:
    vf = VK_FORMAT_R32G32_SFLOAT;
    break;
  case 3:
    vf = VK_FORMAT_R32G32B32_SFLOAT;
    break;
  case 4:
    vf = VK_FORMAT_R32G32B32A32_SFLOAT;
    break;
  default:
    throw std::logic_error("invalid vertex component count");
  }

  VkVertexInputAttributeDescription viad {};
  viad.location = 0;
  viad.binding = 0;
  viad.format = vf;
  viad.offset = 0;

  VkVertexInputBindingDescription vibd {};
  vibd.binding = 0;
  vibd.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;
  vibd.stride = config.vertex_component_count * sizeof(float);

  VkPipelineVertexInputStateCreateInfo pvisci {};
  pvisci.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
  pvisci.vertexAttributeDescriptionCount = 1;
  pvisci.pVertexAttributeDescriptions = &viad;
  pvisci.vertexBindingDescriptionCount = 1;
  pvisci.pVertexBindingDescriptions = &vibd;

  VkPrimitiveTopology pt;
  switch (config.primitive_topology) {
  case L_PRIMITIVE_TOPOLOGY_POINT:
    pt = VK_PRIMITIVE_TOPOLOGY_POINT_LIST;
    break;
  case L_PRIMITIVE_TOPOLOGY_LINE:
    pt = VK_PRIMITIVE_TOPOLOGY_LINE_LIST;
    break;
  case L_PRIMITIVE_TOPOLOGY_TRIANGLE:
    pt = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
    break;
  default:
    throw std::logic_error("invalid primitive topology");
  }

  VkPipelineInputAssemblyStateCreateInfo piasci {};
  piasci.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
  piasci.topology = pt;

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
  prsci.cullMode = VK_CULL_MODE_NONE;
  prsci.frontFace = VK_FRONT_FACE_CLOCKWISE;

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
  pcbas.dstAlphaBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
  pcbas.alphaBlendOp = VK_BLEND_OP_ADD;
  pcbas.colorWriteMask =
    VK_COLOR_COMPONENT_R_BIT |
    VK_COLOR_COMPONENT_G_BIT |
    VK_COLOR_COMPONENT_B_BIT |
    VK_COLOR_COMPONENT_A_BIT;

  VkPipelineColorBlendStateCreateInfo pcbsci {};
  pcbsci.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
  pcbsci.attachmentCount = 1;
  pcbsci.pAttachments = &pcbas;
  pcbsci.blendConstants[0] = 1.0;
  pcbsci.blendConstants[1] = 1.0;
  pcbsci.blendConstants[2] = 1.0;
  pcbsci.blendConstants[3] = 1.0;

  std::array<VkDynamicState, 2> dss {
    VK_DYNAMIC_STATE_VIEWPORT,
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
  gpci.renderPass = renderer->render_pass_;

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
  uniform_buffer_ = uniform_buffer;
  uniform_buffer_allocation_ = uniform_buffer_allocation;
  texture_views_ = texture_views;
}
GraphicsTask::~GraphicsTask() {
  destroy();
}
void GraphicsTask::destroy() {
  VkDevice device = renderer_->device();
  VmaAllocator vma_allocator = renderer_->vma_allocator();

  for (size_t i = 0; i < texture_views_.size(); ++i) {
    vkDestroyImageView(device, texture_views_.at(i), nullptr);
  }
  vmaDestroyBuffer(vma_allocator, uniform_buffer_, uniform_buffer_allocation_);
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
  uniform_buffer_ = VK_NULL_HANDLE;
  uniform_buffer_allocation_ = VK_NULL_HANDLE;
  texture_views_.clear();
}

} // namespace aot_demo
} // namespace ti
