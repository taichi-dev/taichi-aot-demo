cmake_minimum_required(VERSION 3.13)

project(comet)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if("${TAICHI_REPO}" STREQUAL "")
    message(FATAL_ERROR "Set TAICHI_REPO with -DTAICHI_REPO=.. ")
endif()

add_executable(comet comet.cpp)
#target_compile_options(comet PUBLIC -DTI_WITH_CUDA -DTI_WITH_LLVM -DTI_WITH_VULKAN=ON -DTI_INCLUDED)
target_compile_options(comet PUBLIC -DTI_WITH_VULKAN=ON -DTI_INCLUDED)

# C-API Dependencies
target_include_directories(comet
  PRIVATE
    ${PROJECT_SOURCE_DIR}
    ${TAICHI_REPO}/c_api/include
    ${TAICHI_REPO}/c_api/src
  )

target_link_directories(comet
  PRIVATE
    ${PROJECT_SOURCE_DIR}
    ${TAICHI_REPO}/build
  )

target_link_libraries(comet PUBLIC taichi_c_api)

# GUI Dependencies
target_include_directories(comet 
    PUBLIC 
        ${TAICHI_REPO}
        ${TAICHI_REPO}/taichi/backends/vulkan
        ${TAICHI_REPO}/external/Vulkan-Headers/include/
        ${TAICHI_REPO}/external/SPIRV-Tools/include/
        ${TAICHI_REPO}/external/volk/
        ${TAICHI_REPO}/external/glm/
        ${TAICHI_REPO}/external/imgui/
        ${TAICHI_REPO}/external/glfw/include
        ${TAICHI_REPO}/external/imgui/backends
        ${TAICHI_REPO}/external/eigen/
        ${TAICHI_REPO}/external/spdlog/include/
        ${TAICHI_REPO}/external/VulkanMemoryAllocator/include/
        )
