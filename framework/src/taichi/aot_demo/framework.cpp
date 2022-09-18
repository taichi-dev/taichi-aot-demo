#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

Framework F;

Framework::Framework(TiArch arch, bool debug) {
  renderer_ = std::make_unique<Renderer>(debug);
  if (arch == renderer_->arch()) {
    runtime_ = ti::Runtime(arch, renderer_->runtime(), false);
  } else {
    runtime_ = ti::Runtime(arch);
  }
  std::cout << "framework initialized" << std::endl;
}
Framework::~Framework() {
  if (renderer_ != nullptr) {
    std::cout << "framework finalized" << std::endl;
  }
}



ti::NdArray<float> Framework::allocate_vertex_buffer(
  uint32_t vertex_component_count,
  uint32_t vertex_count,
  bool host_access
) const {
  TiMemoryAllocateInfo mai {};
  mai.size = vertex_component_count * vertex_count * sizeof(float);
  mai.host_read = host_access;
  mai.host_write = host_access;
  mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_VERTEX_BIT;
  ti::Memory memory = runtime_.allocate_memory(mai);

  TiNdArray ndarray {};
  ndarray.memory = memory;
  ndarray.elem_type = TI_DATA_TYPE_F32;
  ndarray.shape.dim_count = 1;
  ndarray.shape.dims[0] = vertex_count;
  ndarray.elem_shape.dim_count = 1;
  ndarray.elem_shape.dims[0] = vertex_component_count;
  return ti::NdArray<float>(std::move(memory), ndarray);
}
ti::NdArray<uint32_t> Framework::allocate_index_buffer(
  uint32_t index_count,
  bool host_access
) const {
  TiMemoryAllocateInfo mai {};
  mai.size = index_count * sizeof(uint32_t);
  mai.host_write = host_access;
  mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_VERTEX_BIT;
  ti::Memory memory = runtime_.allocate_memory(mai);

  TiNdArray ndarray {};
  ndarray.memory = memory;
  ndarray.elem_type = TI_DATA_TYPE_U32;
  ndarray.shape.dim_count = 1;
  ndarray.shape.dims[0] = index_count;
  return ti::NdArray<uint32_t>(std::move(memory), ndarray);
}

} // namespace aot_demo
} // namespace ti