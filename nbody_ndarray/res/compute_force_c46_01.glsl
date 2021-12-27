#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 
layout(std430, binding = 4) buffer arr2_i32 { int _arr2_i32_[];}; 
layout(std430, binding = 4) buffer arr2_f32 { float _arr2_f32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void compute_force_c46_01()
{ // range for
  // range known at runtime
  int _beg = 0, _end = _gtmp_i32_[0 >> 2];
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (_end - _beg); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = _beg + _sid;
      int F = _itv;
      int G = 0;
      int H = _gtmp_i32_[G >> 2];
      int I = F - H * int(F / H);
      int K = int(0);
      int _li_L = 0;
      { // linear seek
        int _s0_L = _args_i32_[16 + 2 * 8 + 0];
        int _s1_L = _args_i32_[16 + 2 * 8 + 1];
        _li_L *= _s0_L;
        _li_L += I;
        _li_L *= _s1_L;
        _li_L += K;
      }
      int L = _li_L << 2;
      float M = float(0.0);
      _arr2_f32_[L >> 2] = M;
      int O = int(1);
      int _li_P = 0;
      { // linear seek
        int _s0_P = _args_i32_[16 + 2 * 8 + 0];
        int _s1_P = _args_i32_[16 + 2 * 8 + 1];
        _li_P *= _s0_P;
        _li_P += I;
        _li_P *= _s1_P;
        _li_P += O;
      }
      int P = _li_P << 2;
      _arr2_f32_[P >> 2] = M;
  }
}

void main()
{
  compute_force_c46_01();
}
