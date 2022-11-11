add_demo(7_comet ${CMAKE_CURRENT_SOURCE_DIR}/app.cpp)
generate_aot_files(7_comet "assets/comet.py" "cuda")
generate_aot_files(7_comet "assets/comet.py" "x64")
