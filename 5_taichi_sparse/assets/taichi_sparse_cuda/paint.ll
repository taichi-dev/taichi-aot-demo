; ModuleID = '/home/taichigraphics/.cache/taichi/ticache/llvm/Tb6f66a228a45063ecc954f4153808e5c3fcfa3bc6be19e2aa841613469eb0462.ll'
source_filename = "kernel"
target triple = "nvptx64-nvidia-cuda"

%0 = type { [64 x i64], [64 x i8*] }
%1 = type { [16 x i64], [16 x i8*] }
%2 = type { %1 }
%3 = type { [16 x %S6_ch.28] }
%struct.RuntimeContext.268 = type { %struct.LLVMRuntime.267*, [64 x i64], [32 x [8 x i32]], i32, [64 x i64], [64 x i8], i64* }
%struct.LLVMRuntime.267 = type { i8, i64, i8*, i8*, i8* (i8*, i64, i64)*, void (i8*)*, void (i8*, ...)*, i32 (i8*, i64, i8*, %struct.__va_list_tag.261*)*, i8*, [512 x i8*], [512 x i64], i8*, void (i8*, i32, i32, i8*, void (i8*, i32, i32)*)*, [1024 x %struct.ListManager.262*], [1024 x %struct.NodeManager.263*], %struct.NodeManager.263*, [1024 x i8*], i8*, %struct.RandState.264*, %struct.MemRequestQueue.266*, i8*, void (i8*, i8*)*, void (i8*)*, [2048 x i8], [32 x i64], i32, i64, i8*, i32, i32, i64, i8* }
%struct.__va_list_tag.261 = type { i32, i32, i8*, i8* }
%struct.ListManager.262 = type { [131072 x i8*], i64, i64, i32, i32, i32, %struct.LLVMRuntime.267* }
%struct.NodeManager.263 = type <{ %struct.LLVMRuntime.267*, i32, i32, i32, i32, %struct.ListManager.262*, %struct.ListManager.262*, %struct.ListManager.262*, i32, [4 x i8] }>
%struct.RandState.264 = type { i32, i32, i32, i32, i32 }
%struct.MemRequestQueue.266 = type { [65536 x %struct.MemRequest.265], i32, i32 }
%struct.MemRequest.265 = type { i64, i64, i8*, i64 }
%struct.PointerMeta.272 = type <{ %struct.StructMeta.270, i8, [7 x i8] }>
%struct.StructMeta.270 = type { i32, i64, i64, i8* (i8*, i8*, i32)*, i8* (i8*)*, i32 (i8*, i8*, i32)*, i32 (i8*, i8*)*, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)*, %struct.RuntimeContext.268* }
%struct.PhysicalCoordinates.0.269 = type { [8 x i32] }
%struct.DenseMeta.271 = type <{ %struct.StructMeta.270, i32, [4 x i8] }>
%S0_ch.274 = type { [1048576 x %S1_ch.273], %0 }
%S1_ch.273 = type { float }
%S6_ch.28 = type { i32 }

define void @paint_c84_0_kernel_0_range_forTb6f66a228a45063ecc954f4153808e5c3fcfa3bc6be19e2aa841613469eb0462_6905(%struct.RuntimeContext.268* byval(%struct.RuntimeContext.268) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gpu_parallel_range_for(%struct.RuntimeContext.268* %context, i32 0, i32 262144, void (%struct.RuntimeContext.268*, i8*)* null, void (%struct.RuntimeContext.268*, i8*, i32)* @function_body, void (%struct.RuntimeContext.268*, i8*)* null, i64 1)
  br label %final
}

define internal void @function_body(%struct.RuntimeContext.268* %0, i8* %1, i32 %2) {
allocs:
  %3 = alloca i32
  %4 = alloca %struct.PointerMeta.272
  %5 = alloca %struct.PointerMeta.272
  %6 = alloca %struct.PointerMeta.272
  %7 = alloca %struct.DenseMeta.271
  %8 = alloca %struct.PointerMeta.272
  %9 = alloca %struct.PointerMeta.272
  %10 = alloca %struct.PointerMeta.272
  %11 = alloca %struct.PointerMeta.272
  %12 = alloca %struct.PointerMeta.272
  %13 = alloca %struct.PointerMeta.272
  %14 = alloca %struct.DenseMeta.271
  br label %entry

final:                                            ; preds = %function_body
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  store i32 %2, i32* %3
  %15 = load i32, i32* %3
  %16 = sdiv i32 %15, 512
  %17 = icmp slt i32 %15, 0
  %18 = sext i1 %17 to i32
  %19 = shl i32 %16, 9
  %20 = icmp ne i32 %18, 0
  %21 = sext i1 %20 to i32
  %22 = icmp ne i32 %15, 0
  %23 = sext i1 %22 to i32
  %24 = icmp ne i32 %19, %15
  %25 = sext i1 %24 to i32
  %26 = and i32 %21, %23
  %27 = and i32 %26, %25
  %28 = add i32 %16, %27
  %29 = shl i32 %28, 9
  %30 = sub i32 %15, %29
  %31 = call %struct.LLVMRuntime.267* @RuntimeContext_get_runtime(%struct.RuntimeContext.268* %0)
  %32 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.267* %31, i32 0)
  %33 = bitcast i8* %32 to %S0_ch.274*
  %34 = getelementptr %S0_ch.274, %S0_ch.274* %33, i32 0
  %35 = bitcast %S0_ch.274* %34 to i8*
  %36 = call i8* @get_ch_S0_to_S3(i8* %35)
  %37 = bitcast i8* %36 to %0*
  %38 = lshr i32 %28, 6
  %39 = and i32 %38, 7
  %40 = lshr i32 %30, 6
  %41 = and i32 %40, 7
  %42 = shl i32 %39, 3
  %43 = add i32 %41, %42
  %44 = bitcast %struct.PointerMeta.272* %4 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %44, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %44, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %44, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.270* %44, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %44, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %44, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %44, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %44, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %44, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S3_refine_coordinates)
  %45 = bitcast %struct.PointerMeta.272* %4 to i8*
  %46 = bitcast %0* %37 to i8*
  %47 = call i8* @Pointer_lookup_element(i8* %45, i8* %46, i32 %43)
  %48 = call i8* @get_ch_S3_to_S4(i8* %47)
  %49 = bitcast i8* %48 to %1*
  %50 = lshr i32 %28, 4
  %51 = and i32 %50, 3
  %52 = lshr i32 %30, 4
  %53 = and i32 %52, 3
  %54 = shl i32 %51, 2
  %55 = add i32 %53, %54
  %56 = bitcast %struct.PointerMeta.272* %5 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %56, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %56, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %56, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %56, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %56, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %56, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %56, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %56, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %56, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S4_refine_coordinates)
  %57 = bitcast %struct.PointerMeta.272* %5 to i8*
  %58 = bitcast %1* %49 to i8*
  %59 = call i8* @Pointer_lookup_element(i8* %57, i8* %58, i32 %55)
  %60 = call i8* @get_ch_S4_to_S5(i8* %59)
  %61 = bitcast i8* %60 to %1*
  %62 = lshr i32 %28, 2
  %63 = and i32 %62, 3
  %64 = lshr i32 %30, 2
  %65 = and i32 %64, 3
  %66 = shl i32 %63, 2
  %67 = add i32 %65, %66
  %68 = bitcast %struct.PointerMeta.272* %6 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %68, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %68, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %68, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %68, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %68, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %68, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %68, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %68, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %68, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S5_refine_coordinates)
  %69 = bitcast %struct.PointerMeta.272* %6 to i8*
  %70 = bitcast %1* %61 to i8*
  %71 = call i8* @Pointer_lookup_element(i8* %69, i8* %70, i32 %67)
  %72 = call i8* @get_ch_S5_to_S6(i8* %71)
  %73 = bitcast i8* %72 to [16 x %S6_ch.28]*
  %74 = lshr i32 %28, 0
  %75 = and i32 %74, 3
  %76 = lshr i32 %30, 0
  %77 = and i32 %76, 3
  %78 = shl i32 %75, 2
  %79 = add i32 %77, %78
  %80 = bitcast %struct.DenseMeta.271* %7 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %80, i32 6)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %80, i64 4)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %80, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %80, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %80, i8* (i8*, i8*, i32)* @Dense_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %80, i32 (i8*, i8*, i32)* @Dense_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %80, i32 (i8*, i8*)* @Dense_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %80, i8* (i8*)* @get_ch_S5_to_S6)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %80, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S6_refine_coordinates)
  call void @DenseMeta_set_morton_dim(%struct.DenseMeta.271* %7, i32 0)
  %81 = bitcast %struct.DenseMeta.271* %7 to i8*
  %82 = bitcast [16 x %S6_ch.28]* %73 to i8*
  %83 = call i8* @Dense_lookup_element(i8* %81, i8* %82, i32 %79)
  %84 = call i8* @get_ch_S6_to_S7(i8* %83)
  %85 = bitcast i8* %84 to i32*
  %86 = call i32 @llvm.nvvm.ldg.global.i.i32.p0i32(i32* %85, i32 32)
  %87 = sdiv i32 %28, 64
  %88 = icmp slt i32 %28, 0
  %89 = sext i1 %88 to i32
  %90 = shl i32 %87, 6
  %91 = icmp ne i32 %89, 0
  %92 = sext i1 %91 to i32
  %93 = icmp ne i32 %28, 0
  %94 = sext i1 %93 to i32
  %95 = icmp ne i32 %90, %28
  %96 = sext i1 %95 to i32
  %97 = and i32 %92, %94
  %98 = and i32 %97, %96
  %99 = add i32 %87, %98
  %100 = sdiv i32 %30, 64
  %101 = icmp slt i32 %30, 0
  %102 = sext i1 %101 to i32
  %103 = shl i32 %100, 6
  %104 = icmp ne i32 %102, 0
  %105 = sext i1 %104 to i32
  %106 = icmp ne i32 %30, 0
  %107 = sext i1 %106 to i32
  %108 = icmp ne i32 %103, %30
  %109 = sext i1 %108 to i32
  %110 = and i32 %105, %107
  %111 = and i32 %110, %109
  %112 = add i32 %100, %111
  %113 = sdiv i32 %28, 16
  %114 = shl i32 %113, 4
  %115 = icmp ne i32 %114, %28
  %116 = sext i1 %115 to i32
  %117 = and i32 %97, %116
  %118 = add i32 %113, %117
  %119 = sdiv i32 %30, 16
  %120 = shl i32 %119, 4
  %121 = icmp ne i32 %120, %30
  %122 = sext i1 %121 to i32
  %123 = and i32 %110, %122
  %124 = add i32 %119, %123
  %125 = sdiv i32 %28, 4
  %126 = shl i32 %125, 2
  %127 = icmp ne i32 %126, %28
  %128 = sext i1 %127 to i32
  %129 = and i32 %97, %128
  %130 = add i32 %125, %129
  %131 = sdiv i32 %30, 4
  %132 = shl i32 %131, 2
  %133 = icmp ne i32 %132, %30
  %134 = sext i1 %133 to i32
  %135 = and i32 %110, %134
  %136 = add i32 %131, %135
  %137 = lshr i32 %99, 0
  %138 = and i32 %137, 7
  %139 = lshr i32 %112, 0
  %140 = and i32 %139, 7
  %141 = shl i32 %138, 3
  %142 = add i32 %140, %141
  %143 = bitcast %struct.PointerMeta.272* %8 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %143, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %143, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %143, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.270* %143, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %143, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %143, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %143, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %143, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %143, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S3_refine_coordinates)
  %144 = bitcast %struct.PointerMeta.272* %8 to i8*
  %145 = bitcast %0* %37 to i8*
  %146 = call i32 @Pointer_is_active(i8* %144, i8* %145, i32 %142)
  %147 = add i32 %86, %146
  %148 = lshr i32 %118, 2
  %149 = and i32 %148, 7
  %150 = lshr i32 %124, 2
  %151 = and i32 %150, 7
  %152 = shl i32 %149, 3
  %153 = add i32 %151, %152
  %154 = bitcast %struct.PointerMeta.272* %9 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %154, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %154, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %154, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.270* %154, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %154, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %154, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %154, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %154, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %154, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S3_refine_coordinates)
  %155 = bitcast %struct.PointerMeta.272* %9 to i8*
  %156 = bitcast %0* %37 to i8*
  %157 = call i8* @Pointer_lookup_element(i8* %155, i8* %156, i32 %153)
  %158 = call i8* @get_ch_S3_to_S4(i8* %157)
  %159 = bitcast i8* %158 to %1*
  %160 = lshr i32 %118, 0
  %161 = and i32 %160, 3
  %162 = lshr i32 %124, 0
  %163 = and i32 %162, 3
  %164 = shl i32 %161, 2
  %165 = add i32 %163, %164
  %166 = bitcast %struct.PointerMeta.272* %10 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %166, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %166, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %166, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %166, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %166, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %166, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %166, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %166, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %166, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S4_refine_coordinates)
  %167 = bitcast %struct.PointerMeta.272* %10 to i8*
  %168 = bitcast %1* %159 to i8*
  %169 = call i32 @Pointer_is_active(i8* %167, i8* %168, i32 %165)
  %170 = add i32 %147, %169
  %171 = lshr i32 %130, 4
  %172 = and i32 %171, 7
  %173 = lshr i32 %136, 4
  %174 = and i32 %173, 7
  %175 = shl i32 %172, 3
  %176 = add i32 %174, %175
  %177 = bitcast %struct.PointerMeta.272* %11 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %177, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %177, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %177, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.270* %177, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %177, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %177, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %177, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %177, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %177, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S3_refine_coordinates)
  %178 = bitcast %struct.PointerMeta.272* %11 to i8*
  %179 = bitcast %0* %37 to i8*
  %180 = call i8* @Pointer_lookup_element(i8* %178, i8* %179, i32 %176)
  %181 = call i8* @get_ch_S3_to_S4(i8* %180)
  %182 = bitcast i8* %181 to %1*
  %183 = lshr i32 %130, 2
  %184 = and i32 %183, 3
  %185 = lshr i32 %136, 2
  %186 = and i32 %185, 3
  %187 = shl i32 %184, 2
  %188 = add i32 %186, %187
  %189 = bitcast %struct.PointerMeta.272* %12 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %189, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %189, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %189, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %189, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %189, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %189, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %189, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %189, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %189, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S4_refine_coordinates)
  %190 = bitcast %struct.PointerMeta.272* %12 to i8*
  %191 = bitcast %1* %182 to i8*
  %192 = call i8* @Pointer_lookup_element(i8* %190, i8* %191, i32 %188)
  %193 = call i8* @get_ch_S4_to_S5(i8* %192)
  %194 = bitcast i8* %193 to %1*
  %195 = lshr i32 %130, 0
  %196 = and i32 %195, 3
  %197 = lshr i32 %136, 0
  %198 = and i32 %197, 3
  %199 = shl i32 %196, 2
  %200 = add i32 %198, %199
  %201 = bitcast %struct.PointerMeta.272* %13 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %201, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %201, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %201, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.270* %201, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %201, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %201, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %201, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %201, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %201, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S5_refine_coordinates)
  %202 = bitcast %struct.PointerMeta.272* %13 to i8*
  %203 = bitcast %1* %194 to i8*
  %204 = call i32 @Pointer_is_active(i8* %202, i8* %203, i32 %200)
  %205 = add i32 %170, %204
  %206 = sitofp i32 %205 to float
  %207 = fmul float %206, 2.500000e-01
  %208 = fsub float 1.000000e+00, %207
  %209 = add i32 %28, %130
  %210 = add i32 %209, %118
  %211 = add i32 %210, %99
  %212 = add i32 %211, 2
  %213 = add i32 %30, %136
  %214 = add i32 %213, %124
  %215 = add i32 %214, %112
  %216 = add i32 %215, 2
  %217 = bitcast %S0_ch.274* %34 to i8*
  %218 = call i8* @get_ch_S0_to_S1(i8* %217)
  %219 = bitcast i8* %218 to [1048576 x %S1_ch.273]*
  %220 = lshr i32 %212, 0
  %221 = and i32 %220, 1023
  %222 = lshr i32 %216, 0
  %223 = and i32 %222, 1023
  %224 = shl i32 %221, 10
  %225 = add i32 %223, %224
  %226 = bitcast %struct.DenseMeta.271* %14 to %struct.StructMeta.270*
  call void @StructMeta_set_snode_id(%struct.StructMeta.270* %226, i32 1)
  call void @StructMeta_set_element_size(%struct.StructMeta.270* %226, i64 4)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %226, i64 1048576)
  call void @StructMeta_set_context(%struct.StructMeta.270* %226, %struct.RuntimeContext.268* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.270* %226, i8* (i8*, i8*, i32)* @Dense_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.270* %226, i32 (i8*, i8*, i32)* @Dense_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %226, i32 (i8*, i8*)* @Dense_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %226, i8* (i8*)* @get_ch_S0_to_S1)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %226, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* @S1_refine_coordinates)
  call void @DenseMeta_set_morton_dim(%struct.DenseMeta.271* %14, i32 0)
  %227 = bitcast %struct.DenseMeta.271* %14 to i8*
  %228 = bitcast [1048576 x %S1_ch.273]* %219 to i8*
  %229 = call i8* @Dense_lookup_element(i8* %227, i8* %228, i32 %225)
  %230 = call i8* @get_ch_S1_to_S2(i8* %229)
  %231 = bitcast i8* %230 to float*
  store float %208, float* %231
  br label %final
}

; Function Attrs: argmemonly nounwind readonly
declare i32 @llvm.nvvm.ldg.global.i.i32.p0i32(i32* nocapture, i32) #0

define internal void @S1_refine_coordinates(%struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 10
  %4 = and i32 %3, 1023
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 0)
  %6 = shl i32 %5, 10
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 1023
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 1)
  %11 = shl i32 %10, 10
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S1(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.274*
  %getch = getelementptr %S0_ch.274, %S0_ch.274* %1, i32 0, i32 0
  %2 = bitcast [1048576 x %S1_ch.273]* %getch to i8*
  ret i8* %2
}

define internal i8* @get_ch_S1_to_S2(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S1_ch.273*
  %getch = getelementptr %S1_ch.273, %S1_ch.273* %1, i32 0, i32 0
  %2 = bitcast float* %getch to i8*
  ret i8* %2
}

define internal void @S3_refine_coordinates(%struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 3
  %4 = and i32 %3, 7
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 0)
  %6 = shl i32 %5, 3
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 7
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 1)
  %11 = shl i32 %10, 3
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S3(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.274*
  %getch = getelementptr %S0_ch.274, %S0_ch.274* %1, i32 0, i32 1
  %2 = bitcast %0* %getch to i8*
  ret i8* %2
}

define internal void @S4_refine_coordinates(%struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S3_to_S4(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %2*
  %getch = getelementptr %2, %2* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

define internal void @S5_refine_coordinates(%struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S4_to_S5(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %2*
  %getch = getelementptr %2, %2* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

define internal void @S6_refine_coordinates(%struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S5_to_S6(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %3*
  %getch = getelementptr %3, %3* %1, i32 0, i32 0
  %2 = bitcast [16 x %S6_ch.28]* %getch to i8*
  ret i8* %2
}

define internal i8* @get_ch_S6_to_S7(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S6_ch.28*
  %getch = getelementptr %S6_ch.28, %S6_ch.28* %1, i32 0, i32 0
  %2 = bitcast i32* %getch to i8*
  ret i8* %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.269* %0, i32 %1) #1 {
  %3 = alloca %struct.PhysicalCoordinates.0.269*, align 8
  %4 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269** %3, align 8
  %6 = getelementptr inbounds %struct.PhysicalCoordinates.0.269, %struct.PhysicalCoordinates.0.269* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [8 x i32], [8 x i32]* %6, i64 0, i64 %8
  %10 = load i32, i32* %9, align 4
  ret i32 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.269* %0, i32 %1, i32 %2) #1 {
  %4 = alloca %struct.PhysicalCoordinates.0.269*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.269* %0, %struct.PhysicalCoordinates.0.269** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = load %struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269** %4, align 8
  %9 = getelementptr inbounds %struct.PhysicalCoordinates.0.269, %struct.PhysicalCoordinates.0.269* %8, i32 0, i32 0
  %10 = load i32, i32* %5, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [8 x i32], [8 x i32]* %9, i64 0, i64 %11
  store i32 %7, i32* %12, align 4
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.LLVMRuntime.267* @RuntimeContext_get_runtime(%struct.RuntimeContext.268* %0) #1 {
  %2 = alloca %struct.RuntimeContext.268*, align 8
  store %struct.RuntimeContext.268* %0, %struct.RuntimeContext.268** %2, align 8
  %3 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %2, align 8
  %4 = getelementptr inbounds %struct.RuntimeContext.268, %struct.RuntimeContext.268* %3, i32 0, i32 0
  %5 = load %struct.LLVMRuntime.267*, %struct.LLVMRuntime.267** %4, align 8
  ret %struct.LLVMRuntime.267* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_snode_id(%struct.StructMeta.270* %0, i32 %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i32, align 4
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 0
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_element_size(%struct.StructMeta.270* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 1
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_max_num_elements(%struct.StructMeta.270* %0, i64 %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 2
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_get_num_elements(%struct.StructMeta.270* %0, i32 (i8*, i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i32 (i8*, i8*)*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i32 (i8*, i8*)* %1, i32 (i8*, i8*)** %4, align 8
  %5 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 6
  store i32 (i8*, i8*)* %5, i32 (i8*, i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_lookup_element(%struct.StructMeta.270* %0, i8* (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i8* (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i8* (i8*, i8*, i32)* %1, i8* (i8*, i8*, i32)** %4, align 8
  %5 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 3
  store i8* (i8*, i8*, i32)* %5, i8* (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_from_parent_element(%struct.StructMeta.270* %0, i8* (i8*)* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i8* (i8*)*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  %5 = load i8* (i8*)*, i8* (i8*)** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 4
  store i8* (i8*)* %5, i8* (i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_refine_coordinates(%struct.StructMeta.270* %0, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* %1, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)** %4, align 8
  %5 = load void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)*, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 7
  store void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)* %5, void (%struct.PhysicalCoordinates.0.269*, %struct.PhysicalCoordinates.0.269*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_is_active(%struct.StructMeta.270* %0, i32 (i8*, i8*, i32)* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca i32 (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store i32 (i8*, i8*, i32)* %1, i32 (i8*, i8*, i32)** %4, align 8
  %5 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 5
  store i32 (i8*, i8*, i32)* %5, i32 (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_context(%struct.StructMeta.270* %0, %struct.RuntimeContext.268* %1) #1 {
  %3 = alloca %struct.StructMeta.270*, align 8
  %4 = alloca %struct.RuntimeContext.268*, align 8
  store %struct.StructMeta.270* %0, %struct.StructMeta.270** %3, align 8
  store %struct.RuntimeContext.268* %1, %struct.RuntimeContext.268** %4, align 8
  %5 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %4, align 8
  %6 = load %struct.StructMeta.270*, %struct.StructMeta.270** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 8
  store %struct.RuntimeContext.268* %5, %struct.RuntimeContext.268** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.267* %0, i32 %1) #1 {
  %3 = alloca %struct.LLVMRuntime.267*, align 8
  %4 = alloca i32, align 4
  store %struct.LLVMRuntime.267* %0, %struct.LLVMRuntime.267** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.LLVMRuntime.267*, %struct.LLVMRuntime.267** %3, align 8
  %6 = getelementptr inbounds %struct.LLVMRuntime.267, %struct.LLVMRuntime.267* %5, i32 0, i32 9
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [512 x i8*], [512 x i8*]* %6, i64 0, i64 %8
  %10 = load i8*, i8** %9, align 8
  ret i8* %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gpu_parallel_range_for(%struct.RuntimeContext.268* %0, i32 %1, i32 %2, void (%struct.RuntimeContext.268*, i8*)* %3, void (%struct.RuntimeContext.268*, i8*, i32)* %4, void (%struct.RuntimeContext.268*, i8*)* %5, i64 %6) #1 {
  %8 = alloca %struct.RuntimeContext.268*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca void (%struct.RuntimeContext.268*, i8*)*, align 8
  %12 = alloca void (%struct.RuntimeContext.268*, i8*, i32)*, align 8
  %13 = alloca void (%struct.RuntimeContext.268*, i8*)*, align 8
  %14 = alloca i64, align 8
  %15 = alloca i32, align 4
  %16 = alloca i8*, align 8
  %17 = alloca i64, align 8
  %18 = alloca i8*, align 8
  store %struct.RuntimeContext.268* %0, %struct.RuntimeContext.268** %8, align 8
  store i32 %1, i32* %9, align 4
  store i32 %2, i32* %10, align 4
  store void (%struct.RuntimeContext.268*, i8*)* %3, void (%struct.RuntimeContext.268*, i8*)** %11, align 8
  store void (%struct.RuntimeContext.268*, i8*, i32)* %4, void (%struct.RuntimeContext.268*, i8*, i32)** %12, align 8
  store void (%struct.RuntimeContext.268*, i8*)* %5, void (%struct.RuntimeContext.268*, i8*)** %13, align 8
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
  %30 = load void (%struct.RuntimeContext.268*, i8*)*, void (%struct.RuntimeContext.268*, i8*)** %11, align 8
  %31 = icmp ne void (%struct.RuntimeContext.268*, i8*)* %30, null
  br i1 %31, label %32, label %36

32:                                               ; preds = %7
  %33 = load void (%struct.RuntimeContext.268*, i8*)*, void (%struct.RuntimeContext.268*, i8*)** %11, align 8
  %34 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %8, align 8
  %35 = load i8*, i8** %18, align 8
  call void %33(%struct.RuntimeContext.268* %34, i8* %35)
  br label %36

36:                                               ; preds = %32, %7
  br label %37

37:                                               ; preds = %41, %36
  %38 = load i32, i32* %15, align 4
  %39 = load i32, i32* %10, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %51

41:                                               ; preds = %37
  %42 = load void (%struct.RuntimeContext.268*, i8*, i32)*, void (%struct.RuntimeContext.268*, i8*, i32)** %12, align 8
  %43 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %8, align 8
  %44 = load i8*, i8** %18, align 8
  %45 = load i32, i32* %15, align 4
  call void %42(%struct.RuntimeContext.268* %43, i8* %44, i32 %45)
  %46 = call i32 @block_dim()
  %47 = call i32 @grid_dim()
  %48 = mul nsw i32 %46, %47
  %49 = load i32, i32* %15, align 4
  %50 = add nsw i32 %49, %48
  store i32 %50, i32* %15, align 4
  br label %37

51:                                               ; preds = %37
  %52 = load void (%struct.RuntimeContext.268*, i8*)*, void (%struct.RuntimeContext.268*, i8*)** %13, align 8
  %53 = icmp ne void (%struct.RuntimeContext.268*, i8*)* %52, null
  br i1 %53, label %54, label %58

54:                                               ; preds = %51
  %55 = load void (%struct.RuntimeContext.268*, i8*)*, void (%struct.RuntimeContext.268*, i8*)** %13, align 8
  %56 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %8, align 8
  %57 = load i8*, i8** %18, align 8
  call void %55(%struct.RuntimeContext.268* %56, i8* %57)
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
define internal void @DenseMeta_set_morton_dim(%struct.DenseMeta.271* %0, i32 %1) #1 {
  %3 = alloca %struct.DenseMeta.271*, align 8
  %4 = alloca i32, align 4
  store %struct.DenseMeta.271* %0, %struct.DenseMeta.271** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.DenseMeta.271*, %struct.DenseMeta.271** %3, align 8
  %7 = getelementptr inbounds %struct.DenseMeta.271, %struct.DenseMeta.271* %6, i32 0, i32 1
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
  %6 = bitcast i8* %5 to %struct.StructMeta.270*
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 2
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
  %9 = bitcast i8* %8 to %struct.StructMeta.270*
  %10 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %9, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = load i32, i32* %6, align 4
  %13 = sext i32 %12 to i64
  %14 = mul i64 %11, %13
  %15 = getelementptr inbounds i8, i8* %7, i64 %14
  ret i8* %15
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Pointer_get_num_elements(i8* %0, i8* %1) #1 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load i8*, i8** %3, align 8
  %6 = bitcast i8* %5 to %struct.StructMeta.270*
  %7 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %6, i32 0, i32 2
  %8 = load i64, i64* %7, align 8
  %9 = trunc i64 %8 to i32
  ret i32 %9
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
  %9 = alloca %struct.StructMeta.270*, align 8
  %10 = alloca %struct.RuntimeContext.268*, align 8
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
  %27 = bitcast i8* %26 to %struct.StructMeta.270*
  store %struct.StructMeta.270* %27, %struct.StructMeta.270** %9, align 8
  %28 = load %struct.StructMeta.270*, %struct.StructMeta.270** %9, align 8
  %29 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %28, i32 0, i32 8
  %30 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %29, align 8
  store %struct.RuntimeContext.268* %30, %struct.RuntimeContext.268** %10, align 8
  %31 = load %struct.RuntimeContext.268*, %struct.RuntimeContext.268** %10, align 8
  %32 = getelementptr inbounds %struct.RuntimeContext.268, %struct.RuntimeContext.268* %31, i32 0, i32 0
  %33 = load %struct.LLVMRuntime.267*, %struct.LLVMRuntime.267** %32, align 8
  %34 = getelementptr inbounds %struct.LLVMRuntime.267, %struct.LLVMRuntime.267* %33, i32 0, i32 16
  %35 = load %struct.StructMeta.270*, %struct.StructMeta.270** %9, align 8
  %36 = getelementptr inbounds %struct.StructMeta.270, %struct.StructMeta.270* %35, i32 0, i32 0
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

attributes #0 = { argmemonly nounwind readonly }
attributes #1 = { alwaysinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
attributes #3 = { nounwind readnone }

!nvvm.annotations = !{!0, !1, !2, !3, !4, !3, !5, !5, !5, !5, !6, !6, !5}
!llvm.ident = !{!7}
!nvvmir.version = !{!8}
!llvm.module.flags = !{!9}

!0 = !{void (%struct.RuntimeContext.268*)* @paint_c84_0_kernel_0_range_forTb6f66a228a45063ecc954f4153808e5c3fcfa3bc6be19e2aa841613469eb0462_6905, !"kernel", i32 1}
!1 = !{void (%struct.RuntimeContext.268*)* @paint_c84_0_kernel_0_range_forTb6f66a228a45063ecc954f4153808e5c3fcfa3bc6be19e2aa841613469eb0462_6905, !"maxntidx", i32 128}
!2 = !{void (%struct.RuntimeContext.268*)* @paint_c84_0_kernel_0_range_forTb6f66a228a45063ecc954f4153808e5c3fcfa3bc6be19e2aa841613469eb0462_6905, !"minctasm", i32 2}
!3 = !{null, !"align", i32 8}
!4 = !{null, !"align", i32 8, !"align", i32 65544, !"align", i32 131080}
!5 = !{null, !"align", i32 16}
!6 = !{null, !"align", i32 16, !"align", i32 65552, !"align", i32 131088}
!7 = !{!"clang version 10.0.0-4ubuntu1 "}
!8 = !{i32 1, i32 4}
!9 = !{i32 1, !"wchar_size", i32 4}
