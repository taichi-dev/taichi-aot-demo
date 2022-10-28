#include "taichi/aot_demo/interop/cross_device_copy.hpp"
#include "taichi/aot_demo/renderer.hpp"

#ifdef TI_WITH_CUDA
#include <cuda.h>
#endif

#include <vulkan/vulkan.h>
#include "taichi/taichi.h"

namespace ti {
namespace aot_demo {

static void copyBuffer(VkDevice& device,
                       VkCommandPool& command_pool,
                       VkQueue& graphics_queue,
                       VkBuffer& src_buffer, 
                       VkBuffer& dst_buffer, 
                       VkDeviceSize size) {
    VkCommandBufferAllocateInfo alloc_info{};
    alloc_info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    alloc_info.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    alloc_info.commandPool = command_pool;
    alloc_info.commandBufferCount = 1;

    VkCommandBuffer command_buffer;
    vkAllocateCommandBuffers(device, &alloc_info, &command_buffer);

    VkCommandBufferBeginInfo begin_info{};
    begin_info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
    begin_info.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

    vkBeginCommandBuffer(command_buffer, &begin_info);

    VkBufferCopy copy_region{};
    copy_region.size = size;
    vkCmdCopyBuffer(command_buffer, src_buffer, dst_buffer, 1, &copy_region);

    vkEndCommandBuffer(command_buffer);

    VkSubmitInfo submit_info{};
    submit_info.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
    submit_info.commandBufferCount = 1;
    submit_info.pCommandBuffers = &command_buffer;

    vkQueueSubmit(graphics_queue, 1, &submit_info, VK_NULL_HANDLE);
    vkQueueWaitIdle(graphics_queue);

    vkFreeCommandBuffers(device, command_pool, 1, &command_buffer);
}
    
static uint32_t findMemoryType(VkPhysicalDevice& physical_device, uint32_t type_filter, VkMemoryPropertyFlags properties) {
    VkPhysicalDeviceMemoryProperties mem_properties;
    vkGetPhysicalDeviceMemoryProperties(physical_device, &mem_properties);

    for (uint32_t i = 0; i < mem_properties.memoryTypeCount; i++) {
        if ((type_filter & (1 << i)) && (mem_properties.memoryTypes[i].propertyFlags & properties) == properties) {
            return i;
        }
    }

    throw std::runtime_error("failed to find suitable memory type!");
}

static void createBuffer(VkDevice& device,
                          VkPhysicalDevice& physical_device,
                          VkDeviceSize size, 
                          VkBufferUsageFlags usage, 
                          VkMemoryPropertyFlags properties, 
                          VkBuffer& buffer, 
                          VkDeviceMemory& buffer_memory) {
        VkBufferCreateInfo buffer_info{};
        buffer_info.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        buffer_info.size = size;
        buffer_info.usage = usage;
        buffer_info.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

        if (vkCreateBuffer(device, &buffer_info, nullptr, &buffer) != VK_SUCCESS) {
            throw std::runtime_error("failed to create buffer!");
        }

        VkMemoryRequirements mem_requirements;
        vkGetBufferMemoryRequirements(device, buffer, &mem_requirements);

        VkMemoryAllocateInfo alloc_info{};
        alloc_info.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
        alloc_info.allocationSize = mem_requirements.size;
        alloc_info.memoryTypeIndex = findMemoryType(physical_device, mem_requirements.memoryTypeBits, properties);

        if (vkAllocateMemory(device, &alloc_info, nullptr, &buffer_memory) != VK_SUCCESS) {
            throw std::runtime_error("failed to allocate buffer memory!");
        }

        vkBindBufferMemory(device, buffer, buffer_memory, 0);
}

// TiMemory does not expose interface to check whether it's host accessible
// Therefore we'll copy via staging buffer anyway.
template<class T>
void InteropHelper<T>::copy_from_cpu(GraphicsRuntime& runtime, 
                                     ti::NdArray<T>& vulkan_ndarray, 
                                     ti::Runtime& cpu_runtime,
                                     ti::NdArray<T>& cpu_ndarray) {

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
    createBuffer(vk_device, physical_device, buffer_size, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, staging_buffer, staging_buffer_memory);
    
    // Copy CPU data to staging buffer
    void* data;
    vkMapMemory(vk_device, staging_buffer_memory, 0, buffer_size, 0, &data);
        memcpy(data, cpu_interop_info.ptr, (size_t) buffer_size);
    vkUnmapMemory(vk_device, staging_buffer_memory);

    // Copy data from staging buffer to vertex buffer
    VkCommandPool cmd_pool = runtime.renderer_->command_pool_;
    VkQueue graphics_queue = runtime.renderer_->queue_;
    copyBuffer(vk_device, cmd_pool, graphics_queue, staging_buffer, vulkan_interop_info.buffer, buffer_size);
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

    auto handle = get_device_mem_handle(vertex_buffer_mem, vk_device);
    CUexternalMemory externalMem =
          import_vk_memory_object_from_handle(handle, vulkan_interop_info.size, false);
    
    int offset = 0;
    CUdeviceptr dst_cuda_ptr = reinterpret_cast<CUdeviceptr>(map_buffer_onto_external_memory(externalMem, offset, vulkan_interop_info.size));
    CUdeviceptr src_cuda_ptr = reinterpret_cast<CUdeviceptr>(cuda_interop_info.ptr);

    cuMemcpyDtoD_v2(dst_cuda_ptr, src_cuda_ptr, vulkan_interop_info.size);
#endif // TI_WITH_CUDA
}

template class InteropHelper<double>;
template class InteropHelper<float>;
template class InteropHelper<uint64_t>;
template class InteropHelper<int>;

}
}
