#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

GraphicsRuntime::GraphicsRuntime(TiArch arch, const std::shared_ptr<Renderer>& renderer) :
  ti::Runtime(arch, renderer->runtime(), false), renderer_(renderer) {}

ti::NdArray<float> GraphicsRuntime::allocate_vertex_buffer(
  uint32_t vertex_count,
  uint32_t vertex_component_count,
  bool host_access
) {
  TiMemoryAllocateInfo mai {};
  mai.size = vertex_component_count * vertex_count * sizeof(float);
  mai.host_read = host_access;
  mai.host_write = host_access;
  mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_VERTEX_BIT;
#ifndef ANDROID
  mai.export_sharing = TI_TRUE;
#endif // ANDROID
  ti::Memory memory = allocate_memory(mai);

  TiNdArray ndarray {};
  ndarray.memory = memory;
  ndarray.elem_type = TI_DATA_TYPE_F32;
  ndarray.shape.dim_count = 1;
  ndarray.shape.dims[0] = vertex_count;
  ndarray.elem_shape.dim_count = 1;
  ndarray.elem_shape.dims[0] = vertex_component_count;
  return ti::NdArray<float>(std::move(memory), ndarray);
}
ti::NdArray<uint32_t> GraphicsRuntime::allocate_index_buffer(
  uint32_t index_count,
  uint32_t index_component_count,
  bool host_access
) {
  TiMemoryAllocateInfo mai {};
  mai.size = index_count * index_component_count * sizeof(uint32_t);
  mai.host_write = host_access;
  mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_INDEX_BIT;
#ifndef ANDROID
  mai.export_sharing = TI_TRUE;
#endif // ANDROID
  ti::Memory memory = allocate_memory(mai);

  TiNdArray ndarray {};
  ndarray.memory = memory;
  ndarray.elem_type = TI_DATA_TYPE_U32;
  ndarray.shape.dim_count = 1;
  ndarray.shape.dims[0] = index_count;
  ndarray.elem_shape.dim_count = 1;
  ndarray.elem_shape.dims[0] = index_component_count;
  return ti::NdArray<uint32_t>(std::move(memory), ndarray);
}

} // namespace aot_demo
} // namespace ti
