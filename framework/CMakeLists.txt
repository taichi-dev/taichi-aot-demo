set(RENDER_FRAMEWORK_TARGET render_framework)

file(GLOB TaichiAotDemoFramework_SOURCES 
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/interop/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/src/taichi/aot_demo/draws/*.cpp)

set(TaichiAotDemoFramework_LINK_LIBRARIES
    ${Vulkan_LIBRARY}
    ${taichi_c_api}
    glm
    VulkanMemoryAllocator
    glslang
    SPIRV
    GraphiT)

set(TaichiAotDemoFramework_INCLUDE_DIRECTORIES
    ${TAICHI_C_API_INSTALL_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/external/Vulkan-Headers/include
    ${PROJECT_SOURCE_DIR}/external/VulkanMemoryAllocator/include
    ${PROJECT_SOURCE_DIR}/external/glslang/glslang/Include
    ${PROJECT_SOURCE_DIR}/external/glm
    ${PROJECT_SOURCE_DIR}/external/graphi-t/include
    )

if(TI_WITH_CUDA)
    find_package(CUDAToolkit REQUIRED)
    list(APPEND TaichiAotDemoFramework_LINK_LIBRARIES cuda)
    list(APPEND TaichiAotDemoFramework_INCLUDE_DIRECTORIES ${CUDAToolkit_INCLUDE_DIRS})
endif()

if(TI_WITH_OPENGL)
    list(APPEND TaichiAotDemoFramework_LINK_LIBRARIES glad)
    list(APPEND TaichiAotDemoFramework_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/external/glad/include)
endif()

# Compile for renderer framework
add_library(${RENDER_FRAMEWORK_TARGET} ${TaichiAotDemoFramework_SOURCES})

if(ANDROID)
    find_library(android android)
    find_library(log log)
    list(APPEND TaichiAotDemoFramework_LINK_LIBRARIES android log)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC TI_AOT_DEMO_ANDROID_APP=1)
endif()

if(NOT ANDROID)
    list(APPEND TaichiAotDemoFramework_LINK_LIBRARIES glfw)
    list(APPEND TaichiAotDemoFramework_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/external/glfw/include)
    target_compile_definitions(${RENDER_FRAMEWORK_TARGET} PUBLIC TI_AOT_DEMO_WITH_GLFW=1)
endif()

target_link_libraries(${RENDER_FRAMEWORK_TARGET} PUBLIC ${TaichiAotDemoFramework_LINK_LIBRARIES})
target_include_directories(${RENDER_FRAMEWORK_TARGET} PUBLIC ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})

# Propagate to parent scope
set(RENDER_FRAMEWORK_TARGET render_framework PARENT_SCOPE)
set(TaichiAotDemoFramework_INCLUDE_DIRECTORIES ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES} PARENT_SCOPE)
