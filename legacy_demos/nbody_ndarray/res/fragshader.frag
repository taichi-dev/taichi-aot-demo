#version 320 es

precision highp float;

layout (location = 0) in vec4 v_v4FillColor;
layout (location = 0) out vec4 fragmentColor;

void main() {
    fragmentColor = v_v4FillColor;
}
