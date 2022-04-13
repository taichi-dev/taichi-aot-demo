#version 460

layout (location = 0) in vec3 position;

layout (location = 0) out vec3 world_pos;

layout (set = 0, binding = 0) uniform Constants {
    mat4 proj;
    mat4 view;
};

void main() {
    world_pos = position;

    vec4 pos = vec4(position, 1.0);
    pos = view * pos;
    pos = proj * pos;
    pos.z = pos.w - pos.z;

    gl_Position = pos;
}
