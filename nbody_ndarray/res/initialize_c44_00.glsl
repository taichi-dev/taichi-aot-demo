#version 310 es
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
precision highp float;
layout(std430, binding = 1) buffer gtmp_i32 { int _gtmp_i32_[];}; 
layout(std430, binding = 2) buffer args_i32 { int _args_i32_[];}; 

const float inf = 1.0f / 0.0f;
const float nan = 0.0f / 0.0f;
void initialize_c44_00()
{ // serial
  int B = _args_i32_[16 + 0 * 8 + 0];
  int C = 0;
  _gtmp_i32_[C >> 2] = B;
}

void main()
{
  initialize_c44_00();
}
