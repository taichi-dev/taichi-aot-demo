TAICHI_REPO="/home/ailzhang/github/taichi" # example: /home/taichigraphics/workspace/taichi

rm -rf build && mkdir build && cd build
cmake .. -DTAICHI_REPO=${TAICHI_REPO} && make -j && cd ..

python3 test.py

echo "./build/test"
./build/test
