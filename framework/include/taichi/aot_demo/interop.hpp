#pragma once
#include "taichi/aot_demo/common.hpp"

namespace ti {
namespace aot_demo {
namespace interop {

void copy_memory_arch2arch(
  const ti::Runtime& dst_runtime,
  const ti::MemorySlice& dst,
  const ti::Runtime& src_runtime,
  const ti::MemorySlice& src);

void copy_memory2image_arch2arch(
  const ti::Runtime& dst_runtime,
  const ti::MemorySlice& dst,
  const ti::Runtime& src_runtime,
  const ti::ImageSlice& src);

} // namespace interop
} // naemspace aot_demo
} // namespace ti