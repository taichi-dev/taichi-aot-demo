#include <iostream>

#ifdef TI_WITH_CUDA
#include <cuda.h>
#endif

#ifdef TI_WITH_OPENGL
#include <taichi/aot_demo/gl.h>
#endif

#include <vulkan/vulkan.h>

#include "taichi/aot_demo/interop/cross_device_copy.hpp"
#include "taichi/aot_demo/interop/common_utils.hpp"
#include "taichi/aot_demo/renderer.hpp"


namespace ti {
namespace aot_demo {

template<class T>
void InteropHelper<T>::copy_from_vulkan(GraphicsRuntime& dst_runtime, 
                                     ti::NdArray<T>& dst_vulkan_ndarray, 
                                     ti::Runtime& src_runtime,
                                     ti::NdArray<T>& src_vulkan_ndarray) {
    // Get Dst Vulkan Interop Info 
    TiVulkanMemoryInteropInfo dst_vulkan_interop_info;
    ti_export_vulkan_memory(dst_runtime.runtime(),
                            dst_vulkan_ndarray.memory().memory(),
                            &dst_vulkan_interop_info);
    
    TiVulkanMemoryInteropInfo src_vulkan_interop_info;
    ti_export_vulkan_memory(src_runtime, src_vulkan_ndarray.memory().memory(), &src_vulkan_interop_info);
    
    VkBuffer src_buffer = src_vulkan_interop_info.buffer;
    VkBuffer dst_buffer = dst_vulkan_interop_info.buffer;
    
    VkDeviceSize buffer_size = dst_vulkan_interop_info.size;

    VkDevice vk_device = dst_runtime.renderer_->device_;
    VkCommandPool cmd_pool = dst_runtime.renderer_->command_pool_;
    VkQueue graphics_queue = dst_runtime.renderer_->queue_;
    copyBuffer(vk_device, cmd_pool, graphics_queue, src_buffer, dst_buffer, buffer_size);
}

// TiMemory does not expose interface to check whether it's host accessible
// Therefore we'll copy via staging buffer anyway.
template<class T>
void InteropHelper<T>::copy_from_cpu(GraphicsRuntime& runtime, 
                                     ti::NdArray<T>& vulkan_ndarray, 
                                     ti::Runtime& cpu_runtime,
                                     ti::NdArray<T>& cpu_ndarray) {
#ifdef TI_WITH_CPU
    // Get Interop Info 
    TiVulkanMemoryInteropInfo vulkan_interop_info;
    ti_export_vulkan_memory(runtime.runtime(),
                            vulkan_ndarray.memory().memory(),
                            &vulkan_interop_info);
    
    TiCpuMemoryInteropInfo cpu_interop_info;
    ti_export_cpu_memory(cpu_runtime, cpu_ndarray.memory().memory(), &cpu_interop_info);
    
    // Create staging buffer
    VkDevice vk_device = runtime.renderer_->device_;
    VkPhysicalDevice physical_device = runtime.renderer_->physical_device_;
    VkBuffer staging_buffer;
    VkDeviceMemory staging_buffer_memory;
    VkDeviceSize buffer_size = cpu_interop_info.size;
    createBuffer(vk_device, physical_device, buffer_size, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT | VK_BUFFER_USAGE_TRANSFER_SRC_BIT, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, staging_buffer, staging_buffer_memory);
    
    // Copy CPU data to staging buffer
    void* data;
    vkMapMemory(vk_device, staging_buffer_memory, 0, buffer_size, 0, &data);
        memcpy(data, cpu_interop_info.ptr, (size_t) buffer_size);
    vkUnmapMemory(vk_device, staging_buffer_memory);

    // Copy data from staging buffer to vertex buffer
    VkCommandPool cmd_pool = runtime.renderer_->command_pool_;
    VkQueue graphics_queue = runtime.renderer_->queue_;
    copyBuffer(vk_device, cmd_pool, graphics_queue, staging_buffer, vulkan_interop_info.buffer, buffer_size);
#else
    throw std::runtime_error("Unable to perform copy_from_cpu<T>() with TI_WITH_CPU=OFF");
#endif // TI_WITH_CPU
}

/*---------------------*/
/* CUDA Implementation */
/*---------------------*/
#ifdef TI_WITH_CUDA
int get_device_mem_handle(VkDeviceMemory &mem, VkDevice device) {
  int fd;

  VkMemoryGetFdInfoKHR memory_get_fd_info = {};
  memory_get_fd_info.sType = VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR;
  memory_get_fd_info.pNext = nullptr;
  memory_get_fd_info.memory = mem;
  memory_get_fd_info.handleType =
      VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

  auto fpGetMemoryFdKHR =
      (PFN_vkGetMemoryFdKHR)vkGetDeviceProcAddr(device, "vkGetMemoryFdKHR");

  if (fpGetMemoryFdKHR == nullptr) {
    throw std::runtime_error("vkGetMemoryFdKHR is nullptr");
  }
  fpGetMemoryFdKHR(device, &memory_get_fd_info, &fd);

  return fd;
}

CUexternalMemory import_vk_memory_object_from_handle(int fd,
                                                     unsigned long long size,
                                                     bool is_dedicated) {
  CUexternalMemory ext_mem = nullptr;
  CUDA_EXTERNAL_MEMORY_HANDLE_DESC desc = {};

  memset(&desc, 0, sizeof(desc));

  desc.type = CU_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD;
  desc.handle.fd = fd;
  desc.size = size;
  if (is_dedicated) {
    desc.flags |= CUDA_EXTERNAL_MEMORY_DEDICATED;
  }
  cuImportExternalMemory(&ext_mem, &desc);
  return ext_mem;
}

void *map_buffer_onto_external_memory(CUexternalMemory ext_mem,
                                      unsigned long long offset,
                                      unsigned long long size) {
  void *ptr = nullptr;
  CUDA_EXTERNAL_MEMORY_BUFFER_DESC desc = {};

  memset(&desc, 0, sizeof(desc));

  desc.offset = offset;
  desc.size = size;

  cuExternalMemoryGetMappedBuffer((CUdeviceptr *)&ptr, ext_mem, &desc);
  return ptr;
}
#endif // TI_WITH_CUDA

template<class T>
void InteropHelper<T>::copy_from_cuda(GraphicsRuntime& runtime, 
                                     ti::NdArray<T>& vulkan_ndarray, 
                                     ti::Runtime& cuda_runtime,
                                     ti::NdArray<T>& cuda_ndarray) {
#ifdef TI_WITH_CUDA
    // Get Interop Info
    TiVulkanMemoryInteropInfo vulkan_interop_info;
    ti_export_vulkan_memory(runtime.runtime(),
                            vulkan_ndarray.memory().memory(),
                            &vulkan_interop_info);
    
    TiCudaMemoryInteropInfo cuda_interop_info;
    ti_export_cuda_memory(cuda_runtime, cuda_ndarray.memory().memory(), &cuda_interop_info);

    // Get binded VkDeviceMemory from VkBuffer
    VkDevice vk_device = runtime.renderer_->device_;
    VkDeviceMemory vertex_buffer_mem = vulkan_interop_info.memory;

    int alloc_offset = vulkan_interop_info.offset;
    int alloc_size   = vulkan_interop_info.size;
    int mem_size = alloc_offset + alloc_size;
    auto handle = get_device_mem_handle(vertex_buffer_mem, vk_device);
    CUexternalMemory externalMem =
          import_vk_memory_object_from_handle(handle, mem_size, false);
    CUdeviceptr dst_cuda_ptr = reinterpret_cast<CUdeviceptr>(map_buffer_onto_external_memory(externalMem, alloc_offset, vulkan_interop_info.size));
    CUdeviceptr src_cuda_ptr = reinterpret_cast<CUdeviceptr>(cuda_interop_info.ptr);

    cuMemcpyDtoD_v2(dst_cuda_ptr, src_cuda_ptr, vulkan_interop_info.size);
#else
    throw std::runtime_error("Unable to perform copy_from_cuda<T>() with TI_WITH_CUDA=OFF");
#endif // TI_WITH_CUDA
}

template <class T>
void InteropHelper<T>::copy_from_opengl(GraphicsRuntime &runtime,
                                        ti::NdArray<T> &vulkan_ndarray,
                                        ti::Runtime &opengl_runtime,
                                        ti::NdArray<T> &opengl_ndarray)
{
#ifdef TI_WITH_OPENGL
  // Get Interop Info
  TiVulkanMemoryInteropInfo vulkan_interop_info;
  ti_export_vulkan_memory(runtime.runtime(),
                          vulkan_ndarray.memory().memory(),
                          &vulkan_interop_info);

  TiOpenglMemoryInteropInfo opengl_interop_info;
  ti_export_opengl_memory(runtime.runtime(),
                          opengl_ndarray.memory().memory(), &opengl_interop_info);

  // Create staging buffer
  VkDevice vk_device = runtime.renderer_->device;
  VkPhysicalDevice physical_device = runtime.renderer_->physical_device_;
  VkBuffer staging_buffer;
  VkDeviceMemory staging_buffer_memory;
  VkDeviceSize buffer_size = opengl_interop_info.size;
  createBuffer(vk_device, physical_device, buffer_size, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT | VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
                VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, staging_buffer, staging_buffer_memory);

  void *src_data = glMapBuffer(opengl_interop_info.buffer, GL_READ_WRITE);
  void *dst_data;
  vkMapMemory(device, staging_buffer_memory, 0, buffer_size, 0, &dst_data);
  memcpy(dst_data, src_data, buffer_size);
  vkUnmapMemory(devcie, staging_buffer_memory);
  glUnmapBuffer(opengl_interop_info.buffer);

  // Copy data from staging buffer to vertex buffer
  VkCommandPool cmd_pool = runtime.renderer_->command_pool_;
  vkQueue graphics_queue = runtime.renderer_->queue_;
  copyBuffer(vk_device, cmd_pool, graphics_queue, staging_buffer, vulkan_interop_info.buffer, buffer_size);
#else
  throw std::runtime_error("Unable to perform copy_from_opengl<T>() with TI_WITH_OPENGL=OFF");
#endif // TI_WITH_OPENGL
}

template class InteropHelper<double>;
template class InteropHelper<float>;
template class InteropHelper<uint32_t>;
template class InteropHelper<int>;

}
}
