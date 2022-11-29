# Taichi AOT Demo Framework

This documentation describes the fundamental logistics of the design and implementation of this AOT framework.

## Purpose

Taichi AOT demo programs used to scatter in this repository and served well for months. The demos were linked to Taichi's C++ device API and rendering were done in GGUI. Since, the developers suffered greatly from toolchain and linking issues, the C-API drafted later becomes a go-to solution for native AOT module deployment. The C-API helped but we can't port the existing demos to it because we still need something to render the graphics.

As a result, this framework intends to solve the following problems in our AOT development workflow:

- A minimal and **readable** renderer implementation to visualize results;
- Easy integration into our CI/CD pipeline;
- Keep only AOT module deployment code in demo source code.

## Overview

This section is about the logical and physical structure of the demo framework:

- `Framework` The class of the global variable `F`. It has everything necessary to run the demos.
- `Renderer` A minimal renderer to visualize demo results.
- `GraphicsRuntime` Derived class of `ti::Runtime`. Extended a little bit to support creating `GraphicsTasks` for rendering.
- `AssetManager` Base class of any I/O source. Demo implementations **must not** read from file with filesystem paths on its own.
- `App` Base class of any demo application implementation.

Here are some general guidelines for all kinds of roles to work with this demo project.

### For Demo Creators

To make a new demo you need to create a new directory for all the assets, C++ sources and build scripts. Structure the directory *strictly* like this:

```plaintext
📂 X_my_demo
|- CMakeLists.txt
|- app.cpp
+- 📂 [assets]
   |- [aot_module_generator.py]
   +- 📂 [aot_module]
      |- [metadata.tcb]
      +- ...
```

In `CMakeLists.txt`, create your executable with a name exactly the same as your directroy name.


Then, in `app.cpp`, implement a class derived from `App`. overrdide the member functions as their semantics as described below:

|Member Function|Description|
|-|-|
|`cfg`|Report any necessary information about the demo application.|
|`initialize`|Load `ti::AotModule`s and extract `ti::ComputeGraph`s and `ti::Kernels`. Allocate any `ti::NDArray` and `ti::Texture` or other resources you would use in the application's lifetime. Create `GraphicsTask`s you need to visualize the results.|
|`update`|Run `ti::ComputeGraph`s and `ti::Kernel`s to update the internal states.|
|`render`|Enqueue your `GraphicsTask`s to render.|

**NOTE** Make every application state a member variable, rather than leaving them as `static`s. Otherwise you could encounter scary lifetime issues.

### To CI/CD Engineers

The have several entry points statically linked to the demo implementations, constructing a permutation matrix of executables. For example, `headless` x `1_hello_world` gives birth to `E1_hello_world_headless`.

Currently the framework supports the following entry points:

|Entry Point|Description|
|-|-|
|`headless`|Standalone headless runners that saves frame outputs to `.bmp` files. Consult how to use the binary executables like this: `E1_hello_world_headless --help`.|
|`glfw`|GLFW windowed runners for visualized outputs.|
|`android`|Android native apps for deployment verification. For more information please consult the *Build Android Native Apps* section.|

Among these, `headless` binaries can help a lot with CI/CD integration.

## Build Android Apps

The Android AOT native Apps are to demonstrate Taichi's cross-compilation and mobile platform deployment features. The installation procedures have been automated with the following scripts:

|Script File|Description|
|-|-|
|`scripts/build-taichi-android.sh`|Build Taichi Runtime C-API library for `arm64-v8a` which is pretty common for Android devices.|
|`scripts/build-android.sh`|Build demo native app libraries to `framework/android/app/src/main/jniLibs/arm64-v8a`.|
|`scripts/build-android-app.sh [demo]`|Bundle Android native apps. Limited by the Android build system, you can only build one App at a time. `demo` is the name of the demo to be built, e.g., `E1_hello_world`. You can find the built APK package in `framework/android/app/build/outputs/apk/release`.|

