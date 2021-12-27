#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 
layout(std430, binding = 6) buffer arr1_i32 { int _arr1_i32_[];}; 
layout(std430, binding = 6) buffer arr1_f32 { float _arr1_f32_[];}; 
layout(std430, binding = 5) buffer arr0_i32 { int _arr0_i32_[];}; 
layout(std430, binding = 5) buffer arr0_f32 { float _arr0_f32_[];}; 
layout(std430, binding = 4) buffer arr2_i32 { int _arr2_i32_[];}; 
layout(std430, binding = 4) buffer arr2_f32 { float _arr2_f32_[];}; 
float atomicAdd_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_arr1_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr1_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_arr1_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_arr1_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr1_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_arr1_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_arr1_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr1_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr1_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_arr1_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr1_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr1_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }
const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void compute_force_c46_05()
{ // range for
  // range known at runtime
  int _beg = 0, _end = _gtmp_i32_[8 >> 2];
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (_end - _beg); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = _beg + _sid;
      int B8 = _itv;
      int B9 = 8;
      int Ba = _gtmp_i32_[B9 >> 2];
      int Bb = B8 - Ba * int(B8 / Ba);
      int Bd = int(0);
      int _li_Be = 0;
      { // linear seek
        int _s0_Be = _args_i32_[16 + 2 * 8 + 0];
        int _s1_Be = _args_i32_[16 + 2 * 8 + 1];
        _li_Be *= _s0_Be;
        _li_Be += Bb;
        _li_Be *= _s1_Be;
        _li_Be += Bd;
      }
      int Be = _li_Be << 2;
      float Bf = _arr2_f32_[Be >> 2];
      int Bg = int(1);
      int _li_Bh = 0;
      { // linear seek
        int _s0_Bh = _args_i32_[16 + 2 * 8 + 0];
        int _s1_Bh = _args_i32_[16 + 2 * 8 + 1];
        _li_Bh *= _s0_Bh;
        _li_Bh += Bb;
        _li_Bh *= _s1_Bh;
        _li_Bh += Bg;
      }
      int Bh = _li_Bh << 2;
      float Bi = _arr2_f32_[Bh >> 2];
      float Bj = float(2e-07);
      float Bk = Bf * Bj;
      float Bl = Bi * Bj;
      int _li_Bn = 0;
      { // linear seek
        int _s0_Bn = _args_i32_[16 + 1 * 8 + 0];
        int _s1_Bn = _args_i32_[16 + 1 * 8 + 1];
        _li_Bn *= _s0_Bn;
        _li_Bn += Bb;
        _li_Bn *= _s1_Bn;
        _li_Bn += Bd;
      }
      int Bn = _li_Bn << 2;
      float Bo;
      { // Begin Atomic Op
      Bo = atomicAdd_arr1_f32(Bn >> 2, Bk);
      } // End Atomic Op
      int _li_Bp = 0;
      { // linear seek
        int _s0_Bp = _args_i32_[16 + 1 * 8 + 0];
        int _s1_Bp = _args_i32_[16 + 1 * 8 + 1];
        _li_Bp *= _s0_Bp;
        _li_Bp += Bb;
        _li_Bp *= _s1_Bp;
        _li_Bp += Bg;
      }
      int Bp = _li_Bp << 2;
      float Bq;
      { // Begin Atomic Op
      Bq = atomicAdd_arr1_f32(Bp >> 2, Bl);
      } // End Atomic Op
      float Br = _arr1_f32_[Bn >> 2];
      float Bs = float(1e-06);
      float Bt = Br * Bs;
      float Bu = _arr1_f32_[Bp >> 2];
      float Bv = Bu * Bs;
      int _li_Bx = 0;
      { // linear seek
        int _s0_Bx = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Bx = _args_i32_[16 + 0 * 8 + 1];
        _li_Bx *= _s0_Bx;
        _li_Bx += Bb;
        _li_Bx *= _s1_Bx;
        _li_Bx += Bd;
      }
      int Bx = _li_Bx << 2;
      float By;
      { // Begin Atomic Op
      By = atomicAdd_arr0_f32(Bx >> 2, Bt);
      } // End Atomic Op
      int _li_Bz = 0;
      { // linear seek
        int _s0_Bz = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Bz = _args_i32_[16 + 0 * 8 + 1];
        _li_Bz *= _s0_Bz;
        _li_Bz += Bb;
        _li_Bz *= _s1_Bz;
        _li_Bz += Bg;
      }
      int Bz = _li_Bz << 2;
      float BA;
      { // Begin Atomic Op
      BA = atomicAdd_arr0_f32(Bz >> 2, Bv);
      } // End Atomic Op
  }
}

void main()
{
  compute_force_c46_05();
}
