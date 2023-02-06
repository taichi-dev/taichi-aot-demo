function(configure_environment)
    ################################
    # Configure Python Executable  #
    ################################
    if(NOT ${PYTHON_EXECUTABLE})
        find_package(PythonInterp REQUIRED)
        if(NOT ${PYTHONINTERP_FOUND})
            message(FATAL_ERROR "Unable to find python executable")
        endif()
        set(PYTHON_EXECUTABLE ${PYTHON_EXECUTABLE} PARENT_SCOPE)
    endif()

endfunction()

function(configure_third_party)
    add_subdirectory(external)

    # Compile for Backward-cpp
    if(NOT ANDROID)
        add_subdirectory("${CMAKE_SOURCE_DIR}/external/backward-cpp")
    endif()
endfunction()


function(install_shared_libraries DEMO_OUTPUT_DIRECTORY)
    ###############################################
    # Copy Taichi C-API dylib to output directory #
    ###############################################
    message("-- Taichi Runtime distributed libraries: ${Taichi_Runtime_REDIST_LIBRARY}")

    file(COPY ${Taichi_REDIST_LIBRARIES} DESTINATION ${DEMO_OUTPUT_DIRECTORY})

    if (ANDROID)
        file(COPY ${Taichi_REDIST_LIBRARIES} DESTINATION "${PROJECT_SOURCE_DIR}/framework/android/app/src/main/jniLibs/arm64-v8a/")
    endif()

    # MoltenVK dylib should be copied to the output directory.
    ###########################################
    # Copy MoltenVK dylib to output directory #
    ###########################################
    if (APPLE)
        find_library(MoltenVK libMoltenVK.dylib PATHS $HOMEBREW_CELLAR/molten-vk $VULKAN_SDK REQUIRED)
        add_custom_command(
            OUTPUT ${DEMO_OUTPUT_DIRECTORY}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND}
            ARGS -E copy ${MoltenVK} ${DEMO_OUTPUT_DIRECTORY}
            VERBATIM)
    endif()

endfunction()
