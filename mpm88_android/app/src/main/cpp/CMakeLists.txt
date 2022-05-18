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

# build native_app_glue as a static lib
set(${CMAKE_C_FLAGS}, "${CMAKE_C_FLAGS}")
add_library(native_app_glue STATIC
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c)

# Export ANativeActivity_onCreate(),
# Refer to: https://github.com/android-ndk/ndk/issues/381.
set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} -u ANativeActivity_onCreate")

add_library(native-activity SHARED main.cpp)

target_compile_options(native-activity PUBLIC -Wall -Wextra -std=c++17 -DTI_WITH_VULKAN -DTI_INCLUDED)

target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/taichi/backends/vulkan)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/Vulkan-Headers/include/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/SPIRV-Tools/include/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/volk/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/glm/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/imgui/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/imgui/backends)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/eigen/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/spdlog/include/)
target_include_directories(native-activity PUBLIC ${TAICHI_REPO_DIR}/external/VulkanMemoryAllocator/include/)
target_include_directories(native-activity PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../include/)
target_include_directories(native-activity PUBLIC ${ANDROID_NDK}/sources/android/native_app_glue)

target_link_libraries(native-activity android log m vulkan taichi_export_core native_app_glue)
