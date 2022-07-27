TAICHI_REPO="/home/taichigraphics/workspace/taichi"
C_API_LIB_NAME="libtaichi_c_api.so"

AOT_DIRECTORY="aot_files"
RUNTIME_LIB="${TAICHI_REPO}/python/taichi/_lib/runtime"

rm -rf build && mkdir build && cd build
cmake .. -DC_API_LIB_NAME=${C_API_LIB_NAME} -DTAICHI_REPO=${TAICHI_REPO} && make -j && cd ..

python3 taichi_sparse.py --dir=${AOT_DIRECTORY} 

TI_LIB_DIR=${RUNTIME_LIB} ./build/taichi_sparse ${AOT_DIRECTORY}
