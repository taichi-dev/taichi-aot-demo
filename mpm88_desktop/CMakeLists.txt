cmake_minimum_required(VERSION 3.13)

project(mpm88)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(mpm88 mpm88.cpp)

target_compile_options(mpm88 PUBLIC -Wall -Wextra -DTI_WITH_LLVM -DTI_WITH_CUDA -DTI_WITH_VULKAN -DTI_INCLUDED -DTI_ARCH_x64)

if (NOT DEFINED ENV{TAICHI_REPO_DIR})
    message(FATAL_ERROR "TAICHI_REPO_DIR not set")
endif()

set(TAICHI_REPO_DIR $ENV{TAICHI_REPO_DIR})

target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/taichi/backends/vulkan)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/Vulkan-Headers/include/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/SPIRV-Tools/include/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/volk/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/glm/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/imgui/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/glfw/include)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/imgui/backends)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/eigen/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/spdlog/include/)
target_include_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/external/VulkanMemoryAllocator/include/)
target_include_directories(mpm88 PUBLIC /Users/zhanlueyang/workspace/llvm-10.0.0-m1)

target_link_directories(mpm88 PUBLIC ${TAICHI_REPO_DIR}/build)

target_link_libraries(mpm88 PUBLIC taichi_export_core)

