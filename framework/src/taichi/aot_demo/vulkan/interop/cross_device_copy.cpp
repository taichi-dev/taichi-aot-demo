#include "taichi/aot_demo/vulkan/interop/cross_device_copy.hpp"
#include "taichi/aot_demo/vulkan/interop/common_utils.hpp"
#include "taichi/aot_demo/vulkan/vulkan_renderer.hpp"


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

struct DeviceMemoryHandle {
#ifdef _WIN32
  HANDLE handle;

  DeviceMemoryHandle(HANDLE handle) : handle(handle) {}
  ~DeviceMemoryHandle() {
    if (handle != INVALID_HANDLE_VALUE) {
      // TODO: (penguinliong) Should we release these handles?
      // https://registry.khronos.org/vulkan/specs/1.3-extensions/man/html/vkGetMemoryWin32HandleKHR.html
      //CloseHandle(handle);  
      handle = INVALID_HANDLE_VALUE;
    }
  }
  DeviceMemoryHandle(DeviceMemoryHandle&& b) : handle(std::exchange(b.handle, INVALID_HANDLE_VALUE)) {}
  DeviceMemoryHandle& operator=(DeviceMemoryHandle&& b) {
    handle = std::exchange(b.handle, INVALID_HANDLE_VALUE);
    return *this;
  }
#else
  int fd;

  DeviceMemoryHandle(int fd) : fd(fd) {}
  ~DeviceMemoryHandle() {
    if (fd != -1) {
      //close(fd);
      fd = -1;
    }
  }
  DeviceMemoryHandle(DeviceMemoryHandle&& b) : fd(std::exchange(b.fd, -1)) {}
  DeviceMemoryHandle& operator=(DeviceMemoryHandle&& b) {
    fd = std::exchange(b.fd, -1);
    return *this;
  }
#endif // _WIN32

  DeviceMemoryHandle(const DeviceMemoryHandle&) = delete;
  DeviceMemoryHandle& operator=(const DeviceMemoryHandle&) = delete;
};
DeviceMemoryHandle get_device_mem_handle(VkDeviceMemory mem, VkDevice device) {
#ifdef _WIN32
  HANDLE handle = INVALID_HANDLE_VALUE;

  VkMemoryGetWin32HandleInfoKHR memory_get_win32_handle_info{};
  memory_get_win32_handle_info.sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
  memory_get_win32_handle_info.pNext = nullptr;
  memory_get_win32_handle_info.memory = mem;
  memory_get_win32_handle_info.handleType = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT;

  auto fpGetMemoryWin32HandleKHR =
    (PFN_vkGetMemoryWin32HandleKHR)vkGetDeviceProcAddr(device, "vkGetMemoryWin32HandleKHR");
  
  if (fpGetMemoryWin32HandleKHR == nullptr) {
    throw std::runtime_error("fpGetMemoryWin32HandleKHR is nullptr");
  }
  VkResult res = fpGetMemoryWin32HandleKHR(device, &memory_get_win32_handle_info, &handle);
  assert(res == VK_SUCCESS);

  return DeviceMemoryHandle{handle};
#else
  int fd = -1;

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

  return DeviceMemoryHandle{fd};
#endif // _WIN32
}

/*---------------------*/
/* CUDA Implementation */
/*---------------------*/
#ifdef TI_WITH_CUDA

CUexternalMemory import_cuda_memory_object_from_handle(const DeviceMemoryHandle& handle,
                                                     unsigned long long size,
                                                     bool is_dedicated) {
  CUexternalMemory ext_mem = nullptr;
  CUDA_EXTERNAL_MEMORY_HANDLE_DESC desc = {};

  memset(&desc, 0, sizeof(desc));

  desc.type = CU_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD;
#ifdef _WIN32
  desc.handle.win32.handle = handle.handle;
#else
  desc.handle.fd = handle.fd;
#endif
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

    size_t alloc_offset = vulkan_interop_info.offset;
    size_t alloc_size   = vulkan_interop_info.size;
    size_t mem_size = alloc_offset + alloc_size;
    auto handle = get_device_mem_handle(vertex_buffer_mem, vk_device);
    CUexternalMemory externalMem =
          import_cuda_memory_object_from_handle(handle, mem_size, false);
    CUdeviceptr dst_cuda_ptr = reinterpret_cast<CUdeviceptr>(map_buffer_onto_external_memory(externalMem, alloc_offset, vulkan_interop_info.size));
    CUdeviceptr src_cuda_ptr = reinterpret_cast<CUdeviceptr>(cuda_interop_info.ptr);

    cuMemcpyDtoD_v2(dst_cuda_ptr, src_cuda_ptr, vulkan_interop_info.size);
#else
    throw std::runtime_error("Unable to perform copy_from_cuda<T>() with TI_WITH_CUDA=OFF");
#endif // TI_WITH_CUDA
}

#ifdef TI_WITH_OPENGL
struct OpenglMemoryObject {
  GLuint memory_obj;
  GLuint buffer;

  OpenglMemoryObject(GLuint memory_obj, GLuint buffer) : memory_obj(memory_obj), buffer(buffer) {}
  OpenglMemoryObject(const OpenglMemoryObject &) = delete;
  OpenglMemoryObject(OpenglMemoryObject &&b) : memory_obj(std::exchange(b.memory_obj, 0)), buffer(std::exchange(b.buffer, 0)) {}
  ~OpenglMemoryObject() {
    glDeleteMemoryObjectsEXT(1, &memory_obj);
    glDeleteBuffers(1, &buffer);
  }
};
OpenglMemoryObject import_opengl_memory_object_from_handle(
    const DeviceMemoryHandle& handle,
    size_t offset,
    size_t size)
{
  GLuint memory_obj{};
  GLuint buffer{};

  glCreateBuffers(1, &buffer);
  glCreateMemoryObjectsEXT(1, &memory_obj);
#ifdef WIN32
  glImportMemoryWin32HandleEXT(memory_obj, size, GL_HANDLE_TYPE_OPAQUE_WIN32_EXT, handle.handle);
#else
  glImportMemoryFdEXT(memory_obj, size, GL_HANDLE_TYPE_OPAQUE_FD_EXT, handle.fd);
  // NOTE: fd got consumed so it's now invalid.
#endif
  glNamedBufferStorageMemEXT(buffer, size, memory_obj, offset);

  return OpenglMemoryObject{memory_obj, buffer};
}
#endif // TI_WITH_OPENGL

template <class T>
void InteropHelper<T>::copy_from_opengl(GraphicsRuntime &runtime,
                                        ti::NdArray<T> &vulkan_ndarray,
                                        ti::Runtime &opengl_runtime,
                                        ti::NdArray<T> &opengl_ndarray)
{
#ifdef TI_WITH_OPENGL
  static bool initialized = false;
  if (!initialized) {
    TiOpenglRuntimeInteropInfo orii{};
    ti_export_opengl_runtime(opengl_runtime, &orii);
    assert(orii.get_proc_addr != nullptr);
    int opengl_version = gladLoadGL((GLADloadfunc)orii.get_proc_addr);
    assert(opengl_version != 0);
    initialized = true;
  }

  // Get Interop Info
  TiVulkanMemoryInteropInfo vulkan_interop_info{};
  ti_export_vulkan_memory(runtime.runtime(),
                          vulkan_ndarray.memory().memory(),
                          &vulkan_interop_info);

  TiOpenglMemoryInteropInfo opengl_interop_info{};
  ti_export_opengl_memory(opengl_runtime.runtime(),
                          opengl_ndarray.memory().memory(), &opengl_interop_info);

  VkDevice vk_device = runtime.renderer_->device_;
  VkDeviceMemory vertex_buffer_mem = vulkan_interop_info.memory;

  size_t alloc_offset = vulkan_interop_info.offset;
  size_t alloc_size   = vulkan_interop_info.size;
  size_t mem_size = alloc_offset + alloc_size;
  auto handle = get_device_mem_handle(vertex_buffer_mem, vk_device);
  OpenglMemoryObject memory_obj = import_opengl_memory_object_from_handle(handle, alloc_offset, alloc_size);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }

  glBindBuffer(GL_COPY_READ_BUFFER, opengl_interop_info.buffer);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
  glBindBuffer(GL_COPY_WRITE_BUFFER, memory_obj.buffer);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
  glCopyBufferSubData(GL_COPY_READ_BUFFER, GL_COPY_WRITE_BUFFER, 0, 0, opengl_interop_info.size);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
  glBindBuffer(GL_COPY_WRITE_BUFFER, 0);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
  glBindBuffer(GL_COPY_READ_BUFFER, 0);
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }

  glFlush();
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
  glFinish();
  if (glGetError() != GL_NO_ERROR) {
    throw std::runtime_error("opengl failed");
  }
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
