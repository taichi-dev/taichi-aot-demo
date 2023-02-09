#pragma once
#include <array>
#include <cassert>
#include <cstdint>
#include <map>
#include <vector>
#include <string>
#include <memory>
#include <stdexcept>

#include "glm/glm.hpp"

#ifdef TI_WITH_CUDA
#include <cuda.h>
#endif

#ifdef TI_WITH_OPENGL
#include "glad/gl.h"
#endif // TI_WITH_OPENGL

#if TI_AOT_DEMO_WITH_ANDROID_APP
#define VK_USE_PLATFORM_ANDROID_KHR 1
#endif // TI_AOT_DEMO_WITH_ANDROID_APP

#ifdef _WIN32
#define VK_USE_PLATFORM_WIN32_KHR
#endif // _WIN32
#include <vulkan/vulkan.h>
#include "taichi/cpp/taichi.hpp"
#define VMA_DYNAMIC_VULKAN_FUNCTIONS
#include <vk_mem_alloc.h>

#if TI_AOT_DEMO_WITH_GLFW
#include "GLFW/glfw3.h"
#endif // TI_AOT_DEMO_WITH_GLFW

#if TI_AOT_DEMO_WITH_ANDROID_APP
#include <android/native_window.h>
#endif // TI_AOT_DEMO_WITH_ANDROID_APP
