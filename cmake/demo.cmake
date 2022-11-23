# Internal
function(add_entrance ENTRY_PATH DEMO_PATH DEMO_OUTPUT_DIRECTORY TAICHI_AOT_DEMO_TARGET)
    add_executable(${TAICHI_AOT_DEMO_TARGET}
                   ${ENTRY_PATH}
                   ${DEMO_PATH}
    )

    set_target_properties(${TAICHI_AOT_DEMO_TARGET} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${DEMO_OUTPUT_DIRECTORY})
    target_link_libraries(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${RENDER_FRAMEWORK_TARGET})
    target_include_directories(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})

    # If you are building for Android, you need to link to system libraries.
    if (ANDROID)
        find_library(android android)
        find_library(log log)
        target_link_libraries(${TAICHI_AOT_DEMO_TARGET} PUBLIC android log)
    endif()
endfunction()


# Internal
function(add_headless_demo NAME DEMO_PATH TAICHI_AOT_DEMO_TARGET)
    set(ENTRY_PATH ${PROJECT_SOURCE_DIR}/framework/src/taichi/aot_demo/entry_points/headless.cpp)
    add_entrance(${ENTRY_PATH} ${DEMO_PATH} ${HEADLESS_DEMO_OUTPUT_DIRECTORY} ${TAICHI_AOT_DEMO_TARGET})
endfunction()


# Internal
function(add_glfw_demo NAME DEMO_PATH TAICHI_AOT_DEMO_TARGET)
    set(ENTRY_PATH ${PROJECT_SOURCE_DIR}/framework/src/taichi/aot_demo/entry_points/glfw.cpp)
    add_entrance(${ENTRY_PATH} ${DEMO_PATH} ${GLFW_DEMO_OUTPUT_DIRECTORY} ${TAICHI_AOT_DEMO_TARGET})
        
    target_link_libraries(${TAICHI_AOT_DEMO_TARGET} PUBLIC glfw)
    target_include_directories(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${Vulkan_INCLUDE_DIR}
        ${PROJECT_SOURCE_DIR}/external/glfw/include)
endfunction()


function(add_demo NAME DEMO_PATH)
    set(HEADLESS_AOT_DEMO_TARGET E${NAME}_headless)
    set(GLFW_AOT_DEMO_TARGET E${NAME}_glfw)
    
    add_headless_demo(${NAME} ${DEMO_PATH} ${HEADLESS_AOT_DEMO_TARGET})
    if(NOT ANDROID)
        add_glfw_demo(${NAME} ${DEMO_PATH} ${GLFW_AOT_DEMO_TARGET})
    endif()
endfunction()


function(generate_aot_files NAME PYTHON_SCRIPT_PATH ARCH)
    if(NOT TI_WITH_CUDA AND ARCH STREQUAL "cuda")
        return()
    endif()
    
    if(NOT TI_WITH_CPU AND ARCH STREQUAL "x64")
        return()
    endif()

    # Generate AOT files
    set(DUMMY_TARGET ${NAME}_${ARCH}_DYMMY_TARGET)
    add_custom_target(${DUMMY_TARGET} ALL)
    if(NOT PYTHON_SCRIPT_PATH STREQUAL "")
        add_custom_command(
            TARGET ${DUMMY_TARGET}
            COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_SCRIPT_PATH}
            ARGS --arch=${ARCH}
            VERBATIM)
    endif()
endfunction()
