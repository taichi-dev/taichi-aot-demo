set(TAICHI_TUTORIAL_DEMO_NAME "E0_tutorial_kernel")
message("-- Building ${TAICHI_TUTORIAL_DEMO_NAME}")

list(APPEND TAICHI_TUTORIAL_DEMO_SRC
  ${CMAKE_CURRENT_SOURCE_DIR}/app.cpp
)
if (NOT ANDROID)
  list(APPEND TAICHI_TUTORIAL_DEMO_SRC
    ${BACKWARD_ENABLE}
  )
endif()

add_executable(${TAICHI_TUTORIAL_DEMO_NAME} ${TAICHI_TUTORIAL_DEMO_SRC})
target_include_directories(${TAICHI_TUTORIAL_DEMO_NAME} PUBLIC ${TAICHI_C_API_INSTALL_DIR}/include)
target_link_libraries(${TAICHI_TUTORIAL_DEMO_NAME} ${taichi_c_api})
set_target_properties(${TAICHI_TUTORIAL_DEMO_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/tutorial)

if (ANDROID)
  target_link_libraries(${TAICHI_TUTORIAL_DEMO_NAME} android log)
endif()

if (NOT ANDROID)
  add_backward(${TAICHI_TUTORIAL_DEMO_NAME})
endif()
execute_process(COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/assets/tutorial.py" --arch vulkan --aot)
