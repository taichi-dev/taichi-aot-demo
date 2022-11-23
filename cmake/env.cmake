function(configure_environment)
    #######################################
    # Configure TAICHI_C_API_INSTALL_DIR  #
    #######################################
    if (NOT EXISTS ${TAICHI_C_API_INSTALL_DIR})
        message(FATAL_ERROR "Environment variable TAICHI_C_API_INSTALL_DIR is not specified")
    endif()
    get_filename_component(TAICHI_C_API_INSTALL_DIR ${TAICHI_C_API_INSTALL_DIR} ABSOLUTE CACHE)
    message("-- TAICHI_C_API_INSTALL_DIR=" ${TAICHI_C_API_INSTALL_DIR})

    # Find built taichi C-API library in `TAICHI_C_API_INSTALL_DIR`.
    find_library(taichi_c_api taichi_c_api HINTS
        ${TAICHI_C_API_INSTALL_DIR}/lib
        # CMake find root is overriden by Android toolchain.
        NO_CMAKE_FIND_ROOT_PATH)
    if (NOT EXISTS ${taichi_c_api})
        message(FATAL_ERROR "Couldn't find C-API library; ensure your Taichi is built with `TI_WITH_CAPI=ON`")
    endif()
    
    ################################
    # Configure Compilation Flags  #
    ################################
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_VULKAN")
    if(TI_WITH_CPU)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_CPU")

        # find runtime.bc files
        add_definitions(-DTI_LIB_DIR="${TAICHI_C_API_INSTALL_DIR}/runtime")
    endif()

    if(TI_WITH_CUDA)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTI_WITH_CUDA -DTI_NO_CUDA_INCLUDES")
        
        # find runtime.bc files
        add_definitions(-DTI_LIB_DIR="${TAICHI_C_API_INSTALL_DIR}/runtime")
    endif()
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)

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
    find_package(Vulkan REQUIRED)
    
    add_subdirectory(external)
    
    # Compile for GraphiT
    add_library(GraphiT OBJECT
        "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/args.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include/gft/util.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/args.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/src/gft/util.cpp")
    target_include_directories(GraphiT PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/external/graphi-t/include")

    # Compile for Backward-cpp
    if(NOT ANDROID)
        add_subdirectory("${CMAKE_SOURCE_DIR}/external/backward-cpp")
    endif()
endfunction()


function(install_shared_libraries DEMO_OUTPUT_DIRECTORY DUMMY_TARGET)        
    ###############################################
    # Copy Taichi C-API dylib to output directory #
    ###############################################
    if (WIN32)
        file(GLOB taichi_c_api_SRC "${TAICHI_C_API_INSTALL_DIR}/bin/*")
    else()
        set(taichi_c_api_SRC ${taichi_c_api})
    endif()

    add_custom_command(
        OUTPUT ${DEMO_OUTPUT_DIRECTORY}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${taichi_c_api_SRC} ${DEMO_OUTPUT_DIRECTORY}
        VERBATIM)

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

    add_custom_target(${DUMMY_TARGET} ALL
        DEPENDS ${DEMO_OUTPUT_DIRECTORY}
    )

endfunction()
