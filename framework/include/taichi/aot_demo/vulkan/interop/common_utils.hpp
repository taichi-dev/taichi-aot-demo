#pragma once
#include <vulkan/vulkan.h>

namespace ti {
namespace aot_demo {
namespace vulkan {

void copyBuffer(VkDevice& device,
                VkCommandPool& command_pool,
                VkQueue& graphics_queue,
                VkBuffer& src_buffer, 
                VkBuffer& dst_buffer, 
                VkDeviceSize size);

uint32_t findMemoryType(VkPhysicalDevice& physical_device, uint32_t type_filter, VkMemoryPropertyFlags properties); 

void createBuffer(VkDevice& device,
                  VkPhysicalDevice& physical_device,
                  VkDeviceSize size, 
                  VkBufferUsageFlags usage, 
                  VkMemoryPropertyFlags properties, 
                  VkBuffer& buffer, 
                  VkDeviceMemory& buffer_memory);

void copyImage2Buffer(VkDevice& device,
                     VkCommandPool& command_pool,
                     VkQueue& graphics_queue,
                     VkImage& src_image, 
                     VkBuffer& dst_buffer,
                     VkImageLayout& layout,
                     uint32_t width,
                     uint32_t height,
                     uint32_t channel,
                     bool image_to_buffer);

}
}
}
