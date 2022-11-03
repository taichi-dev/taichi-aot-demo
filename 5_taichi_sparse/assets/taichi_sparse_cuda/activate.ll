; ModuleID = '/home/taichigraphics/.cache/taichi/ticache/llvm/Tfb1b3f37940bfb2cc7a754a287c978845cc2225c6b493d293f9fab7b3b28489b.ll'
source_filename = "kernel"
target triple = "nvptx64-nvidia-cuda"

%0 = type { [64 x i64], [64 x i8*] }
%1 = type { [16 x i64], [16 x i8*] }
%2 = type { %1 }
%3 = type { %struct.ListManager.240*, i32* }
%4 = type { %class.lock_guard.38.21*, i8**, %3* }
%5 = type { i64*, %struct.LLVMRuntime.245*, i64*, i8**, i8* }
%6 = type { %class.lock_guard.38.21*, i8**, %5* }
%7 = type { %struct.LLVMRuntime.245**, i8**, i32*, i64** }
%8 = type { %class.lock_guard.38.21*, i8**, %7* }
%struct.RuntimeContext.246 = type { %struct.LLVMRuntime.245*, [64 x i64], [32 x [8 x i32]], i32, [64 x i64], [64 x i8], i64* }
%struct.LLVMRuntime.245 = type { i8, i64, i8*, i8*, i8* (i8*, i64, i64)*, void (i8*)*, void (i8*, ...)*, i32 (i8*, i64, i8*, %struct.__va_list_tag.239*)*, i8*, [512 x i8*], [512 x i64], i8*, void (i8*, i32, i32, i8*, void (i8*, i32, i32)*)*, [1024 x %struct.ListManager.240*], [1024 x %struct.NodeManager.241*], %struct.NodeManager.241*, [1024 x i8*], i8*, %struct.RandState.242*, %struct.MemRequestQueue.244*, i8*, void (i8*, i8*)*, void (i8*)*, [2048 x i8], [32 x i64], i32, i64, i8*, i32, i32, i64, i8* }
%struct.__va_list_tag.239 = type { i32, i32, i8*, i8* }
%struct.ListManager.240 = type { [131072 x i8*], i64, i64, i32, i32, i32, %struct.LLVMRuntime.245* }
%struct.NodeManager.241 = type <{ %struct.LLVMRuntime.245*, i32, i32, i32, i32, %struct.ListManager.240*, %struct.ListManager.240*, %struct.ListManager.240*, i32, [4 x i8] }>
%struct.RandState.242 = type { i32, i32, i32, i32, i32 }
%struct.MemRequestQueue.244 = type { [65536 x %struct.MemRequest.243], i32, i32 }
%struct.MemRequest.243 = type { i64, i64, i8*, i64 }
%struct.PointerMeta.249 = type <{ %struct.StructMeta.248, i8, [7 x i8] }>
%struct.StructMeta.248 = type { i32, i64, i64, i8* (i8*, i8*, i32)*, i8* (i8*)*, i32 (i8*, i8*, i32)*, i32 (i8*, i8*)*, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)*, %struct.RuntimeContext.246* }
%struct.PhysicalCoordinates.0.247 = type { [8 x i32] }
%struct.DenseMeta.22 = type <{ %struct.StructMeta.248, i32, [4 x i8] }>
%S0_ch.251 = type { [1048576 x %S1_ch.250], %0 }
%S1_ch.250 = type { float }
%S6_ch.252 = type { i32 }
%S5_ch.23 = type { [16 x %S6_ch.252] }
%class.anon.4.24 = type { %struct.StructMeta.248**, i8*** }
%class.anon.5.25 = type { i8*** }
%class.lock_guard.38.21 = type { i8 }
%class.anon.40.26 = type { %class.anon.5.25*, i8**, %class.anon.4.24* }
%struct.uint2.27 = type { i32, i32 }

@.str.6 = private unnamed_addr constant [28 x i8] c"List manager out of chunks.\00", align 1
@.str.4 = private unnamed_addr constant [37 x i8] c"Too many memory allocation requests.\00", align 1
@.str = private unnamed_addr constant [144 x i8] c"Out of CUDA pre-allocated memory.\0AConsider using ti.init(device_memory_fraction=0.9) or ti.init(device_memory_GB=4) to allocate more GPU memory\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"Taichi JIT\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"allocate_from_buffer\00", align 1
@.str.3 = private unnamed_addr constant [28 x i8] c"Out of pre-allocated memory\00", align 1
@"$str" = private addrspace(1) constant [11 x i8] c"__CUDA_FTZ\00"
@__cudart_i2opi_f = internal addrspace(4) global [6 x i32] [i32 1011060801, i32 -614296167, i32 -181084736, i32 -64530479, i32 1313084713, i32 -1560706194], align 4

define void @activate_c82_0_kernel_0_range_forTfb1b3f37940bfb2cc7a754a287c978845cc2225c6b493d293f9fab7b3b28489b_7521(%struct.RuntimeContext.246* byval(%struct.RuntimeContext.246) %context) {
entry:
  br label %body

final:                                            ; preds = %body
  ret void

body:                                             ; preds = %entry
  call void @gpu_parallel_range_for(%struct.RuntimeContext.246* %context, i32 0, i32 262144, void (%struct.RuntimeContext.246*, i8*)* null, void (%struct.RuntimeContext.246*, i8*, i32)* @function_body, void (%struct.RuntimeContext.246*, i8*)* null, i64 1)
  br label %final
}

define internal void @function_body(%struct.RuntimeContext.246* %0, i8* %1, i32 %2) {
allocs:
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca %struct.PointerMeta.249
  %6 = alloca %struct.PointerMeta.249
  %7 = alloca %struct.PointerMeta.249
  %8 = alloca %struct.PointerMeta.249
  %9 = alloca %struct.PointerMeta.249
  %10 = alloca %struct.PointerMeta.249
  %11 = alloca %struct.DenseMeta.22
  br label %entry

final:                                            ; preds = %after_if42
  ret void

entry:                                            ; preds = %allocs
  br label %function_body

function_body:                                    ; preds = %entry
  store i32 %2, i32* %3
  %12 = load i32, i32* %3
  %13 = sdiv i32 %12, 512
  %14 = icmp slt i32 %12, 0
  %15 = sext i1 %14 to i32
  %16 = shl i32 %13, 9
  %17 = icmp ne i32 %15, 0
  %18 = sext i1 %17 to i32
  %19 = icmp ne i32 %12, 0
  %20 = sext i1 %19 to i32
  %21 = icmp ne i32 %16, %12
  %22 = sext i1 %21 to i32
  %23 = and i32 %18, %20
  %24 = and i32 %23, %22
  %25 = add i32 %13, %24
  %26 = shl i32 %25, 9
  %27 = sub i32 %12, %26
  %28 = sitofp i32 %25 to float
  %29 = fmul float %28, 0x3F60000000000000
  %30 = sitofp i32 %27 to float
  %31 = fmul float %30, 0x3F60000000000000
  %32 = call i64 @RuntimeContext_get_args(%struct.RuntimeContext.246* %0, i32 0)
  %33 = trunc i64 %32 to i32
  %34 = bitcast i32 %33 to float
  %35 = call float @__nv_sinf(float %34)
  %36 = call float @__nv_cosf(float %35)
  %37 = call float @__nv_sinf(float %35)
  %neg = fneg float %37
  %38 = fsub float %29, 5.000000e-01
  %39 = fsub float %31, 5.000000e-01
  %40 = fmul float %36, %38
  %41 = fmul float %neg, %39
  %42 = fadd float %40, %41
  %43 = fmul float %37, %38
  %44 = fmul float %36, %39
  %45 = fadd float %43, %44
  %46 = fmul float %42, 0x3FF1C28F60000000
  %47 = fmul float %45, 0x3FF1C28F60000000
  %48 = fadd float %46, 5.000000e-01
  store i32 0, i32* %4
  store i32 -1, i32* %4
  %49 = fmul float %46, %46
  %50 = fmul float %47, %47
  %51 = fadd float %49, %50
  %52 = fcmp ole float %51, 0x3FD14E3BC0000000
  %53 = sext i1 %52 to i32
  %54 = and i32 %53, 1
  %55 = call i32 @logic_not_i32(i32 %54)
  %56 = icmp ne i32 %55, 0
  br i1 %56, label %true_block, label %false_block

true_block:                                       ; preds = %function_body
  store i32 0, i32* %4
  br label %after_if

false_block:                                      ; preds = %function_body
  br label %after_if

after_if:                                         ; preds = %false_block, %true_block
  %57 = fcmp ole float %51, 0x3FCF5CFAA0000000
  %58 = sext i1 %57 to i32
  %59 = and i32 %58, 1
  %60 = call i32 @logic_not_i32(i32 %59)
  %61 = icmp ne i32 %60, 0
  br i1 %61, label %true_block1, label %false_block2

true_block1:                                      ; preds = %after_if
  %62 = load i32, i32* %4
  %63 = icmp eq i32 %62, -1
  %64 = sext i1 %63 to i32
  %65 = and i32 %64, 1
  %66 = icmp ne i32 %65, 0
  br i1 %66, label %true_block4, label %false_block5

false_block2:                                     ; preds = %after_if
  br label %after_if3

after_if3:                                        ; preds = %after_if6, %false_block2
  %67 = fadd float %47, 2.500000e-01
  %68 = fmul float %67, %67
  %69 = fadd float %49, %68
  %70 = fcmp ole float %69, 0x3F7A36E2E0000000
  %71 = sext i1 %70 to i32
  %72 = and i32 %71, 1
  %73 = icmp ne i32 %72, 0
  br i1 %73, label %true_block7, label %false_block8

true_block4:                                      ; preds = %true_block1
  store i32 1, i32* %4
  br label %after_if6

false_block5:                                     ; preds = %true_block1
  br label %after_if6

after_if6:                                        ; preds = %false_block5, %true_block4
  br label %after_if3

true_block7:                                      ; preds = %after_if3
  %74 = load i32, i32* %4
  %75 = icmp eq i32 %74, -1
  %76 = sext i1 %75 to i32
  %77 = and i32 %76, 1
  %78 = icmp ne i32 %77, 0
  br i1 %78, label %true_block10, label %false_block11

false_block8:                                     ; preds = %after_if3
  br label %after_if9

after_if9:                                        ; preds = %after_if12, %false_block8
  %79 = fadd float %47, -2.500000e-01
  %80 = fmul float %79, %79
  %81 = fadd float %49, %80
  %82 = fcmp ole float %81, 0x3F7A36E2E0000000
  %83 = sext i1 %82 to i32
  %84 = and i32 %83, 1
  %85 = icmp ne i32 %84, 0
  br i1 %85, label %true_block13, label %false_block14

true_block10:                                     ; preds = %true_block7
  store i32 1, i32* %4
  br label %after_if12

false_block11:                                    ; preds = %true_block7
  br label %after_if12

after_if12:                                       ; preds = %false_block11, %true_block10
  br label %after_if9

true_block13:                                     ; preds = %after_if9
  %86 = load i32, i32* %4
  %87 = icmp eq i32 %86, -1
  %88 = sext i1 %87 to i32
  %89 = and i32 %88, 1
  %90 = icmp ne i32 %89, 0
  br i1 %90, label %true_block16, label %false_block17

false_block14:                                    ; preds = %after_if9
  br label %after_if15

after_if15:                                       ; preds = %after_if18, %false_block14
  %91 = fcmp ole float %69, 6.250000e-02
  %92 = sext i1 %91 to i32
  %93 = and i32 %92, 1
  %94 = icmp ne i32 %93, 0
  br i1 %94, label %true_block19, label %false_block20

true_block16:                                     ; preds = %true_block13
  store i32 0, i32* %4
  br label %after_if18

false_block17:                                    ; preds = %true_block13
  br label %after_if18

after_if18:                                       ; preds = %false_block17, %true_block16
  br label %after_if15

true_block19:                                     ; preds = %after_if15
  %95 = load i32, i32* %4
  %96 = icmp eq i32 %95, -1
  %97 = sext i1 %96 to i32
  %98 = and i32 %97, 1
  %99 = icmp ne i32 %98, 0
  br i1 %99, label %true_block22, label %false_block23

false_block20:                                    ; preds = %after_if15
  br label %after_if21

after_if21:                                       ; preds = %after_if24, %false_block20
  %100 = fcmp ole float %81, 6.250000e-02
  %101 = sext i1 %100 to i32
  %102 = and i32 %101, 1
  %103 = icmp ne i32 %102, 0
  br i1 %103, label %true_block25, label %false_block26

true_block22:                                     ; preds = %true_block19
  store i32 0, i32* %4
  br label %after_if24

false_block23:                                    ; preds = %true_block19
  br label %after_if24

after_if24:                                       ; preds = %false_block23, %true_block22
  br label %after_if21

true_block25:                                     ; preds = %after_if21
  %104 = load i32, i32* %4
  %105 = icmp eq i32 %104, -1
  %106 = sext i1 %105 to i32
  %107 = and i32 %106, 1
  %108 = icmp ne i32 %107, 0
  br i1 %108, label %true_block28, label %false_block29

false_block26:                                    ; preds = %after_if21
  br label %after_if27

after_if27:                                       ; preds = %after_if30, %false_block26
  %109 = fcmp olt float %48, 5.000000e-01
  %110 = sext i1 %109 to i32
  %111 = and i32 %110, 1
  %112 = load i32, i32* %4
  %113 = icmp eq i32 %112, -1
  %114 = sext i1 %113 to i32
  %115 = and i32 %114, 1
  %116 = icmp ne i32 %111, 0
  br i1 %116, label %true_block31, label %false_block32

true_block28:                                     ; preds = %true_block25
  store i32 1, i32* %4
  br label %after_if30

false_block29:                                    ; preds = %true_block25
  br label %after_if30

after_if30:                                       ; preds = %false_block29, %true_block28
  br label %after_if27

true_block31:                                     ; preds = %after_if27
  %117 = icmp ne i32 %115, 0
  br i1 %117, label %true_block34, label %false_block35

false_block32:                                    ; preds = %after_if27
  %118 = icmp ne i32 %115, 0
  br i1 %118, label %true_block37, label %false_block38

after_if33:                                       ; preds = %after_if39, %after_if36
  %119 = load i32, i32* %4
  %120 = sub i32 1, %119
  %121 = icmp eq i32 %120, 0
  %122 = sext i1 %121 to i32
  %123 = and i32 %122, 1
  %124 = icmp ne i32 %123, 0
  br i1 %124, label %true_block40, label %false_block41

true_block34:                                     ; preds = %true_block31
  store i32 1, i32* %4
  br label %after_if36

false_block35:                                    ; preds = %true_block31
  br label %after_if36

after_if36:                                       ; preds = %false_block35, %true_block34
  br label %after_if33

true_block37:                                     ; preds = %false_block32
  store i32 0, i32* %4
  br label %after_if39

false_block38:                                    ; preds = %false_block32
  br label %after_if39

after_if39:                                       ; preds = %false_block38, %true_block37
  br label %after_if33

true_block40:                                     ; preds = %after_if33
  %125 = call %struct.LLVMRuntime.245* @RuntimeContext_get_runtime(%struct.RuntimeContext.246* %0)
  %126 = call i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.245* %125, i32 0)
  %127 = bitcast i8* %126 to %S0_ch.251*
  %128 = getelementptr %S0_ch.251, %S0_ch.251* %127, i32 0
  %129 = bitcast %S0_ch.251* %128 to i8*
  %130 = call i8* @get_ch_S0_to_S3(i8* %129)
  %131 = bitcast i8* %130 to %0*
  %132 = lshr i32 %25, 6
  %133 = and i32 %132, 7
  %134 = lshr i32 %27, 6
  %135 = and i32 %134, 7
  %136 = shl i32 %133, 3
  %137 = add i32 %135, %136
  %138 = bitcast %struct.PointerMeta.249* %5 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %138, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %138, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %138, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.248* %138, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %138, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %138, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %138, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %138, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %138, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S3_refine_coordinates)
  %139 = bitcast %struct.PointerMeta.249* %5 to i8*
  %140 = bitcast %0* %131 to i8*
  call void @Pointer_activate(i8* %139, i8* %140, i32 %137)
  %141 = bitcast %struct.PointerMeta.249* %6 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %141, i32 3)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %141, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %141, i64 64)
  call void @StructMeta_set_context(%struct.StructMeta.248* %141, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %141, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %141, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %141, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %141, i8* (i8*)* @get_ch_S0_to_S3)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %141, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S3_refine_coordinates)
  %142 = bitcast %struct.PointerMeta.249* %6 to i8*
  %143 = bitcast %0* %131 to i8*
  %144 = call i8* @Pointer_lookup_element(i8* %142, i8* %143, i32 %137)
  %145 = call i8* @get_ch_S3_to_S4(i8* %144)
  %146 = bitcast i8* %145 to %1*
  %147 = lshr i32 %25, 4
  %148 = and i32 %147, 3
  %149 = lshr i32 %27, 4
  %150 = and i32 %149, 3
  %151 = shl i32 %148, 2
  %152 = add i32 %150, %151
  %153 = bitcast %struct.PointerMeta.249* %7 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %153, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %153, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %153, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.248* %153, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %153, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %153, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %153, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %153, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %153, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S4_refine_coordinates)
  %154 = bitcast %struct.PointerMeta.249* %7 to i8*
  %155 = bitcast %1* %146 to i8*
  call void @Pointer_activate(i8* %154, i8* %155, i32 %152)
  %156 = bitcast %struct.PointerMeta.249* %8 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %156, i32 4)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %156, i64 256)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %156, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.248* %156, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %156, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %156, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %156, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %156, i8* (i8*)* @get_ch_S3_to_S4)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %156, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S4_refine_coordinates)
  %157 = bitcast %struct.PointerMeta.249* %8 to i8*
  %158 = bitcast %1* %146 to i8*
  %159 = call i8* @Pointer_lookup_element(i8* %157, i8* %158, i32 %152)
  %160 = call i8* @get_ch_S4_to_S5(i8* %159)
  %161 = bitcast i8* %160 to %1*
  %162 = lshr i32 %25, 2
  %163 = and i32 %162, 3
  %164 = lshr i32 %27, 2
  %165 = and i32 %164, 3
  %166 = shl i32 %163, 2
  %167 = add i32 %165, %166
  %168 = bitcast %struct.PointerMeta.249* %9 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %168, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %168, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %168, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.248* %168, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %168, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %168, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %168, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %168, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %168, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S5_refine_coordinates)
  %169 = bitcast %struct.PointerMeta.249* %9 to i8*
  %170 = bitcast %1* %161 to i8*
  call void @Pointer_activate(i8* %169, i8* %170, i32 %167)
  %171 = bitcast %struct.PointerMeta.249* %10 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %171, i32 5)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %171, i64 64)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %171, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.248* %171, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %171, i8* (i8*, i8*, i32)* @Pointer_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %171, i32 (i8*, i8*, i32)* @Pointer_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %171, i32 (i8*, i8*)* @Pointer_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %171, i8* (i8*)* @get_ch_S4_to_S5)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %171, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S5_refine_coordinates)
  %172 = bitcast %struct.PointerMeta.249* %10 to i8*
  %173 = bitcast %1* %161 to i8*
  %174 = call i8* @Pointer_lookup_element(i8* %172, i8* %173, i32 %167)
  %175 = call i8* @get_ch_S5_to_S6(i8* %174)
  %176 = bitcast i8* %175 to [16 x %S6_ch.252]*
  %177 = lshr i32 %25, 0
  %178 = and i32 %177, 3
  %179 = lshr i32 %27, 0
  %180 = and i32 %179, 3
  %181 = shl i32 %178, 2
  %182 = add i32 %180, %181
  %183 = bitcast %struct.DenseMeta.22* %11 to %struct.StructMeta.248*
  call void @StructMeta_set_snode_id(%struct.StructMeta.248* %183, i32 6)
  call void @StructMeta_set_element_size(%struct.StructMeta.248* %183, i64 4)
  call void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %183, i64 16)
  call void @StructMeta_set_context(%struct.StructMeta.248* %183, %struct.RuntimeContext.246* %0)
  call void @StructMeta_set_lookup_element(%struct.StructMeta.248* %183, i8* (i8*, i8*, i32)* @Dense_lookup_element)
  call void @StructMeta_set_is_active(%struct.StructMeta.248* %183, i32 (i8*, i8*, i32)* @Dense_is_active)
  call void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %183, i32 (i8*, i8*)* @Dense_get_num_elements)
  call void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %183, i8* (i8*)* @get_ch_S5_to_S6)
  call void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %183, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* @S6_refine_coordinates)
  call void @DenseMeta_set_morton_dim(%struct.DenseMeta.22* %11, i32 0)
  %184 = bitcast %struct.DenseMeta.22* %11 to i8*
  %185 = bitcast [16 x %S6_ch.252]* %176 to i8*
  %186 = call i8* @Dense_lookup_element(i8* %184, i8* %185, i32 %182)
  %187 = call i8* @get_ch_S6_to_S7(i8* %186)
  %188 = bitcast i8* %187 to i32*
  store i32 1, i32* %188
  br label %after_if42

false_block41:                                    ; preds = %after_if33
  br label %after_if42

after_if42:                                       ; preds = %false_block41, %true_block40
  br label %final
}

define internal void @S3_refine_coordinates(%struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 3
  %4 = and i32 %3, 7
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 0)
  %6 = shl i32 %5, 3
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 7
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 1)
  %11 = shl i32 %10, 3
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S0_to_S3(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S0_ch.251*
  %getch = getelementptr %S0_ch.251, %S0_ch.251* %1, i32 0, i32 1
  %2 = bitcast %0* %getch to i8*
  ret i8* %2
}

define internal void @S4_refine_coordinates(%struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S3_to_S4(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %2*
  %getch = getelementptr %2, %2* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

define internal void @S5_refine_coordinates(%struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S4_to_S5(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %2*
  %getch = getelementptr %2, %2* %1, i32 0, i32 0
  %2 = bitcast %1* %getch to i8*
  ret i8* %2
}

define internal void @S6_refine_coordinates(%struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247* %1, i32 %2) {
entry:
  %3 = ashr i32 %2, 2
  %4 = and i32 %3, 3
  %5 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 0)
  %6 = shl i32 %5, 2
  %7 = or i32 %6, %4
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 0, i32 %7)
  %8 = ashr i32 %2, 0
  %9 = and i32 %8, 3
  %10 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 1)
  %11 = shl i32 %10, 2
  %12 = or i32 %11, %9
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 1, i32 %12)
  %13 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 2)
  %14 = shl i32 %13, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 2, i32 %14)
  %15 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 3)
  %16 = shl i32 %15, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 3, i32 %16)
  %17 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 4)
  %18 = shl i32 %17, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 4, i32 %18)
  %19 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 5)
  %20 = shl i32 %19, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 5, i32 %20)
  %21 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 6)
  %22 = shl i32 %21, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 6, i32 %22)
  %23 = call i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 7)
  %24 = shl i32 %23, 0
  call void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %1, i32 7, i32 %24)
  ret void
}

define internal i8* @get_ch_S5_to_S6(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S5_ch.23*
  %getch = getelementptr %S5_ch.23, %S5_ch.23* %1, i32 0, i32 0
  %2 = bitcast [16 x %S6_ch.252]* %getch to i8*
  ret i8* %2
}

define internal i8* @get_ch_S6_to_S7(i8* %0) {
entry:
  %1 = bitcast i8* %0 to %S6_ch.252*
  %getch = getelementptr %S6_ch.252, %S6_ch.252* %1, i32 0, i32 0
  %2 = bitcast i32* %getch to i8*
  ret i8* %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @logic_not_i32(i32 %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = icmp ne i32 %3, 0
  %5 = xor i1 %4, true
  %6 = zext i1 %5 to i32
  ret i32 %6
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @PhysicalCoordinates_get_val(%struct.PhysicalCoordinates.0.247* %0, i32 %1) #0 {
  %3 = alloca %struct.PhysicalCoordinates.0.247*, align 8
  %4 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247** %3, align 8
  %6 = getelementptr inbounds %struct.PhysicalCoordinates.0.247, %struct.PhysicalCoordinates.0.247* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [8 x i32], [8 x i32]* %6, i64 0, i64 %8
  %10 = load i32, i32* %9, align 4
  ret i32 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @PhysicalCoordinates_set_val(%struct.PhysicalCoordinates.0.247* %0, i32 %1, i32 %2) #0 {
  %4 = alloca %struct.PhysicalCoordinates.0.247*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.PhysicalCoordinates.0.247* %0, %struct.PhysicalCoordinates.0.247** %4, align 8
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = load %struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247** %4, align 8
  %9 = getelementptr inbounds %struct.PhysicalCoordinates.0.247, %struct.PhysicalCoordinates.0.247* %8, i32 0, i32 0
  %10 = load i32, i32* %5, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [8 x i32], [8 x i32]* %9, i64 0, i64 %11
  store i32 %7, i32* %12, align 4
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @RuntimeContext_get_args(%struct.RuntimeContext.246* %0, i32 %1) #0 {
  %3 = alloca %struct.RuntimeContext.246*, align 8
  %4 = alloca i32, align 4
  store %struct.RuntimeContext.246* %0, %struct.RuntimeContext.246** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %3, align 8
  %6 = getelementptr inbounds %struct.RuntimeContext.246, %struct.RuntimeContext.246* %5, i32 0, i32 1
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [64 x i64], [64 x i64]* %6, i64 0, i64 %8
  %10 = load i64, i64* %9, align 8
  ret i64 %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal %struct.LLVMRuntime.245* @RuntimeContext_get_runtime(%struct.RuntimeContext.246* %0) #0 {
  %2 = alloca %struct.RuntimeContext.246*, align 8
  store %struct.RuntimeContext.246* %0, %struct.RuntimeContext.246** %2, align 8
  %3 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %2, align 8
  %4 = getelementptr inbounds %struct.RuntimeContext.246, %struct.RuntimeContext.246* %3, i32 0, i32 0
  %5 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %4, align 8
  ret %struct.LLVMRuntime.245* %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_snode_id(%struct.StructMeta.248* %0, i32 %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i32, align 4
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 0
  store i32 %5, i32* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_element_size(%struct.StructMeta.248* %0, i64 %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 1
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_max_num_elements(%struct.StructMeta.248* %0, i64 %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i64, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i64 %1, i64* %4, align 8
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 2
  store i64 %5, i64* %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_get_num_elements(%struct.StructMeta.248* %0, i32 (i8*, i8*)* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i32 (i8*, i8*)*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i32 (i8*, i8*)* %1, i32 (i8*, i8*)** %4, align 8
  %5 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 6
  store i32 (i8*, i8*)* %5, i32 (i8*, i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_lookup_element(%struct.StructMeta.248* %0, i8* (i8*, i8*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i8* (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i8* (i8*, i8*, i32)* %1, i8* (i8*, i8*, i32)** %4, align 8
  %5 = load i8* (i8*, i8*, i32)*, i8* (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 3
  store i8* (i8*, i8*, i32)* %5, i8* (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_from_parent_element(%struct.StructMeta.248* %0, i8* (i8*)* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i8* (i8*)*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  %5 = load i8* (i8*)*, i8* (i8*)** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 4
  store i8* (i8*)* %5, i8* (i8*)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_refine_coordinates(%struct.StructMeta.248* %0, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* %1, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)** %4, align 8
  %5 = load void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)*, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 7
  store void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)* %5, void (%struct.PhysicalCoordinates.0.247*, %struct.PhysicalCoordinates.0.247*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_is_active(%struct.StructMeta.248* %0, i32 (i8*, i8*, i32)* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca i32 (i8*, i8*, i32)*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store i32 (i8*, i8*, i32)* %1, i32 (i8*, i8*, i32)** %4, align 8
  %5 = load i32 (i8*, i8*, i32)*, i32 (i8*, i8*, i32)** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 5
  store i32 (i8*, i8*, i32)* %5, i32 (i8*, i8*, i32)** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @StructMeta_set_context(%struct.StructMeta.248* %0, %struct.RuntimeContext.246* %1) #0 {
  %3 = alloca %struct.StructMeta.248*, align 8
  %4 = alloca %struct.RuntimeContext.246*, align 8
  store %struct.StructMeta.248* %0, %struct.StructMeta.248** %3, align 8
  store %struct.RuntimeContext.246* %1, %struct.RuntimeContext.246** %4, align 8
  %5 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %4, align 8
  %6 = load %struct.StructMeta.248*, %struct.StructMeta.248** %3, align 8
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 8
  store %struct.RuntimeContext.246* %5, %struct.RuntimeContext.246** %7, align 8
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @LLVMRuntime_get_roots(%struct.LLVMRuntime.245* %0, i32 %1) #0 {
  %3 = alloca %struct.LLVMRuntime.245*, align 8
  %4 = alloca i32, align 4
  store %struct.LLVMRuntime.245* %0, %struct.LLVMRuntime.245** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %3, align 8
  %6 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %5, i32 0, i32 9
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [512 x i8*], [512 x i8*]* %6, i64 0, i64 %8
  %10 = load i8*, i8** %9, align 8
  ret i8* %10
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @gpu_parallel_range_for(%struct.RuntimeContext.246* %0, i32 %1, i32 %2, void (%struct.RuntimeContext.246*, i8*)* %3, void (%struct.RuntimeContext.246*, i8*, i32)* %4, void (%struct.RuntimeContext.246*, i8*)* %5, i64 %6) #0 {
  %8 = alloca %struct.RuntimeContext.246*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca void (%struct.RuntimeContext.246*, i8*)*, align 8
  %12 = alloca void (%struct.RuntimeContext.246*, i8*, i32)*, align 8
  %13 = alloca void (%struct.RuntimeContext.246*, i8*)*, align 8
  %14 = alloca i64, align 8
  %15 = alloca i32, align 4
  %16 = alloca i8*, align 8
  %17 = alloca i64, align 8
  %18 = alloca i8*, align 8
  store %struct.RuntimeContext.246* %0, %struct.RuntimeContext.246** %8, align 8
  store i32 %1, i32* %9, align 4
  store i32 %2, i32* %10, align 4
  store void (%struct.RuntimeContext.246*, i8*)* %3, void (%struct.RuntimeContext.246*, i8*)** %11, align 8
  store void (%struct.RuntimeContext.246*, i8*, i32)* %4, void (%struct.RuntimeContext.246*, i8*, i32)** %12, align 8
  store void (%struct.RuntimeContext.246*, i8*)* %5, void (%struct.RuntimeContext.246*, i8*)** %13, align 8
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
  %30 = load void (%struct.RuntimeContext.246*, i8*)*, void (%struct.RuntimeContext.246*, i8*)** %11, align 8
  %31 = icmp ne void (%struct.RuntimeContext.246*, i8*)* %30, null
  br i1 %31, label %32, label %36

32:                                               ; preds = %7
  %33 = load void (%struct.RuntimeContext.246*, i8*)*, void (%struct.RuntimeContext.246*, i8*)** %11, align 8
  %34 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %8, align 8
  %35 = load i8*, i8** %18, align 8
  call void %33(%struct.RuntimeContext.246* %34, i8* %35)
  br label %36

36:                                               ; preds = %32, %7
  br label %37

37:                                               ; preds = %41, %36
  %38 = load i32, i32* %15, align 4
  %39 = load i32, i32* %10, align 4
  %40 = icmp slt i32 %38, %39
  br i1 %40, label %41, label %51

41:                                               ; preds = %37
  %42 = load void (%struct.RuntimeContext.246*, i8*, i32)*, void (%struct.RuntimeContext.246*, i8*, i32)** %12, align 8
  %43 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %8, align 8
  %44 = load i8*, i8** %18, align 8
  %45 = load i32, i32* %15, align 4
  call void %42(%struct.RuntimeContext.246* %43, i8* %44, i32 %45)
  %46 = call i32 @block_dim()
  %47 = call i32 @grid_dim()
  %48 = mul nsw i32 %46, %47
  %49 = load i32, i32* %15, align 4
  %50 = add nsw i32 %49, %48
  store i32 %50, i32* %15, align 4
  br label %37

51:                                               ; preds = %37
  %52 = load void (%struct.RuntimeContext.246*, i8*)*, void (%struct.RuntimeContext.246*, i8*)** %13, align 8
  %53 = icmp ne void (%struct.RuntimeContext.246*, i8*)* %52, null
  br i1 %53, label %54, label %58

54:                                               ; preds = %51
  %55 = load void (%struct.RuntimeContext.246*, i8*)*, void (%struct.RuntimeContext.246*, i8*)** %13, align 8
  %56 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %8, align 8
  %57 = load i8*, i8** %18, align 8
  call void %55(%struct.RuntimeContext.246* %56, i8* %57)
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
define internal void @DenseMeta_set_morton_dim(%struct.DenseMeta.22* %0, i32 %1) #0 {
  %3 = alloca %struct.DenseMeta.22*, align 8
  %4 = alloca i32, align 4
  store %struct.DenseMeta.22* %0, %struct.DenseMeta.22** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.DenseMeta.22*, %struct.DenseMeta.22** %3, align 8
  %7 = getelementptr inbounds %struct.DenseMeta.22, %struct.DenseMeta.22* %6, i32 0, i32 1
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
  %6 = bitcast i8* %5 to %struct.StructMeta.248*
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 2
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
  %9 = bitcast i8* %8 to %struct.StructMeta.248*
  %10 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %9, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = load i32, i32* %6, align 4
  %13 = sext i32 %12 to i64
  %14 = mul i64 %11, %13
  %15 = getelementptr inbounds i8, i8* %7, i64 %14
  ret i8* %15
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Pointer_get_num_elements(i8* %0, i8* %1) #0 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load i8*, i8** %3, align 8
  %6 = bitcast i8* %5 to %struct.StructMeta.248*
  %7 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %6, i32 0, i32 2
  %8 = load i64, i64* %7, align 8
  %9 = trunc i64 %8 to i32
  ret i32 %9
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @Pointer_activate(i8* %0, i8* %1, i32 %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct.StructMeta.248*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8*, align 8
  %10 = alloca i8**, align 8
  %11 = alloca i32, align 4
  %12 = alloca %class.anon.4.24, align 8
  %13 = alloca %class.anon.5.25, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 %2, i32* %6, align 4
  %14 = load i8*, i8** %4, align 8
  %15 = bitcast i8* %14 to %struct.StructMeta.248*
  store %struct.StructMeta.248* %15, %struct.StructMeta.248** %7, align 8
  %16 = load i8*, i8** %4, align 8
  %17 = load i8*, i8** %5, align 8
  %18 = call i32 @Pointer_get_num_elements(i8* %16, i8* %17)
  store i32 %18, i32* %8, align 4
  %19 = load i8*, i8** %5, align 8
  %20 = load i32, i32* %6, align 4
  %21 = mul nsw i32 8, %20
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds i8, i8* %19, i64 %22
  store volatile i8* %23, i8** %9, align 8
  %24 = load i8*, i8** %5, align 8
  %25 = load i32, i32* %8, align 4
  %26 = load i32, i32* %6, align 4
  %27 = add nsw i32 %25, %26
  %28 = mul nsw i32 8, %27
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i8, i8* %24, i64 %29
  %31 = bitcast i8* %30 to i8**
  store i8** %31, i8*** %10, align 8
  %32 = load i8**, i8*** %10, align 8
  %33 = load volatile i8*, i8** %32, align 8
  %34 = icmp eq i8* %33, null
  br i1 %34, label %35, label %48

35:                                               ; preds = %3
  %36 = call i32 @cuda_active_mask()
  store i32 %36, i32* %11, align 4
  %37 = load i32, i32* %11, align 4
  %38 = load volatile i8*, i8** %9, align 8
  %39 = ptrtoint i8* %38 to i64
  %40 = call zeroext i1 @is_representative(i32 %37, i64 %39)
  br i1 %40, label %41, label %46

41:                                               ; preds = %35
  %42 = load volatile i8*, i8** %9, align 8
  %43 = getelementptr inbounds %class.anon.4.24, %class.anon.4.24* %12, i32 0, i32 0
  store %struct.StructMeta.248** %7, %struct.StructMeta.248*** %43, align 8
  %44 = getelementptr inbounds %class.anon.4.24, %class.anon.4.24* %12, i32 0, i32 1
  store i8*** %10, i8**** %44, align 8
  %45 = getelementptr inbounds %class.anon.5.25, %class.anon.5.25* %13, i32 0, i32 0
  store i8*** %10, i8**** %45, align 8
  call void @"_Z11locked_taskIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EvPvRKT_RKT0_"(i8* %42, %class.anon.4.24* dereferenceable(16) %12, %class.anon.5.25* dereferenceable(8) %13)
  br label %46

46:                                               ; preds = %41, %35
  %47 = load i32, i32* %11, align 4
  call void @warp_barrier(i32 %47)
  br label %48

48:                                               ; preds = %46, %3
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_active_mask() #0 {
  %1 = alloca i32, align 4
  %2 = call i32 asm sideeffect "activemask.b32 $0;", "=r,~{dirflag},~{fpsr},~{flags}"() #1, !srcloc !10
  store i32 %2, i32* %1, align 4
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @is_representative(i32 %0, i64 %1) #0 {
  %3 = alloca i1, align 1
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i64 %1, i64* %5, align 8
  %12 = call i32 @cuda_compute_capability()
  %13 = icmp slt i32 %12, 70
  br i1 %13, label %14, label %74

14:                                               ; preds = %2
  store i8 0, i8* %6, align 1
  store i32 1, i32* %7, align 4
  br label %15

15:                                               ; preds = %67, %14
  %16 = load i32, i32* %7, align 4
  %17 = icmp slt i32 %16, 32
  br i1 %17, label %18, label %70

18:                                               ; preds = %15
  %19 = call i32 @warp_idx()
  %20 = load i32, i32* %7, align 4
  %21 = add nsw i32 %19, %20
  %22 = icmp slt i32 %21, 32
  br i1 %22, label %23, label %31

23:                                               ; preds = %18
  %24 = load i32, i32* %4, align 4
  %25 = call i32 @warp_idx()
  %26 = load i32, i32* %7, align 4
  %27 = add nsw i32 %25, %26
  %28 = lshr i32 %24, %27
  %29 = and i32 %28, 1
  %30 = icmp ne i32 %29, 0
  br label %31

31:                                               ; preds = %23, %18
  %32 = phi i1 [ false, %18 ], [ %30, %23 ]
  %33 = zext i1 %32 to i8
  store i8 %33, i8* %8, align 1
  %34 = load i8, i8* %8, align 1
  %35 = trunc i8 %34 to i1
  br i1 %35, label %36, label %56

36:                                               ; preds = %31
  %37 = load i64, i64* %5, align 8
  %38 = trunc i64 %37 to i32
  %39 = load i32, i32* %4, align 4
  %40 = load i64, i64* %5, align 8
  %41 = trunc i64 %40 to i32
  %42 = load i32, i32* %7, align 4
  %43 = call i32 @cuda_shfl_down_sync_i32(i32 %39, i32 %41, i32 %42, i32 31)
  %44 = icmp eq i32 %38, %43
  br i1 %44, label %45, label %56

45:                                               ; preds = %36
  %46 = load i64, i64* %5, align 8
  %47 = lshr i64 %46, 32
  %48 = trunc i64 %47 to i32
  %49 = load i32, i32* %4, align 4
  %50 = load i64, i64* %5, align 8
  %51 = lshr i64 %50, 32
  %52 = trunc i64 %51 to i32
  %53 = load i32, i32* %7, align 4
  %54 = call i32 @cuda_shfl_down_sync_i32(i32 %49, i32 %52, i32 %53, i32 31)
  %55 = icmp eq i32 %48, %54
  br label %56

56:                                               ; preds = %45, %36, %31
  %57 = phi i1 [ false, %36 ], [ false, %31 ], [ %55, %45 ]
  %58 = zext i1 %57 to i8
  store i8 %58, i8* %9, align 1
  %59 = load i8, i8* %6, align 1
  %60 = trunc i8 %59 to i1
  br i1 %60, label %64, label %61

61:                                               ; preds = %56
  %62 = load i8, i8* %9, align 1
  %63 = trunc i8 %62 to i1
  br label %64

64:                                               ; preds = %61, %56
  %65 = phi i1 [ true, %56 ], [ %63, %61 ]
  %66 = zext i1 %65 to i8
  store i8 %66, i8* %6, align 1
  br label %67

67:                                               ; preds = %64
  %68 = load i32, i32* %7, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %7, align 4
  br label %15

70:                                               ; preds = %15
  %71 = load i8, i8* %6, align 1
  %72 = trunc i8 %71 to i1
  %73 = xor i1 %72, true
  store i1 %73, i1* %3, align 1
  br label %83

74:                                               ; preds = %2
  %75 = load i32, i32* %4, align 4
  %76 = load i64, i64* %5, align 8
  %77 = call i32 @cuda_match_any_sync_i64(i32 %75, i64 %76)
  store i32 %77, i32* %10, align 4
  %78 = load i32, i32* %10, align 4
  %79 = call i32 @cttz_i32(i32 %78)
  store i32 %79, i32* %11, align 4
  %80 = call i32 @warp_idx()
  %81 = load i32, i32* %11, align 4
  %82 = icmp eq i32 %80, %81
  store i1 %82, i1* %3, align 1
  br label %83

83:                                               ; preds = %74, %70
  %84 = load i1, i1* %3, align 1
  ret i1 %84
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EvPvRKT_RKT0_"(i8* %0, %class.anon.4.24* dereferenceable(16) %1, %class.anon.5.25* dereferenceable(8) %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca %class.anon.4.24*, align 8
  %6 = alloca %class.anon.5.25*, align 8
  %7 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %4, align 8
  store %class.anon.4.24* %1, %class.anon.4.24** %5, align 8
  store %class.anon.5.25* %2, %class.anon.5.25** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %class.anon.4.24*, %class.anon.4.24** %5, align 8
  %10 = load %class.anon.5.25*, %class.anon.5.25** %6, align 8
  call void @"_ZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC2EPhRKS0_RKS1_"(%class.lock_guard.38.21* %7, i8* %8, %class.anon.4.24* dereferenceable(16) %9, %class.anon.5.25* dereferenceable(8) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @warp_barrier(i32 %0) #0 {
entry:
  call void @llvm.nvvm.bar.warp.sync(i32 %0)
  ret void
}

; Function Attrs: convergent nounwind
declare void @llvm.nvvm.bar.warp.sync(i32) #3

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC2EPhRKS0_RKS1_"(%class.lock_guard.38.21* %0, i8* %1, %class.anon.4.24* dereferenceable(16) %2, %class.anon.5.25* dereferenceable(8) %3) unnamed_addr #0 align 2 {
  %5 = alloca %class.lock_guard.38.21*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %class.anon.4.24*, align 8
  %8 = alloca %class.anon.5.25*, align 8
  %9 = alloca %class.anon.40.26, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %5, align 8
  store i8* %1, i8** %6, align 8
  store %class.anon.4.24* %2, %class.anon.4.24** %7, align 8
  store %class.anon.5.25* %3, %class.anon.5.25** %8, align 8
  %15 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %5, align 8
  %16 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %9, i32 0, i32 0
  %17 = load %class.anon.5.25*, %class.anon.5.25** %8, align 8
  store %class.anon.5.25* %17, %class.anon.5.25** %16, align 8
  %18 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %9, i32 0, i32 2
  %20 = load %class.anon.4.24*, %class.anon.4.24** %7, align 8
  store %class.anon.4.24* %20, %class.anon.4.24** %19, align 8
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
  call void @"_ZZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC1EPhRKS0_RKS1_ENKUlvE_clEv"(%class.anon.40.26* %9)
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
  call void @"_ZZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC1EPhRKS0_RKS1_ENKUlvE_clEv"(%class.anon.40.26* %9)
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
  call void @"_ZZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC1EPhRKS0_RKS1_ENKUlvE_clEv"(%class.anon.40.26* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_compute_capability() #0 {
entry:
  ret i32 75
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cttz_i32(i32 %0) #0 {
entry:
  %1 = call i32 @llvm.cttz.i32(i32 %0, i1 false)
  ret i32 %1
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @warp_idx() #0 {
  %1 = call i32 @thread_idx()
  %2 = call i32 @warp_size()
  %3 = srem i32 %1, %2
  ret i32 %3
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZ16Pointer_activateE3$_5Z16Pointer_activateE3$_6EC1EPhRKS0_RKS1_ENKUlvE_clEv"(%class.anon.40.26* %0) #0 align 2 {
  %2 = alloca %class.anon.40.26*, align 8
  store %class.anon.40.26* %0, %class.anon.40.26** %2, align 8
  %3 = load %class.anon.40.26*, %class.anon.40.26** %2, align 8
  %4 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %3, i32 0, i32 0
  %5 = load %class.anon.5.25*, %class.anon.5.25** %4, align 8
  %6 = call zeroext i1 @"_ZZ16Pointer_activateENK3$_6clEv"(%class.anon.5.25* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %3, i32 0, i32 0
  %12 = load %class.anon.5.25*, %class.anon.5.25** %11, align 8
  %13 = call zeroext i1 @"_ZZ16Pointer_activateENK3$_6clEv"(%class.anon.5.25* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %3, i32 0, i32 2
  %16 = load %class.anon.4.24*, %class.anon.4.24** %15, align 8
  call void @"_ZZ16Pointer_activateENK3$_5clEv"(%class.anon.4.24* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %class.anon.40.26, %class.anon.40.26* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @warp_size() #0 {
  ret i32 32
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ16Pointer_activateENK3$_6clEv"(%class.anon.5.25* %0) #0 align 2 {
  %2 = alloca %class.anon.5.25*, align 8
  store %class.anon.5.25* %0, %class.anon.5.25** %2, align 8
  %3 = load %class.anon.5.25*, %class.anon.5.25** %2, align 8
  %4 = getelementptr inbounds %class.anon.5.25, %class.anon.5.25* %3, i32 0, i32 0
  %5 = load i8***, i8**** %4, align 8
  %6 = load i8**, i8*** %5, align 8
  %7 = load volatile i8*, i8** %6, align 8
  %8 = icmp eq i8* %7, null
  ret i1 %8
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mutex_lock_i32(i8* %0) #0 {
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
define internal void @grid_memfence() #0 {
entry:
  call void @llvm.nvvm.membar.gl()
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZ16Pointer_activateENK3$_5clEv"(%class.anon.4.24* %0) #0 align 2 {
  %2 = alloca %class.anon.4.24*, align 8
  %3 = alloca %struct.LLVMRuntime.245*, align 8
  %4 = alloca %struct.NodeManager.241*, align 8
  %5 = alloca i64, align 8
  store %class.anon.4.24* %0, %class.anon.4.24** %2, align 8
  %6 = load %class.anon.4.24*, %class.anon.4.24** %2, align 8
  %7 = getelementptr inbounds %class.anon.4.24, %class.anon.4.24* %6, i32 0, i32 0
  %8 = load %struct.StructMeta.248**, %struct.StructMeta.248*** %7, align 8
  %9 = load %struct.StructMeta.248*, %struct.StructMeta.248** %8, align 8
  %10 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %9, i32 0, i32 8
  %11 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %10, align 8
  %12 = getelementptr inbounds %struct.RuntimeContext.246, %struct.RuntimeContext.246* %11, i32 0, i32 0
  %13 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %12, align 8
  store %struct.LLVMRuntime.245* %13, %struct.LLVMRuntime.245** %3, align 8
  %14 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %3, align 8
  %15 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %14, i32 0, i32 14
  %16 = getelementptr inbounds %class.anon.4.24, %class.anon.4.24* %6, i32 0, i32 0
  %17 = load %struct.StructMeta.248**, %struct.StructMeta.248*** %16, align 8
  %18 = load %struct.StructMeta.248*, %struct.StructMeta.248** %17, align 8
  %19 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %18, i32 0, i32 0
  %20 = load i32, i32* %19, align 8
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [1024 x %struct.NodeManager.241*], [1024 x %struct.NodeManager.241*]* %15, i64 0, i64 %21
  %23 = load %struct.NodeManager.241*, %struct.NodeManager.241** %22, align 8
  store %struct.NodeManager.241* %23, %struct.NodeManager.241** %4, align 8
  %24 = load %struct.NodeManager.241*, %struct.NodeManager.241** %4, align 8
  %25 = call i8* @_ZN11NodeManager8allocateEv(%struct.NodeManager.241* %24)
  %26 = ptrtoint i8* %25 to i64
  store i64 %26, i64* %5, align 8
  %27 = getelementptr inbounds %class.anon.4.24, %class.anon.4.24* %6, i32 0, i32 1
  %28 = load i8***, i8**** %27, align 8
  %29 = load i8**, i8*** %28, align 8
  %30 = bitcast i8** %29 to i64*
  %31 = load i64, i64* %5, align 8
  %32 = call i64 @atomic_exchange_u64(i64* %30, i64 %31)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mutex_unlock_i32(i8* %0) #0 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = load i8*, i8** %2, align 8
  %4 = bitcast i8* %3 to i32*
  %5 = call i32 @atomic_exchange_i32(i32* %4, i32 0)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @atomic_exchange_i32(i32* %0, i32 %1) #0 {
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
define internal i8* @_ZN11NodeManager8allocateEv(%struct.NodeManager.241* %0) #0 align 2 {
  %2 = alloca %struct.NodeManager.241*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.NodeManager.241* %0, %struct.NodeManager.241** %2, align 8
  %5 = load %struct.NodeManager.241*, %struct.NodeManager.241** %2, align 8
  %6 = getelementptr inbounds %struct.NodeManager.241, %struct.NodeManager.241* %5, i32 0, i32 4
  %7 = call i32 @atomic_add_i32(i32* %6, i32 1)
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  %9 = getelementptr inbounds %struct.NodeManager.241, %struct.NodeManager.241* %5, i32 0, i32 5
  %10 = load %struct.ListManager.240*, %struct.ListManager.240** %9, align 8
  %11 = call i32 @_ZN11ListManager4sizeEv(%struct.ListManager.240* %10)
  %12 = icmp sge i32 %8, %11
  br i1 %12, label %13, label %17

13:                                               ; preds = %1
  %14 = getelementptr inbounds %struct.NodeManager.241, %struct.NodeManager.241* %5, i32 0, i32 7
  %15 = load %struct.ListManager.240*, %struct.ListManager.240** %14, align 8
  %16 = call i32 @_ZN11ListManager19reserve_new_elementEv(%struct.ListManager.240* %15)
  store i32 %16, i32* %4, align 4
  br label %23

17:                                               ; preds = %1
  %18 = getelementptr inbounds %struct.NodeManager.241, %struct.NodeManager.241* %5, i32 0, i32 5
  %19 = load %struct.ListManager.240*, %struct.ListManager.240** %18, align 8
  %20 = load i32, i32* %3, align 4
  %21 = call dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.240* %19, i32 %20)
  %22 = load i32, i32* %21, align 4
  store i32 %22, i32* %4, align 4
  br label %23

23:                                               ; preds = %17, %13
  %24 = getelementptr inbounds %struct.NodeManager.241, %struct.NodeManager.241* %5, i32 0, i32 7
  %25 = load %struct.ListManager.240*, %struct.ListManager.240** %24, align 8
  %26 = load i32, i32* %4, align 4
  %27 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.240* %25, i32 %26)
  ret i8* %27
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @atomic_exchange_u64(i64* %0, i64 %1) #0 {
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
define internal i32 @atomic_add_i32(i32* %0, i32 %1) #0 {
entry:
  %2 = atomicrmw add i32* %0, i32 %1 seq_cst
  ret i32 %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11ListManager4sizeEv(%struct.ListManager.240* %0) #0 align 2 {
  %2 = alloca %struct.ListManager.240*, align 8
  store %struct.ListManager.240* %0, %struct.ListManager.240** %2, align 8
  %3 = load %struct.ListManager.240*, %struct.ListManager.240** %2, align 8
  %4 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %3, i32 0, i32 5
  %5 = load i32, i32* %4, align 8
  ret i32 %5
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @_ZN11ListManager19reserve_new_elementEv(%struct.ListManager.240* %0) #0 align 2 {
  %2 = alloca %struct.ListManager.240*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.ListManager.240* %0, %struct.ListManager.240** %2, align 8
  %5 = load %struct.ListManager.240*, %struct.ListManager.240** %2, align 8
  %6 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 5
  %7 = call i32 @atomic_add_i32(i32* %6, i32 1)
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  %9 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 3
  %10 = load i32, i32* %9, align 8
  %11 = ashr i32 %8, %10
  store i32 %11, i32* %4, align 4
  %12 = load i32, i32* %4, align 4
  call void @_ZN11ListManager11touch_chunkEi(%struct.ListManager.240* %5, i32 %12)
  %13 = load i32, i32* %3, align 4
  ret i32 %13
}

; Function Attrs: alwaysinline nounwind uwtable
define internal dereferenceable(4) i32* @_ZN11ListManager3getIiEERT_i(%struct.ListManager.240* %0, i32 %1) #0 align 2 {
  %3 = alloca %struct.ListManager.240*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.240* %0, %struct.ListManager.240** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.240*, %struct.ListManager.240** %3, align 8
  %6 = load i32, i32* %4, align 4
  %7 = call i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.240* %5, i32 %6)
  %8 = bitcast i8* %7 to i32*
  ret i32* %8
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11ListManager15get_element_ptrEi(%struct.ListManager.240* %0, i32 %1) #0 align 2 {
  %3 = alloca %struct.ListManager.240*, align 8
  %4 = alloca i32, align 4
  store %struct.ListManager.240* %0, %struct.ListManager.240** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load %struct.ListManager.240*, %struct.ListManager.240** %3, align 8
  %6 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 0
  %7 = load i32, i32* %4, align 4
  %8 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 3
  %9 = load i32, i32* %8, align 8
  %10 = ashr i32 %7, %9
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %6, i64 0, i64 %11
  %13 = load i8*, i8** %12, align 8
  %14 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 1
  %15 = load i64, i64* %14, align 8
  %16 = load i32, i32* %4, align 4
  %17 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %5, i32 0, i32 3
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
define internal void @_ZN11ListManager11touch_chunkEi(%struct.ListManager.240* %0, i32 %1) #0 align 2 {
  %3 = alloca %struct.ListManager.240*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %3, align 8
  store %struct.ListManager.240* %0, %struct.ListManager.240** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.ListManager.240*, %struct.ListManager.240** %3, align 8
  %7 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 6
  %8 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %7, align 8
  %9 = load i32, i32* %4, align 4
  %10 = sext i32 %9 to i64
  %11 = icmp ult i64 %10, 131072
  %12 = zext i1 %11 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.245* %8, i32 %12, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.6, i64 0, i64 0))
  %13 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 0
  %14 = load i32, i32* %4, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %13, i64 0, i64 %15
  %17 = load i8*, i8** %16, align 8
  %18 = icmp ne i8* %17, null
  br i1 %18, label %24, label %19

19:                                               ; preds = %2
  %20 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 4
  %21 = bitcast i32* %20 to i8*
  %22 = getelementptr inbounds %3, %3* %5, i32 0, i32 0
  store %struct.ListManager.240* %6, %struct.ListManager.240** %22, align 8
  %23 = getelementptr inbounds %3, %3* %5, i32 0, i32 1
  store i32* %4, i32** %23, align 8
  call void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_"(i8* %21, %3* dereferenceable(16) %5)
  br label %24

24:                                               ; preds = %19, %2
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @taichi_assert_runtime(%struct.LLVMRuntime.245* %0, i32 %1, i8* %2) #0 {
  %4 = alloca %struct.LLVMRuntime.245*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  store %struct.LLVMRuntime.245* %0, %struct.LLVMRuntime.245** %4, align 8
  store i32 %1, i32* %5, align 4
  store i8* %2, i8** %6, align 8
  %7 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %4, align 8
  %8 = load i32, i32* %5, align 4
  %9 = load i8*, i8** %6, align 8
  call void @taichi_assert_format(%struct.LLVMRuntime.245* %7, i32 %8, i8* %9, i32 0, i64* null)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_"(i8* %0, %3* dereferenceable(16) %1) #0 {
  %3 = alloca i8*, align 8
  %4 = alloca %3*, align 8
  %5 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %3, align 8
  store %3* %1, %3** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %3*, %3** %4, align 8
  call void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %6, %3* dereferenceable(16) %7, %class.lock_guard.38.21* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %0, %3* dereferenceable(16) %1, %class.lock_guard.38.21* dereferenceable(1) %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca %3*, align 8
  %6 = alloca %class.lock_guard.38.21*, align 8
  %7 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %4, align 8
  store %3* %1, %3** %5, align 8
  store %class.lock_guard.38.21* %2, %class.lock_guard.38.21** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %3*, %3** %5, align 8
  %10 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %6, align 8
  call void @"_ZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%class.lock_guard.38.21* %7, i8* %8, %3* dereferenceable(16) %9, %class.lock_guard.38.21* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%class.lock_guard.38.21* %0, i8* %1, %3* dereferenceable(16) %2, %class.lock_guard.38.21* dereferenceable(1) %3) unnamed_addr #0 align 2 {
  %5 = alloca %class.lock_guard.38.21*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %3*, align 8
  %8 = alloca %class.lock_guard.38.21*, align 8
  %9 = alloca %4, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %5, align 8
  store i8* %1, i8** %6, align 8
  store %3* %2, %3** %7, align 8
  store %class.lock_guard.38.21* %3, %class.lock_guard.38.21** %8, align 8
  %15 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %5, align 8
  %16 = getelementptr inbounds %4, %4* %9, i32 0, i32 0
  %17 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %8, align 8
  store %class.lock_guard.38.21* %17, %class.lock_guard.38.21** %16, align 8
  %18 = getelementptr inbounds %4, %4* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %4, %4* %9, i32 0, i32 2
  %20 = load %3*, %3** %7, align 8
  store %3* %20, %3** %19, align 8
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
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%4* %9)
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
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%4* %9)
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
  call void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%4* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZN11ListManager11touch_chunkEiE3$_8Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%4* %0) #0 align 2 {
  %2 = alloca %4*, align 8
  store %4* %0, %4** %2, align 8
  %3 = load %4*, %4** %2, align 8
  %4 = getelementptr inbounds %4, %4* %3, i32 0, i32 0
  %5 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %4, %4* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %4, %4* %3, i32 0, i32 0
  %12 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %4, %4* %3, i32 0, i32 2
  %16 = load %3*, %3** %15, align 8
  call void @"_ZZN11ListManager11touch_chunkEiENK3$_8clEv"(%3* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %4, %4* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZN11ListManager11touch_chunkEiE3$_8EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %0) #0 align 2 {
  %2 = alloca %class.lock_guard.38.21*, align 8
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %2, align 8
  %3 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN11ListManager11touch_chunkEiENK3$_8clEv"(%3* %0) #0 align 2 {
  %2 = alloca %3*, align 8
  %3 = alloca i8*, align 8
  store %3* %0, %3** %2, align 8
  %4 = load %3*, %3** %2, align 8
  %5 = getelementptr inbounds %3, %3* %4, i32 0, i32 0
  %6 = load %struct.ListManager.240*, %struct.ListManager.240** %5, align 8
  %7 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 0
  %8 = getelementptr inbounds %3, %3* %4, i32 0, i32 1
  %9 = load i32*, i32** %8, align 8
  %10 = load i32, i32* %9, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [131072 x i8*], [131072 x i8*]* %7, i64 0, i64 %11
  %13 = load i8*, i8** %12, align 8
  %14 = icmp ne i8* %13, null
  br i1 %14, label %34, label %15

15:                                               ; preds = %1
  call void @grid_memfence()
  %16 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 6
  %17 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %16, align 8
  %18 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 2
  %19 = load i64, i64* %18, align 8
  %20 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 1
  %21 = load i64, i64* %20, align 8
  %22 = mul i64 %19, %21
  %23 = call i8* @_ZN11LLVMRuntime24request_allocate_alignedEmm(%struct.LLVMRuntime.245* %17, i64 %22, i64 4096)
  store i8* %23, i8** %3, align 8
  %24 = getelementptr inbounds %struct.ListManager.240, %struct.ListManager.240* %6, i32 0, i32 0
  %25 = getelementptr inbounds %3, %3* %4, i32 0, i32 1
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
define internal i8* @_ZN11LLVMRuntime24request_allocate_alignedEmm(%struct.LLVMRuntime.245* %0, i64 %1, i64 %2) #0 align 2 {
  %4 = alloca i8*, align 8
  %5 = alloca %struct.LLVMRuntime.245*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = alloca %struct.MemRequest.243*, align 8
  store %struct.LLVMRuntime.245* %0, %struct.LLVMRuntime.245** %5, align 8
  store i64 %1, i64* %6, align 8
  store i64 %2, i64* %7, align 8
  %10 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %5, align 8
  %11 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %10, i32 0, i32 30
  %12 = load i64, i64* %6, align 8
  %13 = call i64 @atomic_add_i64(i64* %11, i64 %12)
  %14 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %10, i32 0, i32 0
  %15 = load i8, i8* %14, align 8
  %16 = trunc i8 %15 to i1
  br i1 %16, label %17, label %21

17:                                               ; preds = %3
  %18 = load i64, i64* %6, align 8
  %19 = load i64, i64* %7, align 8
  %20 = call i8* @_ZN11LLVMRuntime20allocate_from_bufferEmm(%struct.LLVMRuntime.245* %10, i64 %18, i64 %19)
  store i8* %20, i8** %4, align 8
  br label %53

21:                                               ; preds = %3
  %22 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %10, i32 0, i32 19
  %23 = load %struct.MemRequestQueue.244*, %struct.MemRequestQueue.244** %22, align 8
  %24 = getelementptr inbounds %struct.MemRequestQueue.244, %struct.MemRequestQueue.244* %23, i32 0, i32 1
  %25 = call i32 @atomic_add_i32(i32* %24, i32 1)
  store i32 %25, i32* %8, align 4
  %26 = load i32, i32* %8, align 4
  %27 = icmp sle i32 %26, 65536
  %28 = zext i1 %27 to i32
  call void @taichi_assert_runtime(%struct.LLVMRuntime.245* %10, i32 %28, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.4, i64 0, i64 0))
  %29 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %10, i32 0, i32 19
  %30 = load %struct.MemRequestQueue.244*, %struct.MemRequestQueue.244** %29, align 8
  %31 = getelementptr inbounds %struct.MemRequestQueue.244, %struct.MemRequestQueue.244* %30, i32 0, i32 0
  %32 = load i32, i32* %8, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [65536 x %struct.MemRequest.243], [65536 x %struct.MemRequest.243]* %31, i64 0, i64 %33
  store volatile %struct.MemRequest.243* %34, %struct.MemRequest.243** %9, align 8
  %35 = load volatile %struct.MemRequest.243*, %struct.MemRequest.243** %9, align 8
  %36 = getelementptr inbounds %struct.MemRequest.243, %struct.MemRequest.243* %35, i32 0, i32 0
  %37 = load i64, i64* %6, align 8
  %38 = call i64 @atomic_exchange_u64(i64* %36, i64 %37)
  %39 = load volatile %struct.MemRequest.243*, %struct.MemRequest.243** %9, align 8
  %40 = getelementptr inbounds %struct.MemRequest.243, %struct.MemRequest.243* %39, i32 0, i32 1
  %41 = load i64, i64* %7, align 8
  %42 = call i64 @atomic_exchange_u64(i64* %40, i64 %41)
  br label %43

43:                                               ; preds = %48, %21
  %44 = load volatile %struct.MemRequest.243*, %struct.MemRequest.243** %9, align 8
  %45 = getelementptr inbounds %struct.MemRequest.243, %struct.MemRequest.243* %44, i32 0, i32 2
  %46 = load i8*, i8** %45, align 8
  %47 = icmp eq i8* %46, null
  br i1 %47, label %48, label %49

48:                                               ; preds = %43
  call void @system_memfence()
  br label %43

49:                                               ; preds = %43
  %50 = load volatile %struct.MemRequest.243*, %struct.MemRequest.243** %9, align 8
  %51 = getelementptr inbounds %struct.MemRequest.243, %struct.MemRequest.243* %50, i32 0, i32 2
  %52 = load i8*, i8** %51, align 8
  store i8* %52, i8** %4, align 8
  br label %53

53:                                               ; preds = %49, %17
  %54 = load i8*, i8** %4, align 8
  ret i8* %54
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @atomic_add_i64(i64* %0, i64 %1) #0 {
entry:
  %2 = atomicrmw add i64* %0, i64 %1 seq_cst
  ret i64 %2
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i8* @_ZN11LLVMRuntime20allocate_from_bufferEmm(%struct.LLVMRuntime.245* %0, i64 %1, i64 %2) #0 align 2 {
  %4 = alloca %struct.LLVMRuntime.245*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8, align 1
  %9 = alloca %5, align 8
  store %struct.LLVMRuntime.245* %0, %struct.LLVMRuntime.245** %4, align 8
  store i64 %1, i64* %5, align 8
  store i64 %2, i64* %6, align 8
  %10 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %4, align 8
  store i8* null, i8** %7, align 8
  store i8 0, i8* %8, align 1
  %11 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %10, i32 0, i32 28
  %12 = bitcast i32* %11 to i8*
  %13 = getelementptr inbounds %5, %5* %9, i32 0, i32 0
  store i64* %6, i64** %13, align 8
  %14 = getelementptr inbounds %5, %5* %9, i32 0, i32 1
  store %struct.LLVMRuntime.245* %10, %struct.LLVMRuntime.245** %14, align 8
  %15 = getelementptr inbounds %5, %5* %9, i32 0, i32 2
  store i64* %5, i64** %15, align 8
  %16 = getelementptr inbounds %5, %5* %9, i32 0, i32 3
  store i8** %7, i8*** %16, align 8
  %17 = getelementptr inbounds %5, %5* %9, i32 0, i32 4
  store i8* %8, i8** %17, align 8
  call void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_"(i8* %12, %5* dereferenceable(40) %9)
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
  call void @taichi_assert_runtime(%struct.LLVMRuntime.245* %10, i32 %24, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.3, i64 0, i64 0))
  %25 = load i8*, i8** %7, align 8
  ret i8* %25
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @system_memfence() #0 {
entry:
  call void @llvm.nvvm.membar.sys()
  ret void
}

; Function Attrs: nounwind
declare void @llvm.nvvm.membar.sys() #1

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_"(i8* %0, %5* dereferenceable(40) %1) #0 {
  %3 = alloca i8*, align 8
  %4 = alloca %5*, align 8
  %5 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %3, align 8
  store %5* %1, %5** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %5*, %5** %4, align 8
  call void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %6, %5* dereferenceable(40) %7, %class.lock_guard.38.21* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline
declare dso_local void @__assertfail(i8*, i8*, i32, i8*, i64) #4

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EvS3_S6_RKT0_"(i8* %0, %5* dereferenceable(40) %1, %class.lock_guard.38.21* dereferenceable(1) %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca %5*, align 8
  %6 = alloca %class.lock_guard.38.21*, align 8
  %7 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %4, align 8
  store %5* %1, %5** %5, align 8
  store %class.lock_guard.38.21* %2, %class.lock_guard.38.21** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %5*, %5** %5, align 8
  %10 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %6, align 8
  call void @"_ZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%class.lock_guard.38.21* %7, i8* %8, %5* dereferenceable(40) %9, %class.lock_guard.38.21* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC2EPhRKS1_RKS7_"(%class.lock_guard.38.21* %0, i8* %1, %5* dereferenceable(40) %2, %class.lock_guard.38.21* dereferenceable(1) %3) unnamed_addr #0 align 2 {
  %5 = alloca %class.lock_guard.38.21*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %5*, align 8
  %8 = alloca %class.lock_guard.38.21*, align 8
  %9 = alloca %6, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %5, align 8
  store i8* %1, i8** %6, align 8
  store %5* %2, %5** %7, align 8
  store %class.lock_guard.38.21* %3, %class.lock_guard.38.21** %8, align 8
  %15 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %5, align 8
  %16 = getelementptr inbounds %6, %6* %9, i32 0, i32 0
  %17 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %8, align 8
  store %class.lock_guard.38.21* %17, %class.lock_guard.38.21** %16, align 8
  %18 = getelementptr inbounds %6, %6* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %6, %6* %9, i32 0, i32 2
  %20 = load %5*, %5** %7, align 8
  store %5* %20, %5** %19, align 8
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
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%6* %9)
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
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%6* %9)
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
  call void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%6* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1Z11locked_taskIS1_EvPvRKT_EUlvE_EC1EPhRKS1_RKS7_ENKUlvE_clEv"(%6* %0) #0 align 2 {
  %2 = alloca %6*, align 8
  store %6* %0, %6** %2, align 8
  %3 = load %6*, %6** %2, align 8
  %4 = getelementptr inbounds %6, %6* %3, i32 0, i32 0
  %5 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %6, %6* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %6, %6* %3, i32 0, i32 0
  %12 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %6, %6* %3, i32 0, i32 2
  %16 = load %5*, %5** %15, align 8
  call void @"_ZZN11LLVMRuntime20allocate_from_bufferEmmENK3$_1clEv"(%5* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %6, %6* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZN11LLVMRuntime20allocate_from_bufferEmmE3$_1EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %0) #0 align 2 {
  %2 = alloca %class.lock_guard.38.21*, align 8
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %2, align 8
  %3 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN11LLVMRuntime20allocate_from_bufferEmmENK3$_1clEv"(%5* %0) #0 align 2 {
  %2 = alloca %5*, align 8
  %3 = alloca i64, align 8
  store %5* %0, %5** %2, align 8
  %4 = load %5*, %5** %2, align 8
  %5 = getelementptr inbounds %5, %5* %4, i32 0, i32 1
  %6 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %5, align 8
  %7 = getelementptr inbounds %5, %5* %4, i32 0, i32 0
  %8 = load i64*, i64** %7, align 8
  %9 = load i64, i64* %8, align 8
  %10 = sub i64 %9, 1
  %11 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %6, i32 0, i32 2
  %12 = load i8*, i8** %11, align 8
  %13 = ptrtoint i8* %12 to i64
  %14 = getelementptr inbounds %5, %5* %4, i32 0, i32 0
  %15 = load i64*, i64** %14, align 8
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %13, %16
  %18 = sub i64 %17, 1
  %19 = getelementptr inbounds %5, %5* %4, i32 0, i32 0
  %20 = load i64*, i64** %19, align 8
  %21 = load i64, i64* %20, align 8
  %22 = urem i64 %18, %21
  %23 = sub i64 %10, %22
  store i64 %23, i64* %3, align 8
  %24 = load i64, i64* %3, align 8
  %25 = getelementptr inbounds %5, %5* %4, i32 0, i32 2
  %26 = load i64*, i64** %25, align 8
  %27 = load i64, i64* %26, align 8
  %28 = add i64 %27, %24
  store i64 %28, i64* %26, align 8
  %29 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %6, i32 0, i32 2
  %30 = load i8*, i8** %29, align 8
  %31 = getelementptr inbounds %5, %5* %4, i32 0, i32 2
  %32 = load i64*, i64** %31, align 8
  %33 = load i64, i64* %32, align 8
  %34 = getelementptr inbounds i8, i8* %30, i64 %33
  %35 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %6, i32 0, i32 3
  %36 = load i8*, i8** %35, align 8
  %37 = icmp ule i8* %34, %36
  br i1 %37, label %38, label %53

38:                                               ; preds = %1
  %39 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %6, i32 0, i32 2
  %40 = load i8*, i8** %39, align 8
  %41 = load i64, i64* %3, align 8
  %42 = getelementptr inbounds i8, i8* %40, i64 %41
  %43 = getelementptr inbounds %5, %5* %4, i32 0, i32 3
  %44 = load i8**, i8*** %43, align 8
  store i8* %42, i8** %44, align 8
  %45 = getelementptr inbounds %5, %5* %4, i32 0, i32 2
  %46 = load i64*, i64** %45, align 8
  %47 = load i64, i64* %46, align 8
  %48 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %6, i32 0, i32 2
  %49 = load i8*, i8** %48, align 8
  %50 = getelementptr inbounds i8, i8* %49, i64 %47
  store i8* %50, i8** %48, align 8
  %51 = getelementptr inbounds %5, %5* %4, i32 0, i32 4
  %52 = load i8*, i8** %51, align 8
  store i8 1, i8* %52, align 1
  br label %56

53:                                               ; preds = %1
  %54 = getelementptr inbounds %5, %5* %4, i32 0, i32 4
  %55 = load i8*, i8** %54, align 8
  store i8 0, i8* %55, align 1
  br label %56

56:                                               ; preds = %53, %38
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @taichi_assert_format(%struct.LLVMRuntime.245* %0, i32 %1, i8* %2, i32 %3, i64* %4) #5 {
  %6 = alloca %struct.LLVMRuntime.245*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i64*, align 8
  %11 = alloca %7, align 8
  store %struct.LLVMRuntime.245* %0, %struct.LLVMRuntime.245** %6, align 8
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
  %16 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %6, align 8
  %17 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %16, i32 0, i32 26
  %18 = load i64, i64* %17, align 8
  %19 = icmp ne i64 %18, 0
  br i1 %19, label %28, label %20

20:                                               ; preds = %15
  %21 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %6, align 8
  %22 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %21, i32 0, i32 25
  %23 = bitcast i32* %22 to i8*
  %24 = getelementptr inbounds %7, %7* %11, i32 0, i32 0
  store %struct.LLVMRuntime.245** %6, %struct.LLVMRuntime.245*** %24, align 8
  %25 = getelementptr inbounds %7, %7* %11, i32 0, i32 1
  store i8** %8, i8*** %25, align 8
  %26 = getelementptr inbounds %7, %7* %11, i32 0, i32 2
  store i32* %9, i32** %26, align 8
  %27 = getelementptr inbounds %7, %7* %11, i32 0, i32 3
  store i64** %10, i64*** %27, align 8
  call void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_"(i8* %23, %7* dereferenceable(32) %11)
  br label %28

28:                                               ; preds = %20, %15
  call void asm sideeffect "exit;", "~{dirflag},~{fpsr},~{flags}"() #1, !srcloc !11
  br label %29

29:                                               ; preds = %28, %14
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @mark_force_no_inline() #0 {
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_"(i8* %0, %7* dereferenceable(32) %1) #0 {
  %3 = alloca i8*, align 8
  %4 = alloca %7*, align 8
  %5 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %3, align 8
  store %7* %1, %7** %4, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = load %7*, %7** %4, align 8
  call void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %6, %7* dereferenceable(32) %7, %class.lock_guard.38.21* dereferenceable(1) %5)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_Z11locked_taskIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EvS2_S5_RKT0_"(i8* %0, %7* dereferenceable(32) %1, %class.lock_guard.38.21* dereferenceable(1) %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca %7*, align 8
  %6 = alloca %class.lock_guard.38.21*, align 8
  %7 = alloca %class.lock_guard.38.21, align 1
  store i8* %0, i8** %4, align 8
  store %7* %1, %7** %5, align 8
  store %class.lock_guard.38.21* %2, %class.lock_guard.38.21** %6, align 8
  %8 = load i8*, i8** %4, align 8
  %9 = load %7*, %7** %5, align 8
  %10 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %6, align 8
  call void @"_ZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%class.lock_guard.38.21* %7, i8* %8, %7* dereferenceable(32) %9, %class.lock_guard.38.21* dereferenceable(1) %10)
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC2EPhRKS0_RKS6_"(%class.lock_guard.38.21* %0, i8* %1, %7* dereferenceable(32) %2, %class.lock_guard.38.21* dereferenceable(1) %3) unnamed_addr #0 align 2 {
  %5 = alloca %class.lock_guard.38.21*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %7*, align 8
  %8 = alloca %class.lock_guard.38.21*, align 8
  %9 = alloca %8, align 8
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %5, align 8
  store i8* %1, i8** %6, align 8
  store %7* %2, %7** %7, align 8
  store %class.lock_guard.38.21* %3, %class.lock_guard.38.21** %8, align 8
  %15 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %5, align 8
  %16 = getelementptr inbounds %8, %8* %9, i32 0, i32 0
  %17 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %8, align 8
  store %class.lock_guard.38.21* %17, %class.lock_guard.38.21** %16, align 8
  %18 = getelementptr inbounds %8, %8* %9, i32 0, i32 1
  store i8** %6, i8*** %18, align 8
  %19 = getelementptr inbounds %8, %8* %9, i32 0, i32 2
  %20 = load %7*, %7** %7, align 8
  store %7* %20, %7** %19, align 8
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
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%8* %9)
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
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%8* %9)
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
  call void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%8* %9)
  br label %63

63:                                               ; preds = %62, %61
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZN10lock_guardIZ20taichi_assert_formatE3$_0Z11locked_taskIS0_EvPvRKT_EUlvE_EC1EPhRKS0_RKS6_ENKUlvE_clEv"(%8* %0) #0 align 2 {
  %2 = alloca %8*, align 8
  store %8* %0, %8** %2, align 8
  %3 = load %8*, %8** %2, align 8
  %4 = getelementptr inbounds %8, %8* %3, i32 0, i32 0
  %5 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %4, align 8
  %6 = call zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %5)
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  %8 = getelementptr inbounds %8, %8* %3, i32 0, i32 1
  %9 = load i8**, i8*** %8, align 8
  %10 = load i8*, i8** %9, align 8
  call void @mutex_lock_i32(i8* %10)
  call void @grid_memfence()
  %11 = getelementptr inbounds %8, %8* %3, i32 0, i32 0
  %12 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %11, align 8
  %13 = call zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %12)
  br i1 %13, label %14, label %17

14:                                               ; preds = %7
  %15 = getelementptr inbounds %8, %8* %3, i32 0, i32 2
  %16 = load %7*, %7** %15, align 8
  call void @"_ZZ20taichi_assert_formatENK3$_0clEv"(%7* %16)
  br label %17

17:                                               ; preds = %14, %7
  call void @grid_memfence()
  %18 = getelementptr inbounds %8, %8* %3, i32 0, i32 1
  %19 = load i8**, i8*** %18, align 8
  %20 = load i8*, i8** %19, align 8
  call void @mutex_unlock_i32(i8* %20)
  br label %21

21:                                               ; preds = %17, %1
  ret void
}

; Function Attrs: alwaysinline nounwind uwtable
define internal zeroext i1 @"_ZZ11locked_taskIZ20taichi_assert_formatE3$_0EvPvRKT_ENKUlvE_clEv"(%class.lock_guard.38.21* %0) #0 align 2 {
  %2 = alloca %class.lock_guard.38.21*, align 8
  store %class.lock_guard.38.21* %0, %class.lock_guard.38.21** %2, align 8
  %3 = load %class.lock_guard.38.21*, %class.lock_guard.38.21** %2, align 8
  ret i1 true
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @"_ZZ20taichi_assert_formatENK3$_0clEv"(%7* %0) #0 align 2 {
  %2 = alloca %7*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store %7* %0, %7** %2, align 8
  %6 = load %7*, %7** %2, align 8
  %7 = getelementptr inbounds %7, %7* %6, i32 0, i32 0
  %8 = load %struct.LLVMRuntime.245**, %struct.LLVMRuntime.245*** %7, align 8
  %9 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %8, align 8
  %10 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %9, i32 0, i32 26
  %11 = load i64, i64* %10, align 8
  %12 = icmp ne i64 %11, 0
  br i1 %12, label %62, label %13

13:                                               ; preds = %1
  %14 = getelementptr inbounds %7, %7* %6, i32 0, i32 0
  %15 = load %struct.LLVMRuntime.245**, %struct.LLVMRuntime.245*** %14, align 8
  %16 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %15, align 8
  %17 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %16, i32 0, i32 26
  store i64 1, i64* %17, align 8
  %18 = getelementptr inbounds %7, %7* %6, i32 0, i32 0
  %19 = load %struct.LLVMRuntime.245**, %struct.LLVMRuntime.245*** %18, align 8
  %20 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %19, align 8
  %21 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %20, i32 0, i32 23
  %22 = getelementptr inbounds [2048 x i8], [2048 x i8]* %21, i64 0, i64 0
  call void @llvm.memset.p0i8.i64(i8* align 8 %22, i8 0, i64 2048, i1 false)
  %23 = getelementptr inbounds %7, %7* %6, i32 0, i32 0
  %24 = load %struct.LLVMRuntime.245**, %struct.LLVMRuntime.245*** %23, align 8
  %25 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %24, align 8
  %26 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %25, i32 0, i32 23
  %27 = getelementptr inbounds [2048 x i8], [2048 x i8]* %26, i64 0, i64 0
  %28 = getelementptr inbounds %7, %7* %6, i32 0, i32 1
  %29 = load i8**, i8*** %28, align 8
  %30 = load i8*, i8** %29, align 8
  %31 = getelementptr inbounds %7, %7* %6, i32 0, i32 1
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
  %39 = getelementptr inbounds %7, %7* %6, i32 0, i32 2
  %40 = load i32*, i32** %39, align 8
  %41 = load i32, i32* %40, align 4
  %42 = icmp slt i32 %38, %41
  br i1 %42, label %43, label %61

43:                                               ; preds = %37
  %44 = getelementptr inbounds %7, %7* %6, i32 0, i32 3
  %45 = load i64**, i64*** %44, align 8
  %46 = load i64*, i64** %45, align 8
  %47 = load i32, i32* %5, align 4
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i64, i64* %46, i64 %48
  %50 = load i64, i64* %49, align 8
  %51 = getelementptr inbounds %7, %7* %6, i32 0, i32 0
  %52 = load %struct.LLVMRuntime.245**, %struct.LLVMRuntime.245*** %51, align 8
  %53 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %52, align 8
  %54 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %53, i32 0, i32 24
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
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: alwaysinline nounwind uwtable
define internal i64 @taichi_strlen(i8* %0) #0 {
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
define internal dereferenceable(8) i64* @_ZSt3minImERKT_S2_S2_(i64* dereferenceable(8) %0, i64* dereferenceable(8) %1) #0 {
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

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #6

; Function Attrs: nounwind
declare void @llvm.nvvm.membar.gl() #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.cttz.i32(i32, i1 immarg) #7

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_shfl_down_sync_i32(i32 %0, i32 %1, i32 %2, i32 %3) #0 {
entry:
  %4 = call i32 @llvm.nvvm.shfl.sync.down.i32(i32 %0, i32 %1, i32 %2, i32 %3)
  ret i32 %4
}

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @cuda_match_any_sync_i64(i32 %0, i64 %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i64 %1, i64* %4, align 8
  %6 = load i64, i64* %4, align 8
  %7 = load i32, i32* %3, align 4
  %8 = call i32 asm sideeffect "match.any.sync.b64  $0, $1, $2;", "=r,l,r,~{dirflag},~{fpsr},~{flags}"(i64 %6, i32 %7) #1, !srcloc !12
  store i32 %8, i32* %5, align 4
  %9 = load i32, i32* %5, align 4
  ret i32 %9
}

; Function Attrs: convergent inaccessiblememonly nounwind
declare i32 @llvm.nvvm.shfl.sync.down.i32(i32, i32, i32, i32) #8

; Function Attrs: alwaysinline nounwind uwtable
define internal i32 @Pointer_is_active(i8* %0, i8* %1, i32 %2) #0 {
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
define internal i8* @Pointer_lookup_element(i8* %0, i8* %1, i32 %2) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca %struct.StructMeta.248*, align 8
  %10 = alloca %struct.RuntimeContext.246*, align 8
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
  %27 = bitcast i8* %26 to %struct.StructMeta.248*
  store %struct.StructMeta.248* %27, %struct.StructMeta.248** %9, align 8
  %28 = load %struct.StructMeta.248*, %struct.StructMeta.248** %9, align 8
  %29 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %28, i32 0, i32 8
  %30 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %29, align 8
  store %struct.RuntimeContext.246* %30, %struct.RuntimeContext.246** %10, align 8
  %31 = load %struct.RuntimeContext.246*, %struct.RuntimeContext.246** %10, align 8
  %32 = getelementptr inbounds %struct.RuntimeContext.246, %struct.RuntimeContext.246* %31, i32 0, i32 0
  %33 = load %struct.LLVMRuntime.245*, %struct.LLVMRuntime.245** %32, align 8
  %34 = getelementptr inbounds %struct.LLVMRuntime.245, %struct.LLVMRuntime.245* %33, i32 0, i32 16
  %35 = load %struct.StructMeta.248*, %struct.StructMeta.248** %9, align 8
  %36 = getelementptr inbounds %struct.StructMeta.248, %struct.StructMeta.248* %35, i32 0, i32 0
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

; Function Attrs: alwaysinline inlinehint
define internal float @__nv_sinf(float %a) #9 {
  %res.i.i.i.i = alloca %struct.uint2.27, align 8
  %p.i.i.i = alloca %struct.uint2.27, align 8
  %result.i.i.i = alloca [7 x i32], align 4
  %call.i.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %1 = icmp ne i32 %call.i.i.i, 0
  br i1 %1, label %2, label %4

2:                                                ; preds = %0
  %3 = call float @llvm.nvvm.fabs.ftz.f(float %a)
  br label %__nv_isinff.exit.i

4:                                                ; preds = %0
  %5 = call float @llvm.nvvm.fabs.f(float %a)
  br label %__nv_isinff.exit.i

__nv_isinff.exit.i:                               ; preds = %4, %2
  %retval.0.i.i.i = phi float [ %3, %2 ], [ %5, %4 ]
  %6 = bitcast i32 2139095040 to float
  %7 = fcmp oeq float %retval.0.i.i.i, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %9, label %15

9:                                                ; preds = %__nv_isinff.exit.i
  %call.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %10 = icmp ne i32 %call.i.i, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %9
  %12 = call float @llvm.nvvm.mul.rn.ftz.f(float %a, float 0.000000e+00)
  br label %__nv_fmul_rn.exit.i

13:                                               ; preds = %9
  %14 = call float @llvm.nvvm.mul.rn.f(float %a, float 0.000000e+00)
  br label %__nv_fmul_rn.exit.i

__nv_fmul_rn.exit.i:                              ; preds = %13, %11
  %retval.0.i.i = phi float [ %12, %11 ], [ %14, %13 ]
  br label %15

15:                                               ; preds = %__nv_fmul_rn.exit.i, %__nv_isinff.exit.i
  %a.addr.0.i = phi float [ %retval.0.i.i, %__nv_fmul_rn.exit.i ], [ %a, %__nv_isinff.exit.i ]
  %16 = fmul float %a.addr.0.i, 0x3FE45F3060000000
  %call.i.i1.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %17 = icmp ne i32 %call.i.i1.i, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  %19 = call i32 @llvm.nvvm.f2i.rn.ftz(float %16)
  br label %__nv_float2int_rn.exit.i.i

20:                                               ; preds = %15
  %21 = call i32 @llvm.nvvm.f2i.rn(float %16)
  br label %__nv_float2int_rn.exit.i.i

__nv_float2int_rn.exit.i.i:                       ; preds = %20, %18
  %retval.0.i.i2.i = phi i32 [ %19, %18 ], [ %21, %20 ]
  %22 = sitofp i32 %retval.0.i.i2.i to float
  %23 = fsub float -0.000000e+00, %22
  %call.i1.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %24 = icmp ne i32 %call.i1.i.i, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %__nv_float2int_rn.exit.i.i
  %26 = call float @llvm.nvvm.fma.rn.ftz.f(float %23, float 0x3FF921FB40000000, float %a.addr.0.i)
  br label %__nv_fmaf_rn.exit.i.i

27:                                               ; preds = %__nv_float2int_rn.exit.i.i
  %28 = call float @llvm.nvvm.fma.rn.f(float %23, float 0x3FF921FB40000000, float %a.addr.0.i)
  br label %__nv_fmaf_rn.exit.i.i

__nv_fmaf_rn.exit.i.i:                            ; preds = %27, %25
  %retval.0.i2.i.i = phi float [ %26, %25 ], [ %28, %27 ]
  %29 = fsub float -0.000000e+00, %22
  %call.i3.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %30 = icmp ne i32 %call.i3.i.i, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %__nv_fmaf_rn.exit.i.i
  %32 = call float @llvm.nvvm.fma.rn.ftz.f(float %29, float 0x3E74442D00000000, float %retval.0.i2.i.i)
  br label %__nv_fmaf_rn.exit5.i.i

33:                                               ; preds = %__nv_fmaf_rn.exit.i.i
  %34 = call float @llvm.nvvm.fma.rn.f(float %29, float 0x3E74442D00000000, float %retval.0.i2.i.i)
  br label %__nv_fmaf_rn.exit5.i.i

__nv_fmaf_rn.exit5.i.i:                           ; preds = %33, %31
  %retval.0.i4.i.i = phi float [ %32, %31 ], [ %34, %33 ]
  %35 = fsub float -0.000000e+00, %22
  %call.i6.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %36 = icmp ne i32 %call.i6.i.i, 0
  br i1 %36, label %37, label %39

37:                                               ; preds = %__nv_fmaf_rn.exit5.i.i
  %38 = call float @llvm.nvvm.fma.rn.ftz.f(float %35, float 0x3CF84698A0000000, float %retval.0.i4.i.i)
  br label %__nv_fmaf_rn.exit8.i.i

39:                                               ; preds = %__nv_fmaf_rn.exit5.i.i
  %40 = call float @llvm.nvvm.fma.rn.f(float %35, float 0x3CF84698A0000000, float %retval.0.i4.i.i)
  br label %__nv_fmaf_rn.exit8.i.i

__nv_fmaf_rn.exit8.i.i:                           ; preds = %39, %37
  %retval.0.i7.i.i = phi float [ %38, %37 ], [ %40, %39 ]
  %call.i9.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %41 = icmp ne i32 %call.i9.i.i, 0
  br i1 %41, label %42, label %44

42:                                               ; preds = %__nv_fmaf_rn.exit8.i.i
  %43 = call float @llvm.nvvm.fabs.ftz.f(float %a.addr.0.i)
  br label %__nv_fabsf.exit.i.i

44:                                               ; preds = %__nv_fmaf_rn.exit8.i.i
  %45 = call float @llvm.nvvm.fabs.f(float %a.addr.0.i)
  br label %__nv_fabsf.exit.i.i

__nv_fabsf.exit.i.i:                              ; preds = %44, %42
  %retval.0.i10.i.i = phi float [ %43, %42 ], [ %45, %44 ]
  %46 = fcmp ogt float %retval.0.i10.i.i, 1.056150e+05
  br i1 %46, label %47, label %__internal_trig_reduction_kernel.exit.i

47:                                               ; preds = %__nv_fabsf.exit.i.i
  %48 = bitcast %struct.uint2.27* %p.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %48)
  %49 = bitcast [7 x i32]* %result.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %49)
  %50 = bitcast float %a.addr.0.i to i32
  %51 = and i32 %50, -2147483648
  %52 = lshr i32 %50, 23
  %53 = and i32 %52, 255
  %54 = sub i32 %53, 128
  %55 = shl i32 %50, 8
  %56 = or i32 %55, -2147483648
  %57 = lshr i32 %54, 5
  %58 = sub i32 4, %57
  br label %59

59:                                               ; preds = %61, %47
  %hi.0.i.i.i = phi i32 [ 0, %47 ], [ %75, %61 ]
  %q.0.i.i.i = phi i32 [ 0, %47 ], [ %78, %61 ]
  %60 = icmp slt i32 %q.0.i.i.i, 6
  br i1 %60, label %61, label %79, !llvm.loop !13

61:                                               ; preds = %59
  %62 = getelementptr inbounds i32, i32* getelementptr inbounds ([6 x i32], [6 x i32]* addrspacecast ([6 x i32] addrspace(4)* @__cudart_i2opi_f to [6 x i32]*), i32 0, i32 0), i32 %q.0.i.i.i
  %63 = load i32, i32* %62, align 4
  %64 = bitcast %struct.uint2.27* %res.i.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %64)
  %65 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, i32 0, i32 0
  %66 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, i32 0, i32 1
  %67 = call { i32, i32 } asm "{\0A\09mad.lo.cc.u32   $0, $2, $3, $4;\0A\09madc.hi.u32     $1, $2, $3,  0;\0A\09}", "=r,=r,r,r,r"(i32 %63, i32 %56, i32 %hi.0.i.i.i) #1
  %68 = extractvalue { i32, i32 } %67, 0
  %69 = extractvalue { i32, i32 } %67, 1
  store i32 %68, i32* %65, align 8
  store i32 %69, i32* %66, align 4
  %70 = load %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, align 8
  %71 = bitcast %struct.uint2.27* %res.i.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %71)
  store %struct.uint2.27 %70, %struct.uint2.27* %p.i.i.i, align 8
  %72 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %p.i.i.i, i32 0, i32 0
  %73 = load i32, i32* %72, align 8
  %74 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %p.i.i.i, i32 0, i32 1
  %75 = load i32, i32* %74, align 4
  %76 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %77 = getelementptr inbounds i32, i32* %76, i32 %q.0.i.i.i
  store i32 %73, i32* %77, align 4
  %78 = add nsw i32 %q.0.i.i.i, 1
  br label %59

79:                                               ; preds = %59
  %80 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %81 = getelementptr inbounds i32, i32* %80, i32 %q.0.i.i.i
  store i32 %hi.0.i.i.i, i32* %81, align 4
  %82 = and i32 %54, 31
  %83 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %84 = add nsw i32 %58, 2
  %85 = getelementptr inbounds i32, i32* %83, i32 %84
  %86 = load i32, i32* %85, align 4
  %87 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %88 = add nsw i32 %58, 1
  %89 = getelementptr inbounds i32, i32* %87, i32 %88
  %90 = load i32, i32* %89, align 4
  %91 = icmp ne i32 %82, 0
  br i1 %91, label %92, label %103

92:                                               ; preds = %79
  %93 = sub i32 32, %82
  %94 = shl i32 %86, %82
  %95 = lshr i32 %90, %93
  %96 = add i32 %94, %95
  %97 = shl i32 %90, %82
  %98 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %99 = getelementptr inbounds i32, i32* %98, i32 %58
  %100 = load i32, i32* %99, align 4
  %101 = lshr i32 %100, %93
  %102 = add i32 %97, %101
  br label %103

103:                                              ; preds = %92, %79
  %hi.1.i.i.i = phi i32 [ %96, %92 ], [ %86, %79 ]
  %lo.0.i.i.i = phi i32 [ %102, %92 ], [ %90, %79 ]
  %104 = lshr i32 %hi.1.i.i.i, 30
  %105 = shl i32 %hi.1.i.i.i, 2
  %106 = lshr i32 %lo.0.i.i.i, 30
  %107 = add i32 %105, %106
  %108 = shl i32 %lo.0.i.i.i, 2
  %109 = lshr i32 %107, 31
  %110 = add i32 %104, %109
  %111 = icmp ne i32 %51, 0
  br i1 %111, label %112, label %114

112:                                              ; preds = %103
  %113 = sub i32 0, %110
  br label %114

114:                                              ; preds = %112, %103
  %q.1.i.i.i = phi i32 [ %113, %112 ], [ %110, %103 ]
  %115 = icmp ne i32 %109, 0
  br i1 %115, label %116, label %123

116:                                              ; preds = %114
  %117 = xor i32 %107, -1
  %118 = sub i32 0, %108
  %119 = icmp eq i32 %118, 0
  %120 = zext i1 %119 to i32
  %121 = add i32 %117, %120
  %122 = xor i32 %51, -2147483648
  br label %123

123:                                              ; preds = %116, %114
  %hi.2.i.i.i = phi i32 [ %121, %116 ], [ %107, %114 ]
  %s.0.i.i.i = phi i32 [ %122, %116 ], [ %51, %114 ]
  %lo.1.i.i.i = phi i32 [ %118, %116 ], [ %108, %114 ]
  %124 = call i32 @llvm.ctlz.i32(i32 %hi.2.i.i.i, i1 false)
  %125 = icmp ne i32 %124, 0
  br i1 %125, label %126, label %131

126:                                              ; preds = %123
  %127 = shl i32 %hi.2.i.i.i, %124
  %128 = sub i32 32, %124
  %129 = lshr i32 %lo.1.i.i.i, %128
  %130 = add i32 %127, %129
  br label %131

131:                                              ; preds = %126, %123
  %hi.3.i.i.i = phi i32 [ %130, %126 ], [ %hi.2.i.i.i, %123 ]
  %132 = mul i32 %hi.3.i.i.i, -921707870
  %133 = call i32 @llvm.nvvm.mulhi.ui(i32 %hi.3.i.i.i, i32 -921707870)
  %134 = icmp sgt i32 %133, 0
  br i1 %134, label %135, label %__internal_trig_reduction_slowpath.exit.i.i

135:                                              ; preds = %131
  %136 = shl i32 %133, 1
  %137 = lshr i32 %132, 31
  %138 = add i32 %136, %137
  %139 = add i32 %124, 1
  br label %__internal_trig_reduction_slowpath.exit.i.i

__internal_trig_reduction_slowpath.exit.i.i:      ; preds = %135, %131
  %hi.4.i.i.i = phi i32 [ %138, %135 ], [ %133, %131 ]
  %e.0.i.i.i = phi i32 [ %139, %135 ], [ %124, %131 ]
  %140 = sub i32 126, %e.0.i.i.i
  %141 = shl i32 %140, 23
  %142 = add i32 %hi.4.i.i.i, 1
  %143 = lshr i32 %142, 7
  %144 = add i32 %143, 1
  %145 = lshr i32 %144, 1
  %146 = add i32 %141, %145
  %147 = or i32 %s.0.i.i.i, %146
  %148 = bitcast i32 %147 to float
  %149 = bitcast %struct.uint2.27* %p.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %149)
  %150 = bitcast [7 x i32]* %result.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %150)
  br label %__internal_trig_reduction_kernel.exit.i

__internal_trig_reduction_kernel.exit.i:          ; preds = %__internal_trig_reduction_slowpath.exit.i.i, %__nv_fabsf.exit.i.i
  %t.0.i.i = phi float [ %148, %__internal_trig_reduction_slowpath.exit.i.i ], [ %retval.0.i7.i.i, %__nv_fabsf.exit.i.i ]
  %q.0.i.i = phi i32 [ %q.1.i.i.i, %__internal_trig_reduction_slowpath.exit.i.i ], [ %retval.0.i.i2.i, %__nv_fabsf.exit.i.i ]
  %call.i.i3.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %151 = icmp ne i32 %call.i.i3.i, 0
  br i1 %151, label %152, label %154

152:                                              ; preds = %__internal_trig_reduction_kernel.exit.i
  %153 = call float @llvm.nvvm.mul.rn.ftz.f(float %t.0.i.i, float %t.0.i.i)
  br label %__nv_fmul_rn.exit.i.i

154:                                              ; preds = %__internal_trig_reduction_kernel.exit.i
  %155 = call float @llvm.nvvm.mul.rn.f(float %t.0.i.i, float %t.0.i.i)
  br label %__nv_fmul_rn.exit.i.i

__nv_fmul_rn.exit.i.i:                            ; preds = %154, %152
  %retval.0.i.i4.i = phi float [ %153, %152 ], [ %155, %154 ]
  %156 = and i32 %q.0.i.i, 1
  %157 = icmp ne i32 %156, 0
  br i1 %157, label %158, label %164

158:                                              ; preds = %__nv_fmul_rn.exit.i.i
  %call.i.i.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %159 = icmp ne i32 %call.i.i.i.i, 0
  br i1 %159, label %160, label %162

160:                                              ; preds = %158
  %161 = call float @llvm.nvvm.fma.rn.ftz.f(float 0x3EF99EB9C0000000, float %retval.0.i.i4.i, float 0xBF56C0C340000000)
  br label %__internal_fmad.exit.i.i

162:                                              ; preds = %158
  %163 = call float @llvm.nvvm.fma.rn.f(float 0x3EF99EB9C0000000, float %retval.0.i.i4.i, float 0xBF56C0C340000000)
  br label %__internal_fmad.exit.i.i

__internal_fmad.exit.i.i:                         ; preds = %162, %160
  %retval.0.i.i.i.i = phi float [ %161, %160 ], [ %163, %162 ]
  br label %170

164:                                              ; preds = %__nv_fmul_rn.exit.i.i
  %call.i.i1.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %165 = icmp ne i32 %call.i.i1.i.i, 0
  br i1 %165, label %166, label %168

166:                                              ; preds = %164
  %167 = call float @llvm.nvvm.fma.rn.ftz.f(float 0xBF29943F20000000, float %retval.0.i.i4.i, float 0x3F811073C0000000)
  br label %__internal_fmad.exit3.i.i

168:                                              ; preds = %164
  %169 = call float @llvm.nvvm.fma.rn.f(float 0xBF29943F20000000, float %retval.0.i.i4.i, float 0x3F811073C0000000)
  br label %__internal_fmad.exit3.i.i

__internal_fmad.exit3.i.i:                        ; preds = %168, %166
  %retval.0.i.i2.i.i = phi float [ %167, %166 ], [ %169, %168 ]
  br label %170

170:                                              ; preds = %__internal_fmad.exit3.i.i, %__internal_fmad.exit.i.i
  %z.0.i.i = phi float [ %retval.0.i.i.i.i, %__internal_fmad.exit.i.i ], [ %retval.0.i.i2.i.i, %__internal_fmad.exit3.i.i ]
  %171 = and i32 %q.0.i.i, 1
  %172 = icmp ne i32 %171, 0
  br i1 %172, label %173, label %184

173:                                              ; preds = %170
  %call.i.i4.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %174 = icmp ne i32 %call.i.i4.i.i, 0
  br i1 %174, label %175, label %177

175:                                              ; preds = %173
  %176 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0x3FA55554A0000000)
  br label %__internal_fmad.exit6.i.i

177:                                              ; preds = %173
  %178 = call float @llvm.nvvm.fma.rn.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0x3FA55554A0000000)
  br label %__internal_fmad.exit6.i.i

__internal_fmad.exit6.i.i:                        ; preds = %177, %175
  %retval.0.i.i5.i.i = phi float [ %176, %175 ], [ %178, %177 ]
  %call.i.i7.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %179 = icmp ne i32 %call.i.i7.i.i, 0
  br i1 %179, label %180, label %182

180:                                              ; preds = %__internal_fmad.exit6.i.i
  %181 = call float @llvm.nvvm.fma.rn.ftz.f(float %retval.0.i.i5.i.i, float %retval.0.i.i4.i, float -5.000000e-01)
  br label %__internal_fmad.exit9.i.i

182:                                              ; preds = %__internal_fmad.exit6.i.i
  %183 = call float @llvm.nvvm.fma.rn.f(float %retval.0.i.i5.i.i, float %retval.0.i.i4.i, float -5.000000e-01)
  br label %__internal_fmad.exit9.i.i

__internal_fmad.exit9.i.i:                        ; preds = %182, %180
  %retval.0.i.i8.i.i = phi float [ %181, %180 ], [ %183, %182 ]
  br label %195

184:                                              ; preds = %170
  %call.i.i10.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %185 = icmp ne i32 %call.i.i10.i.i, 0
  br i1 %185, label %186, label %188

186:                                              ; preds = %184
  %187 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0xBFC5555460000000)
  br label %__internal_fmad.exit12.i.i

188:                                              ; preds = %184
  %189 = call float @llvm.nvvm.fma.rn.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0xBFC5555460000000)
  br label %__internal_fmad.exit12.i.i

__internal_fmad.exit12.i.i:                       ; preds = %188, %186
  %retval.0.i.i11.i.i = phi float [ %187, %186 ], [ %189, %188 ]
  %call.i.i13.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %190 = icmp ne i32 %call.i.i13.i.i, 0
  br i1 %190, label %191, label %193

191:                                              ; preds = %__internal_fmad.exit12.i.i
  %192 = call float @llvm.nvvm.fma.rn.ftz.f(float %retval.0.i.i11.i.i, float %retval.0.i.i4.i, float 0.000000e+00)
  br label %__internal_fmad.exit15.i.i

193:                                              ; preds = %__internal_fmad.exit12.i.i
  %194 = call float @llvm.nvvm.fma.rn.f(float %retval.0.i.i11.i.i, float %retval.0.i.i4.i, float 0.000000e+00)
  br label %__internal_fmad.exit15.i.i

__internal_fmad.exit15.i.i:                       ; preds = %193, %191
  %retval.0.i.i14.i.i = phi float [ %192, %191 ], [ %194, %193 ]
  br label %195

195:                                              ; preds = %__internal_fmad.exit15.i.i, %__internal_fmad.exit9.i.i
  %z.1.i.i = phi float [ %retval.0.i.i8.i.i, %__internal_fmad.exit9.i.i ], [ %retval.0.i.i14.i.i, %__internal_fmad.exit15.i.i ]
  %call.i.i16.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %196 = icmp ne i32 %call.i.i16.i.i, 0
  br i1 %196, label %197, label %199

197:                                              ; preds = %195
  %198 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.1.i.i, float %t.0.i.i, float %t.0.i.i)
  br label %__internal_fmad.exit18.i.i

199:                                              ; preds = %195
  %200 = call float @llvm.nvvm.fma.rn.f(float %z.1.i.i, float %t.0.i.i, float %t.0.i.i)
  br label %__internal_fmad.exit18.i.i

__internal_fmad.exit18.i.i:                       ; preds = %199, %197
  %retval.0.i.i17.i.i = phi float [ %198, %197 ], [ %200, %199 ]
  %201 = and i32 %q.0.i.i, 1
  %202 = icmp ne i32 %201, 0
  br i1 %202, label %203, label %209

203:                                              ; preds = %__internal_fmad.exit18.i.i
  %call.i.i19.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %204 = icmp ne i32 %call.i.i19.i.i, 0
  br i1 %204, label %205, label %207

205:                                              ; preds = %203
  %206 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.1.i.i, float %retval.0.i.i4.i, float 1.000000e+00)
  br label %__internal_fmad.exit21.i.i

207:                                              ; preds = %203
  %208 = call float @llvm.nvvm.fma.rn.f(float %z.1.i.i, float %retval.0.i.i4.i, float 1.000000e+00)
  br label %__internal_fmad.exit21.i.i

__internal_fmad.exit21.i.i:                       ; preds = %207, %205
  %retval.0.i.i20.i.i = phi float [ %206, %205 ], [ %208, %207 ]
  br label %209

209:                                              ; preds = %__internal_fmad.exit21.i.i, %__internal_fmad.exit18.i.i
  %x.addr.0.i.i = phi float [ %retval.0.i.i20.i.i, %__internal_fmad.exit21.i.i ], [ %retval.0.i.i17.i.i, %__internal_fmad.exit18.i.i ]
  %210 = and i32 %q.0.i.i, 2
  %211 = icmp ne i32 %210, 0
  br i1 %211, label %212, label %__internal_accurate_sinf.exit

212:                                              ; preds = %209
  %call.i.i22.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %213 = icmp ne i32 %call.i.i22.i.i, 0
  br i1 %213, label %214, label %216

214:                                              ; preds = %212
  %215 = call float @llvm.nvvm.fma.rn.ftz.f(float %x.addr.0.i.i, float -1.000000e+00, float 0.000000e+00)
  br label %__internal_fmad.exit24.i.i

216:                                              ; preds = %212
  %217 = call float @llvm.nvvm.fma.rn.f(float %x.addr.0.i.i, float -1.000000e+00, float 0.000000e+00)
  br label %__internal_fmad.exit24.i.i

__internal_fmad.exit24.i.i:                       ; preds = %216, %214
  %retval.0.i.i23.i.i = phi float [ %215, %214 ], [ %217, %216 ]
  br label %__internal_accurate_sinf.exit

__internal_accurate_sinf.exit:                    ; preds = %__internal_fmad.exit24.i.i, %209
  %x.addr.1.i.i = phi float [ %retval.0.i.i23.i.i, %__internal_fmad.exit24.i.i ], [ %x.addr.0.i.i, %209 ]
  ret float %x.addr.1.i.i
}

; Function Attrs: alwaysinline
declare i32 @__nvvm_reflect(i8*) #10

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.fabs.ftz.f(float) #2

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.fabs.f(float) #2

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.mul.rn.ftz.f(float, float) #2

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.mul.rn.f(float, float) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.f2i.rn.ftz(float) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.f2i.rn(float) #2

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.fma.rn.ftz.f(float, float, float) #2

; Function Attrs: nounwind readnone
declare float @llvm.nvvm.fma.rn.f(float, float, float) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #6

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #6

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.ctlz.i32(i32, i1 immarg) #7

; Function Attrs: nounwind readnone
declare i32 @llvm.nvvm.mulhi.ui(i32, i32) #2

; Function Attrs: alwaysinline inlinehint
define internal float @__nv_cosf(float %a) #9 {
  %res.i.i.i.i = alloca %struct.uint2.27, align 8
  %p.i.i.i = alloca %struct.uint2.27, align 8
  %result.i.i.i = alloca [7 x i32], align 4
  %call.i.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %1 = icmp ne i32 %call.i.i.i, 0
  br i1 %1, label %2, label %4

2:                                                ; preds = %0
  %3 = call float @llvm.nvvm.fabs.ftz.f(float %a)
  br label %__nv_isinff.exit.i

4:                                                ; preds = %0
  %5 = call float @llvm.nvvm.fabs.f(float %a)
  br label %__nv_isinff.exit.i

__nv_isinff.exit.i:                               ; preds = %4, %2
  %retval.0.i.i.i = phi float [ %3, %2 ], [ %5, %4 ]
  %6 = bitcast i32 2139095040 to float
  %7 = fcmp oeq float %retval.0.i.i.i, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %9, label %15

9:                                                ; preds = %__nv_isinff.exit.i
  %call.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %10 = icmp ne i32 %call.i.i, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %9
  %12 = call float @llvm.nvvm.mul.rn.ftz.f(float %a, float 0.000000e+00)
  br label %__nv_fmul_rn.exit.i

13:                                               ; preds = %9
  %14 = call float @llvm.nvvm.mul.rn.f(float %a, float 0.000000e+00)
  br label %__nv_fmul_rn.exit.i

__nv_fmul_rn.exit.i:                              ; preds = %13, %11
  %retval.0.i.i = phi float [ %12, %11 ], [ %14, %13 ]
  br label %15

15:                                               ; preds = %__nv_fmul_rn.exit.i, %__nv_isinff.exit.i
  %a.addr.0.i = phi float [ %retval.0.i.i, %__nv_fmul_rn.exit.i ], [ %a, %__nv_isinff.exit.i ]
  %16 = fmul float %a.addr.0.i, 0x3FE45F3060000000
  %call.i.i1.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %17 = icmp ne i32 %call.i.i1.i, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  %19 = call i32 @llvm.nvvm.f2i.rn.ftz(float %16)
  br label %__nv_float2int_rn.exit.i.i

20:                                               ; preds = %15
  %21 = call i32 @llvm.nvvm.f2i.rn(float %16)
  br label %__nv_float2int_rn.exit.i.i

__nv_float2int_rn.exit.i.i:                       ; preds = %20, %18
  %retval.0.i.i2.i = phi i32 [ %19, %18 ], [ %21, %20 ]
  %22 = sitofp i32 %retval.0.i.i2.i to float
  %23 = fsub float -0.000000e+00, %22
  %call.i1.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %24 = icmp ne i32 %call.i1.i.i, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %__nv_float2int_rn.exit.i.i
  %26 = call float @llvm.nvvm.fma.rn.ftz.f(float %23, float 0x3FF921FB40000000, float %a.addr.0.i)
  br label %__nv_fmaf_rn.exit.i.i

27:                                               ; preds = %__nv_float2int_rn.exit.i.i
  %28 = call float @llvm.nvvm.fma.rn.f(float %23, float 0x3FF921FB40000000, float %a.addr.0.i)
  br label %__nv_fmaf_rn.exit.i.i

__nv_fmaf_rn.exit.i.i:                            ; preds = %27, %25
  %retval.0.i2.i.i = phi float [ %26, %25 ], [ %28, %27 ]
  %29 = fsub float -0.000000e+00, %22
  %call.i3.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %30 = icmp ne i32 %call.i3.i.i, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %__nv_fmaf_rn.exit.i.i
  %32 = call float @llvm.nvvm.fma.rn.ftz.f(float %29, float 0x3E74442D00000000, float %retval.0.i2.i.i)
  br label %__nv_fmaf_rn.exit5.i.i

33:                                               ; preds = %__nv_fmaf_rn.exit.i.i
  %34 = call float @llvm.nvvm.fma.rn.f(float %29, float 0x3E74442D00000000, float %retval.0.i2.i.i)
  br label %__nv_fmaf_rn.exit5.i.i

__nv_fmaf_rn.exit5.i.i:                           ; preds = %33, %31
  %retval.0.i4.i.i = phi float [ %32, %31 ], [ %34, %33 ]
  %35 = fsub float -0.000000e+00, %22
  %call.i6.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %36 = icmp ne i32 %call.i6.i.i, 0
  br i1 %36, label %37, label %39

37:                                               ; preds = %__nv_fmaf_rn.exit5.i.i
  %38 = call float @llvm.nvvm.fma.rn.ftz.f(float %35, float 0x3CF84698A0000000, float %retval.0.i4.i.i)
  br label %__nv_fmaf_rn.exit8.i.i

39:                                               ; preds = %__nv_fmaf_rn.exit5.i.i
  %40 = call float @llvm.nvvm.fma.rn.f(float %35, float 0x3CF84698A0000000, float %retval.0.i4.i.i)
  br label %__nv_fmaf_rn.exit8.i.i

__nv_fmaf_rn.exit8.i.i:                           ; preds = %39, %37
  %retval.0.i7.i.i = phi float [ %38, %37 ], [ %40, %39 ]
  %call.i9.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %41 = icmp ne i32 %call.i9.i.i, 0
  br i1 %41, label %42, label %44

42:                                               ; preds = %__nv_fmaf_rn.exit8.i.i
  %43 = call float @llvm.nvvm.fabs.ftz.f(float %a.addr.0.i)
  br label %__nv_fabsf.exit.i.i

44:                                               ; preds = %__nv_fmaf_rn.exit8.i.i
  %45 = call float @llvm.nvvm.fabs.f(float %a.addr.0.i)
  br label %__nv_fabsf.exit.i.i

__nv_fabsf.exit.i.i:                              ; preds = %44, %42
  %retval.0.i10.i.i = phi float [ %43, %42 ], [ %45, %44 ]
  %46 = fcmp ogt float %retval.0.i10.i.i, 1.056150e+05
  br i1 %46, label %47, label %__internal_trig_reduction_kernel.exit.i

47:                                               ; preds = %__nv_fabsf.exit.i.i
  %48 = bitcast %struct.uint2.27* %p.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %48)
  %49 = bitcast [7 x i32]* %result.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %49)
  %50 = bitcast float %a.addr.0.i to i32
  %51 = and i32 %50, -2147483648
  %52 = lshr i32 %50, 23
  %53 = and i32 %52, 255
  %54 = sub i32 %53, 128
  %55 = shl i32 %50, 8
  %56 = or i32 %55, -2147483648
  %57 = lshr i32 %54, 5
  %58 = sub i32 4, %57
  br label %59

59:                                               ; preds = %61, %47
  %hi.0.i.i.i = phi i32 [ 0, %47 ], [ %75, %61 ]
  %q.0.i.i.i = phi i32 [ 0, %47 ], [ %78, %61 ]
  %60 = icmp slt i32 %q.0.i.i.i, 6
  br i1 %60, label %61, label %79, !llvm.loop !13

61:                                               ; preds = %59
  %62 = getelementptr inbounds i32, i32* getelementptr inbounds ([6 x i32], [6 x i32]* addrspacecast ([6 x i32] addrspace(4)* @__cudart_i2opi_f to [6 x i32]*), i32 0, i32 0), i32 %q.0.i.i.i
  %63 = load i32, i32* %62, align 4
  %64 = bitcast %struct.uint2.27* %res.i.i.i.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %64)
  %65 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, i32 0, i32 0
  %66 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, i32 0, i32 1
  %67 = call { i32, i32 } asm "{\0A\09mad.lo.cc.u32   $0, $2, $3, $4;\0A\09madc.hi.u32     $1, $2, $3,  0;\0A\09}", "=r,=r,r,r,r"(i32 %63, i32 %56, i32 %hi.0.i.i.i) #1
  %68 = extractvalue { i32, i32 } %67, 0
  %69 = extractvalue { i32, i32 } %67, 1
  store i32 %68, i32* %65, align 8
  store i32 %69, i32* %66, align 4
  %70 = load %struct.uint2.27, %struct.uint2.27* %res.i.i.i.i, align 8
  %71 = bitcast %struct.uint2.27* %res.i.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %71)
  store %struct.uint2.27 %70, %struct.uint2.27* %p.i.i.i, align 8
  %72 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %p.i.i.i, i32 0, i32 0
  %73 = load i32, i32* %72, align 8
  %74 = getelementptr inbounds %struct.uint2.27, %struct.uint2.27* %p.i.i.i, i32 0, i32 1
  %75 = load i32, i32* %74, align 4
  %76 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %77 = getelementptr inbounds i32, i32* %76, i32 %q.0.i.i.i
  store i32 %73, i32* %77, align 4
  %78 = add nsw i32 %q.0.i.i.i, 1
  br label %59

79:                                               ; preds = %59
  %80 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %81 = getelementptr inbounds i32, i32* %80, i32 %q.0.i.i.i
  store i32 %hi.0.i.i.i, i32* %81, align 4
  %82 = and i32 %54, 31
  %83 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %84 = add nsw i32 %58, 2
  %85 = getelementptr inbounds i32, i32* %83, i32 %84
  %86 = load i32, i32* %85, align 4
  %87 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %88 = add nsw i32 %58, 1
  %89 = getelementptr inbounds i32, i32* %87, i32 %88
  %90 = load i32, i32* %89, align 4
  %91 = icmp ne i32 %82, 0
  br i1 %91, label %92, label %103

92:                                               ; preds = %79
  %93 = sub i32 32, %82
  %94 = shl i32 %86, %82
  %95 = lshr i32 %90, %93
  %96 = add i32 %94, %95
  %97 = shl i32 %90, %82
  %98 = getelementptr inbounds [7 x i32], [7 x i32]* %result.i.i.i, i32 0, i32 0
  %99 = getelementptr inbounds i32, i32* %98, i32 %58
  %100 = load i32, i32* %99, align 4
  %101 = lshr i32 %100, %93
  %102 = add i32 %97, %101
  br label %103

103:                                              ; preds = %92, %79
  %hi.1.i.i.i = phi i32 [ %96, %92 ], [ %86, %79 ]
  %lo.0.i.i.i = phi i32 [ %102, %92 ], [ %90, %79 ]
  %104 = lshr i32 %hi.1.i.i.i, 30
  %105 = shl i32 %hi.1.i.i.i, 2
  %106 = lshr i32 %lo.0.i.i.i, 30
  %107 = add i32 %105, %106
  %108 = shl i32 %lo.0.i.i.i, 2
  %109 = lshr i32 %107, 31
  %110 = add i32 %104, %109
  %111 = icmp ne i32 %51, 0
  br i1 %111, label %112, label %114

112:                                              ; preds = %103
  %113 = sub i32 0, %110
  br label %114

114:                                              ; preds = %112, %103
  %q.1.i.i.i = phi i32 [ %113, %112 ], [ %110, %103 ]
  %115 = icmp ne i32 %109, 0
  br i1 %115, label %116, label %123

116:                                              ; preds = %114
  %117 = xor i32 %107, -1
  %118 = sub i32 0, %108
  %119 = icmp eq i32 %118, 0
  %120 = zext i1 %119 to i32
  %121 = add i32 %117, %120
  %122 = xor i32 %51, -2147483648
  br label %123

123:                                              ; preds = %116, %114
  %hi.2.i.i.i = phi i32 [ %121, %116 ], [ %107, %114 ]
  %s.0.i.i.i = phi i32 [ %122, %116 ], [ %51, %114 ]
  %lo.1.i.i.i = phi i32 [ %118, %116 ], [ %108, %114 ]
  %124 = call i32 @llvm.ctlz.i32(i32 %hi.2.i.i.i, i1 false)
  %125 = icmp ne i32 %124, 0
  br i1 %125, label %126, label %131

126:                                              ; preds = %123
  %127 = shl i32 %hi.2.i.i.i, %124
  %128 = sub i32 32, %124
  %129 = lshr i32 %lo.1.i.i.i, %128
  %130 = add i32 %127, %129
  br label %131

131:                                              ; preds = %126, %123
  %hi.3.i.i.i = phi i32 [ %130, %126 ], [ %hi.2.i.i.i, %123 ]
  %132 = mul i32 %hi.3.i.i.i, -921707870
  %133 = call i32 @llvm.nvvm.mulhi.ui(i32 %hi.3.i.i.i, i32 -921707870)
  %134 = icmp sgt i32 %133, 0
  br i1 %134, label %135, label %__internal_trig_reduction_slowpath.exit.i.i

135:                                              ; preds = %131
  %136 = shl i32 %133, 1
  %137 = lshr i32 %132, 31
  %138 = add i32 %136, %137
  %139 = add i32 %124, 1
  br label %__internal_trig_reduction_slowpath.exit.i.i

__internal_trig_reduction_slowpath.exit.i.i:      ; preds = %135, %131
  %hi.4.i.i.i = phi i32 [ %138, %135 ], [ %133, %131 ]
  %e.0.i.i.i = phi i32 [ %139, %135 ], [ %124, %131 ]
  %140 = sub i32 126, %e.0.i.i.i
  %141 = shl i32 %140, 23
  %142 = add i32 %hi.4.i.i.i, 1
  %143 = lshr i32 %142, 7
  %144 = add i32 %143, 1
  %145 = lshr i32 %144, 1
  %146 = add i32 %141, %145
  %147 = or i32 %s.0.i.i.i, %146
  %148 = bitcast i32 %147 to float
  %149 = bitcast %struct.uint2.27* %p.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %149)
  %150 = bitcast [7 x i32]* %result.i.i.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %150)
  br label %__internal_trig_reduction_kernel.exit.i

__internal_trig_reduction_kernel.exit.i:          ; preds = %__internal_trig_reduction_slowpath.exit.i.i, %__nv_fabsf.exit.i.i
  %t.0.i.i = phi float [ %148, %__internal_trig_reduction_slowpath.exit.i.i ], [ %retval.0.i7.i.i, %__nv_fabsf.exit.i.i ]
  %q.0.i.i = phi i32 [ %q.1.i.i.i, %__internal_trig_reduction_slowpath.exit.i.i ], [ %retval.0.i.i2.i, %__nv_fabsf.exit.i.i ]
  %151 = add nsw i32 %q.0.i.i, 1
  %call.i.i3.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %152 = icmp ne i32 %call.i.i3.i, 0
  br i1 %152, label %153, label %155

153:                                              ; preds = %__internal_trig_reduction_kernel.exit.i
  %154 = call float @llvm.nvvm.mul.rn.ftz.f(float %t.0.i.i, float %t.0.i.i)
  br label %__nv_fmul_rn.exit.i.i

155:                                              ; preds = %__internal_trig_reduction_kernel.exit.i
  %156 = call float @llvm.nvvm.mul.rn.f(float %t.0.i.i, float %t.0.i.i)
  br label %__nv_fmul_rn.exit.i.i

__nv_fmul_rn.exit.i.i:                            ; preds = %155, %153
  %retval.0.i.i4.i = phi float [ %154, %153 ], [ %156, %155 ]
  %157 = and i32 %151, 1
  %158 = icmp ne i32 %157, 0
  br i1 %158, label %159, label %165

159:                                              ; preds = %__nv_fmul_rn.exit.i.i
  %call.i.i.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %160 = icmp ne i32 %call.i.i.i.i, 0
  br i1 %160, label %161, label %163

161:                                              ; preds = %159
  %162 = call float @llvm.nvvm.fma.rn.ftz.f(float 0x3EF99EB9C0000000, float %retval.0.i.i4.i, float 0xBF56C0C340000000)
  br label %__internal_fmad.exit.i.i

163:                                              ; preds = %159
  %164 = call float @llvm.nvvm.fma.rn.f(float 0x3EF99EB9C0000000, float %retval.0.i.i4.i, float 0xBF56C0C340000000)
  br label %__internal_fmad.exit.i.i

__internal_fmad.exit.i.i:                         ; preds = %163, %161
  %retval.0.i.i.i.i = phi float [ %162, %161 ], [ %164, %163 ]
  br label %171

165:                                              ; preds = %__nv_fmul_rn.exit.i.i
  %call.i.i1.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %166 = icmp ne i32 %call.i.i1.i.i, 0
  br i1 %166, label %167, label %169

167:                                              ; preds = %165
  %168 = call float @llvm.nvvm.fma.rn.ftz.f(float 0xBF29943F20000000, float %retval.0.i.i4.i, float 0x3F811073C0000000)
  br label %__internal_fmad.exit3.i.i

169:                                              ; preds = %165
  %170 = call float @llvm.nvvm.fma.rn.f(float 0xBF29943F20000000, float %retval.0.i.i4.i, float 0x3F811073C0000000)
  br label %__internal_fmad.exit3.i.i

__internal_fmad.exit3.i.i:                        ; preds = %169, %167
  %retval.0.i.i2.i.i = phi float [ %168, %167 ], [ %170, %169 ]
  br label %171

171:                                              ; preds = %__internal_fmad.exit3.i.i, %__internal_fmad.exit.i.i
  %z.0.i.i = phi float [ %retval.0.i.i.i.i, %__internal_fmad.exit.i.i ], [ %retval.0.i.i2.i.i, %__internal_fmad.exit3.i.i ]
  %172 = and i32 %151, 1
  %173 = icmp ne i32 %172, 0
  br i1 %173, label %174, label %185

174:                                              ; preds = %171
  %call.i.i4.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %175 = icmp ne i32 %call.i.i4.i.i, 0
  br i1 %175, label %176, label %178

176:                                              ; preds = %174
  %177 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0x3FA55554A0000000)
  br label %__internal_fmad.exit6.i.i

178:                                              ; preds = %174
  %179 = call float @llvm.nvvm.fma.rn.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0x3FA55554A0000000)
  br label %__internal_fmad.exit6.i.i

__internal_fmad.exit6.i.i:                        ; preds = %178, %176
  %retval.0.i.i5.i.i = phi float [ %177, %176 ], [ %179, %178 ]
  %call.i.i7.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %180 = icmp ne i32 %call.i.i7.i.i, 0
  br i1 %180, label %181, label %183

181:                                              ; preds = %__internal_fmad.exit6.i.i
  %182 = call float @llvm.nvvm.fma.rn.ftz.f(float %retval.0.i.i5.i.i, float %retval.0.i.i4.i, float -5.000000e-01)
  br label %__internal_fmad.exit9.i.i

183:                                              ; preds = %__internal_fmad.exit6.i.i
  %184 = call float @llvm.nvvm.fma.rn.f(float %retval.0.i.i5.i.i, float %retval.0.i.i4.i, float -5.000000e-01)
  br label %__internal_fmad.exit9.i.i

__internal_fmad.exit9.i.i:                        ; preds = %183, %181
  %retval.0.i.i8.i.i = phi float [ %182, %181 ], [ %184, %183 ]
  br label %196

185:                                              ; preds = %171
  %call.i.i10.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %186 = icmp ne i32 %call.i.i10.i.i, 0
  br i1 %186, label %187, label %189

187:                                              ; preds = %185
  %188 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0xBFC5555460000000)
  br label %__internal_fmad.exit12.i.i

189:                                              ; preds = %185
  %190 = call float @llvm.nvvm.fma.rn.f(float %z.0.i.i, float %retval.0.i.i4.i, float 0xBFC5555460000000)
  br label %__internal_fmad.exit12.i.i

__internal_fmad.exit12.i.i:                       ; preds = %189, %187
  %retval.0.i.i11.i.i = phi float [ %188, %187 ], [ %190, %189 ]
  %call.i.i13.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %191 = icmp ne i32 %call.i.i13.i.i, 0
  br i1 %191, label %192, label %194

192:                                              ; preds = %__internal_fmad.exit12.i.i
  %193 = call float @llvm.nvvm.fma.rn.ftz.f(float %retval.0.i.i11.i.i, float %retval.0.i.i4.i, float 0.000000e+00)
  br label %__internal_fmad.exit15.i.i

194:                                              ; preds = %__internal_fmad.exit12.i.i
  %195 = call float @llvm.nvvm.fma.rn.f(float %retval.0.i.i11.i.i, float %retval.0.i.i4.i, float 0.000000e+00)
  br label %__internal_fmad.exit15.i.i

__internal_fmad.exit15.i.i:                       ; preds = %194, %192
  %retval.0.i.i14.i.i = phi float [ %193, %192 ], [ %195, %194 ]
  br label %196

196:                                              ; preds = %__internal_fmad.exit15.i.i, %__internal_fmad.exit9.i.i
  %z.1.i.i = phi float [ %retval.0.i.i8.i.i, %__internal_fmad.exit9.i.i ], [ %retval.0.i.i14.i.i, %__internal_fmad.exit15.i.i ]
  %call.i.i16.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %197 = icmp ne i32 %call.i.i16.i.i, 0
  br i1 %197, label %198, label %200

198:                                              ; preds = %196
  %199 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.1.i.i, float %t.0.i.i, float %t.0.i.i)
  br label %__internal_fmad.exit18.i.i

200:                                              ; preds = %196
  %201 = call float @llvm.nvvm.fma.rn.f(float %z.1.i.i, float %t.0.i.i, float %t.0.i.i)
  br label %__internal_fmad.exit18.i.i

__internal_fmad.exit18.i.i:                       ; preds = %200, %198
  %retval.0.i.i17.i.i = phi float [ %199, %198 ], [ %201, %200 ]
  %202 = and i32 %151, 1
  %203 = icmp ne i32 %202, 0
  br i1 %203, label %204, label %210

204:                                              ; preds = %__internal_fmad.exit18.i.i
  %call.i.i19.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %205 = icmp ne i32 %call.i.i19.i.i, 0
  br i1 %205, label %206, label %208

206:                                              ; preds = %204
  %207 = call float @llvm.nvvm.fma.rn.ftz.f(float %z.1.i.i, float %retval.0.i.i4.i, float 1.000000e+00)
  br label %__internal_fmad.exit21.i.i

208:                                              ; preds = %204
  %209 = call float @llvm.nvvm.fma.rn.f(float %z.1.i.i, float %retval.0.i.i4.i, float 1.000000e+00)
  br label %__internal_fmad.exit21.i.i

__internal_fmad.exit21.i.i:                       ; preds = %208, %206
  %retval.0.i.i20.i.i = phi float [ %207, %206 ], [ %209, %208 ]
  br label %210

210:                                              ; preds = %__internal_fmad.exit21.i.i, %__internal_fmad.exit18.i.i
  %x.addr.0.i.i = phi float [ %retval.0.i.i20.i.i, %__internal_fmad.exit21.i.i ], [ %retval.0.i.i17.i.i, %__internal_fmad.exit18.i.i ]
  %211 = and i32 %151, 2
  %212 = icmp ne i32 %211, 0
  br i1 %212, label %213, label %__internal_accurate_cosf.exit

213:                                              ; preds = %210
  %call.i.i22.i.i = call i32 @__nvvm_reflect(i8* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([11 x i8], [11 x i8] addrspace(1)* @"$str", i32 0, i32 0) to i8*))
  %214 = icmp ne i32 %call.i.i22.i.i, 0
  br i1 %214, label %215, label %217

215:                                              ; preds = %213
  %216 = call float @llvm.nvvm.fma.rn.ftz.f(float %x.addr.0.i.i, float -1.000000e+00, float 0.000000e+00)
  br label %__internal_fmad.exit24.i.i

217:                                              ; preds = %213
  %218 = call float @llvm.nvvm.fma.rn.f(float %x.addr.0.i.i, float -1.000000e+00, float 0.000000e+00)
  br label %__internal_fmad.exit24.i.i

__internal_fmad.exit24.i.i:                       ; preds = %217, %215
  %retval.0.i.i23.i.i = phi float [ %216, %215 ], [ %218, %217 ]
  br label %__internal_accurate_cosf.exit

__internal_accurate_cosf.exit:                    ; preds = %__internal_fmad.exit24.i.i, %210
  %x.addr.1.i.i = phi float [ %retval.0.i.i23.i.i, %__internal_fmad.exit24.i.i ], [ %x.addr.0.i.i, %210 ]
  ret float %x.addr.1.i.i
}

attributes #0 = { alwaysinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind readnone }
attributes #3 = { convergent nounwind }
attributes #4 = { alwaysinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { argmemonly nounwind willreturn }
attributes #7 = { nounwind readnone speculatable willreturn }
attributes #8 = { convergent inaccessiblememonly nounwind }
attributes #9 = { alwaysinline inlinehint }
attributes #10 = { alwaysinline }

!nvvm.annotations = !{!0, !1, !2, !3, !4, !3, !5, !5, !5, !5, !6, !6, !5}
!llvm.ident = !{!7}
!nvvmir.version = !{!8}
!llvm.module.flags = !{!9}

!0 = !{void (%struct.RuntimeContext.246*)* @activate_c82_0_kernel_0_range_forTfb1b3f37940bfb2cc7a754a287c978845cc2225c6b493d293f9fab7b3b28489b_7521, !"kernel", i32 1}
!1 = !{void (%struct.RuntimeContext.246*)* @activate_c82_0_kernel_0_range_forTfb1b3f37940bfb2cc7a754a287c978845cc2225c6b493d293f9fab7b3b28489b_7521, !"maxntidx", i32 128}
!2 = !{void (%struct.RuntimeContext.246*)* @activate_c82_0_kernel_0_range_forTfb1b3f37940bfb2cc7a754a287c978845cc2225c6b493d293f9fab7b3b28489b_7521, !"minctasm", i32 2}
!3 = !{null, !"align", i32 8}
!4 = !{null, !"align", i32 8, !"align", i32 65544, !"align", i32 131080}
!5 = !{null, !"align", i32 16}
!6 = !{null, !"align", i32 16, !"align", i32 65552, !"align", i32 131088}
!7 = !{!"clang version 10.0.0-4ubuntu1 "}
!8 = !{i32 1, i32 4}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 32126}
!11 = !{i32 21721}
!12 = !{i32 31904}
!13 = distinct !{!13, !14}
!14 = !{!"llvm.loop.unroll.count", i32 1}
