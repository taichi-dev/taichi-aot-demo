set(RENDER_FRAMEWORK_TARGET render_framework)

file(GLOB FRAMEWORK_SOURCES 
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/draws/*.cpp
     )

if(TI_AOT_DEMO_RENDER_WITH_VULKAN)
    file(GLOB FRAMEWORK_RENDERER_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/vulkan/interop/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/vulkan/*.cpp)
endif()

find_package(Taichi REQUIRED)

# Compile for renderer framework
add_library(${RENDER_FRAMEWORK_TARGET} STATIC
    ${FRAMEWORK_SOURCES}
    ${FRAMEWORK_RENDERER_SOURCES}
    "${PROJECT_SOURCE_DIR}/external/graphi-t/include/gft/args.hpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/include/gft/util.hpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/src/gft/args.cpp"
    "${PROJECT_SOURCE_DIR}/external/graphi-t/src/gft/util.cpp"
    )

target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/external/graphi-t/third/glslang/glslang/Include
    ${PROJECT_SOURCE_DIR}/external/graphi-t/third/glm
    ${PROJECT_SOURCE_DIR}/external/graphi-t/include
)
target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
    Taichi::Runtime
    glm
    glslang
    SPIRV
)



if(TI_AOT_DEMO_RENDER_WITH_VULKAN)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_AOT_DEMO_RENDER_WITH_VULKAN=1
        )

    find_package(Vulkan REQUIRED)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
        Vulkan::Vulkan)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
        ${PROJECT_SOURCE_DIR}/external/Vulkan-Headers/include
        ${PROJECT_SOURCE_DIR}/external/graphi-t/third/VulkanMemoryAllocator/include
        )
endif()

if(TI_AOT_DEMO_RENDER_WITH_METAL)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC
        TI_AOT_DEMO_RENDER_WITH_METAL=1
        )

    add_subdirectory(${PROJECT_SOURCE_DIR}/external/SPIRV-Cross SPIRV-Cross)

    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC
        spirv-cross-msl
        spirv-cross-core)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC
        ${PROJECT_SOURCE_DIR}/external/SPIRV-Cross)
endif()



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

if(TI_AOT_DEMO_HEADLESS)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PRIVATE TI_AOT_DEMO_HEADLESS=1)
endif()

if(TI_AOT_DEMO_GLFW)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC glfw)
    target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC ${PROJECT_SOURCE_DIR}/external/glfw/include)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PRIVATE TI_AOT_DEMO_GLFW=1)
endif()

if(TI_AOT_DEMO_ANDROID_APP)
    find_library(android android)
    find_library(log log)
    target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC android log)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PRIVATE TI_AOT_DEMO_ANDROID_APP=1)
endif()

# Propagate to parent scope
set(RENDER_FRAMEWORK_TARGET render_framework PARENT_SCOPE)
