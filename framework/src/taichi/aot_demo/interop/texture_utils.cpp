#include "taichi/aot_demo/interop/texture_utils.hpp"
#include "taichi/aot_demo/interop/common_utils.hpp"
#include "taichi/aot_demo/interop/cross_device_copy.hpp"
#include "taichi/aot_demo/renderer.hpp"

#include <vulkan/vulkan.h>
#include "taichi/taichi.h"

namespace ti {
namespace aot_demo {

template<typename T>
ti::NdArray<T> clone_ndarray(ti::Runtime& runtime,
                             const ti::NdArray<T>& ndarray) {
    std::vector<uint32_t> shape;
    for(uint32_t i = 0; i < ndarray.shape().dim_count; i++) {
        shape.push_back(ndarray.shape().dims[i]);
    }
    
    std::vector<uint32_t> element_shape;
    for(uint32_t i = 0; i < ndarray.elem_shape().dim_count; i++) {
        element_shape.push_back(ndarray.elem_shape().dims[i]);
    }

    ti::NdArray<T> target_ndarray = runtime.allocate_ndarray(shape, element_shape, true /*host_access*/);
    
    return target_ndarray;
}

template<class T>
void TextureHelper::copy_from_vulkan_ndarray(GraphicsRuntime& g_runtime, 
                                              ti::Texture& vulkan_texture,
                                              ti::Runtime& vulkan_runtime,
                                              ti::NdArray<T>& vulkan_ndarray) {
    // Get Vulkan Ndarray Interop Info
    TiVulkanMemoryInteropInfo vulkan_interop_info;
    ti_export_vulkan_memory(vulkan_runtime.runtime(),
                            vulkan_ndarray.memory().memory(),
                            &vulkan_interop_info);
    
    VkBuffer ndarray_buffer = vulkan_interop_info.buffer;

    uint32_t width   = vulkan_ndarray.shape().dim_count > 0 ? vulkan_ndarray.shape().dims[0] : 1
    uint32_t heigth  = vulkan_ndarray.shape().dim_count > 1 ? vulkan_ndarray.shape().dims[1] : 1
    uint32_t channel = vulkan_ndarray.shape().dim_count > 2 ? vulkan_ndarray.shape().dims[2] : 1
    
    // Get VkImage
    g_runtime.transition_image(vulkan_texture.image(), TI_IMAGE_LAYOUT_TRANSFER_SRC);

    TiVulkanImageInteropInfo interop_info;
    ti_export_vulkan_image(g_runtime,
                           vulkan_texture.image().image(),
                           &interop_info);

    VkImage vk_image = interop_info.image;
    VkImageLayout image_layout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
    VkDevice vk_device = g_runtime.renderer_->device_;
    VkCommandPool cmd_pool = g_runtime.renderer_->command_pool_;
    VkQueue graphics_queue = g_runtime.renderer_->queue_;
    copyImage2Buffer(vk_device,
                     command_pool,
                     graphics_queue,
                     vk_image, 
                     ndarray_buffer,
                     image_layout,
                     width,
                     height,
                     channel,
                     false /*image_to_buffer*/);
}


template<class T>
void TextureHelper::copy_from_cpu_ndarray(GraphicsRuntime& g_runtime, 
                                          ti::Texture& vulkan_texture, 
                                          ti::Runtime& cpu_runtime,
                                          ti::NdArray<T>& cpu_ndarray) {
    
    // 1. Create Vulkan staging buffer
    ti::NdArray<T> vulkan_ndarray = clone_ndarray(g_runtime, cpu_ndarray);

    // 2. Copy device ndarray to vulkan ndarray
    InteropHelper<T>::copy_from_cpu(g_runtime, vulkan_ndarray, cpu_runtime, cpu_ndarray);
    
    // 3. Copy vulkan ndarray to vulkan texture
    TextureHelper<T>::copy_from_vulkan_ndarray(g_runtime, vulkan_texture, g_runtime, vulkan_ndarray);

}

template<class T>
void TextureHelper::copy_from_cuda_ndarray(GraphicsRuntime& g_runtime, 
                                   ti::Texture& vulkan_texture, 
                                   ti::Runtime& cuda_runtime,
                                   ti::NdArray<T>& cuda_ndarray) {

    // 1. Create Vulkan staging buffer
    ti::NdArray<T> vulkan_ndarray = clone_ndarray(g_runtime, cuda_ndarray);

    // 2. Copy device ndarray to vulkan ndarray
    InteropHelper<T>::copy_from_cuda(g_runtime, vulkan_ndarray, cuda_runtime, cuda_ndarray);
    
    // 3. Copy vulkan ndarray to vulkan texture
    TextureHelper<T>::copy_from_vulkan_ndarray(g_runtime, vulkan_texture, g_runtime, vulkan_ndarray);

} 

template class TextureHelper<double>;
template class TextureHelper<float>;
template class TextureHelper<uint32_t>;
template class TextureHelper<int>;

}
}

