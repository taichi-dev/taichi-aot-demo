#include <cstring>
#include <iostream>
#include <thread>
#include <vector>

#include "taichi/taichi_core.h"
#include "taichi/taichi_vulkan.h"

void allocate_ndarray(TiRuntime& runtime, std::vector<uint32_t> shape,
                      TiDataType data_type, TiMemory* mem,
                      TiArgumentValue* arg_value) {
  TiNdShape ti_shape;
  ti_shape.dim_count = shape.size();

  uint64_t data_num = 1;
  for (int i = 0; i < shape.size(); ++i) {
    data_num *= shape[i];
    ti_shape.dims[i] = shape[i];
  }

  TiMemoryAllocateInfo alloc_info;
  alloc_info.size = data_num * sizeof(uint8_t);
  alloc_info.host_write = true;
  alloc_info.host_read = true;
  alloc_info.export_sharing = false;
  alloc_info.usage = TiMemoryUsageFlagBits::TI_MEMORY_USAGE_STORAGE_BIT;

  *mem = ti_allocate_memory(runtime, &alloc_info);
  TiNdArray arg_array = {
      .memory = *mem, .shape = ti_shape, .elem_type = data_type};
  arg_value->ndarray = std::move(arg_array);
}

int main() {
  std::string folder_dir = "models/taichi_aot";
  std::string func_name = "taichi_add";

  std::vector<uint8_t> input_data(320 * 320 * 4, 1);
  std::vector<uint8_t> output_data(320 * 320 * 4, 1);
  int32_t addend = 3;

  // create runtime
  TiRuntime runtime = ti_create_runtime(TI_ARCH_VULKAN);

  // load aot and kernel
  TiAotModule aot_mod = ti_load_aot_module(runtime, folder_dir.c_str());
  TiComputeGraph g =
      ti_get_aot_module_compute_graph(aot_mod, func_name.c_str());

  // prepare arguments
  TiMemory in_ten_mem, out_ten_mem;
  TiArgumentValue in_ten, out_ten;
  VkDeviceMemory in_vkmemory, out_vkmemory;

  allocate_ndarray(runtime, {320, 320, 4}, TiDataType::TI_DATA_TYPE_U8,
                   &in_ten_mem, &in_ten);

  allocate_ndarray(runtime, {320, 320, 4}, TiDataType::TI_DATA_TYPE_U8,
                   &out_ten_mem, &out_ten);

  TiNamedArgument arg_0 = {
      .name = "in_ten",
      .argument = {.type = TiArgumentType::TI_ARGUMENT_TYPE_NDARRAY,
                   .value = std::move(in_ten)}};

  TiNamedArgument arg_1 = {
      .name = "out_ten",
      .argument = {.type = TiArgumentType::TI_ARGUMENT_TYPE_NDARRAY,
                   .value = std::move(out_ten)}};

  TiNamedArgument arg_2 = {
      .name = "addend",
      .argument = {.type = TiArgumentType::TI_ARGUMENT_TYPE_I32,
                   .value = {.i32 = addend}}};

  // set input data
  void* in_map = ti_map_memory(runtime, in_ten_mem);
  std::memcpy(in_map, input_data.data(), input_data.size() * sizeof(uint8_t));
  ti_unmap_memory(runtime, in_ten_mem);
  ti_wait(runtime);

  void* out_map = ti_map_memory(runtime, out_ten_mem);
  std::memcpy(out_map, output_data.data(),
              output_data.size() * sizeof(uint8_t));
  ti_unmap_memory(runtime, out_ten_mem);
  ti_wait(runtime);

  // run kernel
  constexpr uint32_t arg_count = 3;
  TiNamedArgument args[arg_count] = {std::move(arg_0), std::move(arg_1),
                                     std::move(arg_2)};
  ti_launch_compute_graph(runtime, g, arg_count, &args[0]);
  ti_wait(runtime);

  // check output data
  out_map = ti_map_memory(runtime, out_ten_mem);
  std::memcpy(output_data.data(), out_map,
              output_data.size() * sizeof(uint8_t));
  for (int i = 0; i < 16; ++i) {
    printf("i = %d val = %d\n", i, output_data[i]);
  }
  ti_unmap_memory(runtime, out_ten_mem);
  ti_wait(runtime);

  // release
  ti_free_memory(runtime, in_ten_mem);
  ti_free_memory(runtime, out_ten_mem);
  ti_destroy_aot_module(aot_mod);
  ti_destroy_runtime(runtime);
}
