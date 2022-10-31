cmake_minimum_required(VERSION 3.13)

project(TaichiAotDemo LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)

option(TI_WITH_VULKAN "Compile with Vulkan backend" ON)
option(TI_WITH_CPU "Compile with CPU backend" OFF)
option(TI_WITH_CUDA "Compile with CUDA backend" OFF)

# Add demo source subdirectories.
list(APPEND TAICHI_AOT_DEMO_LIST
    "1_hello_world"
    "2_mpm88"
    "3_implicit_fem"
)

list(APPEND TAICHI_AOT_PYTHON_LIST
     "${CMAKE_CURRENT_SOURCE_DIR}/2_mpm88/assets/mpm88.py"
     "${CMAKE_CURRENT_SOURCE_DIR}/3_implicit_fem/assets/implicit_fem.py"
)

# Add platform entry points here.
list(APPEND TAICHI_AOT_ENTRY_POINT_LIST
    "headless"
)

if (NOT ANDROID)
    list(APPEND TAICHI_AOT_ENTRY_POINT_LIST
        "glfw"
    )
endif()


# Check for `TAICHI_C_API_INSTALL_DIR`.
if (NOT EXISTS ${TAICHI_C_API_INSTALL_DIR})
    set(TAICHI_C_API_INSTALL_DIR $ENV{TAICHI_C_API_INSTALL_DIR})
endif()
if (NOT EXISTS $ENV{TAICHI_C_API_INSTALL_DIR})
    message(FATAL_ERROR "Environment variable TAICHI_C_API_INSTALL_DIR is not specified")
endif()
get_filename_component(TAICHI_C_API_INSTALL_DIR $ENV{TAICHI_C_API_INSTALL_DIR} ABSOLUTE CACHE)
message("-- TAICHI_C_API_INSTALL_DIR=" ${TAICHI_C_API_INSTALL_DIR})


# Find built taichi C-API library in `TAICHI_C_API_INSTALL_DIR`.
find_library(taichi_c_api taichi_c_api HINTS
    ${TAICHI_C_API_INSTALL_DIR}/lib
    # CMake find root is overriden by Android toolchain.
    NO_CMAKE_FIND_ROOT_PATH)
if (NOT EXISTS ${taichi_c_api})
    message(FATAL_ERROR "Couldn't find C-API library; ensure your Taichi is built with `TI_WITH_CAPI=ON`")
endif()


# Find dependencies.
find_package(Vulkan REQUIRED)
if (NOT ANDROID)
    add_subdirectory(external/glfw)
endif()
add_subdirectory(external/VulkanMemoryAllocator)
add_subdirectory(external/glslang)
set(BUILD_TESTING OFF)
set(BUILD_STATIC_LIBS ON)
add_subdirectory(external/glm)
add_library(GraphiT OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/args.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/util.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/args.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/util.cpp")
target_include_directories(GraphiT PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include")


# Declare framework target.
list(APPEND TaichiAotDemoFramework_SOURCES
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/common.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/framework.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/renderer.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/graphics_runtime.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/asset_manager.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/framework.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/renderer.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/glslang.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/graphics_runtime.cpp"
# Draw functions.
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/draws/draw_points.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/include/taichi/aot_demo/draws/draw_mesh.hpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/draws/draw_points.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/draws/draw_mesh.cpp"
)

if (TI_WITH_VULKAN)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_VULKAN=ON")
endif()

if (TI_WITH_CPU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_CPU")
    list(APPEND TAICHI_AOT_DEMO_LIST "1_hello_world_with_cpu_interop")
    list(APPEND TaichiAotDemoFramework_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/interop/cross_device_copy.cpp")
    
    if (TI_WITH_CUDA)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_CUDA")
    endif()
endif()


list(APPEND TaichiAotDemoFramework_LINK_LIBRARIES
    ${Vulkan_LIBRARY}
    ${taichi_c_api}
    glm
    VulkanMemoryAllocator
    glslang
    SPIRV
    GraphiT)
list(APPEND TaichiAotDemoFramework_INCLUDE_DIRECTORIES
    ${Vulkan_INCLUDE_DIR}
    "${TAICHI_C_API_INSTALL_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/VulkanMemoryAllocator/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/glslang/Include"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/glm"
    "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include")

foreach(TAICHI_AOT_DEMO_DIR ${TAICHI_AOT_DEMO_LIST})
    add_subdirectory(${TAICHI_AOT_DEMO_DIR} ${TAICHI_AOT_DEMO_CURRENT_TARGET})

    target_link_libraries(${TAICHI_AOT_DEMO_DIR} PUBLIC ${TaichiAotDemoFramework_LINK_LIBRARIES})
    target_include_directories(${TAICHI_AOT_DEMO_DIR} PUBLIC ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})
endforeach()

message("-- Building demo libraries:")
foreach(TAICHI_AOT_ENTRY_POINT ${TAICHI_AOT_ENTRY_POINT_LIST})

    foreach(TAICHI_AOT_DEMO_DIR ${TAICHI_AOT_DEMO_LIST})
        message("--   ${TAICHI_AOT_DEMO_DIR} @ ${TAICHI_AOT_ENTRY_POINT}")
        set(TAICHI_AOT_DEMO_CURRENT_TARGET E${TAICHI_AOT_DEMO_DIR}_${TAICHI_AOT_ENTRY_POINT})

        add_executable(${TAICHI_AOT_DEMO_CURRENT_TARGET}
            "${CMAKE_CURRENT_SOURCE_DIR}/framework/src/taichi/aot_demo/entry_points/${TAICHI_AOT_ENTRY_POINT}.cpp"
            ${TaichiAotDemoFramework_SOURCES})
        set_target_properties(${TAICHI_AOT_DEMO_CURRENT_TARGET} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TAICHI_AOT_ENTRY_POINT})
        target_link_libraries(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC
            ${TAICHI_AOT_DEMO_DIR}
            ${TaichiAotDemoFramework_LINK_LIBRARIES})
        target_include_directories(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC
            ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})

        # Some settings for specific entry points.
        if(${TAICHI_AOT_ENTRY_POINT} STREQUAL "glfw")
            target_compile_definitions(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC
                TI_AOT_DEMO_WITH_GLFW=1)
            target_link_libraries(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC
                glfw)
            target_include_directories(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC
                ${Vulkan_INCLUDE_DIR}
                "${CMAKE_CURRENT_SOURCE_DIR}/external/glfw/include")
        endif()



        # - Cross-platform compatibility below this line -------------------------------

        # If you are building for Android, you need to link to system libraries.
        if (ANDROID)
            find_library(android android)
            find_library(log log)
            target_link_libraries(${TAICHI_AOT_DEMO_CURRENT_TARGET} PUBLIC android log)
        endif()


        # Copy Taichi C-API dynamic library to build artifact directory.
        if (WIN32)
            file(GLOB taichi_c_api_SRC "${TAICHI_C_API_INSTALL_DIR}/bin/*")
            string(REPLACE "${TAICHI_C_API_INSTALL_DIR}/bin" "" taichi_c_api_DST ${taichi_c_api_SRC})
            add_custom_command(
                TARGET ${TAICHI_AOT_DEMO_CURRENT_TARGET}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND}
                ARGS -E copy ${taichi_c_api_SRC} $<TARGET_FILE_DIR:${TAICHI_AOT_DEMO_CURRENT_TARGET}>/${taichi_c_api_DST}
                VERBATIM)
        else()
            set(taichi_c_api_SRC ${taichi_c_api})
            string(REPLACE "${TAICHI_C_API_INSTALL_DIR}/lib" "" taichi_c_api_DST ${taichi_c_api_SRC})
            add_custom_command(
                TARGET ${TAICHI_AOT_DEMO_CURRENT_TARGET}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND}
                ARGS -E copy ${taichi_c_api_SRC} $<TARGET_FILE_DIR:${TAICHI_AOT_DEMO_CURRENT_TARGET}>/${taichi_c_api_DST}
                VERBATIM)
        endif()


        # MoltenVK dylib should be copied to the output directory.
        if (APPLE)
            find_library(MoltenVK libMoltenVK.dylib PATHS $HOMEBREW_CELLAR/molten-vk $VULKAN_SDK REQUIRED)
            add_custom_command(
                TARGET ${TAICHI_AOT_DEMO_CURRENT_TARGET}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND}
                ARGS -E copy ${MoltenVK} $<TARGET_FILE_DIR:${TAICHI_AOT_DEMO_CURRENT_TARGET}>/libMoltenVK.dylib
                VERBATIM)
        endif()

    endforeach()

endforeach()

# Generate AOT compiled files
if(NOT ${PYTHON_EXECUTABLE})
    find_package(PythonInterp REQUIRED)
    if(NOT ${PYTHONINTERP_FOUND})
        message(FATAL_ERROR "Unable to find python executable")
    endif()
endif()

foreach(PYTHON_SCRIPT ${TAICHI_AOT_PYTHON_LIST})
    execute_process(COMMAND ${PYTHON_EXECUTABLE} ${PYTHON_SCRIPT} --arch vulkan)
endforeach()
