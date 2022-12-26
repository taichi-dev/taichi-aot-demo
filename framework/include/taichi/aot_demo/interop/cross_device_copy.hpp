#pragma once
#include "taichi/aot_demo/common.hpp"
#include "taichi/aot_demo/graphics_runtime.hpp"

namespace ti {
namespace aot_demo {

template<class T>
class InteropHelper {
public:
    static void copy_from_vulkan(GraphicsRuntime& dst_runtime, 
                                 ti::NdArray<T>& dst_vulkan_ndarray, 
                                 ti::Runtime& src_vulkan_runtime,
                                 ti::NdArray<T>& src_vulkan_ndarray); 
    
    static void copy_from_cpu(GraphicsRuntime& runtime, 
                              ti::NdArray<T>& vulkan_ndarray, 
                              ti::Runtime& cpu_runtime,
                              ti::NdArray<T>& cpu_ndarray); 
    
    static void copy_from_cuda(GraphicsRuntime& runtime, 
                               ti::NdArray<T>& vulkan_ndarray, 
                               ti::Runtime& cuda_runtime,
                               ti::NdArray<T>& cuda_ndarray); 

    static void copy_from_opengl(GraphicsRuntime &runtime,
                                    ti::NdArray<T> &vulkan_ndarray,
                                    ti::Runtime &opengl_runtime,
                                    ti::NdArray<T> &opengl_ndarray);
};

}
}
