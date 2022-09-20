cmake_minimum_required(VERSION 3.13)

project(TaichiAotDemo LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)

# Check for `TAICHI_C_API_INSTALL_DIR`.
if (NOT EXISTS ${TAICHI_C_API_INSTALL_DIR})
    set(TAICHI_C_API_INSTALL_DIR $ENV{TAICHI_C_API_INSTALL_DIR})
endif()
if (NOT EXISTS $ENV{TAICHI_C_API_INSTALL_DIR})
    message(FATAL_ERROR "Environment variable TAICHI_C_API_INSTALL_DIR is not specified")
endif()
get_filename_component(TAICHI_C_API_INSTALL_DIR $ENV{TAICHI_C_API_INSTALL_DIR} ABSOLUTE CACHE)
message("-- TAICHI_C_API_INSTALL_DIR=" ${TAICHI_C_API_INSTALL_DIR})


# Declare framework target.
add_library(TaichiAotDemoFramework
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/common.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/framework.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/renderer.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/graphics_runtime.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/framework.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/renderer.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/glslang.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/graphics_runtime.cpp"
    # Draw functions.
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/draws/draw_points.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/draws/draw_points.cpp"
)
target_include_directories(TaichiAotDemoFramework PUBLIC
    ${Vulkan_INCLUDE_DIR}
    "${TAICHI_C_API_INSTALL_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include")


# Find dependencies.
find_package(Vulkan REQUIRED)
add_subdirectory(external/glfw)
add_subdirectory(external/VulkanMemoryAllocator)
add_subdirectory(external/glslang)
add_subdirectory(external/glm)
add_library(GraphiT OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/args.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/util.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/args.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/util.cpp")
target_include_directories(GraphiT PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include")
target_link_libraries(TaichiAotDemoFramework PUBLIC
    ${Vulkan_LIBRARY}
    glfw
    glm
    VulkanMemoryAllocator
    glslang
    SPIRV
    GraphiT)
target_include_directories(TaichiAotDemoFramework PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/external/glfw/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/VulkanMemoryAllocator/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/glslang/Include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/glm"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include")


# Find built taichi C-API library in `TAICHI_C_API_INSTALL_DIR`.
find_library(taichi_c_api taichi_c_api HINTS
    ${TAICHI_C_API_INSTALL_DIR}/lib
    # CMake find root is overriden by Android toolchain.
    NO_CMAKE_FIND_ROOT_PATH)
if (NOT EXISTS ${taichi_c_api})
    message(FATAL_ERROR "Couldn't find C-API library; ensure your Taichi is built with `TI_WITH_CAPI=ON`")
else()
    target_link_libraries(TaichiAotDemoFramework PUBLIC
        ${taichi_c_api})
endif()


# After all the configuration, get the common interfaces for all demo apps.
get_target_property(TaichiAotDemoFramework_INCLUDE_DIRECTORIES TaichiAotDemoFramework INCLUDE_DIRECTORIES)
get_target_property(TaichiAotDemoFramework_LINK_LIBRARIES TaichiAotDemoFramework LINK_LIBRARIES)


# Add demo source subdirectories.
list(APPEND TAICHI_AOT_DEMO_LIST
    "1_hello_world"
    "2_mpm88"
)

message("-- Building demo libraries:")
foreach(TAICHI_AOT_DEMO_DIR ${TAICHI_AOT_DEMO_LIST})
    message("--   ${TAICHI_AOT_DEMO_DIR}")

    add_subdirectory(${TAICHI_AOT_DEMO_DIR})
    target_link_libraries(${TAICHI_AOT_DEMO_DIR} PUBLIC ${TaichiAotDemoFramework_LINK_LIBRARIES})
    target_include_directories(${TAICHI_AOT_DEMO_DIR} PUBLIC ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})

    add_executable(E${TAICHI_AOT_DEMO_DIR}
        "framework/src/taichi/aot_demo/entry_points/headless.cpp")
    target_link_libraries(E${TAICHI_AOT_DEMO_DIR} PUBLIC
        ${TAICHI_AOT_DEMO_DIR}
        TaichiAotDemoFramework
        ${TaichiAotDemoFramework_LINK_LIBRARIES})
    target_include_directories(E${TAICHI_AOT_DEMO_DIR} PUBLIC
        ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})
endforeach()



# - Cross-platform compatibility below this line -------------------------------


# If you are building for Android, you need to link to system libraries.
if (ANDROID)
    find_library(android android)
    find_library(log log)
    target_link_libraries(TaichiAotDemoFramework android log)
endif()


# Copy Taichi C-API dynamic library to build artifact directory.
if (WIN32)
    file(GLOB taichi_c_api_SRC "${TAICHI_C_API_INSTALL_DIR}/bin/*")
    string(REPLACE "${TAICHI_C_API_INSTALL_DIR}/bin" "" taichi_c_api_DST ${taichi_c_api_SRC})
    add_custom_command(
        TARGET TaichiAotDemoFramework
        POST_BUILD
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${taichi_c_api_SRC} $<TARGET_FILE_DIR:TaichiAotDemoFramework>/${taichi_c_api_DST}
        VERBATIM)
else()
    set(taichi_c_api_SRC ${taichi_c_api})
    string(REPLACE "${TAICHI_C_API_INSTALL_DIR}/lib" "" taichi_c_api_DST ${taichi_c_api_SRC})
    add_custom_command(
        TARGET TaichiAotDemoFramework
        POST_BUILD
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${taichi_c_api_SRC} $<TARGET_FILE_DIR:TaichiAotDemoFramework>/${taichi_c_api_DST}
        VERBATIM)
endif()


# MoltenVK dylib should be copied to the output directory.
if (APPLE)
    find_library(MoltenVK libMoltenVK.dylib PATHS $HOMEBREW_CELLAR/molten-vk $VULKAN_SDK REQUIRED)
    add_custom_command(
        TARGET TaichiAotDemoFramework
        POST_BUILD
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${MoltenVK} $<TARGET_FILE_DIR:TaichiAotDemoFramework>/libMoltenVK.dylib
        VERBATIM)
endif()
