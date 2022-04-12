#version 460

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 v_color;

layout (location = 0) out vec3 color;

layout (set = 0, binding = 0) uniform Constants {
    mat4 proj;
    mat4 view;
};

void main() {
    vec4 pos = vec4(position, 1.0);
    pos = view * pos;
    pos = proj * pos;
    pos.z = pos.w - pos.z;

    gl_Position = pos;

    color = v_color;
}
