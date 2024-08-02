#!/bin/bash
set -e

rm -rf build-android-aarch64
mkdir build-android-aarch64
pushd build-android-aarch64

C_API_DIR="${PWD}/../build-taichi-android-aarch64/install/c_api"

TAICHI_C_API_INSTALL_DIR=${C_API_DIR} cmake .. \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_PLATFORM=android-29 \
    -DANDROID_ABI="arm64-v8a" \
    -DTI_AOT_DEMO_ANDROID_APP=ON \
    -G "Ninja"
if [ $? -ne 0 ]; then
    echo "Configuration failed"
    exit -1
fi

cmake --build .
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit -1
fi
popd

# Check for libtaichi_c_api.so
target_file="${PWD}/framework/android/app/src/main/jniLibs/arm64-v8a/libtaichi_c_api.so"
source_file="${C_API_DIR}/lib/libtaichi_c_api.so"

if [ ! -f "$target_file" ]; then
    echo "File not found: $target_file"
    echo "Copying from $source_file to $target_file"

    cp "$source_file" "$target_file"
    chmod 775 "$target_file"

    echo "File copied and permissions set."
else
    echo "File already exists: $target_file"
fi
