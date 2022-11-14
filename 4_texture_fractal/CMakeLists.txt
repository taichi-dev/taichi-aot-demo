add_demo(4_texture_fractal ${CMAKE_CURRENT_SOURCE_DIR}/app.cpp)
generate_aot_files(4_texture_fractal "assets/fractal.py" "vulkan")
