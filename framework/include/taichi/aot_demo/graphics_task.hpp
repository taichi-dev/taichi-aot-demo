#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {


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


class GraphicsTask_ {
public:
  virtual bool is_valid() const = 0;
  virtual void destroy() = 0;

  virtual ~GraphicsTask_() = 0;
};


} // namespace aot_demo
} // namespace ti


// -----------------------------------------------------------------------------
// (penguinliong) Alias the renderers and graphics tasks based on framework
// backend, so that we don't have to dynamic cast in draw implementations.

#if TI_FRAMEWORK_BACKEND_VULKAN
#include "taichi/aot_demo/vulkan/vulkan_graphics_task.hpp"
#endif // TI_FRAMEWORK_BACKEND_VULKAN

#if TI_FRAMEWORK_BACKEND_METAL
#include "taichi/aot_demo/metal/metal_graphics_task.hpp"
#endif // TI_FRAMEWORK_BACKEND_METAL
