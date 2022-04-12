#version 460

layout (location = 0) out vec4 color;
layout (location = 0) in vec3 v_color;

void main() {
    vec3 c = v_color;
    c = c / (c + 1.0);
    c = pow(c, vec3(1.0 / 2.2));

    color = vec4(c, 1.0);
}
