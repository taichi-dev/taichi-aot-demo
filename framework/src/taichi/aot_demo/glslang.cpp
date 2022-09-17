#include <vector>
#include <string>
#include <cstdint>
#include "glslang_c_interface.h"

namespace ti {
namespace aot_demo {

namespace {

struct glslang_lifetime_t {
  glslang_lifetime_t() {
    glslang_initialize_process();
  }
  ~glslang_lifetime_t() {
    glslang_finalize_process();
  }
} LIFETIME;

const glslang_resource_t DefaultTBuiltInResource = {
  /* .MaxLights = */ 32,
  /* .MaxClipPlanes = */ 6,
  /* .MaxTextureUnits = */ 32,
  /* .MaxTextureCoords = */ 32,
  /* .MaxVertexAttribs = */ 64,
  /* .MaxVertexUniformComponents = */ 4096,
  /* .MaxVaryingFloats = */ 64,
  /* .MaxVertexTextureImageUnits = */ 32,
  /* .MaxCombinedTextureImageUnits = */ 80,
  /* .MaxTextureImageUnits = */ 32,
  /* .MaxFragmentUniformComponents = */ 4096,
  /* .MaxDrawBuffers = */ 32,
  /* .MaxVertexUniformVectors = */ 128,
  /* .MaxVaryingVectors = */ 8,
  /* .MaxFragmentUniformVectors = */ 16,
  /* .MaxVertexOutputVectors = */ 16,
  /* .MaxFragmentInputVectors = */ 15,
  /* .MinProgramTexelOffset = */ -8,
  /* .MaxProgramTexelOffset = */ 7,
  /* .MaxClipDistances = */ 8,
  /* .MaxComputeWorkGroupCountX = */ 65535,
  /* .MaxComputeWorkGroupCountY = */ 65535,
  /* .MaxComputeWorkGroupCountZ = */ 65535,
  /* .MaxComputeWorkGroupSizeX = */ 1024,
  /* .MaxComputeWorkGroupSizeY = */ 1024,
  /* .MaxComputeWorkGroupSizeZ = */ 64,
  /* .MaxComputeUniformComponents = */ 1024,
  /* .MaxComputeTextureImageUnits = */ 16,
  /* .MaxComputeImageUniforms = */ 8,
  /* .MaxComputeAtomicCounters = */ 8,
  /* .MaxComputeAtomicCounterBuffers = */ 1,
  /* .MaxVaryingComponents = */ 60,
  /* .MaxVertexOutputComponents = */ 64,
  /* .MaxGeometryInputComponents = */ 64,
  /* .MaxGeometryOutputComponents = */ 128,
  /* .MaxFragmentInputComponents = */ 128,
  /* .MaxImageUnits = */ 8,
  /* .MaxCombinedImageUnitsAndFragmentOutputs = */ 8,
  /* .MaxCombinedShaderOutputResources = */ 8,
  /* .MaxImageSamples = */ 0,
  /* .MaxVertexImageUniforms = */ 0,
  /* .MaxTessControlImageUniforms = */ 0,
  /* .MaxTessEvaluationImageUniforms = */ 0,
  /* .MaxGeometryImageUniforms = */ 0,
  /* .MaxFragmentImageUniforms = */ 8,
  /* .MaxCombinedImageUniforms = */ 8,
  /* .MaxGeometryTextureImageUnits = */ 16,
  /* .MaxGeometryOutputVertices = */ 256,
  /* .MaxGeometryTotalOutputComponents = */ 1024,
  /* .MaxGeometryUniformComponents = */ 1024,
  /* .MaxGeometryVaryingComponents = */ 64,
  /* .MaxTessControlInputComponents = */ 128,
  /* .MaxTessControlOutputComponents = */ 128,
  /* .MaxTessControlTextureImageUnits = */ 16,
  /* .MaxTessControlUniformComponents = */ 1024,
  /* .MaxTessControlTotalOutputComponents = */ 4096,
  /* .MaxTessEvaluationInputComponents = */ 128,
  /* .MaxTessEvaluationOutputComponents = */ 128,
  /* .MaxTessEvaluationTextureImageUnits = */ 16,
  /* .MaxTessEvaluationUniformComponents = */ 1024,
  /* .MaxTessPatchComponents = */ 120,
  /* .MaxPatchVertices = */ 32,
  /* .MaxTessGenLevel = */ 64,
  /* .MaxViewports = */ 16,
  /* .MaxVertexAtomicCounters = */ 0,
  /* .MaxTessControlAtomicCounters = */ 0,
  /* .MaxTessEvaluationAtomicCounters = */ 0,
  /* .MaxGeometryAtomicCounters = */ 0,
  /* .MaxFragmentAtomicCounters = */ 8,
  /* .MaxCombinedAtomicCounters = */ 8,
  /* .MaxAtomicCounterBindings = */ 1,
  /* .MaxVertexAtomicCounterBuffers = */ 0,
  /* .MaxTessControlAtomicCounterBuffers = */ 0,
  /* .MaxTessEvaluationAtomicCounterBuffers = */ 0,
  /* .MaxGeometryAtomicCounterBuffers = */ 0,
  /* .MaxFragmentAtomicCounterBuffers = */ 1,
  /* .MaxCombinedAtomicCounterBuffers = */ 1,
  /* .MaxAtomicCounterBufferSize = */ 16384,
  /* .MaxTransformFeedbackBuffers = */ 4,
  /* .MaxTransformFeedbackInterleavedComponents = */ 64,
  /* .MaxCullDistances = */ 8,
  /* .MaxCombinedClipAndCullDistances = */ 8,
  /* .MaxSamples = */ 4,
  /* .maxMeshOutputVerticesNV = */ 256,
  /* .maxMeshOutputPrimitivesNV = */ 512,
  /* .maxMeshWorkGroupSizeX_NV = */ 32,
  /* .maxMeshWorkGroupSizeY_NV = */ 1,
  /* .maxMeshWorkGroupSizeZ_NV = */ 1,
  /* .maxTaskWorkGroupSizeX_NV = */ 32,
  /* .maxTaskWorkGroupSizeY_NV = */ 1,
  /* .maxTaskWorkGroupSizeZ_NV = */ 1,
  /* .maxMeshViewCountNV = */ 4,
  /* .maxMeshOutputVerticesEXT = */ 256,
  /* .maxMeshOutputPrimitivesEXT = */ 256,
  /* .maxMeshWorkGroupSizeX_EXT = */ 128,
  /* .maxMeshWorkGroupSizeY_EXT = */ 128,
  /* .maxMeshWorkGroupSizeZ_EXT = */ 128,
  /* .maxTaskWorkGroupSizeX_EXT = */ 128,
  /* .maxTaskWorkGroupSizeY_EXT = */ 128,
  /* .maxTaskWorkGroupSizeZ_EXT = */ 128,
  /* .maxMeshViewCountEXT = */ 4,
  /* .maxDualSourceDrawBuffersEXT = */ 1,

  /* .limits = */ {
      /* .nonInductiveForLoops = */ 1,
      /* .whileLoops = */ 1,
      /* .doWhileLoops = */ 1,
      /* .generalUniformIndexing = */ 1,
      /* .generalAttributeMatrixVectorIndexing = */ 1,
      /* .generalVaryingIndexing = */ 1,
      /* .generalSamplerIndexing = */ 1,
      /* .generalVariableIndexing = */ 1,
      /* .generalConstantMatrixVectorIndexing = */ 1,
  }};

} // namespace

std::vector<uint32_t> glsl2spv(glslang_stage_t stage, const std::string& glsl) {
  glslang_input_t input {};
  input.language = GLSLANG_SOURCE_GLSL;
  input.stage = stage;
  input.client = GLSLANG_CLIENT_VULKAN;
  input.client_version = GLSLANG_TARGET_VULKAN_1_0;
  input.target_language = GLSLANG_TARGET_SPV;
  input.target_language_version = GLSLANG_TARGET_SPV_1_0;
  input.code = glsl.c_str();
  input.default_version = 100;
  input.default_profile = GLSLANG_NO_PROFILE;
  input.force_default_version_and_profile = false;
  input.forward_compatible = false;
  input.messages = GLSLANG_MSG_DEFAULT_BIT;
  input.resource = &DefaultTBuiltInResource;

  glslang_shader_t* shader = glslang_shader_create(&input);

  if (!glslang_shader_preprocess(shader, &input))	{
      printf("glsl preprocessing failed:\n");
      printf("%s\n", glslang_shader_get_info_log(shader));
      printf("%s\n", glslang_shader_get_info_debug_log(shader));
      printf("%s\n", input.code);
      glslang_shader_delete(shader);
      return std::vector<uint32_t>();
  }

  if (!glslang_shader_parse(shader, &input)) {
      printf("glsl parsing failed:\n");
      printf("%s\n", glslang_shader_get_info_log(shader));
      printf("%s\n", glslang_shader_get_info_debug_log(shader));
      printf("%s\n", glslang_shader_get_preprocessed_code(shader));
      glslang_shader_delete(shader);
      return std::vector<uint32_t>();
  }

  glslang_program_t* program = glslang_program_create();
  glslang_program_add_shader(program, shader);

  if (!glslang_program_link(program, GLSLANG_MSG_SPV_RULES_BIT | GLSLANG_MSG_VULKAN_RULES_BIT)) {
      printf("glsl linking failed:\n");
      printf("%s\n", glslang_program_get_info_log(program));
      printf("%s\n", glslang_program_get_info_debug_log(program));
      glslang_program_delete(program);
      glslang_shader_delete(shader);
      return std::vector<uint32_t>();
  }

  glslang_program_SPIRV_generate(program, stage);

  std::vector<uint32_t> outShaderModule(glslang_program_SPIRV_get_size(program));
  glslang_program_SPIRV_get(program, outShaderModule.data());

  const char* spirv_messages = glslang_program_SPIRV_get_messages(program);
  if (spirv_messages)
      printf("%s\b", spirv_messages);

  glslang_program_delete(program);
  glslang_shader_delete(shader);

  return outShaderModule;
}

std::vector<uint32_t> vert2spv(const std::string& vert) {
  return glsl2spv(GLSLANG_STAGE_VERTEX, vert);
}
std::vector<uint32_t> frag2spv(const std::string& frag) {
  return glsl2spv(GLSLANG_STAGE_FRAGMENT, frag);
}

} // namespace aot_demo
} // namespace ti
