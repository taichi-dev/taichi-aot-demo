if (NOT ANDROID)
    add_subdirectory(glfw)
endif()
add_subdirectory(graphi-t/third/VulkanMemoryAllocator VulkanMemoryAllocator)
add_subdirectory(graphi-t/third/glslang glslang)

set(BUILD_TESTING OFF)
set(BUILD_STATIC_LIBS ON)
add_subdirectory(graphi-t/third/glm glm)
