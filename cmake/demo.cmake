# Internal
function(add_entrance ENTRY_PATH DEMO_PATH DEMO_OUTPUT_DIRECTORY TAICHI_AOT_DEMO_TARGET)
    add_executable(${TAICHI_AOT_DEMO_TARGET}
                   ${ENTRY_PATH}
                   ${DEMO_PATH}
    )

    set_target_properties(${TAICHI_AOT_DEMO_TARGET} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${DEMO_OUTPUT_DIRECTORY}
        RUNTIME_OUTPUT_DIRECTORY_DEBUG ${DEMO_OUTPUT_DIRECTORY}
        RUNTIME_OUTPUT_DIRECTORY_RELEASE ${DEMO_OUTPUT_DIRECTORY})
    target_link_libraries(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${RENDER_FRAMEWORK_TARGET})
    target_include_directories(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})

    # If you are building for Android, you need to link to system libraries.
    if (ANDROID)
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
        ${PROJECT_SOURCE_DIR}/external/glfw/include)
    target_compile_definitions(${TAICHI_AOT_DEMO_TARGET} PUBLIC TI_AOT_DEMO_WITH_GLFW=1)
endfunction()

#Internal
function(add_android_app_demo NAME DEMO_PATH TAICHI_AOT_DEMO_TARGET)
    # (penguinliong) Note that android app build have two steps:
    #   1. Build the entry point native library.
    #   2. Build the app and import the native library.
    # In CMake we only do the first step. See `build-android-apps` for the
    # second.
    set(ENTRY_PATH
        ${PROJECT_SOURCE_DIR}/framework/src/taichi/aot_demo/entry_points/android.cpp
        ${PROJECT_SOURCE_DIR}/framework/src/taichi/aot_demo/entry_points/android_impl.c)
    add_library(${TAICHI_AOT_DEMO_TARGET} SHARED ${ENTRY_PATH} ${DEMO_PATH})

    set_target_properties(${TAICHI_AOT_DEMO_TARGET} PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${ANDROID_APP_DEMO_OUTPUT_DIRECTORY})

    target_link_libraries(${TAICHI_AOT_DEMO_TARGET} PUBLIC android log ${RENDER_FRAMEWORK_TARGET})
    target_include_directories(${TAICHI_AOT_DEMO_TARGET} PUBLIC
        ${ANDROID_NDK}/sources/android/native_app_glue
        ${TaichiAotDemoFramework_INCLUDE_DIRECTORIES})
    target_compile_definitions(${TAICHI_AOT_DEMO_TARGET} PUBLIC TI_AOT_DEMO_WITH_ANDROID_APP=1)
endfunction()


function(add_demo NAME DEMO_PATH)
    set(HEADLESS_AOT_DEMO_TARGET E${NAME}_headless)
    set(GLFW_AOT_DEMO_TARGET E${NAME}_glfw)
    set(ANDROID_APP_AOT_DEMO_TARGET E${NAME}_android)

    add_headless_demo(${NAME} ${DEMO_PATH} ${HEADLESS_AOT_DEMO_TARGET})
    if(NOT ANDROID)
        add_glfw_demo(${NAME} ${DEMO_PATH} ${GLFW_AOT_DEMO_TARGET})
    endif()
    if (ANDROID)
        add_android_app_demo(${NAME} ${DEMO_PATH} ${ANDROID_APP_AOT_DEMO_TARGET})
    endif()
endfunction()


function(generate_aot_files NAME PYTHON_SCRIPT_PATH ARCH)
    if(NOT TI_WITH_CUDA AND ARCH STREQUAL "cuda")
        return()
    endif()

    if(NOT TI_WITH_CPU AND ARCH STREQUAL "x64")
        return()
    endif()

    if (NOT ANDROID AND ARCH MATCHES "android")
        return()
    endif()

    # Generate AOT files
    set(DUMMY_TARGET ${NAME}_${ARCH}_DUMMY_TARGET)
    add_custom_target(${DUMMY_TARGET} ALL)
    if(NOT PYTHON_SCRIPT_PATH STREQUAL "")
        add_custom_command(
            TARGET ${DUMMY_TARGET}
            COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_SCRIPT_PATH}
            ARGS --arch=${ARCH}
            VERBATIM)
    endif()

    # Copy binary assets to android asset directory.
    set(DUMMY_TARGET2 ${NAME}_${ARCH}_DUMMY_TARGET2)
    add_custom_target(${DUMMY_TARGET2} ALL)
    if(ANDROID)
        add_custom_command(
            TARGET ${DUMMY_TARGET2}
            DEPENDS ${DUMMY_TARGET}
            COMMAND ${CMAKE_COMMAND}
            ARGS -E copy_directory
                ${CMAKE_CURRENT_SOURCE_DIR}/assets
                ${PROJECT_SOURCE_DIR}/framework/android/app/src/main/assets/${NAME}/assets
            VERBATIM)
    endif()
endfunction()
