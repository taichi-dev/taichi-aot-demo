#pragma once
#include <array>
#include <cassert>
#include <cstdint>
#include <map>
#include <vector>
#include <string>
#include <memory>

#include "glm/glm.hpp"

#if TI_AOT_DEMO_ANDROID_APP
#define VK_USE_PLATFORM_ANDROID_KHR 1
#endif // TI_AOT_DEMO_ANDROID_APP

#ifdef TI_WITH_CUDA
#include <cuda.h>
#endif

#ifdef TI_WITH_OPENGL
#ifdef __APPLE__
#include <OpenGL/gl3.h>
#else
#include <GL/gl.h>
#endif // __APPLE__
#endif // TI_WITH_OPENGL

#include <vulkan/vulkan.h>
#include "taichi/cpp/taichi.hpp"
#define VMA_DYNAMIC_VULKAN_FUNCTIONS
#include <vk_mem_alloc.h>
