#pragma once
#include "taichi/cpp/taichi.hpp"
#include "taichi/taichi.h"

#include "taichi/aot_demo/graphics_runtime.hpp"

namespace ti {
namespace aot_demo {

template<class T>
class TextureHelper {
public:
    
    static void interchange_vulkan_ndarray_texture(GraphicsRuntime& g_runtime, 
                                                   ti::Texture& vulkan_texture,
                                                   ti::Runtime& vulkan_runtime,
                                                   ti::NdArray<T>& vulkan_ndarray,
                                                   bool texture_to_ndarray); 

    static void copy_from_cpu_ndarray(GraphicsRuntime& g_runtime, 
                                      ti::Texture& vulkan_texture, 
                                      ti::Runtime& cpu_runtime,
                                      ti::NdArray<T>& cpu_ndarray); 
    
    static void copy_from_cuda_ndarray(GraphicsRuntime& g_runtime, 
                                       ti::Texture& vulkan_texture, 
                                       ti::Runtime& cuda_runtime,
                                       ti::NdArray<T>& cuda_ndarray); 

    static void copy_from_opengl_ndarray(GraphicsRuntime &g_runtime,
                                            ti::Texture &vulkan_texture,
                                            ti::Runtime &opengl_runtime,
                                            ti::NdArray<T> &opengl_texture);
};

}
}
