#pragma once
#include "taichi/cpp/taichi.hpp"
#include "taichi/taichi.h"

#include "taichi/aot_demo/graphics_runtime.hpp"

namespace ti {
namespace aot_demo {

template<class T>
class InteropHelper {
public:
    static void copy_from_cpu(GraphicsRuntime& runtime, 
                              ti::NdArray<T>& vulkan_ndarray, 
                              ti::Runtime& cpu_runtime,
                              ti::NdArray<T>& cpu_ndarray); 
};

}
}
