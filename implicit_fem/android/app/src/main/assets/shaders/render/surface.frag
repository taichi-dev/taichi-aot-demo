#version 460

layout (location = 0) out vec4 color;

layout (location = 0) in vec3 world_pos;


const float pi = 3.1415926;

const vec3 sh[] = {
    vec3(4.2422637939453125, 3.469686985015869, 2.921431303024292),
    vec3(-0.3360636532306671, 0.14775796234607697, 0.34051141142845154),
    vec3(3.112220048904419, 2.7990305423736572, 2.1869006156921387),
    vec3(-0.4123135805130005, -0.3369070887565613, -0.2881617248058319),
    vec3(-0.009572692215442657, -0.027084171772003174, -0.03501185029745102),
    vec3(-0.039841532707214355, -0.04630348086357117, -0.03528120741248131),
    vec3(1.5684678554534912, 1.4283108711242676, 1.0892961025238037),
    vec3(0.06361131370067596, 0.061201803386211395, 0.057093050330877304),
    vec3(0.056722987443208694, -0.0033324179239571095, 0.027888836339116096)
};

float sh_l0() {
    return sqrt(1.0 / (4.0 * pi));
}

float sh_l1_y0(vec3 n) {
    return sqrt(3.0 / (4.0 * pi)) * n.x;
}

float sh_l1_y1(vec3 n) {
    return sqrt(3.0 / (4.0 * pi)) * n.z;
}

float sh_l1_y2(vec3 n) {
    return sqrt(3.0 / (4.0 * pi)) * n.y;
}

float sh_l2_y0(vec3 n) {
    return sqrt(15.0 / (4.0 * pi)) * n.x * n.y;
}

float sh_l2_y1(vec3 n) {
    return sqrt(15.0 / (4.0 * pi)) * n.y * n.z;
}

float sh_l2_y2(vec3 n) {
    return sqrt(5.0 / (16.0 * pi)) * (3.0 * n.z * n.z - 1.0);
}

float sh_l2_y3(vec3 n) {
    return sqrt(15.0 / (8.0 * pi)) * n.x * n.z;
}

float sh_l2_y4(vec3 n) {
    return sqrt(15.0 / (32.0 * pi)) * (n.x * n.x - n.y * n.y);
}

void main() {
    vec3 normal = normalize(cross(dFdy(world_pos), dFdx(world_pos)));

    vec3 shaded = vec3(0.0);
    
    shaded += sh_l0() * sh[0];

    shaded += sh_l1_y0(normal.xzy) * sh[1];
    shaded += sh_l1_y1(normal.xzy) * sh[2];
    shaded += sh_l1_y2(normal.xzy) * sh[3];

    shaded += sh_l2_y0(normal.xzy) * sh[4];
    shaded += sh_l2_y1(normal.xzy) * sh[5];
    shaded += sh_l2_y2(normal.xzy) * sh[6];
    shaded += sh_l2_y3(normal.xzy) * sh[7];
    shaded += sh_l2_y4(normal.xzy) * sh[8];

    vec3 c = vec3(0.7) * shaded;
    c = c / (1.0 + c);
    c = pow(c, vec3(1.0 / 2.2));

    color = vec4(c, 1.0);
}
