cmake_minimum_required(VERSION 3.13)

project(taichi_sparse)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if("${TAICHI_REPO}" STREQUAL "")
    message(FATAL_ERROR "Set TAICHI_REPO with -DTAICHI_REPO=.. ")
endif()

if("${C_API_LIB_NAME}" STREQUAL "")
    message(FATAL_ERROR "Set C_API_LIB_NAME with -DC_API_LIB_NAME=.. ")
endif()

add_executable(taichi_sparse taichi_sparse.cpp)
target_compile_options(taichi_sparse PUBLIC -Wall -Wextra -DTI_WITH_CUDA -DTI_WITH_LLVM -DTI_INCLUDED)

target_include_directories(taichi_sparse
  PRIVATE
    ${PROJECT_SOURCE_DIR}
    ${TAICHI_REPO}/c_api/include
    ${TAICHI_REPO}/c_api/src
  )

target_link_directories(taichi_sparse
  PRIVATE
    ${PROJECT_SOURCE_DIR}
    ${TAICHI_REPO}/build
  )

target_link_libraries(taichi_sparse PUBLIC ${C_API_LIB_NAME})
