if (NOT ANDROID)
    add_subdirectory(glfw)
endif()
add_subdirectory(VulkanMemoryAllocator)
add_subdirectory(glslang)

set(BUILD_TESTING OFF)
set(BUILD_STATIC_LIBS ON)
add_subdirectory(glm)
