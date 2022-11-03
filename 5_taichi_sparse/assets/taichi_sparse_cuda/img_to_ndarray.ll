; ModuleID = '/home/taichigraphics/.cache/taichi/ticache/llvm/T36bf9df9d959ff9e0985a74cf87f5a9427461f732eb9d0f2c7005809a2e73cb3.ll'
source_filename = "kernel"
target triple = "nvptx64-nvidia-cuda"

%0 = type { [64 x i64], [64 x i8*] }
%struct.RuntimeContext.282 = type { %struct.LLVMRuntime.281*, [64 x i64], [32 x [8 x i32]], i32, [64 x i64], [64 x i8], i64* }
%struct.LLVMRuntime.281 = type { i8, i64, i8*, i8*, i8* (i8*, i64, i64)*, void (i8*)*, void (i8*, ...)*, i32 (i8*, i64, i8*, %struct.__va_list_tag.275*)*, i8*, [512 x i8*], [512 x i64], i8*, void (i8*, i32, i32, i8*, void (i8*, i32, i32)*)*, [1024 x %struct.ListManager.276*], [1024 x %struct.NodeManager.277*], %struct.NodeManager.277*, [1024 x i8*], i8*, %struct.RandState.278*, %struct.MemRequestQueue.280*, i8*, void (i8*, i8*)*, void (i8*)*, [2048 x i8], [32 x i64], i32, i64, i8*, i32, i32, i64, i8* }
%struct.__va_list_tag.275 = type { i32, i32, i8*, i8* }
%struct.ListManager.276 = type { [131072 x i8*], i64, i64, i32, i32, i32, %struct.LLVMRuntime.281* }
%struct.NodeManager.277 = type <{ %struct.LLVMRuntime.281*, i32, i32, i32, i32, %struct.ListManager.276*, %struct.ListManager.276*, %struct.ListManager.276*, i32, [4 x i8] }>
%struct.RandState.278 = type { i32, i32, i32, i32, i32 }
%struct.MemRequestQueue.280 = type { [65536 x %struct.MemRequest.279], i32, i32 }
%struct.MemRequest.279 = type { i64, i64, i8*, i64 }
%struct.DenseMeta.285 = type <{ %struct.StructMeta.284, i32, [4 x i8] }>
%struct.StructMeta.284 = type { i32, i64, i64, i8* (i8*, i8*, i32)*, i8* (i8*)*, i32 (i8*, i8*, i32)*, i32 (i8*, i8*)*, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)*, %struct.RuntimeContext.282* }
%struct.PhysicalCoordinates.0.283 = type { [8 x i32] }
%S0_ch.287 = type { [1048576 x %S1_ch.286], %0 }
%S1_ch.286 = type { float }

define void @img_to_ndarray_c76_0_kernel_0_range_forT36bf9df9d959ff9e0985a74cf87f5a9427461f732eb9d0f2c7005809a2e73cb3_7899(%struct.RuntimeContext.282* byval(%struct.RuntimeContext.282) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gpu_parallel_range_for(%struct.RuntimeContext.282* %context, i32 0, i32 1048576, void (%struct.RuntimeContext.282*, i8*)* null, void (%struct.RuntimeContext.282*, i8*, i32)* @function_body, void (%struct.RuntimeContext.282*, i8*)* null, i64 1)
  br label %final
}

define internal void @function_body(%struct.RuntimeContext.282* %0, i8* %1, i32 %2) {
allocs:
  %3 = alloca i32
  %4 = alloca %struct.DenseMeta.285
  %5 = alloca i32
  br label %entry

final:                                            ; preds = %after_if
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  store i32 %2, i32* %3
  %6 = load i32, i32* %3
  %7 = lshr i32 %6, 10
  %8 = and i32 %7, 1023
  %9 = lshr i32 %6, 0
  %10 = and i32 %9, 1023
  %11 = icmp slt i32 %8, 680
  %12 = sext i1 %11 to i32
  %13 = icmp slt i32 %10, 680
  %14 = sext i1 %13 to i32
  %15 = and i32 %12, %14
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %true_block, label %false_block

true_block:                                       ; preds = %function_body
  %17 = call i64 @RuntimeContext_get_args(%struct.RuntimeContext.282* %0, i32 0)
  %18 = inttoptr i64 %17 to float*
  %19 = call %struct.LLVMRuntime.281* @RuntimeContext_get_runtime(%struct.RuntimeContext.282* %0)
  %20 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.281* %19, i32 0)
  %21 = bitcast i8* %20 to %S0_ch.287*
  %22 = getelementptr %S0_ch.287, %S0_ch.287* %21, i32 0
  %23 = bitcast %S0_ch.287* %22 to i8*
  %24 = call i8* @get_ch_S0_to_S1(i8* %23)
  %25 = bitcast i8* %24 to [1048576 x %S1_ch.286]*
  %26 = shl i32 %8, 10
  %27 = add i32 %10, %26
  %28 = bitcast %struct.DenseMeta.285* %4 to %struct.StructMeta.284*
  call void @StructMeta_set_snode_id(%struct.StructMeta.284* %28, i32 1)
  call void @StructMeta_set_element_size(%struct.StructMeta.284* %28, i64 4)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.284* %28, i64 1048576)
  call void @StructMeta_set_context(%struct.StructMeta.284* %28, %struct.RuntimeContext.282* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.284* %28, i8* (i8*, i8*, i32)* @Dense_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.284* %28, i32 (i8*, i8*, i32)* @Dense_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.284* %28, i32 (i8*, i8*)* @Dense_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.284* %28, i8* (i8*)* @get_ch_S0_to_S1)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.284* %28, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)* @S1_refine_coordinates)
  call void @DenseMeta_set_morton_dim(%struct.DenseMeta.285* %4, i32 0)
  %29 = bitcast %struct.DenseMeta.285* %4 to i8*
  %30 = bitcast [1048576 x %S1_ch.286]* %25 to i8*
  %31 = call i8* @Dense_lookup_element(i8* %29, i8* %30, i32 %27)
  %32 = call i8* @get_ch_S1_to_S2(i8* %31)
  %33 = bitcast i8* %32 to float*
  %34 = call float @llvm.nvvm.ldg.global.f.f32.p0f32(float* %33, i32 32)
  store i32 0, i32* %5
  br label %for_loop_test

false_block:                                      ; preds = %function_body
  br label %after_if

after_if:                                         ; preds = %after_for, %false_block
  br label %final

for_loop_body:                                    ; preds = %for_loop_test
  %35 = load i32, i32* %5
  %36 = call i32 @RuntimeContext_get_extra_args(%struct.RuntimeContext.282* %0, i32 0, i32 0)
  %37 = call i32 @RuntimeContext_get_extra_args(%struct.RuntimeContext.282* %0, i32 0, i32 1)
  %38 = call i32 @RuntimeContext_get_extra_args(%struct.RuntimeContext.282* %0, i32 0, i32 2)
  %39 = mul i32 0, %36
  %40 = add i32 %39, %8
  %41 = mul i32 %40, %37
  %42 = add i32 %41, %10
  %43 = mul i32 %42, %38
  %44 = add i32 %43, %35
  %45 = getelementptr float, float* %18, i32 %44
  store float %34, float* %45
  br label %for_loop_inc

for_loop_inc:                                     ; preds = %for_loop_body
  %46 = load i32, i32* %5
  %47 = add i32 %46, 1
  store i32 %47, i32* %5
  br label %for_loop_test

after_for:                                        ; preds = %for_loop_test
  br label %after_if

for_loop_test:                                    ; preds = %for_loop_inc, %true_block
  %48 = load i32, i32* %5
  %49 = icmp slt i32 %48, 4
  br i1 %49, label %for_loop_body, label %after_for
}

; Function Attrs: argmemonly nounwind readonly
declare float @llvm.nvvm.ldg.global.f.f32.p0f32(float* nocapture, i32) #0

define internal void @S1_refine_coordinates(%struct.PhysicalCoordinates.0.283* %0, %struct.PhysicalCoordinates.0.283* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 10
  %4 = and i32 %3, 1023
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 0)
  %6 = shl i32 %5, 10
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 1023
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 1)
  %11 = shl i32 %10, 10
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S1(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.287*
  %getch = getelementptr %S0_ch.287, %S0_ch.287* %1, i32 0, i32 0
  %2 = bitcast [1048576 x %S1_ch.286]* %getch to i8*
  ret i8* %2
}

define internal i8* @get_ch_S1_to_S2(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S1_ch.286*
  %getch = getelementptr %S1_ch.286, %S1_ch.286* %1, i32 0, i32 0
  %2 = bitcast float* %getch to i8*
  ret i8* %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.283* %0, i32 %1) #1 {
  %3 = alloca %struct.PhysicalCoordinates.0.283*, align 8
  %4 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.283* %0, %struct.PhysicalCoordinates.0.283** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283** %3, align 8
  %6 = getelementptr inbounds %struct.PhysicalCoordinates.0.283, %struct.PhysicalCoordinates.0.283* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [8 x i32], [8 x i32]* %6, i64 0, i64 %8
  %10 = load i32, i32* %9, align 4
  ret i32 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.283* %0, i32 %1, i32 %2) #1 {
  %4 = alloca %struct.PhysicalCoordinates.0.283*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.283* %0, %struct.PhysicalCoordinates.0.283** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = load %struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283** %4, align 8
  %9 = getelementptr inbounds %struct.PhysicalCoordinates.0.283, %struct.PhysicalCoordinates.0.283* %8, i32 0, i32 0
  %10 = load i32, i32* %5, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [8 x i32], [8 x i32]* %9, i64 0, i64 %11
  store i32 %7, i32* %12, align 4
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @RuntimeContext_get_args(%struct.RuntimeContext.282* %0, i32 %1) #1 {
  %3 = alloca %struct.RuntimeContext.282*, align 8
  %4 = alloca i32, align 4
  store %struct.RuntimeContext.282* %0, %struct.RuntimeContext.282** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %3, align 8
  %6 = getelementptr inbounds %struct.RuntimeContext.282, %struct.RuntimeContext.282* %5, i32 0, i32 1
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [64 x i64], [64 x i64]* %6, i64 0, i64 %8
  %10 = load i64, i64* %9, align 8
  ret i64 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.LLVMRuntime.281* @RuntimeContext_get_runtime(%struct.RuntimeContext.282* %0) #1 {
  %2 = alloca %struct.RuntimeContext.282*, align 8
  store %struct.RuntimeContext.282* %0, %struct.RuntimeContext.282** %2, align 8
  %3 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %2, align 8
  %4 = getelementptr inbounds %struct.RuntimeContext.282, %struct.RuntimeContext.282* %3, i32 0, i32 0
  %5 = load %struct.LLVMRuntime.281*, %struct.LLVMRuntime.281** %4, align 8
  ret %struct.LLVMRuntime.281* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @RuntimeContext_get_extra_args(%struct.RuntimeContext.282* %0, i32 %1, i32 %2) #1 {
  %4 = alloca %struct.RuntimeContext.282*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.RuntimeContext.282* %0, %struct.RuntimeContext.282** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %4, align 8
  %8 = getelementptr inbounds %struct.RuntimeContext.282, %struct.RuntimeContext.282* %7, i32 0, i32 2
  %9 = load i32, i32* %5, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [32 x [8 x i32]], [32 x [8 x i32]]* %8, i64 0, i64 %10
  %12 = load i32, i32* %6, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [8 x i32], [8 x i32]* %11, i64 0, i64 %13
  %15 = load i32, i32* %14, align 4
  ret i32 %15
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_snode_id(%struct.StructMeta.284* %0, i32 %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i32, align 4
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 0
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_element_size(%struct.StructMeta.284* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 1
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_max_num_elements(%struct.StructMeta.284* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 2
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_get_num_elements(%struct.StructMeta.284* %0, i32 (i8*, i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i32 (i8*, i8*)*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i32 (i8*, i8*)* %1, i32 (i8*, i8*)** %4, align 8
  %5 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 6
  store i32 (i8*, i8*)* %5, i32 (i8*, i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_lookup_element(%struct.StructMeta.284* %0, i8* (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i8* (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i8* (i8*, i8*, i32)* %1, i8* (i8*, i8*, i32)** %4, align 8
  %5 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 3
  store i8* (i8*, i8*, i32)* %5, i8* (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_from_parent_element(%struct.StructMeta.284* %0, i8* (i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i8* (i8*)*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  %5 = load i8* (i8*)*, i8* (i8*)** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 4
  store i8* (i8*)* %5, i8* (i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_refine_coordinates(%struct.StructMeta.284* %0, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)* %1, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)** %4, align 8
  %5 = load void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)*, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 7
  store void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)* %5, void (%struct.PhysicalCoordinates.0.283*, %struct.PhysicalCoordinates.0.283*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_is_active(%struct.StructMeta.284* %0, i32 (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca i32 (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store i32 (i8*, i8*, i32)* %1, i32 (i8*, i8*, i32)** %4, align 8
  %5 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 5
  store i32 (i8*, i8*, i32)* %5, i32 (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_context(%struct.StructMeta.284* %0, %struct.RuntimeContext.282* %1) #1 {
  %3 = alloca %struct.StructMeta.284*, align 8
  %4 = alloca %struct.RuntimeContext.282*, align 8
  store %struct.StructMeta.284* %0, %struct.StructMeta.284** %3, align 8
  store %struct.RuntimeContext.282* %1, %struct.RuntimeContext.282** %4, align 8
  %5 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %4, align 8
  %6 = load %struct.StructMeta.284*, %struct.StructMeta.284** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 8
  store %struct.RuntimeContext.282* %5, %struct.RuntimeContext.282** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.281* %0, i32 %1) #1 {
  %3 = alloca %struct.LLVMRuntime.281*, align 8
  %4 = alloca i32, align 4
  store %struct.LLVMRuntime.281* %0, %struct.LLVMRuntime.281** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.LLVMRuntime.281*, %struct.LLVMRuntime.281** %3, align 8
  %6 = getelementptr inbounds %struct.LLVMRuntime.281, %struct.LLVMRuntime.281* %5, i32 0, i32 9
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [512 x i8*], [512 x i8*]* %6, i64 0, i64 %8
  %10 = load i8*, i8** %9, align 8
  ret i8* %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gpu_parallel_range_for(%struct.RuntimeContext.282* %0, i32 %1, i32 %2, void (%struct.RuntimeContext.282*, i8*)* %3, void (%struct.RuntimeContext.282*, i8*, i32)* %4, void (%struct.RuntimeContext.282*, i8*)* %5, i64 %6) #1 {
  %8 = alloca %struct.RuntimeContext.282*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca void (%struct.RuntimeContext.282*, i8*)*, align 8
  %12 = alloca void (%struct.RuntimeContext.282*, i8*, i32)*, align 8
  %13 = alloca void (%struct.RuntimeContext.282*, i8*)*, align 8
  %14 = alloca i64, align 8
  %15 = alloca i32, align 4
  %16 = alloca i8*, align 8
  %17 = alloca i64, align 8
  %18 = alloca i8*, align 8
  store %struct.RuntimeContext.282* %0, %struct.RuntimeContext.282** %8, align 8
  store i32 %1, i32* %9, align 4
  store i32 %2, i32* %10, align 4
  store void (%struct.RuntimeContext.282*, i8*)* %3, void (%struct.RuntimeContext.282*, i8*)** %11, align 8
  store void (%struct.RuntimeContext.282*, i8*, i32)* %4, void (%struct.RuntimeContext.282*, i8*, i32)** %12, align 8
  store void (%struct.RuntimeContext.282*, i8*)* %5, void (%struct.RuntimeContext.282*, i8*)** %13, align 8
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
  %30 = load void (%struct.RuntimeContext.282*, i8*)*, void (%struct.RuntimeContext.282*, i8*)** %11, align 8
  %31 = icmp ne void (%struct.RuntimeContext.282*, i8*)* %30, null
  br i1 %31, label %32, label %36

32:                                               ; preds = %7
  %33 = load void (%struct.RuntimeContext.282*, i8*)*, void (%struct.RuntimeContext.282*, i8*)** %11, align 8
  %34 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %8, align 8
  %35 = load i8*, i8** %18, align 8
  call void %33(%struct.RuntimeContext.282* %34, i8* %35)
  br label %36

36:                                               ; preds = %32, %7
  br label %37

37:                                               ; preds = %41, %36
  %38 = load i32, i32* %15, align 4
  %39 = load i32, i32* %10, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %51

41:                                               ; preds = %37
  %42 = load void (%struct.RuntimeContext.282*, i8*, i32)*, void (%struct.RuntimeContext.282*, i8*, i32)** %12, align 8
  %43 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %8, align 8
  %44 = load i8*, i8** %18, align 8
  %45 = load i32, i32* %15, align 4
  call void %42(%struct.RuntimeContext.282* %43, i8* %44, i32 %45)
  %46 = call i32 @block_dim()
  %47 = call i32 @grid_dim()
  %48 = mul nsw i32 %46, %47
  %49 = load i32, i32* %15, align 4
  %50 = add nsw i32 %49, %48
  store i32 %50, i32* %15, align 4
  br label %37

51:                                               ; preds = %37
  %52 = load void (%struct.RuntimeContext.282*, i8*)*, void (%struct.RuntimeContext.282*, i8*)** %13, align 8
  %53 = icmp ne void (%struct.RuntimeContext.282*, i8*)* %52, null
  br i1 %53, label %54, label %58

54:                                               ; preds = %51
  %55 = load void (%struct.RuntimeContext.282*, i8*)*, void (%struct.RuntimeContext.282*, i8*)** %13, align 8
  %56 = load %struct.RuntimeContext.282*, %struct.RuntimeContext.282** %8, align 8
  %57 = load i8*, i8** %18, align 8
  call void %55(%struct.RuntimeContext.282* %56, i8* %57)
  br label %58

58:                                               ; preds = %54, %51
  %59 = load i8*, i8** %16, align 8
  call void @llvm.stackrestore(i8* %59)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @thread_idx() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  ret i32 %0
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

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @grid_dim() #1 {
entry:
  %0 = call i32 @llvm.nvvm.read.ptx.sreg.nctaid.x()
  ret i32 %0
}

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.nctaid.x() #3

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #3

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #3

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.read.ptx.sreg.tid.x() #3

; Function Attrs: alwaysinline nounwind uwtable
define internal void @DenseMeta_set_morton_dim(%struct.DenseMeta.285* %0, i32 %1) #1 {
  %3 = alloca %struct.DenseMeta.285*, align 8
  %4 = alloca i32, align 4
  store %struct.DenseMeta.285* %0, %struct.DenseMeta.285** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.DenseMeta.285*, %struct.DenseMeta.285** %3, align 8
  %7 = getelementptr inbounds %struct.DenseMeta.285, %struct.DenseMeta.285* %6, i32 0, i32 1
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Dense_get_num_elements(i8* %0, i8* %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load i8*, i8** %3, align 8
  %6 = bitcast i8* %5 to %struct.StructMeta.284*
  %7 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %6, i32 0, i32 2
  %8 = load i64, i64* %7, align 8
  %9 = trunc i64 %8 to i32
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Dense_is_active(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  ret i32 1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @Dense_lookup_element(i8* %0, i8* %1, i32 %2) #1 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %7 = load i8*, i8** %5, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = bitcast i8* %8 to %struct.StructMeta.284*
  %10 = getelementptr inbounds %struct.StructMeta.284, %struct.StructMeta.284* %9, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = load i32, i32* %6, align 4
  %13 = sext i32 %12 to i64
  %14 = mul i64 %11, %13
  %15 = getelementptr inbounds i8, i8* %7, i64 %14
  ret i8* %15
}

attributes #0 = { argmemonly nounwind readonly }
attributes #1 = { alwaysinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind readnone }

!nvvm.annotations = !{!0, !1, !2, !3, !4, !3, !5, !5, !5, !5, !6, !6, !5}
!llvm.ident = !{!7}
!nvvmir.version = !{!8}
!llvm.module.flags = !{!9}

!0 = !{void (%struct.RuntimeContext.282*)* @img_to_ndarray_c76_0_kernel_0_range_forT36bf9df9d959ff9e0985a74cf87f5a9427461f732eb9d0f2c7005809a2e73cb3_7899, !"kernel", i32 1}
!1 = !{void (%struct.RuntimeContext.282*)* @img_to_ndarray_c76_0_kernel_0_range_forT36bf9df9d959ff9e0985a74cf87f5a9427461f732eb9d0f2c7005809a2e73cb3_7899, !"maxntidx", i32 128}
!2 = !{void (%struct.RuntimeContext.282*)* @img_to_ndarray_c76_0_kernel_0_range_forT36bf9df9d959ff9e0985a74cf87f5a9427461f732eb9d0f2c7005809a2e73cb3_7899, !"minctasm", i32 2}
!3 = !{null, !"align", i32 8}
!4 = !{null, !"align", i32 8, !"align", i32 65544, !"align", i32 131080}
!5 = !{null, !"align", i32 16}
!6 = !{null, !"align", i32 16, !"align", i32 65552, !"align", i32 131088}
!7 = !{!"clang version 10.0.0-4ubuntu1 "}
!8 = !{i32 1, i32 4}
!9 = !{i32 1, !"wchar_size", i32 4}
