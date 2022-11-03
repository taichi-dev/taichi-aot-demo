; ModuleID = '/home/taichigraphics/.cache/taichi/ticache/llvm/T88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9.ll'
source_filename = "kernel"
target triple = "nvptx64-nvidia-cuda"

%0 = type { [64 x i64], [64 x i8*] }
%1 = type { [16 x i64], [16 x i8*] }
%2 = type { i8 }
%struct.RuntimeContext.0 = type { %struct.LLVMRuntime.1*, [64 x i64], [32 x [8 x i32]], i32, [64 x i64], [64 x i8], i64* }
%struct.LLVMRuntime.1 = type { i8, i64, i8*, i8*, i8* (i8*, i64, i64)*, void (i8*)*, void (i8*, ...)*, i32 (i8*, i64, i8*, %struct.__va_list_tag.2*)*, i8*, [512 x i8*], [512 x i64], i8*, void (i8*, i32, i32, i8*, void (i8*, i32, i32)*)*, [1024 x %struct.ListManager.3*], [1024 x %struct.NodeManager.4*], %struct.NodeManager.4*, [1024 x i8*], i8*, %struct.RandState.5*, %struct.MemRequestQueue.7*, i8*, void (i8*, i8*)*, void (i8*)*, [2048 x i8], [32 x i64], i32, i64, i8*, i32, i32, i64, i8* }
%struct.__va_list_tag.2 = type { i32, i32, i8*, i8* }
%struct.ListManager.3 = type { [131072 x i8*], i64, i64, i32, i32, i32, %struct.LLVMRuntime.1* }
%struct.NodeManager.4 = type <{ %struct.LLVMRuntime.1*, i32, i32, i32, i32, %struct.ListManager.3*, %struct.ListManager.3*, %struct.ListManager.3*, i32, [4 x i8] }>
%struct.RandState.5 = type { i32, i32, i32, i32, i32 }
%struct.MemRequestQueue.7 = type { [65536 x %struct.MemRequest.8], i32, i32 }
%struct.MemRequest.8 = type { i64, i64, i8*, i64 }
%struct.PointerMeta.15 = type <{ %struct.StructMeta.9, i8, [7 x i8] }>
%struct.StructMeta.9 = type { i32, i64, i64, i8* (i8*, i8*, i32)*, i8* (i8*)*, i32 (i8*, i8*, i32)*, i32 (i8*, i8*)*, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, %struct.RuntimeContext.0* }
%struct.PhysicalCoordinates.0 = type { [8 x i32] }
%struct.RootMeta.16 = type <{ %struct.StructMeta.9, i32, [4 x i8] }>
%struct.Element.82 = type { i8*, [2 x i32], %struct.PhysicalCoordinates.0 }
%S0_ch.10 = type { [1048576 x %S1_ch.11], %0 }
%S1_ch.11 = type { float }
%S3_ch.12 = type { %1 }
%class.anon.7.13 = type { %struct.ListManager.3*, i32* }
%class.anon.50.14 = type { %2*, i8**, %class.anon.7.13* }
%class.anon.0.15 = type { i64*, %struct.LLVMRuntime.1*, i64*, i8**, i8* }
%class.anon.19.16 = type { %2*, i8**, %class.anon.0.15* }
%class.anon.17 = type { %struct.LLVMRuntime.1**, i8**, i32*, i64** }
%class.anon.14.18 = type { %2*, i8**, %class.anon.17* }
%class.anon.6.19 = type { i8**, i8** }
%class.anon.45.20 = type { %2*, i8**, %class.anon.6.19* }

@_ZL31taichi_listgen_max_element_size = internal constant i32 1024, align 4
@.str.6 = private unnamed_addr constant [28 x i8] c"List manager out of chunks.\00", align 1
@.str.4 = private unnamed_addr constant [37 x i8] c"Too many memory allocation requests.\00", align 1
@.str = private unnamed_addr constant [144 x i8] c"Out of CUDA pre-allocated memory.\0AConsider using ti.init(device_memory_fraction=0.9) or ti.init(device_memory_GB=4) to allocate more GPU memory\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"Taichi JIT\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"allocate_from_buffer\00", align 1
@.str.3 = private unnamed_addr constant [28 x i8] c"Out of pre-allocated memory\00", align 1
@.str.31 = private unnamed_addr constant [15 x i8] c"ptr not found.\00", align 1

define void @block1_deactivate_all_c80_0_kernel_23_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_686(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_0_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1687(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_root(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_21_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_672(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_22_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1730(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_nonroot(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_1_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_626(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S5_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_2_listgen_S5pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1683(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S5_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_nonroot(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_3_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_5(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @parallel_struct_for_1(%struct.RuntimeContext.0* %context, i32 5, i32 16, i32 1, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)* @function_body, i64 1, i32 1)
  br label %final
}

define internal void @function_body(%struct.RuntimeContext.0* %0, i8* %1, %struct.Element.82* %2, i32 %3, i32 %4) {
allocs:
  %5 = alloca i32
  %6 = alloca %struct.PhysicalCoordinates.0
  %7 = alloca %struct.PhysicalCoordinates.0
  %8 = alloca %struct.PointerMeta.15
  %9 = alloca %struct.PointerMeta.15
  %10 = alloca %struct.PointerMeta.15
  %11 = alloca %struct.PointerMeta.15
  br label %entry

final:                                            ; preds = %func_exit
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  %12 = call %struct.PhysicalCoordinates.0* @Element_get_ptr_pcoord(%struct.Element.82* %2)
  %13 = bitcast %struct.PhysicalCoordinates.0* %12 to %struct.PhysicalCoordinates.0*
  call void @S5_refine_coordinates(%struct.PhysicalCoordinates.0* %13, %struct.PhysicalCoordinates.0* %6, i32 0)
  %14 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %15 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  %16 = add i32 %14, %3
  store i32 %16, i32* %5
  br label %loop_test

loop_test:                                        ; preds = %loop_body_tail, %function_body
  %17 = load i32, i32* %5
  %18 = icmp slt i32 %17, %4
  br i1 %18, label %loop_body, label %func_exit

loop_body:                                        ; preds = %loop_test
  %19 = load i32, i32* %5
  %20 = bitcast %struct.PhysicalCoordinates.0* %12 to %struct.PhysicalCoordinates.0*
  call void @S5_refine_coordinates(%struct.PhysicalCoordinates.0* %20, %struct.PhysicalCoordinates.0* %7, i32 %19)
  %21 = call i8* @Element_get_element(%struct.Element.82* %2)
  %22 = load i32, i32* %5
  %23 = bitcast %struct.PointerMeta.15* %8 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %23, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %23, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %23, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %23, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %23, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %23, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %23, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %23, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %23, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S5_refine_coordinates)
  %24 = bitcast %struct.PointerMeta.15* %8 to i8*
  %25 = call i32 @Pointer_is_active(i8* %24, i8* %21, i32 %22)
  %26 = trunc i32 %25 to i1
  %27 = and i1 true, %26
  br i1 %27, label %struct_for_body_body, label %loop_body_tail

loop_body_tail:                                   ; preds = %struct_for_body_body, %loop_body
  %28 = load i32, i32* %5
  %29 = add i32 %28, %15
  store i32 %29, i32* %5
  br label %loop_test

func_exit:                                        ; preds = %loop_test
  br label %final

struct_for_body_body:                             ; preds = %loop_body
  %30 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 0
  %31 = load i32, i32* %30
  %32 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 1
  %33 = load i32, i32* %32
  %34 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %0)
  %35 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.1* %34, i32 0)
  %36 = bitcast i8* %35 to %S0_ch.10*
  %37 = getelementptr %S0_ch.10, %S0_ch.10* %36, i32 0
  %38 = bitcast %S0_ch.10* %37 to i8*
  %39 = call i8* @get_ch_S0_to_S3(i8* %38)
  %40 = bitcast i8* %39 to %0*
  %41 = lshr i32 %31, 4
  %42 = and i32 %41, 7
  %43 = lshr i32 %33, 4
  %44 = and i32 %43, 7
  %45 = shl i32 %42, 3
  %46 = add i32 %44, %45
  %47 = bitcast %struct.PointerMeta.15* %9 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %47, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %47, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %47, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %47, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %47, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %47, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %47, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %47, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %47, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %48 = bitcast %struct.PointerMeta.15* %9 to i8*
  %49 = bitcast %0* %40 to i8*
  %50 = call i8* @Pointer_lookup_element(i8* %48, i8* %49, i32 %46)
  %51 = call i8* @get_ch_S3_to_S4(i8* %50)
  %52 = bitcast i8* %51 to %1*
  %53 = lshr i32 %31, 2
  %54 = and i32 %53, 3
  %55 = lshr i32 %33, 2
  %56 = and i32 %55, 3
  %57 = shl i32 %54, 2
  %58 = add i32 %56, %57
  %59 = bitcast %struct.PointerMeta.15* %10 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %59, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %59, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %59, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %59, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %59, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %59, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %59, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %59, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %59, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %60 = bitcast %struct.PointerMeta.15* %10 to i8*
  %61 = bitcast %1* %52 to i8*
  %62 = call i8* @Pointer_lookup_element(i8* %60, i8* %61, i32 %58)
  %63 = call i8* @get_ch_S4_to_S5(i8* %62)
  %64 = bitcast i8* %63 to %1*
  %65 = lshr i32 %31, 0
  %66 = and i32 %65, 3
  %67 = lshr i32 %33, 0
  %68 = and i32 %67, 3
  %69 = shl i32 %66, 2
  %70 = add i32 %68, %69
  %71 = bitcast %struct.PointerMeta.15* %11 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %71, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %71, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %71, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %71, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %71, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %71, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %71, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %71, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %71, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S5_refine_coordinates)
  %72 = bitcast %struct.PointerMeta.15* %11 to i8*
  %73 = bitcast %1* %64 to i8*
  call void @Pointer_deactivate(i8* %72, i8* %73, i32 %70)
  br label %loop_body_tail
}

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #0

define void @block1_deactivate_all_c80_0_kernel_4_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_432(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_0(%struct.RuntimeContext.0* %context, i32 5)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_5_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1596(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_1(%struct.RuntimeContext.0* %0, i32 5)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_6_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_238(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_2(%struct.RuntimeContext.0* %0, i32 5)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_7_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_636(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_8_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1695(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_root(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_9_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_634(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_10_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1733(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.PointerMeta.15
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %4, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %5 = bitcast %struct.PointerMeta.15* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_nonroot(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_11_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_118(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @parallel_struct_for_1(%struct.RuntimeContext.0* %context, i32 4, i32 16, i32 1, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)* @function_body.1, i64 1, i32 1)
  br label %final
}

define internal void @function_body.1(%struct.RuntimeContext.0* %0, i8* %1, %struct.Element.82* %2, i32 %3, i32 %4) {
allocs:
  %5 = alloca i32
  %6 = alloca %struct.PhysicalCoordinates.0
  %7 = alloca %struct.PhysicalCoordinates.0
  %8 = alloca %struct.PointerMeta.15
  %9 = alloca %struct.PointerMeta.15
  %10 = alloca %struct.PointerMeta.15
  br label %entry

final:                                            ; preds = %func_exit
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  %11 = call %struct.PhysicalCoordinates.0* @Element_get_ptr_pcoord(%struct.Element.82* %2)
  %12 = bitcast %struct.PhysicalCoordinates.0* %11 to %struct.PhysicalCoordinates.0*
  call void @S4_refine_coordinates(%struct.PhysicalCoordinates.0* %12, %struct.PhysicalCoordinates.0* %6, i32 0)
  %13 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %14 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  %15 = add i32 %13, %3
  store i32 %15, i32* %5
  br label %loop_test

loop_test:                                        ; preds = %loop_body_tail, %function_body
  %16 = load i32, i32* %5
  %17 = icmp slt i32 %16, %4
  br i1 %17, label %loop_body, label %func_exit

loop_body:                                        ; preds = %loop_test
  %18 = load i32, i32* %5
  %19 = bitcast %struct.PhysicalCoordinates.0* %11 to %struct.PhysicalCoordinates.0*
  call void @S4_refine_coordinates(%struct.PhysicalCoordinates.0* %19, %struct.PhysicalCoordinates.0* %7, i32 %18)
  %20 = call i8* @Element_get_element(%struct.Element.82* %2)
  %21 = load i32, i32* %5
  %22 = bitcast %struct.PointerMeta.15* %8 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %22, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %22, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %22, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %22, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %22, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %22, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %22, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %22, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %22, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %23 = bitcast %struct.PointerMeta.15* %8 to i8*
  %24 = call i32 @Pointer_is_active(i8* %23, i8* %20, i32 %21)
  %25 = trunc i32 %24 to i1
  %26 = and i1 true, %25
  br i1 %26, label %struct_for_body_body, label %loop_body_tail

loop_body_tail:                                   ; preds = %struct_for_body_body, %loop_body
  %27 = load i32, i32* %5
  %28 = add i32 %27, %14
  store i32 %28, i32* %5
  br label %loop_test

func_exit:                                        ; preds = %loop_test
  br label %final

struct_for_body_body:                             ; preds = %loop_body
  %29 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 0
  %30 = load i32, i32* %29
  %31 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 1
  %32 = load i32, i32* %31
  %33 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %0)
  %34 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.1* %33, i32 0)
  %35 = bitcast i8* %34 to %S0_ch.10*
  %36 = getelementptr %S0_ch.10, %S0_ch.10* %35, i32 0
  %37 = bitcast %S0_ch.10* %36 to i8*
  %38 = call i8* @get_ch_S0_to_S3(i8* %37)
  %39 = bitcast i8* %38 to %0*
  %40 = lshr i32 %30, 2
  %41 = and i32 %40, 7
  %42 = lshr i32 %32, 2
  %43 = and i32 %42, 7
  %44 = shl i32 %41, 3
  %45 = add i32 %43, %44
  %46 = bitcast %struct.PointerMeta.15* %9 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %46, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %46, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %46, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %46, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %46, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %46, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %46, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %46, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %46, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %47 = bitcast %struct.PointerMeta.15* %9 to i8*
  %48 = bitcast %0* %39 to i8*
  %49 = call i8* @Pointer_lookup_element(i8* %47, i8* %48, i32 %45)
  %50 = call i8* @get_ch_S3_to_S4(i8* %49)
  %51 = bitcast i8* %50 to %1*
  %52 = lshr i32 %30, 0
  %53 = and i32 %52, 3
  %54 = lshr i32 %32, 0
  %55 = and i32 %54, 3
  %56 = shl i32 %53, 2
  %57 = add i32 %55, %56
  %58 = bitcast %struct.PointerMeta.15* %10 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %58, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %58, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %58, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.9* %58, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %58, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %58, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %58, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %58, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %58, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S4_refine_coordinates)
  %59 = bitcast %struct.PointerMeta.15* %10 to i8*
  %60 = bitcast %1* %51 to i8*
  call void @Pointer_deactivate(i8* %59, i8* %60, i32 %57)
  br label %loop_body_tail
}

define void @block1_deactivate_all_c80_0_kernel_12_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_481(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_0(%struct.RuntimeContext.0* %context, i32 4)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_13_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1645(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_1(%struct.RuntimeContext.0* %0, i32 4)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_14_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_223(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_2(%struct.RuntimeContext.0* %0, i32 4)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_15_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_685(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @clear_list(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_16_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1728(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  %0 = alloca %struct.PointerMeta.15
  %1 = alloca %struct.RootMeta.16
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  %2 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %2, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %2, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %2, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %2, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %2, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %2, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %2, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %2, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %2, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %3 = bitcast %struct.PointerMeta.15* %0 to %struct.StructMeta.9*
  %4 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %4, i32 0)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %4, i64 4195328)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %4, i64 1)
  call void @StructMeta_set_context(%struct.StructMeta.9* %4, %struct.RuntimeContext.0* %context)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %4, i8* (i8*, i8*, i32)* @Root_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %4, i32 (i8*, i8*, i32)* @Root_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %4, i32 (i8*, i8*)* @Root_get_num_elements)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %4, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S0_refine_coordinates)
  %5 = bitcast %struct.RootMeta.16* %1 to %struct.StructMeta.9*
  %6 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %context)
  call void @element_listgen_root(%struct.LLVMRuntime.1* %6, %struct.StructMeta.9* %5, %struct.StructMeta.9* %3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_17_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_112(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @parallel_struct_for_1(%struct.RuntimeContext.0* %context, i32 3, i32 64, i32 1, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)* @function_body.2, i64 1, i32 1)
  br label %final
}

define internal void @function_body.2(%struct.RuntimeContext.0* %0, i8* %1, %struct.Element.82* %2, i32 %3, i32 %4) {
allocs:
  %5 = alloca i32
  %6 = alloca %struct.PhysicalCoordinates.0
  %7 = alloca %struct.PhysicalCoordinates.0
  %8 = alloca %struct.PointerMeta.15
  %9 = alloca %struct.PointerMeta.15
  br label %entry

final:                                            ; preds = %func_exit
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  %10 = call %struct.PhysicalCoordinates.0* @Element_get_ptr_pcoord(%struct.Element.82* %2)
  %11 = bitcast %struct.PhysicalCoordinates.0* %10 to %struct.PhysicalCoordinates.0*
  call void @S3_refine_coordinates(%struct.PhysicalCoordinates.0* %11, %struct.PhysicalCoordinates.0* %6, i32 0)
  %12 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %13 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  %14 = add i32 %12, %3
  store i32 %14, i32* %5
  br label %loop_test

loop_test:                                        ; preds = %loop_body_tail, %function_body
  %15 = load i32, i32* %5
  %16 = icmp slt i32 %15, %4
  br i1 %16, label %loop_body, label %func_exit

loop_body:                                        ; preds = %loop_test
  %17 = load i32, i32* %5
  %18 = bitcast %struct.PhysicalCoordinates.0* %10 to %struct.PhysicalCoordinates.0*
  call void @S3_refine_coordinates(%struct.PhysicalCoordinates.0* %18, %struct.PhysicalCoordinates.0* %7, i32 %17)
  %19 = call i8* @Element_get_element(%struct.Element.82* %2)
  %20 = load i32, i32* %5
  %21 = bitcast %struct.PointerMeta.15* %8 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %21, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %21, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %21, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %21, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %21, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %21, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %21, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %21, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %21, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %22 = bitcast %struct.PointerMeta.15* %8 to i8*
  %23 = call i32 @Pointer_is_active(i8* %22, i8* %19, i32 %20)
  %24 = trunc i32 %23 to i1
  %25 = and i1 true, %24
  br i1 %25, label %struct_for_body_body, label %loop_body_tail

loop_body_tail:                                   ; preds = %struct_for_body_body, %loop_body
  %26 = load i32, i32* %5
  %27 = add i32 %26, %13
  store i32 %27, i32* %5
  br label %loop_test

func_exit:                                        ; preds = %loop_test
  br label %final

struct_for_body_body:                             ; preds = %loop_body
  %28 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 0
  %29 = load i32, i32* %28
  %30 = getelementptr %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %7, i32 0, i32 0, i32 1
  %31 = load i32, i32* %30
  %32 = call %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %0)
  %33 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.1* %32, i32 0)
  %34 = bitcast i8* %33 to %S0_ch.10*
  %35 = getelementptr %S0_ch.10, %S0_ch.10* %34, i32 0
  %36 = bitcast %S0_ch.10* %35 to i8*
  %37 = call i8* @get_ch_S0_to_S3(i8* %36)
  %38 = bitcast i8* %37 to %0*
  %39 = shl i32 %29, 3
  %40 = add i32 %31, %39
  %41 = bitcast %struct.PointerMeta.15* %9 to %struct.StructMeta.9*
  call void @StructMeta_set_snode_id(%struct.StructMeta.9* %41, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.9* %41, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %41, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.9* %41, %struct.RuntimeContext.0* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.9* %41, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.9* %41, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %41, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %41, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %41, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* @S3_refine_coordinates)
  %42 = bitcast %struct.PointerMeta.15* %9 to i8*
  %43 = bitcast %0* %38 to i8*
  call void @Pointer_deactivate(i8* %42, i8* %43, i32 %40)
  br label %loop_body_tail
}

define void @block1_deactivate_all_c80_0_kernel_18_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_491(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_0(%struct.RuntimeContext.0* %context, i32 3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_19_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1655(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_1(%struct.RuntimeContext.0* %0, i32 3)
  br label %final
}

define void @block1_deactivate_all_c80_0_kernel_20_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_210(%struct.RuntimeContext.0* byval(%struct.RuntimeContext.0) %0) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gc_parallel_2(%struct.RuntimeContext.0* %0, i32 3)
  br label %final
}

define internal void @S0_refine_coordinates(%struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0* %1, i32 %2) {
entry:
  %3 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 0)
  %4 = shl i32 %3, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 0, i32 %4)
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 1)
  %6 = shl i32 %5, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 1, i32 %6)
  %7 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 2)
  %8 = shl i32 %7, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 2, i32 %8)
  %9 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 3)
  %10 = shl i32 %9, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 3, i32 %10)
  %11 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 4)
  %12 = shl i32 %11, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 4, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 5)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 5, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 6)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 6, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 7)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 7, i32 %18)
  ret void
}

define internal void @S3_refine_coordinates(%struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 3
  %4 = and i32 %3, 7
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 0)
  %6 = shl i32 %5, 3
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 7
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 1)
  %11 = shl i32 %10, 3
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S3(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.10*
  %getch = getelementptr %S0_ch.10, %S0_ch.10* %1, i32 0, i32 1
  %2 = bitcast %0* %getch to i8*
  ret i8* %2
}

define internal void @S4_refine_coordinates(%struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S3_to_S4(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S3_ch.12*
  %getch = getelementptr %S3_ch.12, %S3_ch.12* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

define internal void @S5_refine_coordinates(%struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S4_to_S5(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S3_ch.12*
  %getch = getelementptr %S3_ch.12, %S3_ch.12* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0* %0, i32 %1) #1 {
  %3 = alloca %struct.PhysicalCoordinates.0*, align 8
  %4 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0** %3, align 8
  %6 = getelementptr inbounds %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [8 x i32], [8 x i32]* %6, i64 0, i64 %8
  %10 = load i32, i32* %9, align 4
  ret i32 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0* %0, i32 %1, i32 %2) #1 {
  %4 = alloca %struct.PhysicalCoordinates.0*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0* %0, %struct.PhysicalCoordinates.0** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = load %struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0** %4, align 8
  %9 = getelementptr inbounds %struct.PhysicalCoordinates.0, %struct.PhysicalCoordinates.0* %8, i32 0, i32 0
  %10 = load i32, i32* %5, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [8 x i32], [8 x i32]* %9, i64 0, i64 %11
  store i32 %7, i32* %12, align 4
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.LLVMRuntime.1* @RuntimeContext_get_runtime(%struct.RuntimeContext.0* %0) #1 {
  %2 = alloca %struct.RuntimeContext.0*, align 8
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %2, align 8
  %3 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %2, align 8
  %4 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %3, i32 0, i32 0
  %5 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  ret %struct.LLVMRuntime.1* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_snode_id(%struct.StructMeta.9* %0, i32 %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i32, align 4
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 0
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_element_size(%struct.StructMeta.9* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 1
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_max_num_elements(%struct.StructMeta.9* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 2
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_get_num_elements(%struct.StructMeta.9* %0, i32 (i8*, i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i32 (i8*, i8*)*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i32 (i8*, i8*)* %1, i32 (i8*, i8*)** %4, align 8
  %5 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 6
  store i32 (i8*, i8*)* %5, i32 (i8*, i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_lookup_element(%struct.StructMeta.9* %0, i8* (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i8* (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i8* (i8*, i8*, i32)* %1, i8* (i8*, i8*, i32)** %4, align 8
  %5 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 3
  store i8* (i8*, i8*, i32)* %5, i8* (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_from_parent_element(%struct.StructMeta.9* %0, i8* (i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i8* (i8*)*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  %5 = load i8* (i8*)*, i8* (i8*)** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 4
  store i8* (i8*)* %5, i8* (i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_refine_coordinates(%struct.StructMeta.9* %0, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* %1, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %4, align 8
  %5 = load void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 7
  store void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* %5, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_is_active(%struct.StructMeta.9* %0, i32 (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca i32 (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store i32 (i8*, i8*, i32)* %1, i32 (i8*, i8*, i32)** %4, align 8
  %5 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 5
  store i32 (i8*, i8*, i32)* %5, i32 (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_context(%struct.StructMeta.9* %0, %struct.RuntimeContext.0* %1) #1 {
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca %struct.RuntimeContext.0*, align 8
  store %struct.StructMeta.9* %0, %struct.StructMeta.9** %3, align 8
  store %struct.RuntimeContext.0* %1, %struct.RuntimeContext.0** %4, align 8
  %5 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %4, align 8
  %6 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 8
  store %struct.RuntimeContext.0* %5, %struct.RuntimeContext.0** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @Element_get_element(%struct.Element.82* %0) #1 {
  %2 = alloca %struct.Element.82*, align 8
  store %struct.Element.82* %0, %struct.Element.82** %2, align 8
  %3 = load %struct.Element.82*, %struct.Element.82** %2, align 8
  %4 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %3, i32 0, i32 0
  %5 = load i8*, i8** %4, align 8
  ret i8* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.PhysicalCoordinates.0* @Element_get_ptr_pcoord(%struct.Element.82* %0) #1 {
  %2 = alloca %struct.Element.82*, align 8
  store %struct.Element.82* %0, %struct.Element.82** %2, align 8
  %3 = load %struct.Element.82*, %struct.Element.82** %2, align 8
  %4 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %3, i32 0, i32 2
  ret %struct.PhysicalCoordinates.0* %4
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.1* %0, i32 %1) #1 {
  %3 = alloca %struct.LLVMRuntime.1*, align 8
  %4 = alloca i32, align 4
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %3, align 8
  %6 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %5, i32 0, i32 9
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [512 x i8*], [512 x i8*]* %6, i64 0, i64 %8
  %10 = load i8*, i8** %9, align 8
  ret i8* %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @clear_list(%struct.LLVMRuntime.1* %0, %struct.StructMeta.9* %1, %struct.StructMeta.9* %2) #1 {
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca %struct.StructMeta.9*, align 8
  %6 = alloca %struct.StructMeta.9*, align 8
  %7 = alloca %struct.ListManager.3*, align 8
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %4, align 8
  store %struct.StructMeta.9* %1, %struct.StructMeta.9** %5, align 8
  store %struct.StructMeta.9* %2, %struct.StructMeta.9** %6, align 8
  %8 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %9 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %8, i32 0, i32 13
  %10 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %11 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %10, i32 0, i32 0
  %12 = load i32, i32* %11, align 8
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %9, i64 0, i64 %13
  %15 = load %struct.ListManager.3*, %struct.ListManager.3** %14, align 8
  store %struct.ListManager.3* %15, %struct.ListManager.3** %7, align 8
  %16 = load %struct.ListManager.3*, %struct.ListManager.3** %7, align 8
  call void @_ZN11ListManager5clearEv(%struct.ListManager.3* %16)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11ListManager5clearEv(%struct.ListManager.3* %0) #1 align 2 {
  %2 = alloca %struct.ListManager.3*, align 8
  store %struct.ListManager.3* %0, %struct.ListManager.3** %2, align 8
  %3 = load %struct.ListManager.3*, %struct.ListManager.3** %2, align 8
  %4 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %3, i32 0, i32 5
  store i32 0, i32* %4, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @element_listgen_root(%struct.LLVMRuntime.1* %0, %struct.StructMeta.9* %1, %struct.StructMeta.9* %2) #1 {
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca %struct.StructMeta.9*, align 8
  %6 = alloca %struct.StructMeta.9*, align 8
  %7 = alloca %struct.ListManager.3*, align 8
  %8 = alloca %struct.ListManager.3*, align 8
  %9 = alloca i8* (i8*, i8*, i32)*, align 8
  %10 = alloca i32 (i8*, i8*)*, align 8
  %11 = alloca i8* (i8*)*, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca %struct.Element.82, align 8
  %15 = alloca i8*, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca %struct.Element.82, align 8
  %20 = alloca i32, align 4
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %4, align 8
  store %struct.StructMeta.9* %1, %struct.StructMeta.9** %5, align 8
  store %struct.StructMeta.9* %2, %struct.StructMeta.9** %6, align 8
  %21 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %22 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %21, i32 0, i32 13
  %23 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %24 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %23, i32 0, i32 0
  %25 = load i32, i32* %24, align 8
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %22, i64 0, i64 %26
  %28 = load %struct.ListManager.3*, %struct.ListManager.3** %27, align 8
  store %struct.ListManager.3* %28, %struct.ListManager.3** %7, align 8
  %29 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %30 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %29, i32 0, i32 13
  %31 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %32 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %31, i32 0, i32 0
  %33 = load i32, i32* %32, align 8
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %30, i64 0, i64 %34
  %36 = load %struct.ListManager.3*, %struct.ListManager.3** %35, align 8
  store %struct.ListManager.3* %36, %struct.ListManager.3** %8, align 8
  %37 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %38 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %37, i32 0, i32 3
  %39 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %38, align 8
  store i8* (i8*, i8*, i32)* %39, i8* (i8*, i8*, i32)** %9, align 8
  %40 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %41 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %40, i32 0, i32 6
  %42 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %41, align 8
  store i32 (i8*, i8*)* %42, i32 (i8*, i8*)** %10, align 8
  %43 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %44 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %43, i32 0, i32 4
  %45 = load i8* (i8*)*, i8* (i8*)** %44, align 8
  store i8* (i8*)* %45, i8* (i8*)** %11, align 8
  %46 = call i32 @block_dim()
  %47 = call i32 @block_idx()
  %48 = mul nsw i32 %46, %47
  %49 = call i32 @thread_idx()
  %50 = add nsw i32 %48, %49
  store i32 %50, i32* %12, align 4
  %51 = call i32 @grid_dim()
  %52 = call i32 @block_dim()
  %53 = mul nsw i32 %51, %52
  store i32 %53, i32* %13, align 4
  %54 = load %struct.ListManager.3*, %struct.ListManager.3** %7, align 8
  %55 = call dereferenceable(48) %struct.Element.82* @_ZN11ListManager3getI7ElementEERT_i(%struct.ListManager.3* %54, i32 0)
  %56 = bitcast %struct.Element.82* %14 to i8*
  %57 = bitcast %struct.Element.82* %55 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %56, i8* align 8 %57, i64 48, i1 false)
  %58 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %9, align 8
  %59 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %60 = bitcast %struct.StructMeta.9* %59 to i8*
  %61 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %14, i32 0, i32 0
  %62 = load i8*, i8** %61, align 8
  %63 = call i8* %58(i8* %60, i8* %62, i32 0)
  store i8* %63, i8** %15, align 8
  %64 = load i8* (i8*)*, i8* (i8*)** %11, align 8
  %65 = load i8*, i8** %15, align 8
  %66 = call i8* %64(i8* %65)
  store i8* %66, i8** %15, align 8
  %67 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %10, align 8
  %68 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %69 = bitcast %struct.StructMeta.9* %68 to i8*
  %70 = load i8*, i8** %15, align 8
  %71 = call i32 %67(i8* %69, i8* %70)
  store i32 %71, i32* %16, align 4
  %72 = call dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %16, i32* dereferenceable(4) @_ZL31taichi_listgen_max_element_size)
  %73 = load i32, i32* %72, align 4
  store i32 %73, i32* %17, align 4
  %74 = load i32, i32* %12, align 4
  store i32 %74, i32* %18, align 4
  br label %75

75:                                               ; preds = %103, %3
  %76 = load i32, i32* %18, align 4
  %77 = load i32, i32* %17, align 4
  %78 = mul nsw i32 %76, %77
  %79 = load i32, i32* %16, align 4
  %80 = icmp slt i32 %78, %79
  br i1 %80, label %81, label %107

81:                                               ; preds = %75
  %82 = load i8*, i8** %15, align 8
  %83 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %19, i32 0, i32 0
  store i8* %82, i8** %83, align 8
  %84 = load i32, i32* %18, align 4
  %85 = load i32, i32* %17, align 4
  %86 = mul nsw i32 %84, %85
  %87 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %19, i32 0, i32 1
  %88 = getelementptr inbounds [2 x i32], [2 x i32]* %87, i64 0, i64 0
  store i32 %86, i32* %88, align 8
  %89 = load i32, i32* %18, align 4
  %90 = add nsw i32 %89, 1
  %91 = load i32, i32* %17, align 4
  %92 = mul nsw i32 %90, %91
  store i32 %92, i32* %20, align 4
  %93 = call dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %20, i32* dereferenceable(4) %16)
  %94 = load i32, i32* %93, align 4
  %95 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %19, i32 0, i32 1
  %96 = getelementptr inbounds [2 x i32], [2 x i32]* %95, i64 0, i64 1
  store i32 %94, i32* %96, align 4
  %97 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %14, i32 0, i32 2
  %98 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %19, i32 0, i32 2
  %99 = bitcast %struct.PhysicalCoordinates.0* %98 to i8*
  %100 = bitcast %struct.PhysicalCoordinates.0* %97 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %99, i8* align 8 %100, i64 32, i1 false)
  %101 = load %struct.ListManager.3*, %struct.ListManager.3** %8, align 8
  %102 = bitcast %struct.Element.82* %19 to i8*
  call void @_ZN11ListManager6appendEPv(%struct.ListManager.3* %101, i8* %102)
  br label %103

103:                                              ; preds = %81
  %104 = load i32, i32* %13, align 4
  %105 = load i32, i32* %18, align 4
  %106 = add nsw i32 %105, %104
  store i32 %106, i32* %18, align 4
  br label %75

107:                                              ; preds = %75
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @block_dim() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @block_idx() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @thread_idx() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @grid_dim() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal dereferenceable(48) %struct.Element.82* @_ZN11ListManager3getI7ElementEERT_i(%struct.ListManager.3* %0, i32 %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %6 = load i32, i32* %4, align 4
  %7 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.3* %5, i32 %6)
  %8 = bitcast i8* %7 to %struct.Element.82*
  ret %struct.Element.82* %8
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: alwaysinline nounwind uwtable
define internal dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %0, i32* dereferenceable(4) %1) #1 {
  %3 = alloca i32*, align 8
  %4 = alloca i32*, align 8
  %5 = alloca i32*, align 8
  store i32* %0, i32** %4, align 8
  store i32* %1, i32** %5, align 8
  %6 = load i32*, i32** %5, align 8
  %7 = load i32, i32* %6, align 4
  %8 = load i32*, i32** %4, align 8
  %9 = load i32, i32* %8, align 4
  %10 = icmp slt i32 %7, %9
  br i1 %10, label %11, label %13

11:                                               ; preds = %2
  %12 = load i32*, i32** %5, align 8
  store i32* %12, i32** %3, align 8
  br label %15

13:                                               ; preds = %2
  %14 = load i32*, i32** %4, align 8
  store i32* %14, i32** %3, align 8
  br label %15

15:                                               ; preds = %13, %11
  %16 = load i32*, i32** %3, align 8
  ret i32* %16
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11ListManager6appendEPv(%struct.ListManager.3* %0, i8* %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i8* %1, i8** %4, align 8
  %6 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %7 = call i8* @_ZN11ListManager8allocateEv(%struct.ListManager.3* %6)
  store i8* %7, i8** %5, align 8
  %8 = load i8*, i8** %5, align 8
  %9 = load i8*, i8** %4, align 8
  %10 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %8, i8* align 1 %9, i64 %11, i1 false)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11ListManager8allocateEv(%struct.ListManager.3* %0) #1 align 2 {
  %2 = alloca %struct.ListManager.3*, align 8
  %3 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %2, align 8
  %4 = load %struct.ListManager.3*, %struct.ListManager.3** %2, align 8
  %5 = call i32 @_ZN11ListManager19reserve_new_elementEv(%struct.ListManager.3* %4)
  store i32 %5, i32* %3, align 4
  %6 = load i32, i32* %3, align 4
  %7 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.3* %4, i32 %6)
  ret i8* %7
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11ListManager19reserve_new_elementEv(%struct.ListManager.3* %0) #1 align 2 {
  %2 = alloca %struct.ListManager.3*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %2, align 8
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %2, align 8
  %6 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 5
  %7 = call i32 @atomic_add_i32(i32* %6, i32 1)
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  %9 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 3
  %10 = load i32, i32* %9, align 8
  %11 = ashr i32 %8, %10
  store i32 %11, i32* %4, align 4
  %12 = load i32, i32* %4, align 4
  call void @_ZN11ListManager11touch_chunkEi(%struct.ListManager.3* %5, i32 %12)
  %13 = load i32, i32* %3, align 4
  ret i32 %13
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.3* %0, i32 %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %6 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 3
  %9 = load i32, i32* %8, align 8
  %10 = ashr i32 %7, %9
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %6, i64 0, i64 %11
  %13 = load i8*, i8** %12, align 8
  %14 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 1
  %15 = load i64, i64* %14, align 8
  %16 = load i32, i32* %4, align 4
  %17 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 3
  %18 = load i32, i32* %17, align 8
  %19 = shl i32 1, %18
  %20 = sub nsw i32 %19, 1
  %21 = and i32 %16, %20
  %22 = sext i32 %21 to i64
  %23 = mul i64 %15, %22
  %24 = getelementptr inbounds i8, i8* %13, i64 %23
  ret i8* %24
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @atomic_add_i32(i32* %0, i32 %1) #1 {
entry:
  %2 = atomicrmw add i32* %0, i32 %1 seq_cst
  ret i32 %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11ListManager11touch_chunkEi(%struct.ListManager.3* %0, i32 %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %class.anon.7.13, align 8
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %7 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 6
  %8 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %7, align 8
  %9 = load i32, i32* %4, align 4
  %10 = sext i32 %9 to i64
  %11 = icmp ult i64 %10, 131072
  %12 = zext i1 %11 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.1* %8, i32 %12, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.6, i64 0, i64 0))
  %13 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 0
  %14 = load i32, i32* %4, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %13, i64 0, i64 %15
  %17 = load i8*, i8** %16, align 8
  %18 = icmp ne i8* %17, null
  br i1 %18, label %24, label %19

19:                                               ; preds = %2
  %20 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 4
  %21 = bitcast i32* %20 to i8*
  %22 = getelementptr inbounds %class.anon.7.13, %class.anon.7.13* %5, i32 0, i32 0
  store %struct.ListManager.3* %6, %struct.ListManager.3** %22, align 8
  %23 = getelementptr inbounds %class.anon.7.13, %class.anon.7.13* %5, i32 0, i32 1
  store i32* %4, i32** %23, align 8
  call void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_"(i8* %21, %class.anon.7.13* dereferenceable(16) %5)
  br label %24

24:                                               ; preds = %19, %2
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @taichi_assert_runtime(%struct.LLVMRuntime.1* %0, i32 %1, i8* %2) #1 {
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %4, align 8
  store i32 %1, i32* %5, align 4
  store i8* %2, i8** %6, align 8
  %7 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %8 = load i32, i32* %5, align 4
  %9 = load i8*, i8** %6, align 8
  call void @taichi_assert_format(%struct.LLVMRuntime.1* %7, i32 %8, i8* %9, i32 0, i64* null)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_"(i8* %0, %class.anon.7.13* dereferenceable(16) %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca %class.anon.7.13*, align 8
  %5 = alloca %2, align 1
  store i8* %0, i8** %3, align 8
  store %class.anon.7.13* %1, %class.anon.7.13** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %class.anon.7.13*, %class.anon.7.13** %4, align 8
  call void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %6, %class.anon.7.13* dereferenceable(16) %7, %2* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %0, %class.anon.7.13* dereferenceable(16) %1, %2* dereferenceable(1) %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca %class.anon.7.13*, align 8
  %6 = alloca %2*, align 8
  %7 = alloca %2, align 1
  store i8* %0, i8** %4, align 8
  store %class.anon.7.13* %1, %class.anon.7.13** %5, align 8
  store %2* %2, %2** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %class.anon.7.13*, %class.anon.7.13** %5, align 8
  %10 = load %2*, %2** %6, align 8
  call void @"_ZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%2* %7, i8* %8, %class.anon.7.13* dereferenceable(16) %9, %2* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%2* %0, i8* %1, %class.anon.7.13* dereferenceable(16) %2, %2* dereferenceable(1) %3) unnamed_addr #1 align 2 {
  %5 = alloca %2*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %class.anon.7.13*, align 8
  %8 = alloca %2*, align 8
  %9 = alloca %class.anon.50.14, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %2* %0, %2** %5, align 8
  store i8* %1, i8** %6, align 8
  store %class.anon.7.13* %2, %class.anon.7.13** %7, align 8
  store %2* %3, %2** %8, align 8
  %15 = load %2*, %2** %5, align 8
  %16 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %9, i32 0, i32 0
  %17 = load %2*, %2** %8, align 8
  store %2* %17, %2** %16, align 8
  %18 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %9, i32 0, i32 2
  %20 = load %class.anon.7.13*, %class.anon.7.13** %7, align 8
  store %class.anon.7.13* %20, %class.anon.7.13** %19, align 8
  %21 = call i32 @cuda_compute_capability()
  %22 = icmp slt i32 %21, 70
  br i1 %22, label %23, label %62

23:                                               ; preds = %4
  store i8 0, i8* %10, align 1
  %24 = load i8, i8* %10, align 1
  %25 = trunc i8 %24 to i1
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  %27 = call i32 @cuda_active_mask()
  store i32 %27, i32* %11, align 4
  %28 = load i32, i32* %11, align 4
  store i32 %28, i32* %12, align 4
  br label %29

29:                                               ; preds = %39, %26
  %30 = load i32, i32* %12, align 4
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %45

32:                                               ; preds = %29
  %33 = load i32, i32* %12, align 4
  %34 = call i32 @cttz_i32(i32 %33)
  store i32 %34, i32* %13, align 4
  %35 = call i32 @warp_idx()
  %36 = load i32, i32* %13, align 4
  %37 = icmp eq i32 %35, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %32
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.50.14* %9)
  br label %39

39:                                               ; preds = %38, %32
  %40 = load i32, i32* %13, align 4
  %41 = shl i32 1, %40
  %42 = xor i32 %41, -1
  %43 = load i32, i32* %12, align 4
  %44 = and i32 %43, %42
  store i32 %44, i32* %12, align 4
  br label %29

45:                                               ; preds = %29
  br label %61

46:                                               ; preds = %23
  store i32 0, i32* %14, align 4
  br label %47

47:                                               ; preds = %57, %46
  %48 = load i32, i32* %14, align 4
  %49 = call i32 @warp_size()
  %50 = icmp slt i32 %48, %49
  br i1 %50, label %51, label %60

51:                                               ; preds = %47
  %52 = call i32 @warp_idx()
  %53 = load i32, i32* %14, align 4
  %54 = icmp eq i32 %52, %53
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.50.14* %9)
  br label %56

56:                                               ; preds = %55, %51
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %14, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %14, align 4
  br label %47

60:                                               ; preds = %47
  br label %61

61:                                               ; preds = %60, %45
  br label %63

62:                                               ; preds = %4
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.50.14* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_compute_capability() #1 {
entry:
  ret i32 75
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_active_mask() #1 {
  %1 = alloca i32, align 4
  %2 = call i32 asm sideeffect "activemask.b32 $0;", "=r,~{dirflag},~{fpsr},~{flags}"() #3, !srcloc !79
  store i32 %2, i32* %1, align 4
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cttz_i32(i32 %0) #1 {
entry:
  %1 = call i32 @llvm.cttz.i32(i32 %0, i1 false)
  ret i32 %1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @warp_idx() #1 {
  %1 = call i32 @thread_idx()
  %2 = call i32 @warp_size()
  %3 = srem i32 %1, %2
  ret i32 %3
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.50.14* %0) #1 align 2 {
  %2 = alloca %class.anon.50.14*, align 8
  store %class.anon.50.14* %0, %class.anon.50.14** %2, align 8
  %3 = load %class.anon.50.14*, %class.anon.50.14** %2, align 8
  %4 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %3, i32 0, i32 0
  %5 = load %2*, %2** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%2* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %3, i32 0, i32 0
  %12 = load %2*, %2** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%2* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %3, i32 0, i32 2
  %16 = load %class.anon.7.13*, %class.anon.7.13** %15, align 8
  call void @"_ZZN11ListManager11touch_chunkEiENK3$_8clEv"(%class.anon.7.13* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %class.anon.50.14, %class.anon.50.14* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @warp_size() #1 {
  ret i32 32
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%2* %0) #1 align 2 {
  %2 = alloca %2*, align 8
  store %2* %0, %2** %2, align 8
  %3 = load %2*, %2** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mutex_lock_i32(i8* %0) #1 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  br label %3

3:                                                ; preds = %8, %1
  %4 = load i8*, i8** %2, align 8
  %5 = bitcast i8* %4 to i32*
  %6 = call i32 @atomic_exchange_i32(i32* %5, i32 1)
  %7 = icmp eq i32 %6, 1
  br i1 %7, label %8, label %9

8:                                                ; preds = %3
  br label %3

9:                                                ; preds = %3
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @grid_memfence() #1 {
entry:
  call void @llvm.nvvm.membar.gl()
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN11ListManager11touch_chunkEiENK3$_8clEv"(%class.anon.7.13* %0) #1 align 2 {
  %2 = alloca %class.anon.7.13*, align 8
  %3 = alloca i8*, align 8
  store %class.anon.7.13* %0, %class.anon.7.13** %2, align 8
  %4 = load %class.anon.7.13*, %class.anon.7.13** %2, align 8
  %5 = getelementptr inbounds %class.anon.7.13, %class.anon.7.13* %4, i32 0, i32 0
  %6 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %7 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 0
  %8 = getelementptr inbounds %class.anon.7.13, %class.anon.7.13* %4, i32 0, i32 1
  %9 = load i32*, i32** %8, align 8
  %10 = load i32, i32* %9, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %7, i64 0, i64 %11
  %13 = load i8*, i8** %12, align 8
  %14 = icmp ne i8* %13, null
  br i1 %14, label %34, label %15

15:                                               ; preds = %1
  call void @grid_memfence()
  %16 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 6
  %17 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %16, align 8
  %18 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 2
  %19 = load i64, i64* %18, align 8
  %20 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 1
  %21 = load i64, i64* %20, align 8
  %22 = mul i64 %19, %21
  %23 = call i8* @_ZN11LLVMRuntime24request_allocate_alignedEmm(%struct.LLVMRuntime.1* %17, i64 %22, i64 4096)
  store i8* %23, i8** %3, align 8
  %24 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %6, i32 0, i32 0
  %25 = getelementptr inbounds %class.anon.7.13, %class.anon.7.13* %4, i32 0, i32 1
  %26 = load i32*, i32** %25, align 8
  %27 = load i32, i32* %26, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %24, i64 0, i64 %28
  %30 = bitcast i8** %29 to i64*
  %31 = load i8*, i8** %3, align 8
  %32 = ptrtoint i8* %31 to i64
  %33 = call i64 @atomic_exchange_u64(i64* %30, i64 %32)
  br label %34

34:                                               ; preds = %15, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mutex_unlock_i32(i8* %0) #1 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = load i8*, i8** %2, align 8
  %4 = bitcast i8* %3 to i32*
  %5 = call i32 @atomic_exchange_i32(i32* %4, i32 0)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @atomic_exchange_i32(i32* %0, i32 %1) #1 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load i32*, i32** %3, align 8
  %7 = load i32, i32* %4, align 4
  %8 = atomicrmw volatile xchg i32* %6, i32 %7 seq_cst
  store i32 %8, i32* %5, align 4
  %9 = load i32, i32* %5, align 4
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11LLVMRuntime24request_allocate_alignedEmm(%struct.LLVMRuntime.1* %0, i64 %1, i64 %2) #1 align 2 {
  %4 = alloca i8*, align 8
  %5 = alloca %struct.LLVMRuntime.1*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = alloca %struct.MemRequest.8*, align 8
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %5, align 8
  store i64 %1, i64* %6, align 8
  store i64 %2, i64* %7, align 8
  %10 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %5, align 8
  %11 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 30
  %12 = load i64, i64* %6, align 8
  %13 = call i64 @atomic_add_i64(i64* %11, i64 %12)
  %14 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 0
  %15 = load i8, i8* %14, align 8
  %16 = trunc i8 %15 to i1
  br i1 %16, label %17, label %21

17:                                               ; preds = %3
  %18 = load i64, i64* %6, align 8
  %19 = load i64, i64* %7, align 8
  %20 = call i8* @_ZN11LLVMRuntime20allocate_from_bufferEmm(%struct.LLVMRuntime.1* %10, i64 %18, i64 %19)
  store i8* %20, i8** %4, align 8
  br label %53

21:                                               ; preds = %3
  %22 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 19
  %23 = load %struct.MemRequestQueue.7*, %struct.MemRequestQueue.7** %22, align 8
  %24 = getelementptr inbounds %struct.MemRequestQueue.7, %struct.MemRequestQueue.7* %23, i32 0, i32 1
  %25 = call i32 @atomic_add_i32(i32* %24, i32 1)
  store i32 %25, i32* %8, align 4
  %26 = load i32, i32* %8, align 4
  %27 = icmp sle i32 %26, 65536
  %28 = zext i1 %27 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.1* %10, i32 %28, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.4, i64 0, i64 0))
  %29 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 19
  %30 = load %struct.MemRequestQueue.7*, %struct.MemRequestQueue.7** %29, align 8
  %31 = getelementptr inbounds %struct.MemRequestQueue.7, %struct.MemRequestQueue.7* %30, i32 0, i32 0
  %32 = load i32, i32* %8, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [65536 x %struct.MemRequest.8], [65536 x %struct.MemRequest.8]* %31, i64 0, i64 %33
  store volatile %struct.MemRequest.8* %34, %struct.MemRequest.8** %9, align 8
  %35 = load volatile %struct.MemRequest.8*, %struct.MemRequest.8** %9, align 8
  %36 = getelementptr inbounds %struct.MemRequest.8, %struct.MemRequest.8* %35, i32 0, i32 0
  %37 = load i64, i64* %6, align 8
  %38 = call i64 @atomic_exchange_u64(i64* %36, i64 %37)
  %39 = load volatile %struct.MemRequest.8*, %struct.MemRequest.8** %9, align 8
  %40 = getelementptr inbounds %struct.MemRequest.8, %struct.MemRequest.8* %39, i32 0, i32 1
  %41 = load i64, i64* %7, align 8
  %42 = call i64 @atomic_exchange_u64(i64* %40, i64 %41)
  br label %43

43:                                               ; preds = %48, %21
  %44 = load volatile %struct.MemRequest.8*, %struct.MemRequest.8** %9, align 8
  %45 = getelementptr inbounds %struct.MemRequest.8, %struct.MemRequest.8* %44, i32 0, i32 2
  %46 = load i8*, i8** %45, align 8
  %47 = icmp eq i8* %46, null
  br i1 %47, label %48, label %49

48:                                               ; preds = %43
  call void @system_memfence()
  br label %43

49:                                               ; preds = %43
  %50 = load volatile %struct.MemRequest.8*, %struct.MemRequest.8** %9, align 8
  %51 = getelementptr inbounds %struct.MemRequest.8, %struct.MemRequest.8* %50, i32 0, i32 2
  %52 = load i8*, i8** %51, align 8
  store i8* %52, i8** %4, align 8
  br label %53

53:                                               ; preds = %49, %17
  %54 = load i8*, i8** %4, align 8
  ret i8* %54
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @atomic_exchange_u64(i64* %0, i64 %1) #1 {
  %3 = alloca i64*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64* %0, i64** %3, align 8
  store i64 %1, i64* %4, align 8
  %6 = load i64*, i64** %3, align 8
  %7 = load i64, i64* %4, align 8
  %8 = atomicrmw volatile xchg i64* %6, i64 %7 seq_cst
  store i64 %8, i64* %5, align 8
  %9 = load i64, i64* %5, align 8
  ret i64 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @atomic_add_i64(i64* %0, i64 %1) #1 {
entry:
  %2 = atomicrmw add i64* %0, i64 %1 seq_cst
  ret i64 %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11LLVMRuntime20allocate_from_bufferEmm(%struct.LLVMRuntime.1* %0, i64 %1, i64 %2) #1 align 2 {
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8, align 1
  %9 = alloca %class.anon.0.15, align 8
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %4, align 8
  store i64 %1, i64* %5, align 8
  store i64 %2, i64* %6, align 8
  %10 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  store i8* null, i8** %7, align 8
  store i8 0, i8* %8, align 1
  %11 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 28
  %12 = bitcast i32* %11 to i8*
  %13 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %9, i32 0, i32 0
  store i64* %6, i64** %13, align 8
  %14 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %9, i32 0, i32 1
  store %struct.LLVMRuntime.1* %10, %struct.LLVMRuntime.1** %14, align 8
  %15 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %9, i32 0, i32 2
  store i64* %5, i64** %15, align 8
  %16 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %9, i32 0, i32 3
  store i8** %7, i8*** %16, align 8
  %17 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %9, i32 0, i32 4
  store i8* %8, i8** %17, align 8
  call void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_"(i8* %12, %class.anon.0.15* dereferenceable(40) %9)
  %18 = load i8, i8* %8, align 1
  %19 = trunc i8 %18 to i1
  br i1 %19, label %21, label %20

20:                                               ; preds = %3
  call void @__assertfail(i8* getelementptr inbounds ([144 x i8], [144 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.2, i64 0, i64 0), i64 1)
  br label %21

21:                                               ; preds = %20, %3
  %22 = load i8, i8* %8, align 1
  %23 = trunc i8 %22 to i1
  %24 = zext i1 %23 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.1* %10, i32 %24, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.3, i64 0, i64 0))
  %25 = load i8*, i8** %7, align 8
  ret i8* %25
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @system_memfence() #1 {
entry:
  call void @llvm.nvvm.membar.sys()
  ret void
}

; Function Attrs: nounwind
declare void @llvm.nvvm.membar.sys() #3

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_"(i8* %0, %class.anon.0.15* dereferenceable(40) %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca %class.anon.0.15*, align 8
  %5 = alloca %2, align 1
  store i8* %0, i8** %3, align 8
  store %class.anon.0.15* %1, %class.anon.0.15** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %class.anon.0.15*, %class.anon.0.15** %4, align 8
  call void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %6, %class.anon.0.15* dereferenceable(40) %7, %2* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline
declare dso_local void @__assertfail(i8*, i8*, i32, i8*, i64) #4

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %0, %class.anon.0.15* dereferenceable(40) %1, %2* dereferenceable(1) %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca %class.anon.0.15*, align 8
  %6 = alloca %2*, align 8
  %7 = alloca %2, align 1
  store i8* %0, i8** %4, align 8
  store %class.anon.0.15* %1, %class.anon.0.15** %5, align 8
  store %2* %2, %2** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %class.anon.0.15*, %class.anon.0.15** %5, align 8
  %10 = load %2*, %2** %6, align 8
  call void @"_ZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%2* %7, i8* %8, %class.anon.0.15* dereferenceable(40) %9, %2* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%2* %0, i8* %1, %class.anon.0.15* dereferenceable(40) %2, %2* dereferenceable(1) %3) unnamed_addr #1 align 2 {
  %5 = alloca %2*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %class.anon.0.15*, align 8
  %8 = alloca %2*, align 8
  %9 = alloca %class.anon.19.16, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %2* %0, %2** %5, align 8
  store i8* %1, i8** %6, align 8
  store %class.anon.0.15* %2, %class.anon.0.15** %7, align 8
  store %2* %3, %2** %8, align 8
  %15 = load %2*, %2** %5, align 8
  %16 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %9, i32 0, i32 0
  %17 = load %2*, %2** %8, align 8
  store %2* %17, %2** %16, align 8
  %18 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %9, i32 0, i32 2
  %20 = load %class.anon.0.15*, %class.anon.0.15** %7, align 8
  store %class.anon.0.15* %20, %class.anon.0.15** %19, align 8
  %21 = call i32 @cuda_compute_capability()
  %22 = icmp slt i32 %21, 70
  br i1 %22, label %23, label %62

23:                                               ; preds = %4
  store i8 0, i8* %10, align 1
  %24 = load i8, i8* %10, align 1
  %25 = trunc i8 %24 to i1
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  %27 = call i32 @cuda_active_mask()
  store i32 %27, i32* %11, align 4
  %28 = load i32, i32* %11, align 4
  store i32 %28, i32* %12, align 4
  br label %29

29:                                               ; preds = %39, %26
  %30 = load i32, i32* %12, align 4
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %45

32:                                               ; preds = %29
  %33 = load i32, i32* %12, align 4
  %34 = call i32 @cttz_i32(i32 %33)
  store i32 %34, i32* %13, align 4
  %35 = call i32 @warp_idx()
  %36 = load i32, i32* %13, align 4
  %37 = icmp eq i32 %35, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %32
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.19.16* %9)
  br label %39

39:                                               ; preds = %38, %32
  %40 = load i32, i32* %13, align 4
  %41 = shl i32 1, %40
  %42 = xor i32 %41, -1
  %43 = load i32, i32* %12, align 4
  %44 = and i32 %43, %42
  store i32 %44, i32* %12, align 4
  br label %29

45:                                               ; preds = %29
  br label %61

46:                                               ; preds = %23
  store i32 0, i32* %14, align 4
  br label %47

47:                                               ; preds = %57, %46
  %48 = load i32, i32* %14, align 4
  %49 = call i32 @warp_size()
  %50 = icmp slt i32 %48, %49
  br i1 %50, label %51, label %60

51:                                               ; preds = %47
  %52 = call i32 @warp_idx()
  %53 = load i32, i32* %14, align 4
  %54 = icmp eq i32 %52, %53
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.19.16* %9)
  br label %56

56:                                               ; preds = %55, %51
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %14, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %14, align 4
  br label %47

60:                                               ; preds = %47
  br label %61

61:                                               ; preds = %60, %45
  br label %63

62:                                               ; preds = %4
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.19.16* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%class.anon.19.16* %0) #1 align 2 {
  %2 = alloca %class.anon.19.16*, align 8
  store %class.anon.19.16* %0, %class.anon.19.16** %2, align 8
  %3 = load %class.anon.19.16*, %class.anon.19.16** %2, align 8
  %4 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %3, i32 0, i32 0
  %5 = load %2*, %2** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%2* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %3, i32 0, i32 0
  %12 = load %2*, %2** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%2* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %3, i32 0, i32 2
  %16 = load %class.anon.0.15*, %class.anon.0.15** %15, align 8
  call void @"_ZZN11LLVMRuntime20allocate_from_bufferEmmENK3$_1clEv"(%class.anon.0.15* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %class.anon.19.16, %class.anon.19.16* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%2* %0) #1 align 2 {
  %2 = alloca %2*, align 8
  store %2* %0, %2** %2, align 8
  %3 = load %2*, %2** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN11LLVMRuntime20allocate_from_bufferEmmENK3$_1clEv"(%class.anon.0.15* %0) #1 align 2 {
  %2 = alloca %class.anon.0.15*, align 8
  %3 = alloca i64, align 8
  store %class.anon.0.15* %0, %class.anon.0.15** %2, align 8
  %4 = load %class.anon.0.15*, %class.anon.0.15** %2, align 8
  %5 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 1
  %6 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %5, align 8
  %7 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 0
  %8 = load i64*, i64** %7, align 8
  %9 = load i64, i64* %8, align 8
  %10 = sub i64 %9, 1
  %11 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %6, i32 0, i32 2
  %12 = load i8*, i8** %11, align 8
  %13 = ptrtoint i8* %12 to i64
  %14 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 0
  %15 = load i64*, i64** %14, align 8
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %13, %16
  %18 = sub i64 %17, 1
  %19 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 0
  %20 = load i64*, i64** %19, align 8
  %21 = load i64, i64* %20, align 8
  %22 = urem i64 %18, %21
  %23 = sub i64 %10, %22
  store i64 %23, i64* %3, align 8
  %24 = load i64, i64* %3, align 8
  %25 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 2
  %26 = load i64*, i64** %25, align 8
  %27 = load i64, i64* %26, align 8
  %28 = add i64 %27, %24
  store i64 %28, i64* %26, align 8
  %29 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %6, i32 0, i32 2
  %30 = load i8*, i8** %29, align 8
  %31 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 2
  %32 = load i64*, i64** %31, align 8
  %33 = load i64, i64* %32, align 8
  %34 = getelementptr inbounds i8, i8* %30, i64 %33
  %35 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %6, i32 0, i32 3
  %36 = load i8*, i8** %35, align 8
  %37 = icmp ule i8* %34, %36
  br i1 %37, label %38, label %53

38:                                               ; preds = %1
  %39 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %6, i32 0, i32 2
  %40 = load i8*, i8** %39, align 8
  %41 = load i64, i64* %3, align 8
  %42 = getelementptr inbounds i8, i8* %40, i64 %41
  %43 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 3
  %44 = load i8**, i8*** %43, align 8
  store i8* %42, i8** %44, align 8
  %45 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 2
  %46 = load i64*, i64** %45, align 8
  %47 = load i64, i64* %46, align 8
  %48 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %6, i32 0, i32 2
  %49 = load i8*, i8** %48, align 8
  %50 = getelementptr inbounds i8, i8* %49, i64 %47
  store i8* %50, i8** %48, align 8
  %51 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 4
  %52 = load i8*, i8** %51, align 8
  store i8 1, i8* %52, align 1
  br label %56

53:                                               ; preds = %1
  %54 = getelementptr inbounds %class.anon.0.15, %class.anon.0.15* %4, i32 0, i32 4
  %55 = load i8*, i8** %54, align 8
  store i8 0, i8* %55, align 1
  br label %56

56:                                               ; preds = %53, %38
  ret void
}

; Function Attrs: nounwind
declare void @llvm.nvvm.membar.gl() #3

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.cttz.i32(i32, i1 immarg) #5

; Function Attrs: noinline nounwind optnone uwtable
define internal void @taichi_assert_format(%struct.LLVMRuntime.1* %0, i32 %1, i8* %2, i32 %3, i64* %4) #6 {
  %6 = alloca %struct.LLVMRuntime.1*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i64*, align 8
  %11 = alloca %class.anon.17, align 8
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %6, align 8
  store i32 %1, i32* %7, align 4
  store i8* %2, i8** %8, align 8
  store i32 %3, i32* %9, align 4
  store i64* %4, i64** %10, align 8
  call void @mark_force_no_inline()
  %12 = load i32, i32* %7, align 4
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %15

14:                                               ; preds = %5
  br label %29

15:                                               ; preds = %5
  %16 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %6, align 8
  %17 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %16, i32 0, i32 26
  %18 = load i64, i64* %17, align 8
  %19 = icmp ne i64 %18, 0
  br i1 %19, label %28, label %20

20:                                               ; preds = %15
  %21 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %6, align 8
  %22 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %21, i32 0, i32 25
  %23 = bitcast i32* %22 to i8*
  %24 = getelementptr inbounds %class.anon.17, %class.anon.17* %11, i32 0, i32 0
  store %struct.LLVMRuntime.1** %6, %struct.LLVMRuntime.1*** %24, align 8
  %25 = getelementptr inbounds %class.anon.17, %class.anon.17* %11, i32 0, i32 1
  store i8** %8, i8*** %25, align 8
  %26 = getelementptr inbounds %class.anon.17, %class.anon.17* %11, i32 0, i32 2
  store i32* %9, i32** %26, align 8
  %27 = getelementptr inbounds %class.anon.17, %class.anon.17* %11, i32 0, i32 3
  store i64** %10, i64*** %27, align 8
  call void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_"(i8* %23, %class.anon.17* dereferenceable(32) %11)
  br label %28

28:                                               ; preds = %20, %15
  call void asm sideeffect "exit;", "~{dirflag},~{fpsr},~{flags}"() #3, !srcloc !80
  br label %29

29:                                               ; preds = %28, %14
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mark_force_no_inline() #1 {
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_"(i8* %0, %class.anon.17* dereferenceable(32) %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca %class.anon.17*, align 8
  %5 = alloca %2, align 1
  store i8* %0, i8** %3, align 8
  store %class.anon.17* %1, %class.anon.17** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %class.anon.17*, %class.anon.17** %4, align 8
  call void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %6, %class.anon.17* dereferenceable(32) %7, %2* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %0, %class.anon.17* dereferenceable(32) %1, %2* dereferenceable(1) %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca %class.anon.17*, align 8
  %6 = alloca %2*, align 8
  %7 = alloca %2, align 1
  store i8* %0, i8** %4, align 8
  store %class.anon.17* %1, %class.anon.17** %5, align 8
  store %2* %2, %2** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %class.anon.17*, %class.anon.17** %5, align 8
  %10 = load %2*, %2** %6, align 8
  call void @"_ZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%2* %7, i8* %8, %class.anon.17* dereferenceable(32) %9, %2* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%2* %0, i8* %1, %class.anon.17* dereferenceable(32) %2, %2* dereferenceable(1) %3) unnamed_addr #1 align 2 {
  %5 = alloca %2*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %class.anon.17*, align 8
  %8 = alloca %2*, align 8
  %9 = alloca %class.anon.14.18, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %2* %0, %2** %5, align 8
  store i8* %1, i8** %6, align 8
  store %class.anon.17* %2, %class.anon.17** %7, align 8
  store %2* %3, %2** %8, align 8
  %15 = load %2*, %2** %5, align 8
  %16 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %9, i32 0, i32 0
  %17 = load %2*, %2** %8, align 8
  store %2* %17, %2** %16, align 8
  %18 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %9, i32 0, i32 2
  %20 = load %class.anon.17*, %class.anon.17** %7, align 8
  store %class.anon.17* %20, %class.anon.17** %19, align 8
  %21 = call i32 @cuda_compute_capability()
  %22 = icmp slt i32 %21, 70
  br i1 %22, label %23, label %62

23:                                               ; preds = %4
  store i8 0, i8* %10, align 1
  %24 = load i8, i8* %10, align 1
  %25 = trunc i8 %24 to i1
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  %27 = call i32 @cuda_active_mask()
  store i32 %27, i32* %11, align 4
  %28 = load i32, i32* %11, align 4
  store i32 %28, i32* %12, align 4
  br label %29

29:                                               ; preds = %39, %26
  %30 = load i32, i32* %12, align 4
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %45

32:                                               ; preds = %29
  %33 = load i32, i32* %12, align 4
  %34 = call i32 @cttz_i32(i32 %33)
  store i32 %34, i32* %13, align 4
  %35 = call i32 @warp_idx()
  %36 = load i32, i32* %13, align 4
  %37 = icmp eq i32 %35, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %32
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.14.18* %9)
  br label %39

39:                                               ; preds = %38, %32
  %40 = load i32, i32* %13, align 4
  %41 = shl i32 1, %40
  %42 = xor i32 %41, -1
  %43 = load i32, i32* %12, align 4
  %44 = and i32 %43, %42
  store i32 %44, i32* %12, align 4
  br label %29

45:                                               ; preds = %29
  br label %61

46:                                               ; preds = %23
  store i32 0, i32* %14, align 4
  br label %47

47:                                               ; preds = %57, %46
  %48 = load i32, i32* %14, align 4
  %49 = call i32 @warp_size()
  %50 = icmp slt i32 %48, %49
  br i1 %50, label %51, label %60

51:                                               ; preds = %47
  %52 = call i32 @warp_idx()
  %53 = load i32, i32* %14, align 4
  %54 = icmp eq i32 %52, %53
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.14.18* %9)
  br label %56

56:                                               ; preds = %55, %51
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %14, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %14, align 4
  br label %47

60:                                               ; preds = %47
  br label %61

61:                                               ; preds = %60, %45
  br label %63

62:                                               ; preds = %4
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.14.18* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.14.18* %0) #1 align 2 {
  %2 = alloca %class.anon.14.18*, align 8
  store %class.anon.14.18* %0, %class.anon.14.18** %2, align 8
  %3 = load %class.anon.14.18*, %class.anon.14.18** %2, align 8
  %4 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %3, i32 0, i32 0
  %5 = load %2*, %2** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%2* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %3, i32 0, i32 0
  %12 = load %2*, %2** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%2* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %3, i32 0, i32 2
  %16 = load %class.anon.17*, %class.anon.17** %15, align 8
  call void @"_ZZ20taichi_assert_formatENK3$_0clEv"(%class.anon.17* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %class.anon.14.18, %class.anon.14.18* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%2* %0) #1 align 2 {
  %2 = alloca %2*, align 8
  store %2* %0, %2** %2, align 8
  %3 = load %2*, %2** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZ20taichi_assert_formatENK3$_0clEv"(%class.anon.17* %0) #1 align 2 {
  %2 = alloca %class.anon.17*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store %class.anon.17* %0, %class.anon.17** %2, align 8
  %6 = load %class.anon.17*, %class.anon.17** %2, align 8
  %7 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 0
  %8 = load %struct.LLVMRuntime.1**, %struct.LLVMRuntime.1*** %7, align 8
  %9 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %8, align 8
  %10 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %9, i32 0, i32 26
  %11 = load i64, i64* %10, align 8
  %12 = icmp ne i64 %11, 0
  br i1 %12, label %62, label %13

13:                                               ; preds = %1
  %14 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 0
  %15 = load %struct.LLVMRuntime.1**, %struct.LLVMRuntime.1*** %14, align 8
  %16 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %15, align 8
  %17 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %16, i32 0, i32 26
  store i64 1, i64* %17, align 8
  %18 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 0
  %19 = load %struct.LLVMRuntime.1**, %struct.LLVMRuntime.1*** %18, align 8
  %20 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %19, align 8
  %21 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %20, i32 0, i32 23
  %22 = getelementptr inbounds [2048 x i8], [2048 x i8]* %21, i64 0, i64 0
  call void @llvm.memset.p0i8.i64(i8* align 8 %22, i8 0, i64 2048, i1 false)
  %23 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 0
  %24 = load %struct.LLVMRuntime.1**, %struct.LLVMRuntime.1*** %23, align 8
  %25 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %24, align 8
  %26 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %25, i32 0, i32 23
  %27 = getelementptr inbounds [2048 x i8], [2048 x i8]* %26, i64 0, i64 0
  %28 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 1
  %29 = load i8**, i8*** %28, align 8
  %30 = load i8*, i8** %29, align 8
  %31 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 1
  %32 = load i8**, i8*** %31, align 8
  %33 = load i8*, i8** %32, align 8
  %34 = call i64 @taichi_strlen(i8* %33)
  store i64 %34, i64* %3, align 8
  store i64 2047, i64* %4, align 8
  %35 = call dereferenceable(8) i64* @_ZSt3minImERKT_S2_S2_(i64* dereferenceable(8) %3, i64* dereferenceable(8) %4)
  %36 = load i64, i64* %35, align 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %27, i8* align 1 %30, i64 %36, i1 false)
  store i32 0, i32* %5, align 4
  br label %37

37:                                               ; preds = %58, %13
  %38 = load i32, i32* %5, align 4
  %39 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 2
  %40 = load i32*, i32** %39, align 8
  %41 = load i32, i32* %40, align 4
  %42 = icmp slt i32 %38, %41
  br i1 %42, label %43, label %61

43:                                               ; preds = %37
  %44 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 3
  %45 = load i64**, i64*** %44, align 8
  %46 = load i64*, i64** %45, align 8
  %47 = load i32, i32* %5, align 4
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i64, i64* %46, i64 %48
  %50 = load i64, i64* %49, align 8
  %51 = getelementptr inbounds %class.anon.17, %class.anon.17* %6, i32 0, i32 0
  %52 = load %struct.LLVMRuntime.1**, %struct.LLVMRuntime.1*** %51, align 8
  %53 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %52, align 8
  %54 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %53, i32 0, i32 24
  %55 = load i32, i32* %5, align 4
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds [32 x i64], [32 x i64]* %54, i64 0, i64 %56
  store i64 %50, i64* %57, align 8
  br label %58

58:                                               ; preds = %43
  %59 = load i32, i32* %5, align 4
  %60 = add nsw i32 %59, 1
  store i32 %60, i32* %5, align 4
  br label %37

61:                                               ; preds = %37
  br label %62

62:                                               ; preds = %61, %1
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @taichi_strlen(i8* %0) #1 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  store i64 0, i64* %3, align 8
  %5 = load i8*, i8** %2, align 8
  store i8* %5, i8** %4, align 8
  br label %6

6:                                                ; preds = %13, %1
  %7 = load i8*, i8** %4, align 8
  %8 = load i8, i8* %7, align 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %10, label %16

10:                                               ; preds = %6
  %11 = load i64, i64* %3, align 8
  %12 = add i64 %11, 1
  store i64 %12, i64* %3, align 8
  br label %13

13:                                               ; preds = %10
  %14 = load i8*, i8** %4, align 8
  %15 = getelementptr inbounds i8, i8* %14, i32 1
  store i8* %15, i8** %4, align 8
  br label %6

16:                                               ; preds = %6
  %17 = load i64, i64* %3, align 8
  ret i64 %17
}

; Function Attrs: alwaysinline nounwind uwtable
define internal dereferenceable(8) i64* @_ZSt3minImERKT_S2_S2_(i64* dereferenceable(8) %0, i64* dereferenceable(8) %1) #1 {
  %3 = alloca i64*, align 8
  %4 = alloca i64*, align 8
  %5 = alloca i64*, align 8
  store i64* %0, i64** %4, align 8
  store i64* %1, i64** %5, align 8
  %6 = load i64*, i64** %5, align 8
  %7 = load i64, i64* %6, align 8
  %8 = load i64*, i64** %4, align 8
  %9 = load i64, i64* %8, align 8
  %10 = icmp ult i64 %7, %9
  br i1 %10, label %11, label %13

11:                                               ; preds = %2
  %12 = load i64*, i64** %5, align 8
  store i64* %12, i64** %3, align 8
  br label %15

13:                                               ; preds = %2
  %14 = load i64*, i64** %4, align 8
  store i64* %14, i64** %3, align 8
  br label %15

15:                                               ; preds = %13, %11
  %16 = load i64*, i64** %3, align 8
  ret i64* %16
}

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.x() #0

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #0

; Function Attrs: alwaysinline nounwind uwtable
define internal void @element_listgen_nonroot(%struct.LLVMRuntime.1* %0, %struct.StructMeta.9* %1, %struct.StructMeta.9* %2) #1 {
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca %struct.StructMeta.9*, align 8
  %6 = alloca %struct.StructMeta.9*, align 8
  %7 = alloca %struct.ListManager.3*, align 8
  %8 = alloca i32, align 4
  %9 = alloca %struct.ListManager.3*, align 8
  %10 = alloca void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, align 8
  %11 = alloca i32 (i8*, i8*, i32)*, align 8
  %12 = alloca i8* (i8*, i8*, i32)*, align 8
  %13 = alloca i32 (i8*, i8*)*, align 8
  %14 = alloca i8* (i8*)*, align 8
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca %struct.Element.82, align 8
  %21 = alloca i32, align 4
  %22 = alloca i32, align 4
  %23 = alloca i32, align 4
  %24 = alloca %struct.PhysicalCoordinates.0, align 4
  %25 = alloca i8*, align 8
  %26 = alloca i32, align 4
  %27 = alloca i32, align 4
  %28 = alloca i32, align 4
  %29 = alloca %struct.Element.82, align 8
  %30 = alloca i32, align 4
  store %struct.LLVMRuntime.1* %0, %struct.LLVMRuntime.1** %4, align 8
  store %struct.StructMeta.9* %1, %struct.StructMeta.9** %5, align 8
  store %struct.StructMeta.9* %2, %struct.StructMeta.9** %6, align 8
  %31 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %32 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %31, i32 0, i32 13
  %33 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %34 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %33, i32 0, i32 0
  %35 = load i32, i32* %34, align 8
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %32, i64 0, i64 %36
  %38 = load %struct.ListManager.3*, %struct.ListManager.3** %37, align 8
  store %struct.ListManager.3* %38, %struct.ListManager.3** %7, align 8
  %39 = load %struct.ListManager.3*, %struct.ListManager.3** %7, align 8
  %40 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %39)
  store i32 %40, i32* %8, align 4
  %41 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %42 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %41, i32 0, i32 13
  %43 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %44 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %43, i32 0, i32 0
  %45 = load i32, i32* %44, align 8
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %42, i64 0, i64 %46
  %48 = load %struct.ListManager.3*, %struct.ListManager.3** %47, align 8
  store %struct.ListManager.3* %48, %struct.ListManager.3** %9, align 8
  %49 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %50 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %49, i32 0, i32 7
  %51 = load void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %50, align 8
  store void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)* %51, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %10, align 8
  %52 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %53 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %52, i32 0, i32 5
  %54 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %53, align 8
  store i32 (i8*, i8*, i32)* %54, i32 (i8*, i8*, i32)** %11, align 8
  %55 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %56 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %55, i32 0, i32 3
  %57 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %56, align 8
  store i8* (i8*, i8*, i32)* %57, i8* (i8*, i8*, i32)** %12, align 8
  %58 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %59 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %58, i32 0, i32 6
  %60 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %59, align 8
  store i32 (i8*, i8*)* %60, i32 (i8*, i8*)** %13, align 8
  %61 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %62 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %61, i32 0, i32 4
  %63 = load i8* (i8*)*, i8* (i8*)** %62, align 8
  store i8* (i8*)* %63, i8* (i8*)** %14, align 8
  %64 = call i32 @block_idx()
  store i32 %64, i32* %15, align 4
  %65 = call i32 @grid_dim()
  store i32 %65, i32* %16, align 4
  %66 = call i32 @thread_idx()
  store i32 %66, i32* %17, align 4
  %67 = call i32 @block_dim()
  store i32 %67, i32* %18, align 4
  %68 = load i32, i32* %15, align 4
  store i32 %68, i32* %19, align 4
  br label %69

69:                                               ; preds = %155, %3
  %70 = load i32, i32* %19, align 4
  %71 = load i32, i32* %8, align 4
  %72 = icmp slt i32 %70, %71
  br i1 %72, label %73, label %159

73:                                               ; preds = %69
  %74 = load %struct.ListManager.3*, %struct.ListManager.3** %7, align 8
  %75 = load i32, i32* %19, align 4
  %76 = call dereferenceable(48) %struct.Element.82* @_ZN11ListManager3getI7ElementEERT_i(%struct.ListManager.3* %74, i32 %75)
  %77 = bitcast %struct.Element.82* %20 to i8*
  %78 = bitcast %struct.Element.82* %76 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %77, i8* align 8 %78, i64 48, i1 false)
  %79 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %20, i32 0, i32 1
  %80 = getelementptr inbounds [2 x i32], [2 x i32]* %79, i64 0, i64 0
  %81 = load i32, i32* %80, align 8
  %82 = load i32, i32* %17, align 4
  %83 = add nsw i32 %81, %82
  store i32 %83, i32* %21, align 4
  %84 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %20, i32 0, i32 1
  %85 = getelementptr inbounds [2 x i32], [2 x i32]* %84, i64 0, i64 1
  %86 = load i32, i32* %85, align 4
  store i32 %86, i32* %22, align 4
  %87 = load i32, i32* %21, align 4
  store i32 %87, i32* %23, align 4
  br label %88

88:                                               ; preds = %150, %73
  %89 = load i32, i32* %23, align 4
  %90 = load i32, i32* %22, align 4
  %91 = icmp slt i32 %89, %90
  br i1 %91, label %92, label %154

92:                                               ; preds = %88
  %93 = load void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)*, void (%struct.PhysicalCoordinates.0*, %struct.PhysicalCoordinates.0*, i32)** %10, align 8
  %94 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %20, i32 0, i32 2
  %95 = load i32, i32* %23, align 4
  call void %93(%struct.PhysicalCoordinates.0* %94, %struct.PhysicalCoordinates.0* %24, i32 %95)
  %96 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %11, align 8
  %97 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %98 = bitcast %struct.StructMeta.9* %97 to i8*
  %99 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %20, i32 0, i32 0
  %100 = load i8*, i8** %99, align 8
  %101 = load i32, i32* %23, align 4
  %102 = call i32 %96(i8* %98, i8* %100, i32 %101)
  %103 = icmp ne i32 %102, 0
  br i1 %103, label %104, label %149

104:                                              ; preds = %92
  %105 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %12, align 8
  %106 = load %struct.StructMeta.9*, %struct.StructMeta.9** %5, align 8
  %107 = bitcast %struct.StructMeta.9* %106 to i8*
  %108 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %20, i32 0, i32 0
  %109 = load i8*, i8** %108, align 8
  %110 = load i32, i32* %23, align 4
  %111 = call i8* %105(i8* %107, i8* %109, i32 %110)
  store i8* %111, i8** %25, align 8
  %112 = load i8* (i8*)*, i8* (i8*)** %14, align 8
  %113 = load i8*, i8** %25, align 8
  %114 = call i8* %112(i8* %113)
  store i8* %114, i8** %25, align 8
  %115 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %13, align 8
  %116 = load %struct.StructMeta.9*, %struct.StructMeta.9** %6, align 8
  %117 = bitcast %struct.StructMeta.9* %116 to i8*
  %118 = load i8*, i8** %25, align 8
  %119 = call i32 %115(i8* %117, i8* %118)
  store i32 %119, i32* %26, align 4
  %120 = call dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %26, i32* dereferenceable(4) @_ZL31taichi_listgen_max_element_size)
  %121 = load i32, i32* %120, align 4
  store i32 %121, i32* %27, align 4
  store i32 0, i32* %28, align 4
  br label %122

122:                                              ; preds = %144, %104
  %123 = load i32, i32* %28, align 4
  %124 = load i32, i32* %26, align 4
  %125 = icmp slt i32 %123, %124
  br i1 %125, label %126, label %148

126:                                              ; preds = %122
  %127 = load i8*, i8** %25, align 8
  %128 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %29, i32 0, i32 0
  store i8* %127, i8** %128, align 8
  %129 = load i32, i32* %28, align 4
  %130 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %29, i32 0, i32 1
  %131 = getelementptr inbounds [2 x i32], [2 x i32]* %130, i64 0, i64 0
  store i32 %129, i32* %131, align 8
  %132 = load i32, i32* %28, align 4
  %133 = load i32, i32* %27, align 4
  %134 = add nsw i32 %132, %133
  store i32 %134, i32* %30, align 4
  %135 = call dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %30, i32* dereferenceable(4) %26)
  %136 = load i32, i32* %135, align 4
  %137 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %29, i32 0, i32 1
  %138 = getelementptr inbounds [2 x i32], [2 x i32]* %137, i64 0, i64 1
  store i32 %136, i32* %138, align 4
  %139 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %29, i32 0, i32 2
  %140 = bitcast %struct.PhysicalCoordinates.0* %139 to i8*
  %141 = bitcast %struct.PhysicalCoordinates.0* %24 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %140, i8* align 4 %141, i64 32, i1 false)
  %142 = load %struct.ListManager.3*, %struct.ListManager.3** %9, align 8
  %143 = bitcast %struct.Element.82* %29 to i8*
  call void @_ZN11ListManager6appendEPv(%struct.ListManager.3* %142, i8* %143)
  br label %144

144:                                              ; preds = %126
  %145 = load i32, i32* %27, align 4
  %146 = load i32, i32* %28, align 4
  %147 = add nsw i32 %146, %145
  store i32 %147, i32* %28, align 4
  br label %122

148:                                              ; preds = %122
  br label %149

149:                                              ; preds = %148, %92
  br label %150

150:                                              ; preds = %149
  %151 = load i32, i32* %18, align 4
  %152 = load i32, i32* %23, align 4
  %153 = add nsw i32 %152, %151
  store i32 %153, i32* %23, align 4
  br label %88

154:                                              ; preds = %88
  br label %155

155:                                              ; preds = %154
  %156 = load i32, i32* %16, align 4
  %157 = load i32, i32* %19, align 4
  %158 = add nsw i32 %157, %156
  store i32 %158, i32* %19, align 4
  br label %69

159:                                              ; preds = %69
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %0) #1 align 2 {
  %2 = alloca %struct.ListManager.3*, align 8
  store %struct.ListManager.3* %0, %struct.ListManager.3** %2, align 8
  %3 = load %struct.ListManager.3*, %struct.ListManager.3** %2, align 8
  %4 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %3, i32 0, i32 5
  %5 = load i32, i32* %4, align 8
  ret i32 %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Pointer_get_num_elements(i8* %0, i8* %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load i8*, i8** %3, align 8
  %6 = bitcast i8* %5 to %struct.StructMeta.9*
  %7 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %6, i32 0, i32 2
  %8 = load i64, i64* %7, align 8
  %9 = trunc i64 %8 to i32
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @Pointer_deactivate(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i8**, align 8
  %10 = alloca %class.anon.6.19, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %11 = load i8*, i8** %4, align 8
  %12 = load i8*, i8** %5, align 8
  %13 = call i32 @Pointer_get_num_elements(i8* %11, i8* %12)
  store i32 %13, i32* %7, align 4
  %14 = load i8*, i8** %5, align 8
  %15 = load i32, i32* %6, align 4
  %16 = mul nsw i32 8, %15
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds i8, i8* %14, i64 %17
  store i8* %18, i8** %8, align 8
  %19 = load i8*, i8** %5, align 8
  %20 = load i32, i32* %7, align 4
  %21 = load i32, i32* %6, align 4
  %22 = add nsw i32 %20, %21
  %23 = mul nsw i32 8, %22
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds i8, i8* %19, i64 %24
  %26 = bitcast i8* %25 to i8**
  store i8** %26, i8*** %9, align 8
  %27 = load i8**, i8*** %9, align 8
  %28 = load i8*, i8** %27, align 8
  %29 = icmp ne i8* %28, null
  br i1 %29, label %30, label %35

30:                                               ; preds = %3
  %31 = load i8*, i8** %8, align 8
  %32 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %10, i32 0, i32 0
  %33 = load i8**, i8*** %9, align 8
  store i8** %33, i8*** %32, align 8
  %34 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %10, i32 0, i32 1
  store i8** %4, i8*** %34, align 8
  call void @"_Z11locked_taskIZ18Pointer_deactivateE3$_7EvPvRKT_"(i8* %31, %class.anon.6.19* dereferenceable(16) %10)
  br label %35

35:                                               ; preds = %30, %3
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ18Pointer_deactivateE3$_7EvPvRKT_"(i8* %0, %class.anon.6.19* dereferenceable(16) %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca %class.anon.6.19*, align 8
  %5 = alloca %2, align 1
  store i8* %0, i8** %3, align 8
  store %class.anon.6.19* %1, %class.anon.6.19** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %class.anon.6.19*, %class.anon.6.19** %4, align 8
  call void @"_Z11locked_taskIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %6, %class.anon.6.19* dereferenceable(16) %7, %2* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %0, %class.anon.6.19* dereferenceable(16) %1, %2* dereferenceable(1) %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca %class.anon.6.19*, align 8
  %6 = alloca %2*, align 8
  %7 = alloca %2, align 1
  store i8* %0, i8** %4, align 8
  store %class.anon.6.19* %1, %class.anon.6.19** %5, align 8
  store %2* %2, %2** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %class.anon.6.19*, %class.anon.6.19** %5, align 8
  %10 = load %2*, %2** %6, align 8
  call void @"_ZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%2* %7, i8* %8, %class.anon.6.19* dereferenceable(16) %9, %2* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%2* %0, i8* %1, %class.anon.6.19* dereferenceable(16) %2, %2* dereferenceable(1) %3) unnamed_addr #1 align 2 {
  %5 = alloca %2*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %class.anon.6.19*, align 8
  %8 = alloca %2*, align 8
  %9 = alloca %class.anon.45.20, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %2* %0, %2** %5, align 8
  store i8* %1, i8** %6, align 8
  store %class.anon.6.19* %2, %class.anon.6.19** %7, align 8
  store %2* %3, %2** %8, align 8
  %15 = load %2*, %2** %5, align 8
  %16 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %9, i32 0, i32 0
  %17 = load %2*, %2** %8, align 8
  store %2* %17, %2** %16, align 8
  %18 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %9, i32 0, i32 2
  %20 = load %class.anon.6.19*, %class.anon.6.19** %7, align 8
  store %class.anon.6.19* %20, %class.anon.6.19** %19, align 8
  %21 = call i32 @cuda_compute_capability()
  %22 = icmp slt i32 %21, 70
  br i1 %22, label %23, label %62

23:                                               ; preds = %4
  store i8 0, i8* %10, align 1
  %24 = load i8, i8* %10, align 1
  %25 = trunc i8 %24 to i1
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  %27 = call i32 @cuda_active_mask()
  store i32 %27, i32* %11, align 4
  %28 = load i32, i32* %11, align 4
  store i32 %28, i32* %12, align 4
  br label %29

29:                                               ; preds = %39, %26
  %30 = load i32, i32* %12, align 4
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %45

32:                                               ; preds = %29
  %33 = load i32, i32* %12, align 4
  %34 = call i32 @cttz_i32(i32 %33)
  store i32 %34, i32* %13, align 4
  %35 = call i32 @warp_idx()
  %36 = load i32, i32* %13, align 4
  %37 = icmp eq i32 %35, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %32
  call void @"_ZZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.45.20* %9)
  br label %39

39:                                               ; preds = %38, %32
  %40 = load i32, i32* %13, align 4
  %41 = shl i32 1, %40
  %42 = xor i32 %41, -1
  %43 = load i32, i32* %12, align 4
  %44 = and i32 %43, %42
  store i32 %44, i32* %12, align 4
  br label %29

45:                                               ; preds = %29
  br label %61

46:                                               ; preds = %23
  store i32 0, i32* %14, align 4
  br label %47

47:                                               ; preds = %57, %46
  %48 = load i32, i32* %14, align 4
  %49 = call i32 @warp_size()
  %50 = icmp slt i32 %48, %49
  br i1 %50, label %51, label %60

51:                                               ; preds = %47
  %52 = call i32 @warp_idx()
  %53 = load i32, i32* %14, align 4
  %54 = icmp eq i32 %52, %53
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  call void @"_ZZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.45.20* %9)
  br label %56

56:                                               ; preds = %55, %51
  br label %57

57:                                               ; preds = %56
  %58 = load i32, i32* %14, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %14, align 4
  br label %47

60:                                               ; preds = %47
  br label %61

61:                                               ; preds = %60, %45
  br label %63

62:                                               ; preds = %4
  call void @"_ZZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.45.20* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZ18Pointer_deactivateE3$_7Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%class.anon.45.20* %0) #1 align 2 {
  %2 = alloca %class.anon.45.20*, align 8
  store %class.anon.45.20* %0, %class.anon.45.20** %2, align 8
  %3 = load %class.anon.45.20*, %class.anon.45.20** %2, align 8
  %4 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %3, i32 0, i32 0
  %5 = load %2*, %2** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZ18Pointer_deactivateE3$_7EvPvRKT_ENKUlvE_clEv"(%2* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %3, i32 0, i32 0
  %12 = load %2*, %2** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZ18Pointer_deactivateE3$_7EvPvRKT_ENKUlvE_clEv"(%2* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %3, i32 0, i32 2
  %16 = load %class.anon.6.19*, %class.anon.6.19** %15, align 8
  call void @"_ZZ18Pointer_deactivateENK3$_7clEv"(%class.anon.6.19* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %class.anon.45.20, %class.anon.45.20* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZ18Pointer_deactivateE3$_7EvPvRKT_ENKUlvE_clEv"(%2* %0) #1 align 2 {
  %2 = alloca %2*, align 8
  store %2* %0, %2** %2, align 8
  %3 = load %2*, %2** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZ18Pointer_deactivateENK3$_7clEv"(%class.anon.6.19* %0) #1 align 2 {
  %2 = alloca %class.anon.6.19*, align 8
  %3 = alloca %struct.StructMeta.9*, align 8
  %4 = alloca %struct.LLVMRuntime.1*, align 8
  %5 = alloca %struct.NodeManager.4*, align 8
  store %class.anon.6.19* %0, %class.anon.6.19** %2, align 8
  %6 = load %class.anon.6.19*, %class.anon.6.19** %2, align 8
  %7 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %6, i32 0, i32 0
  %8 = load i8**, i8*** %7, align 8
  %9 = load i8*, i8** %8, align 8
  %10 = icmp ne i8* %9, null
  br i1 %10, label %11, label %35

11:                                               ; preds = %1
  %12 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %6, i32 0, i32 1
  %13 = load i8**, i8*** %12, align 8
  %14 = load i8*, i8** %13, align 8
  %15 = bitcast i8* %14 to %struct.StructMeta.9*
  store %struct.StructMeta.9* %15, %struct.StructMeta.9** %3, align 8
  %16 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %17 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %16, i32 0, i32 8
  %18 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %17, align 8
  %19 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %18, i32 0, i32 0
  %20 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %19, align 8
  store %struct.LLVMRuntime.1* %20, %struct.LLVMRuntime.1** %4, align 8
  %21 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %4, align 8
  %22 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %21, i32 0, i32 14
  %23 = load %struct.StructMeta.9*, %struct.StructMeta.9** %3, align 8
  %24 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %23, i32 0, i32 0
  %25 = load i32, i32* %24, align 8
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [1024 x %struct.NodeManager.4*], [1024 x %struct.NodeManager.4*]* %22, i64 0, i64 %26
  %28 = load %struct.NodeManager.4*, %struct.NodeManager.4** %27, align 8
  store %struct.NodeManager.4* %28, %struct.NodeManager.4** %5, align 8
  %29 = load %struct.NodeManager.4*, %struct.NodeManager.4** %5, align 8
  %30 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %6, i32 0, i32 0
  %31 = load i8**, i8*** %30, align 8
  %32 = load i8*, i8** %31, align 8
  call void @_ZN11NodeManager7recycleEPh(%struct.NodeManager.4* %29, i8* %32)
  %33 = getelementptr inbounds %class.anon.6.19, %class.anon.6.19* %6, i32 0, i32 0
  %34 = load i8**, i8*** %33, align 8
  store i8* null, i8** %34, align 8
  br label %35

35:                                               ; preds = %11, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11NodeManager7recycleEPh(%struct.NodeManager.4* %0, i8* %1) #1 align 2 {
  %3 = alloca %struct.NodeManager.4*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store %struct.NodeManager.4* %0, %struct.NodeManager.4** %3, align 8
  store i8* %1, i8** %4, align 8
  %6 = load %struct.NodeManager.4*, %struct.NodeManager.4** %3, align 8
  %7 = load i8*, i8** %4, align 8
  %8 = call i32 @_ZN11NodeManager6locateEPh(%struct.NodeManager.4* %6, i8* %7)
  store i32 %8, i32* %5, align 4
  %9 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %6, i32 0, i32 6
  %10 = load %struct.ListManager.3*, %struct.ListManager.3** %9, align 8
  %11 = bitcast i32* %5 to i8*
  call void @_ZN11ListManager6appendEPv(%struct.ListManager.3* %10, i8* %11)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11NodeManager6locateEPh(%struct.NodeManager.4* %0, i8* %1) #1 align 2 {
  %3 = alloca %struct.NodeManager.4*, align 8
  %4 = alloca i8*, align 8
  store %struct.NodeManager.4* %0, %struct.NodeManager.4** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load %struct.NodeManager.4*, %struct.NodeManager.4** %3, align 8
  %6 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %5, i32 0, i32 7
  %7 = load %struct.ListManager.3*, %struct.ListManager.3** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = call i32 @_ZN11ListManager9ptr2indexEPh(%struct.ListManager.3* %7, i8* %8)
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11ListManager9ptr2indexEPh(%struct.ListManager.3* %0, i8* %1) #1 align 2 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.ListManager.3*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %4, align 8
  store i8* %1, i8** %5, align 8
  %8 = load %struct.ListManager.3*, %struct.ListManager.3** %4, align 8
  %9 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 2
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 1
  %12 = load i64, i64* %11, align 8
  %13 = mul i64 %10, %12
  store i64 %13, i64* %6, align 8
  store i32 0, i32* %7, align 4
  br label %14

14:                                               ; preds = %65, %2
  %15 = load i32, i32* %7, align 4
  %16 = sext i32 %15 to i64
  %17 = icmp ult i64 %16, 131072
  br i1 %17, label %18, label %68

18:                                               ; preds = %14
  %19 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 6
  %20 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %19, align 8
  %21 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 0
  %22 = load i32, i32* %7, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %21, i64 0, i64 %23
  %25 = load i8*, i8** %24, align 8
  %26 = icmp ne i8* %25, null
  %27 = zext i1 %26 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.1* %20, i32 %27, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.31, i64 0, i64 0))
  %28 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 0
  %29 = load i32, i32* %7, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %28, i64 0, i64 %30
  %32 = load i8*, i8** %31, align 8
  %33 = load i8*, i8** %5, align 8
  %34 = icmp ule i8* %32, %33
  br i1 %34, label %35, label %64

35:                                               ; preds = %18
  %36 = load i8*, i8** %5, align 8
  %37 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 0
  %38 = load i32, i32* %7, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %37, i64 0, i64 %39
  %41 = load i8*, i8** %40, align 8
  %42 = load i64, i64* %6, align 8
  %43 = getelementptr inbounds i8, i8* %41, i64 %42
  %44 = icmp ult i8* %36, %43
  br i1 %44, label %45, label %64

45:                                               ; preds = %35
  %46 = load i32, i32* %7, align 4
  %47 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 3
  %48 = load i32, i32* %47, align 8
  %49 = shl i32 %46, %48
  %50 = load i8*, i8** %5, align 8
  %51 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 0
  %52 = load i32, i32* %7, align 4
  %53 = sext i32 %52 to i64
  %54 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %51, i64 0, i64 %53
  %55 = load i8*, i8** %54, align 8
  %56 = ptrtoint i8* %50 to i64
  %57 = ptrtoint i8* %55 to i64
  %58 = sub i64 %56, %57
  %59 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %8, i32 0, i32 1
  %60 = load i64, i64* %59, align 8
  %61 = udiv i64 %58, %60
  %62 = trunc i64 %61 to i32
  %63 = add nsw i32 %49, %62
  store i32 %63, i32* %3, align 4
  br label %69

64:                                               ; preds = %35, %18
  br label %65

65:                                               ; preds = %64
  %66 = load i32, i32* %7, align 4
  %67 = add nsw i32 %66, 1
  store i32 %67, i32* %7, align 4
  br label %14

68:                                               ; preds = %14
  store i32 -1, i32* %3, align 4
  br label %69

69:                                               ; preds = %68, %45
  %70 = load i32, i32* %3, align 4
  ret i32 %70
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Pointer_is_active(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %9 = load i8*, i8** %4, align 8
  %10 = load i8*, i8** %5, align 8
  %11 = call i32 @Pointer_get_num_elements(i8* %9, i8* %10)
  store i32 %11, i32* %7, align 4
  %12 = load i8*, i8** %5, align 8
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %6, align 4
  %15 = add nsw i32 %13, %14
  %16 = mul nsw i32 8, %15
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds i8, i8* %12, i64 %17
  %19 = bitcast i8* %18 to i8**
  %20 = load i8*, i8** %19, align 8
  store i8* %20, i8** %8, align 8
  %21 = load i8*, i8** %8, align 8
  %22 = icmp ne i8* %21, null
  %23 = zext i1 %22 to i32
  ret i32 %23
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @Pointer_lookup_element(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca %struct.StructMeta.9*, align 8
  %10 = alloca %struct.RuntimeContext.0*, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %11 = load i8*, i8** %4, align 8
  %12 = load i8*, i8** %5, align 8
  %13 = call i32 @Pointer_get_num_elements(i8* %11, i8* %12)
  store i32 %13, i32* %7, align 4
  %14 = load i8*, i8** %5, align 8
  %15 = load i32, i32* %7, align 4
  %16 = load i32, i32* %6, align 4
  %17 = add nsw i32 %15, %16
  %18 = mul nsw i32 8, %17
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds i8, i8* %14, i64 %19
  %21 = bitcast i8* %20 to i8**
  %22 = load i8*, i8** %21, align 8
  store i8* %22, i8** %8, align 8
  %23 = load i8*, i8** %8, align 8
  %24 = icmp eq i8* %23, null
  br i1 %24, label %25, label %41

25:                                               ; preds = %3
  %26 = load i8*, i8** %4, align 8
  %27 = bitcast i8* %26 to %struct.StructMeta.9*
  store %struct.StructMeta.9* %27, %struct.StructMeta.9** %9, align 8
  %28 = load %struct.StructMeta.9*, %struct.StructMeta.9** %9, align 8
  %29 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %28, i32 0, i32 8
  %30 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %29, align 8
  store %struct.RuntimeContext.0* %30, %struct.RuntimeContext.0** %10, align 8
  %31 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %10, align 8
  %32 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %31, i32 0, i32 0
  %33 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %32, align 8
  %34 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %33, i32 0, i32 16
  %35 = load %struct.StructMeta.9*, %struct.StructMeta.9** %9, align 8
  %36 = getelementptr inbounds %struct.StructMeta.9, %struct.StructMeta.9* %35, i32 0, i32 0
  %37 = load i32, i32* %36, align 8
  %38 = sext i32 %37 to i64
  %39 = getelementptr inbounds [1024 x i8*], [1024 x i8*]* %34, i64 0, i64 %38
  %40 = load i8*, i8** %39, align 8
  store i8* %40, i8** %8, align 8
  br label %41

41:                                               ; preds = %25, %3
  %42 = load i8*, i8** %8, align 8
  ret i8* %42
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Root_is_active(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  ret i32 1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @Root_lookup_element(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %7 = load i8*, i8** %5, align 8
  ret i8* %7
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Root_get_num_elements(i8* %0, i8* %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  ret i32 1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_0(%struct.RuntimeContext.0* %0, i32 %1) #1 {
  %3 = alloca %struct.RuntimeContext.0*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.LLVMRuntime.1*, align 8
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %3, align 8
  %7 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %6, i32 0, i32 0
  %8 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %7, align 8
  store %struct.LLVMRuntime.1* %8, %struct.LLVMRuntime.1** %5, align 8
  %9 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %3, align 8
  %10 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %5, align 8
  %11 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %10, i32 0, i32 14
  %12 = load i32, i32* %4, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1024 x %struct.NodeManager.4*], [1024 x %struct.NodeManager.4*]* %11, i64 0, i64 %13
  %15 = load %struct.NodeManager.4*, %struct.NodeManager.4** %14, align 8
  call void @gc_parallel_impl_0(%struct.RuntimeContext.0* %9, %struct.NodeManager.4* %15)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_impl_0(%struct.RuntimeContext.0* %0, %struct.NodeManager.4* %1) #1 {
  %3 = alloca %struct.RuntimeContext.0*, align 8
  %4 = alloca %struct.NodeManager.4*, align 8
  %5 = alloca %struct.ListManager.3*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %3, align 8
  store %struct.NodeManager.4* %1, %struct.NodeManager.4** %4, align 8
  %11 = load %struct.NodeManager.4*, %struct.NodeManager.4** %4, align 8
  %12 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %11, i32 0, i32 5
  %13 = load %struct.ListManager.3*, %struct.ListManager.3** %12, align 8
  store %struct.ListManager.3* %13, %struct.ListManager.3** %5, align 8
  %14 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %15 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %14)
  store i32 %15, i32* %6, align 4
  %16 = load %struct.NodeManager.4*, %struct.NodeManager.4** %4, align 8
  %17 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %16, i32 0, i32 4
  %18 = load i32, i32* %17, align 4
  store i32 %18, i32* %7, align 4
  %19 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %3, align 8
  %20 = call i32 @linear_thread_idx(%struct.RuntimeContext.0* %19)
  store i32 %20, i32* %8, align 4
  %21 = load i32, i32* %7, align 4
  %22 = mul nsw i32 %21, 2
  %23 = load i32, i32* %6, align 4
  %24 = icmp sgt i32 %22, %23
  br i1 %24, label %25, label %49

25:                                               ; preds = %2
  %26 = load i32, i32* %6, align 4
  %27 = load i32, i32* %7, align 4
  %28 = sub nsw i32 %26, %27
  store i32 %28, i32* %9, align 4
  br label %29

29:                                               ; preds = %33, %25
  %30 = load i32, i32* %8, align 4
  %31 = load i32, i32* %9, align 4
  %32 = icmp slt i32 %30, %31
  br i1 %32, label %33, label %48

33:                                               ; preds = %29
  %34 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %35 = load i32, i32* %7, align 4
  %36 = load i32, i32* %8, align 4
  %37 = add nsw i32 %35, %36
  %38 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %34, i32 %37)
  %39 = load i32, i32* %38, align 4
  %40 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %41 = load i32, i32* %8, align 4
  %42 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %40, i32 %41)
  store i32 %39, i32* %42, align 4
  %43 = call i32 @grid_dim()
  %44 = call i32 @block_dim()
  %45 = mul nsw i32 %43, %44
  %46 = load i32, i32* %8, align 4
  %47 = add nsw i32 %46, %45
  store i32 %47, i32* %8, align 4
  br label %29

48:                                               ; preds = %29
  br label %73

49:                                               ; preds = %2
  %50 = load i32, i32* %7, align 4
  store i32 %50, i32* %10, align 4
  br label %51

51:                                               ; preds = %55, %49
  %52 = load i32, i32* %8, align 4
  %53 = load i32, i32* %10, align 4
  %54 = icmp slt i32 %52, %53
  br i1 %54, label %55, label %72

55:                                               ; preds = %51
  %56 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %57 = load i32, i32* %6, align 4
  %58 = load i32, i32* %10, align 4
  %59 = sub nsw i32 %57, %58
  %60 = load i32, i32* %8, align 4
  %61 = add nsw i32 %59, %60
  %62 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %56, i32 %61)
  %63 = load i32, i32* %62, align 4
  %64 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %65 = load i32, i32* %8, align 4
  %66 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %64, i32 %65)
  store i32 %63, i32* %66, align 4
  %67 = call i32 @grid_dim()
  %68 = call i32 @block_dim()
  %69 = mul nsw i32 %67, %68
  %70 = load i32, i32* %8, align 4
  %71 = add nsw i32 %70, %69
  store i32 %71, i32* %8, align 4
  br label %51

72:                                               ; preds = %51
  br label %73

73:                                               ; preds = %72, %48
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @linear_thread_idx(%struct.RuntimeContext.0* %0) #1 {
  %2 = alloca %struct.RuntimeContext.0*, align 8
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %2, align 8
  %3 = call i32 @block_idx()
  %4 = call i32 @block_dim()
  %5 = mul nsw i32 %3, %4
  %6 = call i32 @thread_idx()
  %7 = add nsw i32 %5, %6
  ret i32 %7
}

; Function Attrs: alwaysinline nounwind uwtable
define internal dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %0, i32 %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %6 = load i32, i32* %4, align 4
  %7 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.3* %5, i32 %6)
  %8 = bitcast i8* %7 to i32*
  ret i32* %8
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_1(%struct.RuntimeContext.0* %0, i32 %1) #1 {
  %3 = alloca %struct.RuntimeContext.0*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.LLVMRuntime.1*, align 8
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %3, align 8
  %7 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %6, i32 0, i32 0
  %8 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %7, align 8
  store %struct.LLVMRuntime.1* %8, %struct.LLVMRuntime.1** %5, align 8
  %9 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %5, align 8
  %10 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %9, i32 0, i32 14
  %11 = load i32, i32* %4, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [1024 x %struct.NodeManager.4*], [1024 x %struct.NodeManager.4*]* %10, i64 0, i64 %12
  %14 = load %struct.NodeManager.4*, %struct.NodeManager.4** %13, align 8
  call void @gc_parallel_impl_1(%struct.NodeManager.4* %14)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_impl_1(%struct.NodeManager.4* %0) #1 {
  %2 = alloca %struct.NodeManager.4*, align 8
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  store %struct.NodeManager.4* %0, %struct.NodeManager.4** %2, align 8
  %5 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %6 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %5, i32 0, i32 5
  %7 = load %struct.ListManager.3*, %struct.ListManager.3** %6, align 8
  store %struct.ListManager.3* %7, %struct.ListManager.3** %3, align 8
  %8 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %9 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %8)
  %10 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %11 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %10, i32 0, i32 4
  %12 = load i32, i32* %11, align 4
  %13 = sub nsw i32 %9, %12
  %14 = call i32 @max_i32(i32 %13, i32 0)
  store i32 %14, i32* %4, align 4
  %15 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %16 = load i32, i32* %4, align 4
  call void @_ZN11ListManager6resizeEi(%struct.ListManager.3* %15, i32 %16)
  %17 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %18 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %17, i32 0, i32 4
  store i32 0, i32* %18, align 4
  %19 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %20 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %19, i32 0, i32 6
  %21 = load %struct.ListManager.3*, %struct.ListManager.3** %20, align 8
  %22 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %21)
  %23 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %24 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %23, i32 0, i32 8
  store i32 %22, i32* %24, align 8
  %25 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %26 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %25, i32 0, i32 6
  %27 = load %struct.ListManager.3*, %struct.ListManager.3** %26, align 8
  call void @_ZN11ListManager5clearEv(%struct.ListManager.3* %27)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @max_i32(i32 %0, i32 %1) #1 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load i32, i32* %4, align 4
  %7 = icmp sgt i32 %5, %6
  br i1 %7, label %8, label %10

8:                                                ; preds = %2
  %9 = load i32, i32* %3, align 4
  br label %12

10:                                               ; preds = %2
  %11 = load i32, i32* %4, align 4
  br label %12

12:                                               ; preds = %10, %8
  %13 = phi i32 [ %9, %8 ], [ %11, %10 ]
  ret i32 %13
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11ListManager6resizeEi(%struct.ListManager.3* %0, i32 %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %6 = load i32, i32* %4, align 4
  %7 = getelementptr inbounds %struct.ListManager.3, %struct.ListManager.3* %5, i32 0, i32 5
  store i32 %6, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_2(%struct.RuntimeContext.0* %0, i32 %1) #1 {
  %3 = alloca %struct.RuntimeContext.0*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.LLVMRuntime.1*, align 8
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %3, align 8
  %7 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %6, i32 0, i32 0
  %8 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %7, align 8
  store %struct.LLVMRuntime.1* %8, %struct.LLVMRuntime.1** %5, align 8
  %9 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %5, align 8
  %10 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %9, i32 0, i32 14
  %11 = load i32, i32* %4, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [1024 x %struct.NodeManager.4*], [1024 x %struct.NodeManager.4*]* %10, i64 0, i64 %12
  %14 = load %struct.NodeManager.4*, %struct.NodeManager.4** %13, align 8
  call void @gc_parallel_impl_2(%struct.NodeManager.4* %14)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gc_parallel_impl_2(%struct.NodeManager.4* %0) #1 {
  %2 = alloca %struct.NodeManager.4*, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct.ListManager.3*, align 8
  %5 = alloca %struct.ListManager.3*, align 8
  %6 = alloca %struct.ListManager.3*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i8*, align 8
  %11 = alloca i8*, align 8
  %12 = alloca i8*, align 8
  %13 = alloca i8*, align 8
  store %struct.NodeManager.4* %0, %struct.NodeManager.4** %2, align 8
  %14 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %15 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %14, i32 0, i32 8
  %16 = load i32, i32* %15, align 8
  store i32 %16, i32* %3, align 4
  %17 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %18 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %17, i32 0, i32 5
  %19 = load %struct.ListManager.3*, %struct.ListManager.3** %18, align 8
  store %struct.ListManager.3* %19, %struct.ListManager.3** %4, align 8
  %20 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %21 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %20, i32 0, i32 6
  %22 = load %struct.ListManager.3*, %struct.ListManager.3** %21, align 8
  store %struct.ListManager.3* %22, %struct.ListManager.3** %5, align 8
  %23 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %24 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %23, i32 0, i32 7
  %25 = load %struct.ListManager.3*, %struct.ListManager.3** %24, align 8
  store %struct.ListManager.3* %25, %struct.ListManager.3** %6, align 8
  %26 = load %struct.NodeManager.4*, %struct.NodeManager.4** %2, align 8
  %27 = getelementptr inbounds %struct.NodeManager.4, %struct.NodeManager.4* %26, i32 0, i32 2
  %28 = load i32, i32* %27, align 4
  store i32 %28, i32* %7, align 4
  %29 = call i32 @block_idx()
  store i32 %29, i32* %8, align 4
  br label %30

30:                                               ; preds = %107, %1
  %31 = load i32, i32* %8, align 4
  %32 = load i32, i32* %3, align 4
  %33 = icmp slt i32 %31, %32
  br i1 %33, label %34, label %111

34:                                               ; preds = %30
  %35 = load %struct.ListManager.3*, %struct.ListManager.3** %5, align 8
  %36 = load i32, i32* %8, align 4
  %37 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.3* %35, i32 %36)
  %38 = load i32, i32* %37, align 4
  store i32 %38, i32* %9, align 4
  %39 = load %struct.ListManager.3*, %struct.ListManager.3** %6, align 8
  %40 = load i32, i32* %9, align 4
  %41 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.3* %39, i32 %40)
  store i8* %41, i8** %10, align 8
  %42 = call i32 @thread_idx()
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %44, label %46

44:                                               ; preds = %34
  %45 = load %struct.ListManager.3*, %struct.ListManager.3** %4, align 8
  call void @_ZN11ListManager9push_backIiEEvRKT_(%struct.ListManager.3* %45, i32* dereferenceable(4) %9)
  br label %46

46:                                               ; preds = %44, %34
  %47 = load i8*, i8** %10, align 8
  %48 = load i32, i32* %7, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds i8, i8* %47, i64 %49
  store i8* %50, i8** %11, align 8
  %51 = load i8*, i8** %10, align 8
  %52 = ptrtoint i8* %51 to i64
  %53 = urem i64 %52, 4
  %54 = icmp ne i64 %53, 0
  br i1 %54, label %55, label %79

55:                                               ; preds = %46
  %56 = load i8*, i8** %10, align 8
  %57 = getelementptr inbounds i8, i8* %56, i64 4
  %58 = load i8*, i8** %10, align 8
  %59 = ptrtoint i8* %58 to i64
  %60 = urem i64 %59, 4
  %61 = sub i64 0, %60
  %62 = getelementptr inbounds i8, i8* %57, i64 %61
  store i8* %62, i8** %12, align 8
  %63 = call i32 @thread_idx()
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %65, label %77

65:                                               ; preds = %55
  %66 = load i8*, i8** %10, align 8
  store i8* %66, i8** %13, align 8
  br label %67

67:                                               ; preds = %73, %65
  %68 = load i8*, i8** %13, align 8
  %69 = load i8*, i8** %12, align 8
  %70 = icmp ult i8* %68, %69
  br i1 %70, label %71, label %76

71:                                               ; preds = %67
  %72 = load i8*, i8** %13, align 8
  store i8 0, i8* %72, align 1
  br label %73

73:                                               ; preds = %71
  %74 = load i8*, i8** %13, align 8
  %75 = getelementptr inbounds i8, i8* %74, i32 1
  store i8* %75, i8** %13, align 8
  br label %67

76:                                               ; preds = %67
  br label %77

77:                                               ; preds = %76, %55
  %78 = load i8*, i8** %12, align 8
  store i8* %78, i8** %10, align 8
  br label %79

79:                                               ; preds = %77, %46
  %80 = call i32 @thread_idx()
  %81 = sext i32 %80 to i64
  %82 = mul i64 %81, 4
  %83 = load i8*, i8** %10, align 8
  %84 = getelementptr inbounds i8, i8* %83, i64 %82
  store i8* %84, i8** %10, align 8
  br label %85

85:                                               ; preds = %90, %79
  %86 = load i8*, i8** %10, align 8
  %87 = getelementptr inbounds i8, i8* %86, i64 4
  %88 = load i8*, i8** %11, align 8
  %89 = icmp ule i8* %87, %88
  br i1 %89, label %90, label %98

90:                                               ; preds = %85
  %91 = load i8*, i8** %10, align 8
  %92 = bitcast i8* %91 to i32*
  store i32 0, i32* %92, align 4
  %93 = call i32 @block_dim()
  %94 = sext i32 %93 to i64
  %95 = mul i64 4, %94
  %96 = load i8*, i8** %10, align 8
  %97 = getelementptr inbounds i8, i8* %96, i64 %95
  store i8* %97, i8** %10, align 8
  br label %85

98:                                               ; preds = %85
  br label %99

99:                                               ; preds = %103, %98
  %100 = load i8*, i8** %10, align 8
  %101 = load i8*, i8** %11, align 8
  %102 = icmp ult i8* %100, %101
  br i1 %102, label %103, label %107

103:                                              ; preds = %99
  %104 = load i8*, i8** %10, align 8
  store i8 0, i8* %104, align 1
  %105 = load i8*, i8** %10, align 8
  %106 = getelementptr inbounds i8, i8* %105, i32 1
  store i8* %106, i8** %10, align 8
  br label %99

107:                                              ; preds = %99
  %108 = call i32 @grid_dim()
  %109 = load i32, i32* %8, align 4
  %110 = add nsw i32 %109, %108
  store i32 %110, i32* %8, align 4
  br label %30

111:                                              ; preds = %30
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @_ZN11ListManager9push_backIiEEvRKT_(%struct.ListManager.3* %0, i32* dereferenceable(4) %1) #1 align 2 {
  %3 = alloca %struct.ListManager.3*, align 8
  %4 = alloca i32*, align 8
  store %struct.ListManager.3* %0, %struct.ListManager.3** %3, align 8
  store i32* %1, i32** %4, align 8
  %5 = load %struct.ListManager.3*, %struct.ListManager.3** %3, align 8
  %6 = load i32*, i32** %4, align 8
  %7 = bitcast i32* %6 to i8*
  call void @_ZN11ListManager6appendEPv(%struct.ListManager.3* %5, i8* %7)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @parallel_struct_for_1(%struct.RuntimeContext.0* %0, i32 %1, i32 %2, i32 %3, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)* %4, i64 %5, i32 %6) #1 {
  %8 = alloca %struct.RuntimeContext.0*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)*, align 8
  %13 = alloca i64, align 8
  %14 = alloca i32, align 4
  %15 = alloca %struct.ListManager.3*, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca [1 x i8], align 8
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  %22 = alloca %struct.Element.82*, align 8
  %23 = alloca i32, align 4
  %24 = alloca i32, align 4
  store %struct.RuntimeContext.0* %0, %struct.RuntimeContext.0** %8, align 8
  store i32 %1, i32* %9, align 4
  store i32 %2, i32* %10, align 4
  store i32 %3, i32* %11, align 4
  store void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)* %4, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)** %12, align 8
  store i64 %5, i64* %13, align 8
  store i32 %6, i32* %14, align 4
  %25 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %8, align 8
  %26 = getelementptr inbounds %struct.RuntimeContext.0, %struct.RuntimeContext.0* %25, i32 0, i32 0
  %27 = load %struct.LLVMRuntime.1*, %struct.LLVMRuntime.1** %26, align 8
  %28 = getelementptr inbounds %struct.LLVMRuntime.1, %struct.LLVMRuntime.1* %27, i32 0, i32 13
  %29 = load i32, i32* %9, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [1024 x %struct.ListManager.3*], [1024 x %struct.ListManager.3*]* %28, i64 0, i64 %30
  %32 = load %struct.ListManager.3*, %struct.ListManager.3** %31, align 8
  store %struct.ListManager.3* %32, %struct.ListManager.3** %15, align 8
  %33 = load %struct.ListManager.3*, %struct.ListManager.3** %15, align 8
  %34 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.3* %33)
  store i32 %34, i32* %16, align 4
  %35 = call i32 @block_idx()
  store i32 %35, i32* %17, align 4
  store i32 1, i32* %11, align 4
  %36 = load i32, i32* %10, align 4
  %37 = load i32, i32* %11, align 4
  %38 = sdiv i32 %36, %37
  store i32 %38, i32* %19, align 4
  br label %39

39:                                               ; preds = %88, %7
  %40 = load i32, i32* %17, align 4
  %41 = load i32, i32* %11, align 4
  %42 = sdiv i32 %40, %41
  store i32 %42, i32* %20, align 4
  %43 = load i32, i32* %20, align 4
  %44 = load i32, i32* %16, align 4
  %45 = icmp sge i32 %43, %44
  br i1 %45, label %46, label %47

46:                                               ; preds = %39
  br label %92

47:                                               ; preds = %39
  %48 = load i32, i32* %17, align 4
  %49 = load i32, i32* %11, align 4
  %50 = srem i32 %48, %49
  store i32 %50, i32* %21, align 4
  %51 = load %struct.ListManager.3*, %struct.ListManager.3** %15, align 8
  %52 = load i32, i32* %20, align 4
  %53 = call dereferenceable(48) %struct.Element.82* @_ZN11ListManager3getI7ElementEERT_i(%struct.ListManager.3* %51, i32 %52)
  store %struct.Element.82* %53, %struct.Element.82** %22, align 8
  %54 = load %struct.Element.82*, %struct.Element.82** %22, align 8
  %55 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %54, i32 0, i32 1
  %56 = getelementptr inbounds [2 x i32], [2 x i32]* %55, i64 0, i64 0
  %57 = load i32, i32* %56, align 8
  %58 = load i32, i32* %21, align 4
  %59 = load i32, i32* %19, align 4
  %60 = mul nsw i32 %58, %59
  %61 = add nsw i32 %57, %60
  store i32 %61, i32* %23, align 4
  %62 = load %struct.Element.82*, %struct.Element.82** %22, align 8
  %63 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %62, i32 0, i32 1
  %64 = getelementptr inbounds [2 x i32], [2 x i32]* %63, i64 0, i64 0
  %65 = load i32, i32* %64, align 8
  %66 = load i32, i32* %21, align 4
  %67 = add nsw i32 %66, 1
  %68 = load i32, i32* %19, align 4
  %69 = mul nsw i32 %67, %68
  %70 = add nsw i32 %65, %69
  store i32 %70, i32* %24, align 4
  %71 = load %struct.Element.82*, %struct.Element.82** %22, align 8
  %72 = getelementptr inbounds %struct.Element.82, %struct.Element.82* %71, i32 0, i32 1
  %73 = getelementptr inbounds [2 x i32], [2 x i32]* %72, i64 0, i64 1
  %74 = call dereferenceable(4) i32* @_ZSt3minIiERKT_S2_S2_(i32* dereferenceable(4) %24, i32* dereferenceable(4) %73)
  %75 = load i32, i32* %74, align 4
  store i32 %75, i32* %24, align 4
  %76 = load i32, i32* %23, align 4
  %77 = load i32, i32* %24, align 4
  %78 = icmp slt i32 %76, %77
  br i1 %78, label %79, label %88

79:                                               ; preds = %47
  %80 = load void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)*, void (%struct.RuntimeContext.0*, i8*, %struct.Element.82*, i32, i32)** %12, align 8
  %81 = load %struct.RuntimeContext.0*, %struct.RuntimeContext.0** %8, align 8
  %82 = getelementptr inbounds [1 x i8], [1 x i8]* %18, i64 0, i64 0
  %83 = load %struct.ListManager.3*, %struct.ListManager.3** %15, align 8
  %84 = load i32, i32* %20, align 4
  %85 = call dereferenceable(48) %struct.Element.82* @_ZN11ListManager3getI7ElementEERT_i(%struct.ListManager.3* %83, i32 %84)
  %86 = load i32, i32* %23, align 4
  %87 = load i32, i32* %24, align 4
  call void %80(%struct.RuntimeContext.0* %81, i8* %82, %struct.Element.82* %85, i32 %86, i32 %87)
  br label %88

88:                                               ; preds = %79, %47
  %89 = call i32 @grid_dim()
  %90 = load i32, i32* %17, align 4
  %91 = add nsw i32 %90, %89
  store i32 %91, i32* %17, align 4
  br label %39

92:                                               ; preds = %46
  ret void
}

attributes #0 = { nounwind readnone }
attributes #1 = { alwaysinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { nounwind }
attributes #4 = { alwaysinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readnone speculatable willreturn }
attributes #6 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!nvvm.annotations = !{!0, !1, !2, !3, !4, !5, !6, !7, !8, !9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !72, !74, !74, !74, !74, !75, !75, !74}
!llvm.ident = !{!76}
!nvvmir.version = !{!77}
!llvm.module.flags = !{!78}

!0 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_23_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_686, !"kernel", i32 1}
!1 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_23_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_686, !"maxntidx", i32 1}
!2 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_23_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_686, !"minctasm", i32 2}
!3 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_0_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1687, !"kernel", i32 1}
!4 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_0_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1687, !"maxntidx", i32 64}
!5 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_0_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1687, !"minctasm", i32 2}
!6 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_21_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_672, !"kernel", i32 1}
!7 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_21_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_672, !"maxntidx", i32 1}
!8 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_21_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_672, !"minctasm", i32 2}
!9 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_22_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1730, !"kernel", i32 1}
!10 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_22_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1730, !"maxntidx", i32 16}
!11 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_22_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1730, !"minctasm", i32 2}
!12 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_1_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_626, !"kernel", i32 1}
!13 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_1_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_626, !"maxntidx", i32 1}
!14 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_1_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_626, !"minctasm", i32 2}
!15 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_2_listgen_S5pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1683, !"kernel", i32 1}
!16 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_2_listgen_S5pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1683, !"maxntidx", i32 16}
!17 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_2_listgen_S5pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1683, !"minctasm", i32 2}
!18 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_3_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_5, !"kernel", i32 1}
!19 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_3_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_5, !"maxntidx", i32 16}
!20 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_3_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_5, !"minctasm", i32 2}
!21 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_4_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_432, !"kernel", i32 1}
!22 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_4_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_432, !"maxntidx", i32 64}
!23 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_4_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_432, !"minctasm", i32 2}
!24 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_5_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1596, !"kernel", i32 1}
!25 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_5_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1596, !"maxntidx", i32 1}
!26 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_5_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1596, !"minctasm", i32 2}
!27 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_6_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_238, !"kernel", i32 1}
!28 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_6_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_238, !"maxntidx", i32 64}
!29 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_6_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_238, !"minctasm", i32 2}
!30 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_7_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_636, !"kernel", i32 1}
!31 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_7_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_636, !"maxntidx", i32 1}
!32 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_7_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_636, !"minctasm", i32 2}
!33 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_8_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1695, !"kernel", i32 1}
!34 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_8_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1695, !"maxntidx", i32 64}
!35 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_8_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1695, !"minctasm", i32 2}
!36 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_9_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_634, !"kernel", i32 1}
!37 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_9_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_634, !"maxntidx", i32 1}
!38 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_9_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_634, !"minctasm", i32 2}
!39 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_10_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1733, !"kernel", i32 1}
!40 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_10_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1733, !"maxntidx", i32 16}
!41 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_10_listgen_S4pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1733, !"minctasm", i32 2}
!42 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_11_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_118, !"kernel", i32 1}
!43 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_11_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_118, !"maxntidx", i32 16}
!44 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_11_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_118, !"minctasm", i32 2}
!45 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_12_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_481, !"kernel", i32 1}
!46 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_12_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_481, !"maxntidx", i32 64}
!47 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_12_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_481, !"minctasm", i32 2}
!48 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_13_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1645, !"kernel", i32 1}
!49 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_13_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1645, !"maxntidx", i32 1}
!50 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_13_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1645, !"minctasm", i32 2}
!51 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_14_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_223, !"kernel", i32 1}
!52 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_14_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_223, !"maxntidx", i32 64}
!53 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_14_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_223, !"minctasm", i32 2}
!54 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_15_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_685, !"kernel", i32 1}
!55 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_15_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_685, !"maxntidx", i32 1}
!56 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_15_serialT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_685, !"minctasm", i32 2}
!57 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_16_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1728, !"kernel", i32 1}
!58 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_16_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1728, !"maxntidx", i32 64}
!59 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_16_listgen_S3pointerT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1728, !"minctasm", i32 2}
!60 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_17_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_112, !"kernel", i32 1}
!61 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_17_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_112, !"maxntidx", i32 64}
!62 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_17_struct_forT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_112, !"minctasm", i32 2}
!63 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_18_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_491, !"kernel", i32 1}
!64 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_18_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_491, !"maxntidx", i32 64}
!65 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_18_gc_gather_listT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_491, !"minctasm", i32 2}
!66 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_19_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1655, !"kernel", i32 1}
!67 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_19_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1655, !"maxntidx", i32 1}
!68 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_19_gc_reinit_listsT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_1655, !"minctasm", i32 2}
!69 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_20_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_210, !"kernel", i32 1}
!70 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_20_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_210, !"maxntidx", i32 64}
!71 = !{void (%struct.RuntimeContext.0*)* @block1_deactivate_all_c80_0_kernel_20_gc_zero_fillT88eee0cc07837667f9a582aa05c5908c452ad6f4ffd479fe0dc309fd83b370d9_210, !"minctasm", i32 2}
!72 = !{null, !"align", i32 8}
!73 = !{null, !"align", i32 8, !"align", i32 65544, !"align", i32 131080}
!74 = !{null, !"align", i32 16}
!75 = !{null, !"align", i32 16, !"align", i32 65552, !"align", i32 131088}
!76 = !{!"clang version 10.0.0-4ubuntu1 "}
!77 = !{i32 1, i32 4}
!78 = !{i32 1, !"wchar_size", i32 4}
!79 = !{i32 32126}
!80 = !{i32 21721}
