#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

Framework F;

Framework::Framework(const AppConfig& app_cfg, TiArch arch, bool debug) {
  renderer_ = std::make_unique<Renderer>(
    debug,
    app_cfg.framebuffer_width,
    app_cfg.framebuffer_height);
  runtime_ = GraphicsRuntime(arch, renderer_);
  asset_mgr_ = create_asset_manager();

  frame_ = 0;
  tic0_ = std::chrono::steady_clock::now();
  tic_ = std::chrono::steady_clock::now();
  toc_ = std::chrono::steady_clock::now();
  std::cout << "framework initialized" << std::endl;
}
Framework::~Framework() {
  if (renderer_ != nullptr) {
    std::cout << "framework finalized" << std::endl;
  }
}


ti::Runtime create_runtime_helper(TiArch arch, const Renderer& renderer) {
  if (arch == renderer.arch()) {
    return ti::Runtime(arch, renderer.runtime(), false);
  } else {
    return ti::Runtime(arch);
  }
}

GraphicsRuntime::GraphicsRuntime(TiArch arch, const std::shared_ptr<Renderer>& renderer) :
  ti::Runtime(create_runtime_helper(arch, *renderer)), renderer_(renderer) {}

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