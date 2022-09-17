// A minimalist renderer.
// @PENGUINLIONG
#include <cassert>
#include <array>
#include <stdexcept>
#include <vulkan/vulkan.h>
#define TI_WITH_VULKAN 1
#include <taichi/cpp/taichi.hpp>

inline void check_vulkan_result(VkResult result) {
  if (result < VK_SUCCESS) {
    throw std::runtime_error("vulkan failed");
  }
}

std::vector<uint32_t> glsl2spv(const std::string& glsl) {
  throw std::logic_error("unimplemented");
}

class Renderer {
  VkInstance instance_;
  VkDevice device_;
  VkSurfaceKHR surface_;
  VkSwapchainKHR swapchain_;
  VkQueue graphics_queue_;
  uint32_t graphics_qfam_idx_;

public:
  constexpr bool is_valid() const {
    return instance_ != VK_NULL_HANDLE;
  }

  Renderer(const ti::Runtime& runtime) {
    TiVulkanRuntimeInteropInfo vrii {};
    ti_export_vulkan_runtime(runtime, &vrii);

    if (ti_get_last_error(0, nullptr) < TI_ERROR_SUCCESS) {
      return;
    }

    instance_ = vrii.instance;
    device_ = vrii.device;
    //surface_ = vrii.surface;
    //swapchain_ = vrii.swapchain;
    graphics_queue_ = vrii.graphics_queue;
    graphics_qfam_idx_ = vrii.graphics_queue_family_index;
  }
 
  constexpr VkDevice device() const {
    return device_;
  }
};

enum GraphicsTaskResource {
  L_GRAPHICS_TASK_RESOURCE_UNIFORM_BUFFER,
  L_GRAPHICS_TASK_RESOURCE_STORAGE_BUFFER,
  L_GRAPHICS_TASK_RESOURCE_SAMPLED_IMAGE,
};

struct GraphicsTaskConfig {
  std::string vert_glsl;
  std::string frag_glsl;
  std::vector<GraphicsTaskResource> rscs;
  VkFormat vert_fmt;
  size_t vert_stride;
  VkIndexType idx_ty;
  VkPrimitiveTopology topo;
};

class GraphicsTask {
  const std::shared_ptr<Renderer> renderer_;
  const GraphicsTaskConfig cfg_;

  VkPipeline pipe_;
  VkPipelineLayout pipe_layout_;
  VkDescriptorSetLayout desc_set_layout_;
  VkDescriptorPool desc_pool_;
  VkDescriptorSet desc_set_;

public:
  GraphicsTask(
    const std::shared_ptr<Renderer>& renderer,
    const GraphicsTaskConfig& cfg
  ) : renderer_(renderer), cfg_(cfg) {
    VkResult res = VK_SUCCESS;
    assert(renderer->is_valid());

    VkDevice d = renderer->device();

    std::array<std::vector<uint32_t>, 2> cs {};
    cs.at(0) = glsl2spv(cfg.vert_glsl);
    cs.at(1) = glsl2spv(cfg.frag_glsl);

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
      res = vkCreateShaderModule(d, &smci, nullptr, &sm);
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

    VkDescriptorPool dp = VK_NULL_HANDLE;
    res = vkCreateDescriptorPool(d, &dpci, nullptr, &dp);
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

    VkDescriptorSetLayout dsl = VK_NULL_HANDLE;
    res = vkCreateDescriptorSetLayout(d, &dslci, nullptr, &dsl);
    check_vulkan_result(res);

    VkDescriptorSetAllocateInfo dsai {};
    dsai.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
    dsai.descriptorPool = dp;
    dsai.descriptorSetCount = 1;
    dsai.pSetLayouts = &dsl;

    VkDescriptorSet ds = VK_NULL_HANDLE;
    res = vkAllocateDescriptorSets(d, &dsai, &ds);
    check_vulkan_result(res);

    VkPipelineLayoutCreateInfo plci {};
    plci.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    plci.setLayoutCount = 1;
    plci.pSetLayouts = &dsl;

    VkPipelineLayout pl = VK_NULL_HANDLE;
    res = vkCreatePipelineLayout(d, &plci, nullptr, &pl);
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
    gpci.layout = pl;

    VkPipeline p = VK_NULL_HANDLE;
    res = vkCreateGraphicsPipelines(d, nullptr, 1, &gpci, nullptr, &p);
    check_vulkan_result(res);

    // Clean up. Shader modules can be destroyed at this point.
    for (size_t i = 0; i < sms.size(); ++i) {
      vkDestroyShaderModule(d, sms.at(i), nullptr);
    }

    pipe_ = p;
    pipe_layout_ = pl;
    desc_set_layout_ = dsl;
    desc_pool_ = dp;
    desc_set_ = ds;
  }
};
