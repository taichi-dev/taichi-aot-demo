#version 460

layout (location = 0) out vec4 color;

layout (location = 0) in vec3 world_pos;

void main() {
    vec3 normal = normalize(cross(dFdx(world_pos), dFdy(world_pos)));

    color = vec4(normal * 0.5 + 0.5, 1.0);
}
