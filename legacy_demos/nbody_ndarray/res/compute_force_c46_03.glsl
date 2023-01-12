#version 310 es
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 1) buffer gtmp_f32 { float _gtmp_f32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 
layout(std430, binding = 2) buffer args_f32 { float _args_f32_[];}; 
layout(std430, binding = 5) buffer arr0_i32 { int _arr0_i32_[];}; 
layout(std430, binding = 5) buffer arr0_f32 { float _arr0_f32_[];}; 
layout(std430, binding = 4) buffer arr2_i32 { int _arr2_i32_[];}; 
layout(std430, binding = 4) buffer arr2_f32 { float _arr2_f32_[];}; 
float atomicAdd_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_gtmp_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _gtmp_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_gtmp_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_arr0_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr0_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr0_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }float atomicAdd_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) + rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicSub_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt((intBitsToFloat(old_val) - rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMax_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt(max(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); } float atomicMin_arr2_f32(int addr, float rhs) { int old_val, new_val, ret; do { old_val = _arr2_i32_[addr]; new_val = floatBitsToInt(min(intBitsToFloat(old_val), rhs)); } while (old_val != atomicCompSwap(_arr2_i32_[addr], old_val, new_val)); return intBitsToFloat(old_val); }
const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void compute_force_c46_03()
{ // range for
  // range known at runtime
  int _beg = 0, _end = _gtmp_i32_[4 >> 2];
  int _sid0 = int(gl_GlobalInvocationID.x);
  for (int _sid = _sid0; _sid < (_end - _beg); _sid += int(gl_WorkGroupSize.x * gl_NumWorkGroups.x)) {
    int _itv = _beg + _sid;
      int W = int(1);
      int X = int(0);
      float Y = float(-25.0);
      float Z = float(1.0);
      float Aq = float(1e-05);
      int Ar = _itv;
      int As = 4;
      int At = _gtmp_i32_[As >> 2];
      int Au = Ar - At * int(Ar / At);
      int _li_Aw = 0;
      { // linear seek
        int _s0_Aw = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Aw = _args_i32_[16 + 0 * 8 + 1];
        _li_Aw *= _s0_Aw;
        _li_Aw += Au;
        _li_Aw *= _s1_Aw;
        _li_Aw += X;
      }
      int Aw = _li_Aw << 2;
      float Ax = _arr0_f32_[Aw >> 2];
      int _li_Ay = 0;
      { // linear seek
        int _s0_Ay = _args_i32_[16 + 0 * 8 + 0];
        int _s1_Ay = _args_i32_[16 + 0 * 8 + 1];
        _li_Ay *= _s0_Ay;
        _li_Ay += Au;
        _li_Ay *= _s1_Ay;
        _li_Ay += W;
      }
      int Ay = _li_Ay << 2;
      float Az = _arr0_f32_[Ay >> 2];
      int AA = _args_i32_[16 + 0 * 8 + 0];
      for (int AB_ = X; AB_ < AA; AB_ += 1) {
        int AB = AB_;
        int AC = AB;
        int AD = AC - AA * int(AC / AA);
        int AE = -int(Au != AD);
        int AF = AE & W;
        if (AF != 0) {
          int _li_AH = 0;
          { // linear seek
            int _s0_AH = _args_i32_[16 + 0 * 8 + 0];
            int _s1_AH = _args_i32_[16 + 0 * 8 + 1];
            _li_AH *= _s0_AH;
            _li_AH += AD;
            _li_AH *= _s1_AH;
            _li_AH += X;
          }
          int AH = _li_AH << 2;
          float AI = _arr0_f32_[AH >> 2];
          float AJ = Ax - AI;
          int _li_AK = 0;
          { // linear seek
            int _s0_AK = _args_i32_[16 + 0 * 8 + 0];
            int _s1_AK = _args_i32_[16 + 0 * 8 + 1];
            _li_AK *= _s0_AK;
            _li_AK += AD;
            _li_AK *= _s1_AK;
            _li_AK += W;
          }
          int AK = _li_AK << 2;
          float AL = _arr0_f32_[AK >> 2];
          float AM = Az - AL;
          float AN = AJ * AJ;
          float AO = AM * AM;
          float AP = AN + AO;
          float AQ = AP + Aq;
          float AR = float(sqrt(AQ));
          float AS = Z / AR;
          float AT = AS * AS;
          float AU = AS * AT;
          float AV = AU * Y;
          float AW = AV * AJ;
          float AX = AV * AM;
          int _li_AZ = 0;
          { // linear seek
            int _s0_AZ = _args_i32_[16 + 2 * 8 + 0];
            int _s1_AZ = _args_i32_[16 + 2 * 8 + 1];
            _li_AZ *= _s0_AZ;
            _li_AZ += Au;
            _li_AZ *= _s1_AZ;
            _li_AZ += X;
          }
          int AZ = _li_AZ << 2;
          float B0;
          { // Begin Atomic Op
          B0 = atomicAdd_arr2_f32(AZ >> 2, AW);
          } // End Atomic Op
          int _li_B1 = 0;
          { // linear seek
            int _s0_B1 = _args_i32_[16 + 2 * 8 + 0];
            int _s1_B1 = _args_i32_[16 + 2 * 8 + 1];
            _li_B1 *= _s0_B1;
            _li_B1 += Au;
            _li_B1 *= _s1_B1;
            _li_B1 += W;
          }
          int B1 = _li_B1 << 2;
          float B2;
          { // Begin Atomic Op
          B2 = atomicAdd_arr2_f32(B1 >> 2, AX);
          } // End Atomic Op
        }
      }
  }
}

void main()
{
  compute_force_c46_03();
}
