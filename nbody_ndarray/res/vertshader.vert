#version 320 es

precision highp float;

layout (location = 0) in vec2 a_v4Position;

layout (location = 1) in vec4 a_v4FillColor;

layout (location = 0) out vec4 v_v4FillColor;

void main() {
    v_v4FillColor = a_v4FillColor;
    gl_Position = vec4(a_v4Position.xy*2.0 - 1.0, 1, 1);
    //gl_Position = a_v4Position;
    gl_PointSize = 10.0f;
}
