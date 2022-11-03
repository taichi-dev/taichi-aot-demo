; ModuleID = '/home/taichigraphics/.cache/taichi/ticache/llvm/Tf2cb569bdeecaa27c4826f4e02a605acf82d35bcc3f0cda68c840984b858774a.ll'
source_filename = "kernel"
target triple = "nvptx64-nvidia-cuda"

%0 = type { [64 x i64], [64 x i8*] }
%struct.RuntimeContext.8 = type { %struct.LLVMRuntime.7*, [64 x i64], [32 x [8 x i32]], i32, [64 x i64], [64 x i8], i64* }
%struct.LLVMRuntime.7 = type { i8, i64, i8*, i8*, i8* (i8*, i64, i64)*, void (i8*)*, void (i8*, ...)*, i32 (i8*, i64, i8*, %struct.__va_list_tag.1*)*, i8*, [512 x i8*], [512 x i64], i8*, void (i8*, i32, i32, i8*, void (i8*, i32, i32)*)*, [1024 x %struct.ListManager.2*], [1024 x %struct.NodeManager.3*], %struct.NodeManager.3*, [1024 x i8*], i8*, %struct.RandState.4*, %struct.MemRequestQueue.6*, i8*, void (i8*, i8*)*, void (i8*)*, [2048 x i8], [32 x i64], i32, i64, i8*, i32, i32, i64, i8* }
%struct.__va_list_tag.1 = type { i32, i32, i8*, i8* }
%struct.ListManager.2 = type { [131072 x i8*], i64, i64, i32, i32, i32, %struct.LLVMRuntime.7* }
%struct.NodeManager.3 = type <{ %struct.LLVMRuntime.7*, i32, i32, i32, i32, %struct.ListManager.2*, %struct.ListManager.2*, %struct.ListManager.2*, i32, [4 x i8] }>
%struct.RandState.4 = type { i32, i32, i32, i32, i32 }
%struct.MemRequestQueue.6 = type { [65536 x %struct.MemRequest.5], i32, i32 }
%struct.MemRequest.5 = type { i64, i64, i8*, i64 }
%struct.DenseMeta.12 = type <{ %struct.StructMeta.10, i32, [4 x i8] }>
%struct.StructMeta.10 = type { i32, i64, i64, i8* (i8*, i8*, i32)*, i8* (i8*)*, i32 (i8*, i8*, i32)*, i32 (i8*, i8*)*, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)*, %struct.RuntimeContext.8* }
%struct.PhysicalCoordinates.0.9 = type { [8 x i32] }
%S0_ch.14 = type { [1048576 x %S1_ch.13], %0 }
%S1_ch.13 = type { float }

define void @fill_img_c78_0_kernel_0_range_forTf2cb569bdeecaa27c4826f4e02a605acf82d35bcc3f0cda68c840984b858774a_7704(%struct.RuntimeContext.8* byval(%struct.RuntimeContext.8) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gpu_parallel_range_for(%struct.RuntimeContext.8* %context, i32 0, i32 1048576, void (%struct.RuntimeContext.8*, i8*)* null, void (%struct.RuntimeContext.8*, i8*, i32)* @function_body, void (%struct.RuntimeContext.8*, i8*)* null, i64 1)
  br label %final
}

define internal void @function_body(%struct.RuntimeContext.8* %0, i8* %1, i32 %2) {
allocs:
  %3 = alloca i32
  %4 = alloca %struct.DenseMeta.12
  br label %entry

final:                                            ; preds = %after_if
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  store i32 %2, i32* %3
  %5 = load i32, i32* %3
  %6 = lshr i32 %5, 10
  %7 = and i32 %6, 1023
  %8 = lshr i32 %5, 0
  %9 = and i32 %8, 1023
  %10 = icmp slt i32 %7, 680
  %11 = sext i1 %10 to i32
  %12 = icmp slt i32 %9, 680
  %13 = sext i1 %12 to i32
  %14 = and i32 %11, %13
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %true_block, label %false_block

true_block:                                       ; preds = %function_body
  %16 = call %struct.LLVMRuntime.7* @RuntimeContext_get_runtime(%struct.RuntimeContext.8* %0)
  %17 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.7* %16, i32 0)
  %18 = bitcast i8* %17 to %S0_ch.14*
  %19 = getelementptr %S0_ch.14, %S0_ch.14* %18, i32 0
  %20 = bitcast %S0_ch.14* %19 to i8*
  %21 = call i8* @get_ch_S0_to_S1(i8* %20)
  %22 = bitcast i8* %21 to [1048576 x %S1_ch.13]*
  %23 = shl i32 %7, 10
  %24 = add i32 %9, %23
  %25 = bitcast %struct.DenseMeta.12* %4 to %struct.StructMeta.10*
  call void @StructMeta_set_snode_id(%struct.StructMeta.10* %25, i32 1)
  call void @StructMeta_set_element_size(%struct.StructMeta.10* %25, i64 4)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.10* %25, i64 1048576)
  call void @StructMeta_set_context(%struct.StructMeta.10* %25, %struct.RuntimeContext.8* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.10* %25, i8* (i8*, i8*, i32)* @Dense_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.10* %25, i32 (i8*, i8*, i32)* @Dense_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.10* %25, i32 (i8*, i8*)* @Dense_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.10* %25, i8* (i8*)* @get_ch_S0_to_S1)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.10* %25, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)* @S1_refine_coordinates)
  call void @DenseMeta_set_morton_dim(%struct.DenseMeta.12* %4, i32 0)
  %26 = bitcast %struct.DenseMeta.12* %4 to i8*
  %27 = bitcast [1048576 x %S1_ch.13]* %22 to i8*
  %28 = call i8* @Dense_lookup_element(i8* %26, i8* %27, i32 %24)
  %29 = call i8* @get_ch_S1_to_S2(i8* %28)
  %30 = bitcast i8* %29 to float*
  store float 0x3FA99999A0000000, float* %30
  br label %after_if

false_block:                                      ; preds = %function_body
  br label %after_if

after_if:                                         ; preds = %false_block, %true_block
  br label %final
}

define internal void @S1_refine_coordinates(%struct.PhysicalCoordinates.0.9* %0, %struct.PhysicalCoordinates.0.9* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 10
  %4 = and i32 %3, 1023
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 0)
  %6 = shl i32 %5, 10
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 1023
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 1)
  %11 = shl i32 %10, 10
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S1(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.14*
  %getch = getelementptr %S0_ch.14, %S0_ch.14* %1, i32 0, i32 0
  %2 = bitcast [1048576 x %S1_ch.13]* %getch to i8*
  ret i8* %2
}

define internal i8* @get_ch_S1_to_S2(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S1_ch.13*
  %getch = getelementptr %S1_ch.13, %S1_ch.13* %1, i32 0, i32 0
  %2 = bitcast float* %getch to i8*
  ret i8* %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.9* %0, i32 %1) #0 {
  %3 = alloca %struct.PhysicalCoordinates.0.9*, align 8
  %4 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.9* %0, %struct.PhysicalCoordinates.0.9** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9** %3, align 8
  %6 = getelementptr inbounds %struct.PhysicalCoordinates.0.9, %struct.PhysicalCoordinates.0.9* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [8 x i32], [8 x i32]* %6, i64 0, i64 %8
  %10 = load i32, i32* %9, align 4
  ret i32 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.9* %0, i32 %1, i32 %2) #0 {
  %4 = alloca %struct.PhysicalCoordinates.0.9*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.9* %0, %struct.PhysicalCoordinates.0.9** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = load %struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9** %4, align 8
  %9 = getelementptr inbounds %struct.PhysicalCoordinates.0.9, %struct.PhysicalCoordinates.0.9* %8, i32 0, i32 0
  %10 = load i32, i32* %5, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [8 x i32], [8 x i32]* %9, i64 0, i64 %11
  store i32 %7, i32* %12, align 4
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.LLVMRuntime.7* @RuntimeContext_get_runtime(%struct.RuntimeContext.8* %0) #0 {
  %2 = alloca %struct.RuntimeContext.8*, align 8
  store %struct.RuntimeContext.8* %0, %struct.RuntimeContext.8** %2, align 8
  %3 = load %struct.RuntimeContext.8*, %struct.RuntimeContext.8** %2, align 8
  %4 = getelementptr inbounds %struct.RuntimeContext.8, %struct.RuntimeContext.8* %3, i32 0, i32 0
  %5 = load %struct.LLVMRuntime.7*, %struct.LLVMRuntime.7** %4, align 8
  ret %struct.LLVMRuntime.7* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_snode_id(%struct.StructMeta.10* %0, i32 %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i32, align 4
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 0
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_element_size(%struct.StructMeta.10* %0, i64 %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 1
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_max_num_elements(%struct.StructMeta.10* %0, i64 %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 2
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_get_num_elements(%struct.StructMeta.10* %0, i32 (i8*, i8*)* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i32 (i8*, i8*)*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i32 (i8*, i8*)* %1, i32 (i8*, i8*)** %4, align 8
  %5 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 6
  store i32 (i8*, i8*)* %5, i32 (i8*, i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_lookup_element(%struct.StructMeta.10* %0, i8* (i8*, i8*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i8* (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i8* (i8*, i8*, i32)* %1, i8* (i8*, i8*, i32)** %4, align 8
  %5 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 3
  store i8* (i8*, i8*, i32)* %5, i8* (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_from_parent_element(%struct.StructMeta.10* %0, i8* (i8*)* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i8* (i8*)*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  %5 = load i8* (i8*)*, i8* (i8*)** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 4
  store i8* (i8*)* %5, i8* (i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_refine_coordinates(%struct.StructMeta.10* %0, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)* %1, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)** %4, align 8
  %5 = load void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)*, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 7
  store void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)* %5, void (%struct.PhysicalCoordinates.0.9*, %struct.PhysicalCoordinates.0.9*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_is_active(%struct.StructMeta.10* %0, i32 (i8*, i8*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca i32 (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store i32 (i8*, i8*, i32)* %1, i32 (i8*, i8*, i32)** %4, align 8
  %5 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 5
  store i32 (i8*, i8*, i32)* %5, i32 (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_context(%struct.StructMeta.10* %0, %struct.RuntimeContext.8* %1) #0 {
  %3 = alloca %struct.StructMeta.10*, align 8
  %4 = alloca %struct.RuntimeContext.8*, align 8
  store %struct.StructMeta.10* %0, %struct.StructMeta.10** %3, align 8
  store %struct.RuntimeContext.8* %1, %struct.RuntimeContext.8** %4, align 8
  %5 = load %struct.RuntimeContext.8*, %struct.RuntimeContext.8** %4, align 8
  %6 = load %struct.StructMeta.10*, %struct.StructMeta.10** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 8
  store %struct.RuntimeContext.8* %5, %struct.RuntimeContext.8** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.7* %0, i32 %1) #0 {
  %3 = alloca %struct.LLVMRuntime.7*, align 8
  %4 = alloca i32, align 4
  store %struct.LLVMRuntime.7* %0, %struct.LLVMRuntime.7** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.LLVMRuntime.7*, %struct.LLVMRuntime.7** %3, align 8
  %6 = getelementptr inbounds %struct.LLVMRuntime.7, %struct.LLVMRuntime.7* %5, i32 0, i32 9
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [512 x i8*], [512 x i8*]* %6, i64 0, i64 %8
  %10 = load i8*, i8** %9, align 8
  ret i8* %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gpu_parallel_range_for(%struct.RuntimeContext.8* %0, i32 %1, i32 %2, void (%struct.RuntimeContext.8*, i8*)* %3, void (%struct.RuntimeContext.8*, i8*, i32)* %4, void (%struct.RuntimeContext.8*, i8*)* %5, i64 %6) #0 {
  %8 = alloca %struct.RuntimeContext.8*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca void (%struct.RuntimeContext.8*, i8*)*, align 8
  %12 = alloca void (%struct.RuntimeContext.8*, i8*, i32)*, align 8
  %13 = alloca void (%struct.RuntimeContext.8*, i8*)*, align 8
  %14 = alloca i64, align 8
  %15 = alloca i32, align 4
  %16 = alloca i8*, align 8
  %17 = alloca i64, align 8
  %18 = alloca i8*, align 8
  store %struct.RuntimeContext.8* %0, %struct.RuntimeContext.8** %8, align 8
  store i32 %1, i32* %9, align 4
  store i32 %2, i32* %10, align 4
  store void (%struct.RuntimeContext.8*, i8*)* %3, void (%struct.RuntimeContext.8*, i8*)** %11, align 8
  store void (%struct.RuntimeContext.8*, i8*, i32)* %4, void (%struct.RuntimeContext.8*, i8*, i32)** %12, align 8
  store void (%struct.RuntimeContext.8*, i8*)* %5, void (%struct.RuntimeContext.8*, i8*)** %13, align 8
  store i64 %6, i64* %14, align 8
  %19 = call i32 @thread_idx()
  %20 = call i32 @block_dim()
  %21 = call i32 @block_idx()
  %22 = mul nsw i32 %20, %21
  %23 = add nsw i32 %19, %22
  %24 = load i32, i32* %9, align 4
  %25 = add nsw i32 %23, %24
  store i32 %25, i32* %15, align 4
  %26 = load i64, i64* %14, align 8
  %27 = call i8* @llvm.stacksave()
  store i8* %27, i8** %16, align 8
  %28 = alloca i8, i64 %26, align 8
  store i64 %26, i64* %17, align 8
  %29 = getelementptr inbounds i8, i8* %28, i64 0
  store i8* %29, i8** %18, align 8
  %30 = load void (%struct.RuntimeContext.8*, i8*)*, void (%struct.RuntimeContext.8*, i8*)** %11, align 8
  %31 = icmp ne void (%struct.RuntimeContext.8*, i8*)* %30, null
  br i1 %31, label %32, label %36

32:                                               ; preds = %7
  %33 = load void (%struct.RuntimeContext.8*, i8*)*, void (%struct.RuntimeContext.8*, i8*)** %11, align 8
  %34 = load %struct.RuntimeContext.8*, %struct.RuntimeContext.8** %8, align 8
  %35 = load i8*, i8** %18, align 8
  call void %33(%struct.RuntimeContext.8* %34, i8* %35)
  br label %36

36:                                               ; preds = %32, %7
  br label %37

37:                                               ; preds = %41, %36
  %38 = load i32, i32* %15, align 4
  %39 = load i32, i32* %10, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %51

41:                                               ; preds = %37
  %42 = load void (%struct.RuntimeContext.8*, i8*, i32)*, void (%struct.RuntimeContext.8*, i8*, i32)** %12, align 8
  %43 = load %struct.RuntimeContext.8*, %struct.RuntimeContext.8** %8, align 8
  %44 = load i8*, i8** %18, align 8
  %45 = load i32, i32* %15, align 4
  call void %42(%struct.RuntimeContext.8* %43, i8* %44, i32 %45)
  %46 = call i32 @block_dim()
  %47 = call i32 @grid_dim()
  %48 = mul nsw i32 %46, %47
  %49 = load i32, i32* %15, align 4
  %50 = add nsw i32 %49, %48
  store i32 %50, i32* %15, align 4
  br label %37

51:                                               ; preds = %37
  %52 = load void (%struct.RuntimeContext.8*, i8*)*, void (%struct.RuntimeContext.8*, i8*)** %13, align 8
  %53 = icmp ne void (%struct.RuntimeContext.8*, i8*)* %52, null
  br i1 %53, label %54, label %58

54:                                               ; preds = %51
  %55 = load void (%struct.RuntimeContext.8*, i8*)*, void (%struct.RuntimeContext.8*, i8*)** %13, align 8
  %56 = load %struct.RuntimeContext.8*, %struct.RuntimeContext.8** %8, align 8
  %57 = load i8*, i8** %18, align 8
  call void %55(%struct.RuntimeContext.8* %56, i8* %57)
  br label %58

58:                                               ; preds = %54, %51
  %59 = load i8*, i8** %16, align 8
  call void @llvm.stackrestore(i8* %59)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @thread_idx() #0 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @block_dim() #0 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x()
  ret i32 %0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @block_idx() #0 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
  ret i32 %0
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #1

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @grid_dim() #0 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
  ret i32 %0
}

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #1

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.x() #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.tid.x() #2

; Function Attrs: alwaysinline nounwind uwtable
define internal void @DenseMeta_set_morton_dim(%struct.DenseMeta.12* %0, i32 %1) #0 {
  %3 = alloca %struct.DenseMeta.12*, align 8
  %4 = alloca i32, align 4
  store %struct.DenseMeta.12* %0, %struct.DenseMeta.12** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.DenseMeta.12*, %struct.DenseMeta.12** %3, align 8
  %7 = getelementptr inbounds %struct.DenseMeta.12, %struct.DenseMeta.12* %6, i32 0, i32 1
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Dense_get_num_elements(i8* %0, i8* %1) #0 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load i8*, i8** %3, align 8
  %6 = bitcast i8* %5 to %struct.StructMeta.10*
  %7 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %6, i32 0, i32 2
  %8 = load i64, i64* %7, align 8
  %9 = trunc i64 %8 to i32
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Dense_is_active(i8* %0, i8* %1, i32 %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  ret i32 1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @Dense_lookup_element(i8* %0, i8* %1, i32 %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %7 = load i8*, i8** %5, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = bitcast i8* %8 to %struct.StructMeta.10*
  %10 = getelementptr inbounds %struct.StructMeta.10, %struct.StructMeta.10* %9, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = load i32, i32* %6, align 4
  %13 = sext i32 %12 to i64
  %14 = mul i64 %11, %13
  %15 = getelementptr inbounds i8, i8* %7, i64 %14
  ret i8* %15
}

attributes #0 = { alwaysinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind readnone }

!nvvm.annotations = !{!0, !1, !2, !3, !4, !3, !5, !5, !5, !5, !6, !6, !5}
!llvm.ident = !{!7}
!nvvmir.version = !{!8}
!llvm.module.flags = !{!9}

!0 = !{void (%struct.RuntimeContext.8*)* @fill_img_c78_0_kernel_0_range_forTf2cb569bdeecaa27c4826f4e02a605acf82d35bcc3f0cda68c840984b858774a_7704, !"kernel", i32 1}
!1 = !{void (%struct.RuntimeContext.8*)* @fill_img_c78_0_kernel_0_range_forTf2cb569bdeecaa27c4826f4e02a605acf82d35bcc3f0cda68c840984b858774a_7704, !"maxntidx", i32 128}
!2 = !{void (%struct.RuntimeContext.8*)* @fill_img_c78_0_kernel_0_range_forTf2cb569bdeecaa27c4826f4e02a605acf82d35bcc3f0cda68c840984b858774a_7704, !"minctasm", i32 2}
!3 = !{null, !"align", i32 8}
!4 = !{null, !"align", i32 8, !"align", i32 65544, !"align", i32 131080}
!5 = !{null, !"align", i32 16}
!6 = !{null, !"align", i32 16, !"align", i32 65552, !"align", i32 131088}
!7 = !{!"clang version 10.0.0-4ubuntu1 "}
!8 = !{i32 1, i32 4}
!9 = !{i32 1, !"wchar_size", i32 4}
