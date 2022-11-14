add_demo(6_taichi_sparse ${CMAKE_CURRENT_SOURCE_DIR}/app.cpp)
generate_aot_files(6_taichi_sparse "assets/taichi_sparse.py" "cuda")
generate_aot_files(6_taichi_sparse "assets/taichi_sparse.py" "x64")
