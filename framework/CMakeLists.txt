set(RENDER_FRAMEWORK_TARGET render_framework)

file(GLOB TaichiAotDemoFramework_SOURCES 
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/interop/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/draws/*.cpp
     )

find_package(Taichi REQUIRED)
find_package(Vulkan REQUIRED)

# Compile for renderer framework
add_library(${RENDER_FRAMEWORK_TARGET}
    ${TaichiAotDemoFramework_SOURCES}
    "${PROJECT_SOURCE_DIR}/external/graphi-t/include/gft/args.hpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/include/gft/util.hpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/src/gft/args.cpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/src/gft/util.cpp"
    )

target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/external/Vulkan-Headers/include
    ${PROJECT_SOURCE_DIR}/external/VulkanMemoryAllocator/include
    ${PROJECT_SOURCE_DIR}/external/glslang/glslang/Include
    ${PROJECT_SOURCE_DIR}/external/glm
    ${PROJECT_SOURCE_DIR}/external/graphi-t/include
)
target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
    Vulkan::Vulkan
    Taichi::Runtime
    glm
    VulkanMemoryAllocator
    glslang
    SPIRV
)

if(TI_WITH_VULKAN)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_WITH_VULKAN=1
        )
endif()

if(TI_WITH_CPU)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_WITH_CPU=1
        # find runtime.bc files
        TI_LIB_DIR="${TAICHI_C_API_INSTALL_DIR}/runtime"
        )
endif()

if(TI_WITH_CUDA)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_WITH_CUDA=1
        # find runtime.bc files
        TI_LIB_DIR="${TAICHI_C_API_INSTALL_DIR}/runtime"
        )

    find_package(CUDAToolkit REQUIRED)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC cuda)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
        ${CUDAToolkit_INCLUDE_DIRS})
endif()

if(TI_WITH_OPENGL)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_WITH_OPENGL=1
        )

    add_library(glad OBJECT
        "${PROJECT_SOURCE_DIR}/external/glad/src/gl.c"
        "${PROJECT_SOURCE_DIR}/external/glad/src/egl.c"
    )
    target_include_directories(glad PUBLIC ${PROJECT_SOURCE_DIR}/external/glad/include)

    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC glad)
endif()

if(ANDROID)
    find_library(android android)
    find_library(log log)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC android log)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC TI_AOT_DEMO_ANDROID_APP=1)
endif()

if(NOT ANDROID)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC glfw)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC ${PROJECT_SOURCE_DIR}/external/glfw/include)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC TI_AOT_DEMO_WITH_GLFW=1)
endif()

# Propagate to parent scope
set(RENDER_FRAMEWORK_TARGET render_framework PARENT_SCOPE)
