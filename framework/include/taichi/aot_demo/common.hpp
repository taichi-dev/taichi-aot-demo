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
#define TI_NO_VULKAN_INCLUDES 1
#include <vulkan/vulkan.h>
#include "taichi/cpp/taichi.hpp"

#define VMA_DYNAMIC_VULKAN_FUNCTIONS
#include <vk_mem_alloc.h>
