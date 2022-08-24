cmake_minimum_required(VERSION 3.13)

project(texture)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(texture texture.cpp)

target_compile_options(texture PUBLIC -Wall -Wextra -DTI_WITH_VULKAN -DTI_INCLUDED -DTI_ARCH_x64)

target_include_directories(texture PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include/)

find_package(taichi_export_core REQUIRED CONFIG)

target_link_libraries(texture PUBLIC taichi_export_core::taichi_export_core)
