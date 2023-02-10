#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {
namespace interop {

void copy_memory_vulkan_to_vulkan(ti::Runtime &dst_runtime,
                                ti::Memory &dst_vulkan_ndarray,
                                ti::Runtime &src_runtime,
                                ti::Memory &src_vulkan_ndarray);

void copy_memory_cpu_to_vulkan(ti::Runtime &runtime,
                               ti::Memory &vulkan_ndarray,
                               ti::Runtime &cpu_runtime,
                               ti::Memory &cpu_ndarray);

void copy_memory_cuda_to_vulkan(ti::Runtime &runtime,
                                ti::NdArray<T> &vulkan_ndarray,
                                ti::Runtime &cuda_runtime,
                                ti::NdArray<T> &cuda_ndarray);

void copy_memory_opengl_to_vulkan(ti::Runtime &runtime,
                                  ti::NdArray<T> &vulkan_ndarray,
                                  ti::Runtime &opengl_runtime,
                                  ti::NdArray<T> &opengl_ndarray);

} // namespace interop
} // namespace aot_demo
} // namespace ti
