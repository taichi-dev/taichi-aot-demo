## How to compile

1. Compile Taichi(https://github.com/taichi-dev/taichi) with:

```shell
export TAICHI_CMAKE_ARGS="-DTI_BUILD_TESTS=ON -DTI_WITH_VULKAN=ON"
export TAICHI_CMAKE_ARGS="-DTI_WITH_CUDA=ON ${TAICHI_CMAKE_ARGS}"
export TAICHI_CMAKE_ARGS="-DTI_WITH_C_API=ON ${TAICHI_CMAKE_ARGS}"
export TAICHI_CMAKE_ARGS="-DTI_WITH_LLVM=ON ${TAICHI_CMAKE_ARGS}"
python3 setup.py develop --user
```
2. Set `${TAICHI_REPO}` and `${BACKEND_NAME}` for `linux_compile_and_run.sh`, for example:
```shell
BACKEND_NAME="cuda" # cuda, x64, vulkan
TAICHI_REPO="/home/taichigraphics/workspace/taichi"
```

3. Compile and run demo with:
```shell
sh linux_compile_and_run.sh
```
