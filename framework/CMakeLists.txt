set(RENDER_FRAMEWORK_TARGET render_framework)

# Framework sources.
file(GLOB FRAMEWORK_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/${TI_FRAMEWORK_BACKEND}/interop/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/${TI_FRAMEWORK_BACKEND}/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/${TI_FRAMEWORK_BACKEND}/draws/*.cpp)
add_library(${RENDER_FRAMEWORK_TARGET} STATIC
    ${FRAMEWORK_SOURCES})
target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
    Taichi::Runtime
    glm::glm_static
    GraphiT)

# Configure entry points.
if(TI_AOT_DEMO_WITH_HEADLESS)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_AOT_DEMO_WITH_HEADLESS=1
    )

    if(NOT ANDROID AND NOT IOS)
        add_subdirectory(${PROJECT_SOURCE_DIR}/external/backward-cpp backward-cpp)
    endif()
endif()

if(TI_AOT_DEMO_WITH_GLFW)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_AOT_DEMO_WITH_GLFW=1
    )

    add_subdirectory(${PROJECT_SOURCE_DIR}/external/glfw glfw)
endif()

if(TI_AOT_DEMO_WITH_ANDROID_APP)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_AOT_DEMO_WITH_ANDROID_APP=1
    )

    find_library(android android)
    find_library(log log)
endif()

# Configure Taichi backends.
if(TI_WITH_VULKAN)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_WITH_VULKAN=1
    )

    add_subdirectory(${PROJECT_SOURCE_DIR}/external/VulkanMemoryAllocator VulkanMemoryAllocator)
    add_subdirectory(${PROJECT_SOURCE_DIR}/external/glslang glslang)
    find_package(Vulkan REQUIRED)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
        Vulkan::Vulkan
        VulkanMemoryAllocator
        glslang
        SPIRV)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
        ${PROJECT_SOURCE_DIR}/external/Vulkan-Headers/include
        ${PROJECT_SOURCE_DIR}/external/VulkanMemoryAllocator/include
        ${PROJECT_SOURCE_DIR}/external/glslang/glslang/Include)
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

# Propagate to parent scope
set(RENDER_FRAMEWORK_TARGET render_framework PARENT_SCOPE)
