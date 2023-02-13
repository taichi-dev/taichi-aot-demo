// A minimalist renderer.
// @PENGUINLIONG
#include "taichi/aot_demo/graphics_task.hpp"
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

// Implemented in glslang.cpp
std::vector<uint32_t> vert2spv(const std::string& vert);
std::vector<uint32_t> frag2spv(const std::string& frag);

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
    case L_GRAPHICS_TASK_RESOURCE_TYPE_BUFFER:
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
    case L_GRAPHICS_TASK_RESOURCE_TYPE_BUFFER:
    {
      const TiVulkanMemoryInteropInfo& vmii =
        renderer_->export_ti_memory(*resource.shadow_buffer);
      check_taichi_error();

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
      const TiVulkanImageInteropInfo &viii =
          renderer_->export_ti_image(*resource.shadow_texture);
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

void GraphicsTask::update() {
  if (config_.vertex_buffer != nullptr) {
    config_.vertex_buffer->update();
  }
  if (config_.index_buffer != nullptr) {
    config_.index_buffer->update();
  }
  for (const GraphicsTaskResource &rsc : config_.resources) {
    switch (rsc.type) {
      case GraphicsTaskResourceType::L_GRAPHICS_TASK_RESOURCE_TYPE_BUFFER:
        rsc.shadow_buffer->update();
        break;
      case GraphicsTaskResourceType::L_GRAPHICS_TASK_RESOURCE_TYPE_TEXTURE:
        rsc.shadow_texture->update();
        break;
    }
  }
}


std::shared_ptr<ShadowBuffer> GraphicsTaskBuilder::create_shadow_buffer(
    const ti::Memory &src,
    ShadowBufferUsage usage) {
  return std::make_shared<ShadowBuffer>(renderer_, src, usage);
}
std::shared_ptr<ShadowTexture> GraphicsTaskBuilder::create_shadow_texture(
    const ti::Image &src,
    ShadowTextureUsage usage) {
  return std::make_shared<ShadowTexture>(renderer_, src, usage);
}

} // namespace aot_demo
} // namespace ti
