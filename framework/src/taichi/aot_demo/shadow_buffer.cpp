#pragma once
#include "taichi/aot_demo/shadow_buffer.hpp"
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

ShadowBuffer::ShadowBuffer(const std::shared_ptr<Renderer> &renderer,
               const ti::Memory &client_memory,
               ShadowBufferUsage usage)
    : renderer_(renderer) {
  TiMemoryAllocateInfo mai {};
  mai.size = client_memory.size();
#ifndef ANDROID
  mai.export_sharing = TI_TRUE;
#endif  // ANDROID
  switch (usage) {
    case ShadowBufferUsage::VertexBuffer:
      mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_VERTEX_BIT;
      break;
    case ShadowBufferUsage::IndexBuffer:
      mai.usage = TI_MEMORY_USAGE_STORAGE_BIT | TI_MEMORY_USAGE_INDEX_BIT;
      break;
    case ShadowBufferUsage::StorageBuffer:
      mai.usage = TI_MEMORY_USAGE_STORAGE_BIT;
      break;
  }
  ti::Memory memory = renderer->runtime_.allocate_memory(mai);

  usage_ = usage;
  memory_ = std::move(memory);
  client_memory_ = ti::Memory(renderer_->client_runtime_, client_memory,
                              client_memory.size(), false);
}

ShadowBuffer::~ShadowBuffer() {
  memory_.destroy();
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



void ShadowBuffer::copy_from_vulkan_() {
  ti::Runtime &client_runtime = renderer_->client_runtime();

  assert(client_runtime.arch() == TI_ARCH_VULKAN);
  client_memory_.copy_to(memory_);
}

void ShadowBuffer::copy_from_cpu_() {
#if TI_WITH_CPU
  ti::Runtime &client_runtime = renderer_->client_runtime();
  ti::Runtime &runtime = renderer_->client_runtime();

  TiCpuMemoryInteropInfo cmii{};
  ti_export_cpu_memory(client_runtime, client_memory_.memory(), &cmii);

  ti::Memory staging_buffer = renderer_.allocate_staging_buffer(memory_.size());
  staging_buffer.write(cmii.ptr, cmii.size);
  staging_buffer.copy_to(memory_);
#endif // TI_WITH_CPU
}

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
void ShadowBuffer::copy_from_cuda_() {
#ifdef TI_WITH_CUDA
  ti::Runtime &runtime = renderer_->runtime_;
  ti::Runtime &cuda_runtime = renderer_->client_runtime();
  // Get Interop Info
  TiVulkanMemoryInteropInfo vulkan_interop_info;
  ti_export_vulkan_memory(runtime.runtime(),
                          memory_.memory(),
                          &vulkan_interop_info);
  
  TiCudaMemoryInteropInfo cuda_interop_info;
  ti_export_cuda_memory(cuda_runtime, client_memory_.memory(), &cuda_interop_info);

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
  CUdeviceptr client_memory__cuda_ptr = reinterpret_cast<CUdeviceptr>(cuda_interop_info.ptr);

  cuMemcpyDtoD_v2(dst_cuda_ptr, client_memory__cuda_ptr, vulkan_interop_info.size);
#else
  assert(false);
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

void ShadowBuffer::copy_from_opengl_() {
#ifdef TI_WITH_OPENGL
  ti::Runtime &runtime = renderer_->runtime_;
  ti::Runtime &opengl_runtime = renderer_->client_runtime();
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
                          memory_.memory(),
                          &vulkan_interop_info);

  TiOpenglMemoryInteropInfo opengl_interop_info{};
  ti_export_opengl_memory(opengl_runtime.runtime(),
                          client_memory_.memory(), &opengl_interop_info);

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
  assert(false);
#endif // TI_WITH_OPENGL
}

void ShadowBuffer::update() {
  switch (renderer_->client_runtime_.arch()) {
    case TI_ARCH_VULKAN:
      copy_from_vulkan_();
      break;
    case TI_ARCH_X64:
    case TI_ARCH_ARM64:
      copy_from_cpu_();
      break;
    case TI_ARCH_CUDA:
      copy_from_cuda_();
      break;
    case TI_ARCH_OPENGL:
      copy_from_opengl_();
      break;
    default:
      assert(false);
  }
}


} // namespace aot_demo
} // namespace ti
