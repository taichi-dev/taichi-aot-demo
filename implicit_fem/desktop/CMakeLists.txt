cmake_minimum_required(VERSION 3.15)

project(implicit_fem LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type selected, default to Release")
    set(CMAKE_BUILD_TYPE "Release" CACHE PATH "Build Type" FORCE)
endif()


add_executable(implicit_fem implicit_fem.cpp)


if (NOT DEFINED ENV{TAICHI_REPO_DIR})
    message(FATAL_ERROR "TAICHI_REPO_DIR not set")
else()
    set(TAICHI_REPO_DIR $ENV{TAICHI_REPO_DIR})
endif()


add_definitions(-D_GLFW_BUILD_DLL -DTI_INCLUDED)
if (MSVC)
    target_compile_options(implicit_fem PUBLIC "/Zc:__cplusplus")
    set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreadedDLL)
endif()


set(TI_WITH_VULKAN ON)
set(TI_WITH_OPENGL OFF)
set(TI_WITH_LLVM OFF)
set(TI_WITH_CC OFF)
set(TI_WITH_PYTHON OFF)
set(TI_EXPORT_CORE ON)
add_subdirectory(${TAICHI_REPO_DIR} taichi)


target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/taichi/backends/vulkan)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/Vulkan-Headers/include/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/SPIRV-Tools/include/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/volk/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/glm/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/imgui/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/glfw/include)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/imgui/backends)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/eigen/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/spdlog/include/)
target_include_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/external/VulkanMemoryAllocator/include/)
target_include_directories(implicit_fem PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include/)

target_link_directories(implicit_fem PUBLIC ${TAICHI_REPO_DIR}/build)

target_link_libraries(implicit_fem PUBLIC taichi_isolated_core glfw)
