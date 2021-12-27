#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 
layout(std430, binding = 5) buffer arr1_i32 { int _arr1_i32_[];}; 
layout(std430, binding = 5) buffer arr1_f32 { float _arr1_f32_[];}; 
layout(std430, binding = 4) buffer arr0_i32 { int _arr0_i32_[];}; 
layout(std430, binding = 4) buffer arr0_f32 { float _arr0_f32_[];}; 

uvec4 _rand_; void _init_rand() { int RAND_STATE = 1024; uint i = (7654321u + gl_GlobalInvocationID.x) * (1234567u + 9723451u * uint(_gtmp_i32_[RAND_STATE])); _rand_.x = 123456789u * i * 1000000007u; _rand_.y = 362436069u; _rand_.z = 521288629u; _rand_.w = 88675123u; _gtmp_i32_[RAND_STATE] += 1; } uint _rand_u32() { uint t = _rand_.x ^ (_rand_.x << 11); _rand_.xyz = _rand_.yzw; _rand_.w = (_rand_.w ^ (_rand_.w >> 19)) ^ (t ^ (t >> 8)); return _rand_.w * 1000000007u; } float _rand_f32() { return float(_rand_u32()) * (1.0 / 4294967296.0); } int _rand_i32() { return int(_rand_u32()); }
const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void initialize_c44_01()
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
      float J = _rand_f32();
      float K = J + J;
      float L = float(3.1415927);
      float M = K * L;
      float N = _rand_f32();
      float O = float(sqrt(N));
      float P = float(0.7);
      float Q = O * P;
      float R = float(0.3);
      float S = Q + R;
      float T = float(0.4);
      float U = S * T;
      float V = float(cos(M));
      float W = float(sin(M));
      float X = U * V;
      float Y = U * W;
      float Z = float(0.5);
      float Aq = X + Z;
      float Ar = Y + Z;
      int At = int(0);
      int _li_Au = 0;
      { // linear seek
        int _s0_Au = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Au = _args_i32_[16 + 0 * 8 + 1];
        _li_Au *= _s0_Au;
        _li_Au += I;
        _li_Au *= _s1_Au;
        _li_Au += At;
      }
      int Au = _li_Au << 2;
      _arr0_f32_[Au >> 2] = Aq;
      int Aw = int(1);
      int _li_Ax = 0;
      { // linear seek
        int _s0_Ax = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Ax = _args_i32_[16 + 0 * 8 + 1];
        _li_Ax *= _s0_Ax;
        _li_Ax += I;
        _li_Ax *= _s1_Ax;
        _li_Ax += Aw;
      }
      int Ax = _li_Ax << 2;
      _arr0_f32_[Ax >> 2] = Ar;
      float Az = float(-Y);
      int _li_AB = 0;
      { // linear seek
        int _s0_AB = _args_i32_[16 + 1 * 8 + 0];
        int _s1_AB = _args_i32_[16 + 1 * 8 + 1];
        _li_AB *= _s0_AB;
        _li_AB += I;
        _li_AB *= _s1_AB;
        _li_AB += At;
      }
      int AB = _li_AB << 2;
      int _li_AC = 0;
      { // linear seek
        int _s0_AC = _args_i32_[16 + 1 * 8 + 0];
        int _s1_AC = _args_i32_[16 + 1 * 8 + 1];
        _li_AC *= _s0_AC;
        _li_AC += I;
        _li_AC *= _s1_AC;
        _li_AC += Aw;
      }
      int AC = _li_AC << 2;
      float AD = float(120.0);
      float AE = Az * AD;
      float AF = X * AD;
      _arr1_f32_[AB >> 2] = AE;
      _arr1_f32_[AC >> 2] = AF;
  }
}

void main()
{
  _init_rand();
  initialize_c44_01();
}
