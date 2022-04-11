cmake_minimum_required(VERSION 3.8)

if (NOT DEFINED ENV{TAICHI_REPO_DIR})
    message(FATAL_ERROR "TAICHI_REPO_DIR not set")
endif()

set(TAICHI_REPO_DIR $ENV{TAICHI_REPO_DIR})

# build main native library
set(JNILIBS_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/)

if (EXISTS "${JNILIBS_PATH}/libtaichi_export_core.so")
  link_directories(${JNILIBS_PATH})
else()
  message(FATAL_ERROR "Please copy libtaichi_export_core.so to ${JNILIBS_PATH}")
endif()

add_library(taichi-implicit-fem SHARED implicit_fem.cpp)

target_compile_options(taichi-implicit-fem PUBLIC -Wall -Wextra -std=c++17 -DTI_WITH_VULKAN -DTI_INCLUDED)

target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/taichi/backends/vulkan)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/Vulkan-Headers/include/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/SPIRV-Tools/include/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/volk/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/glm/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/imgui/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/imgui/backends)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/eigen/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/spdlog/include/)
target_include_directories(taichi-implicit-fem PUBLIC ${TAICHI_REPO_DIR}/external/VulkanMemoryAllocator/include/)
target_include_directories(taichi-implicit-fem PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../include/)

target_link_libraries(taichi-implicit-fem android log m vulkan taichi_export_core)
