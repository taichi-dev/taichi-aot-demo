#version 460

layout (location = 0) out vec4 color;
layout (location = 0) in vec3 world_pos;

void main() {
    color = vec4(0.8, 0.5, 0.2, 1.0);
}
