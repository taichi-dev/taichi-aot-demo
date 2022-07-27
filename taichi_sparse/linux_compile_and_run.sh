TAICHI_REPO="/home/taichigraphics/workspace/taichi"

AOT_DIRECTORY="/tmp/aot_files"
RUNTIME_LIB="${TAICHI_REPO}/python/taichi/_lib/runtime"

rm -rf build && mkdir build && cd build
cmake .. -DTAICHI_REPO=${TAICHI_REPO} && make -j && cd ..

python3 taichi_sparse.py --dir=${AOT_DIRECTORY} 

echo "TI_LIB_DIR=${RUNTIME_LIB} ./build/taichi_sparse ${AOT_DIRECTORY}"
TI_LIB_DIR=${RUNTIME_LIB} ./build/taichi_sparse ${AOT_DIRECTORY}
