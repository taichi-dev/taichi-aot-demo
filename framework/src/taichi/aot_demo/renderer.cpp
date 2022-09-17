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

  TiError err = ti_get_last_error(0, nullptr);
  assert(err >= TI_ERROR_SUCCESS);

  instance_ = instance;
  device_ = device;
  queue_family_index_ = queue_family_index;
  queue_ = queue;

  runtime_ = runtime;
}
Renderer::~Renderer() {
  destroy();
}
void Renderer::destroy() {
  ti_destroy_runtime(runtime_);
  runtime_ = TI_NULL_HANDLE;

  vkDestroyDevice(device_, nullptr);
  vkDestroyInstance(instance_, nullptr);

  instance_ = VK_NULL_HANDLE;
  device_ = VK_NULL_HANDLE;
  queue_family_index_ = VK_QUEUE_FAMILY_IGNORED;
  queue_ = VK_NULL_HANDLE;
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
