#version 460

layout (location = 0) out vec4 color;

layout (location = 0) in vec3 world_pos;

void main() {
    vec3 normal = normalize(cross(dFdx(world_pos), dFdy(world_pos)));
    vec3 light_direction = -vec3(0.6, 0.8, 0.0);
    float h = dot(normal, light_direction);
    float lambertian_intensity = max(-0.9, h) * 0.5 + 0.5;
    h = max(h, 0.0);
    float specular_intensity = h * h;
    specular_intensity = specular_intensity * specular_intensity * specular_intensity;

    color = vec4(lambertian_intensity * vec3(0.95, 0.55, 0.3) * 0.9 + specular_intensity * vec3(0.4), 1.0);
}
