cmake_minimum_required(VERSION 3.8)

project(implicit_fem)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_library(log-lib log)
find_library(android-lib android)
find_package(Vulkan)


if (NOT DEFINED ENV{TAICHI_REPO_DIR})
    message(FATAL_ERROR "TAICHI_REPO_DIR not set")
endif()

set(TAICHI_REPO_DIR $ENV{TAICHI_REPO_DIR})

# build main native library
set(JNILIBS_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/)


# build native_app_glue as a static lib
set(${CMAKE_C_FLAGS}, "${CMAKE_C_FLAGS}")
add_library(native_app_glue STATIC
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c)

# Export ANativeActivity_onCreate(),
# Refer to: https://github.com/android-ndk/ndk/issues/381.
set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} -u ANativeActivity_onCreate")

add_library(taichi-implicit-fem SHARED implicit_fem.cpp)


set(TI_WITH_VULKAN ON)
set(TI_WITH_OPENGL OFF)
set(TI_WITH_LLVM OFF)
set(TI_WITH_CC OFF)
set(TI_WITH_PYTHON OFF)
set(TI_EXPORT_CORE ON)
add_subdirectory(${TAICHI_REPO_DIR} taichi)


target_compile_options(taichi-implicit-fem PUBLIC -Wall -Wextra -DTI_WITH_VULKAN -DTI_INCLUDED)

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
target_include_directories(taichi-implicit-fem PUBLIC ${ANDROID_NDK}/sources/android/native_app_glue)

target_link_libraries(taichi-implicit-fem android log m Vulkan native_app_glue taichi_isolated_core)
