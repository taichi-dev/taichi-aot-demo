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
#include <vulkan/vulkan.h>
#include "taichi/cpp/taichi.hpp"
#ifdef VK_NO_PROTOTYPES
#undef VK_NO_PROTOTYPES
#endif
