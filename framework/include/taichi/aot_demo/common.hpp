#pragma once
#include <array>
#include <cassert>
#include <cstdint>
#include <map>
#include <vector>
#include <string>
#include <memory>

#include "glm/glm.hpp"

#define TI_WITH_VULKAN 1

#if TI_AOT_DEMO_ANDROID_APP
#define VK_USE_PLATFORM_ANDROID_KHR 1
#endif // TI_AOT_DEMO_ANDROID_APP

#include <vulkan/vulkan.h>
#include "taichi/cpp/taichi.hpp"
#define TI_NO_OPENGL_INCLUDES 1
#define VMA_DYNAMIC_VULKAN_FUNCTIONS
#include <vk_mem_alloc.h>
