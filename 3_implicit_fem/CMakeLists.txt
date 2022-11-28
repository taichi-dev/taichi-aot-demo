add_demo(3_implicit_fem ${CMAKE_CURRENT_SOURCE_DIR}/app.cpp)
generate_aot_files(3_implicit_fem "assets/implicit_fem.py" "vulkan")
generate_aot_files(3_implicit_fem "assets/implicit_fem.py" "android-vulkan")
