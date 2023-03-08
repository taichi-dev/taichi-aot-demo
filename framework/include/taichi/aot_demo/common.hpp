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

#if TI_WITH_VULKAN
#ifdef _WIN32
#define VK_USE_PLATFORM_WIN32_KHR
#endif  // _WIN32
#ifdef ANDROID
#define VK_USE_PLATFORM_ANDROID_KHR 1
#endif // ANDROID
#include <vulkan/vulkan.h>
#define VMA_STATIC_VULKAN_FUNCTIONS 0
#define VMA_DYNAMIC_VULKAN_FUNCTIONS 1
#include <vk_mem_alloc.h>
#endif  // TI_WITH_VULKAN

#ifdef TI_WITH_METAL
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <MetalKit/MTKView.h>
#endif  // __OBJC__
#endif  // TI_WITH_METAL

#ifdef TI_WITH_CUDA
#include <cuda.h>
#endif

#ifdef TI_WITH_OPENGL
#include "glad/gl.h"
#endif // TI_WITH_OPENGL

#include "taichi/cpp/taichi.hpp"

#if TI_AOT_DEMO_GLFW
#include "GLFW/glfw3.h"
#endif // TI_AOT_DEMO_GLFW

#if TI_AOT_DEMO_ANDROID_APP
#include <android/native_window.h>
#endif // TI_AOT_DEMO_ANDROID_APP
