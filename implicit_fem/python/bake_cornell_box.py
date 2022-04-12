import taichi as ti
import numpy as np

ti.init(arch=ti.vulkan)

@ti.func
def intersect_plane(pos, d, pt_on_plane, norm):
    dist = np.inf
    hit_pos = ti.Vector([0.0, 0.0, 0.0])
    denom = d.dot(norm)
    if abs(denom) > 0.0:
        dist = norm.dot(pt_on_plane - pos) / denom
        hit_pos = pos + d * dist
    return dist, hit_pos

@ti.func
def intersect_scene(pos, dir):
    albedo = ti.Vector([0.6, 0.6, 0.6])
    t = np.inf
    emissive = 0
    hit_norm= ti.Vector([1.0, 0.0, 0.0])

    # Left wall
    d, hit_p = intersect_plane(pos, dir, ti.Vector([-1.0, 0.0, 0.0]), ti.Vector([1.0, 0.0, 0.0]))
    if d > 0.0 and d < t and hit_p.y >= -1.0 and hit_p.y <= 1.0 and hit_p.z >= -1.0 and hit_p.z <= 1.0:
        albedo = ti.Vector([0.8, 0.1, 0.03])
        t = d
        hit_norm = ti.Vector([1.0, 0.0, 0.0])

    # Right wall
    d, hit_p = intersect_plane(pos, dir, ti.Vector([1.0, 0.0, 0.0]), ti.Vector([-1.0, 0.0, 0.0]))
    if d > 1e-5 and d < t and hit_p.y >= -1.0 and hit_p.y <= 1.0 and hit_p.z >= -1.0 and hit_p.z <= 1.0:
        albedo = ti.Vector([0.1, 0.3, 0.8])
        t = d
        hit_norm = ti.Vector([-1.0, 0.0, 0.0])

    # Ceiling
    d, hit_p = intersect_plane(pos, dir, ti.Vector([0.0, 0.0, 1.0]), ti.Vector([0.0, 0.0, -1.0]))
    if d > 1e-5 and d < t and hit_p.x >= -1.0 and hit_p.x <= 1.0 and hit_p.y >= -1.0 and hit_p.y <= 1.0:
        albedo = ti.Vector([0.7, 0.7, 0.7])
        t = d
        hit_norm = ti.Vector([0.0, 0.0, -1.0])
        if hit_p.x >= -0.3 and hit_p.x <= 0.3 and hit_p.y >= -0.3 and hit_p.y <= 0.3:
            albedo = ti.Vector([50.0, 45.0, 35.0])
            emissive = 1

    # Floor
    d, hit_p = intersect_plane(pos, dir, ti.Vector([0.0, 0.0, -1.0]), ti.Vector([0.0, 0.0, 1.0]))
    if d > 1e-5 and d < t and hit_p.x >= -1.0 and hit_p.x <= 1.0 and hit_p.y >= -1.0 and hit_p.y <= 1.0:
        albedo = ti.Vector([0.6, 0.6, 0.6])
        t = d
        hit_norm = ti.Vector([0.0, 0.0, 1.0])

    # Back wall
    d, hit_p = intersect_plane(pos, dir, ti.Vector([0.0, -1.0, 0.0]), ti.Vector([0.0, 1.0, 0.0]))
    if d > 1e-5 and d < t and hit_p.x >= -1.0 and hit_p.x <= 1.0 and hit_p.z >= -1.0 and hit_p.z <= 1.0:
        albedo = ti.Vector([0.7, 0.7, 0.7])
        t = d
        hit_norm = ti.Vector([0.0, 0.0, 1.0])

    return t, albedo, emissive, hit_norm

@ti.func
def cosine_weighted_hemisphere(norm):
    u0 = ti.random()
    u1 = ti.random()
    a = 1.0 - 2.0 * u0
    b = ti.sqrt(1.0 - a * a)
    phi = 2.0 * np.pi * u1
    return ti.Vector([
        norm.x + b * ti.cos(phi),
        norm.y + b * ti.sin(phi),
        norm.z + a])

@ti.func
def sign(v):
    return -1 if v < 0 else 1

@ti.func
def rand_sphere():
    u = ti.Vector([ti.random(), ti.random()]) * 2.0 - 1.0
    d = 1.0 - (abs(u[0]) + abs(u[1]))
    r = 1.0 - abs(d)

    phi = 0.0 if (r == 0.0) else ((np.pi / 4.0) * ((abs(u[1]) - abs(u[0])) / r + 1.0))
    f = r * ti.sqrt(2 - r * r)
    return ti.Vector([
        f * sign(u[0]) * ti.cos(phi),
        f * sign(u[1]) * ti.sin(phi),
        sign(d) * (1.0 - r * r)])


@ti.func
def integrate(pos, dir):
    throughput = ti.Vector([1.0, 1.0, 1.0])
    Lin = ti.Vector([0.0, 0.0, 0.0])

    for d in range(10):
        t, albedo, emissive, hit_norm = intersect_scene(pos, dir)
        if t > 1000.0:
            break
        hit_p = pos + dir * t
        if emissive:
            Lin = albedo
            break
        throughput *= albedo
        pos = hit_p
        dir = cosine_weighted_hemisphere(hit_norm)
        pos = pos + hit_norm * 1e-5

    return throughput * Lin

res = (512, 512)
accum_img = ti.Vector.field(3, dtype=ti.f32, shape=res)
display_img = ti.Vector.field(3, dtype=ti.f32, shape=res)

@ti.kernel
def render_scene(img : ti.template()):
    for i, j in img:
        cam_pos = ti.Vector([0.0, 4.0, 0.0])
        cam_fwd = ti.Vector([0.0, -1.0, 0.0])
        cam_right = ti.Vector([1.0, 0.0, 0.0])
        cam_up = ti.Vector([0.0, 0.0, 1.0])
        uv = ti.cast(ti.Vector([i, j]), ti.f32) / ti.cast(ti.Vector(res), ti.f32)
        uv = uv * 2.0 - 1.0
        half_fov = 40.0 * np.pi / 180.0 / 2.0
        tan_half_fov = ti.tan(half_fov)
        dir = cam_fwd + tan_half_fov * uv.x * cam_right + tan_half_fov * uv.y * cam_up
        dir = dir / dir.norm()

        for s in range(100):
            img[i, j] += integrate(cam_pos, dir)

@ti.kernel
def render_wall(img : ti.template(), axis_x : ti.types.vector(3, dtype=ti.f32), axis_y : ti.types.vector(3, dtype=ti.f32), norm : ti.types.vector(3, dtype=ti.f32)):
    for i, j in img:
        uv = ti.cast(ti.Vector([i, j]), ti.f32) / ti.cast(ti.Vector(res), ti.f32)
        uv = uv * 2.0 - 1.0
        pos = uv.x * axis_x + uv.y * axis_y
        dir = -norm

        for s in range(100):
            img[i, j] += integrate(pos, dir)

# @ti.kernel
# def render_sh(img : ti.template()):
#     for i, j in img:
#         uv = ti.cast(ti.Vector([i, j]), ti.f32) / ti.cast(ti.Vector(res), ti.f32)
#         uv = uv * 2.0 - 1.0
#         pos = uv.x * axis_x + uv.y * axis_y
#         dir = -norm

#         for s in range(100):
#             img[i, j] += integrate(pos, dir)

@ti.kernel
def tonemap(samples : ti.f32, acc : ti.template()):
    for i, j in acc:
        c = acc[i, j] / samples
        display_img[i, j] = ti.sqrt(c / (1.0 + c))

@ti.kernel
def down_sample(img_down : ti.template(), img : ti.template()):
    for i, j in img_down:
        img_down[i, j] = ti.Vector([0.0, 0.0, 0.0])
    for i, j in img:
        img_down[i // 16, j // 16] += img[i, j]
    for i, j in img_down:
        img_down[i, j] /= 8000.0 * 16.0 * 16.0

@ti.func
def sh_l0():
    return ti.sqrt(1.0 / (4.0 * np.pi))

@ti.func
def sh_l1_y0(n):
    return ti.sqrt(3.0 / (4.0 * np.pi)) * n.x

@ti.func
def sh_l1_y1(n):
    return ti.sqrt(3.0 / (4.0 * np.pi)) * n.z

@ti.func
def sh_l1_y2(n):
    return ti.sqrt(3.0 / (4.0 * np.pi)) * n.y

@ti.func
def sh_l2_y0(n):
    return ti.sqrt(15 / (4.0 * np.pi)) * n.x * n.y

@ti.func
def sh_l2_y1(n):
    return ti.sqrt(15 / (4.0 * np.pi)) * n.y * n.z

@ti.func
def sh_l2_y2(n):
    return ti.sqrt(5 / (16.0 * np.pi)) * (3.0 * n.z * n.z - 1.0)

@ti.func
def sh_l2_y3(n):
    return ti.sqrt(15 / (8.0 * np.pi)) * n.x * n.z

@ti.func
def sh_l2_y4(n):
    return ti.sqrt(15 / (32.0 * np.pi)) * (n.x * n.x - n.y * n.y)


@ti.kernel
def bake_sh(sh : ti.template()):
    for i in range(8000):
        sphere_norm = rand_sphere()

        radiance = ti.Vector([0.0, 0.0, 0.0])

        for s in range(100):
            dir = cosine_weighted_hemisphere(sphere_norm)
            radiance += integrate(ti.Vector([0.0, 0.0, 0.0]), dir)

        radiance *= 0.01

        # if radiance.x > 10.0:
        #     radiance *= 0.0

        sh[0] += radiance * sh_l0()

        sh[1] += radiance * sh_l1_y0(sphere_norm)
        sh[2] += radiance * sh_l1_y1(sphere_norm)
        sh[3] += radiance * sh_l1_y2(sphere_norm)

        sh[4] += radiance * sh_l2_y0(sphere_norm)
        sh[5] += radiance * sh_l2_y1(sphere_norm)
        sh[6] += radiance * sh_l2_y2(sphere_norm)
        sh[7] += radiance * sh_l2_y3(sphere_norm)
        sh[8] += radiance * sh_l2_y4(sphere_norm)


window = ti.ui.Window(name="cornell box", res=res)
canvas = window.get_canvas()
# Scene integrate
for i in range(80):
    render_scene(accum_img)
    tonemap((i + 1) * 100, accum_img)
    canvas.set_image(display_img)
    window.show()

left_wall = ti.Vector.field(3, dtype=ti.f32, shape=res)
right_wall = ti.Vector.field(3, dtype=ti.f32, shape=res)
ceiling_wall = ti.Vector.field(3, dtype=ti.f32, shape=res)
bottom_wall = ti.Vector.field(3, dtype=ti.f32, shape=res)
back_wall = ti.Vector.field(3, dtype=ti.f32, shape=res)

sh = ti.Vector.field(3, dtype=ti.f32, shape=(9))

down_sample_walls = ti.Vector.field(3, dtype=ti.f32, shape=(512 // 16, 512 // 16))

# Bake walls
for i in range(80):
    render_wall(left_wall, ti.Vector([0.0, 1.0, 0.0]), ti.Vector([0.0, 0.0, 1.0]), ti.Vector([1.0, 0.0, 0.0]))
    tonemap((i + 1) * 100, left_wall)
    canvas.set_image(display_img)
    window.show()

for i in range(80):
    render_wall(right_wall, ti.Vector([0.0, 1.0, 0.0]), ti.Vector([0.0, 0.0, 1.0]), ti.Vector([-1.0, 0.0, 0.0]))
    tonemap((i + 1) * 100, right_wall)
    canvas.set_image(display_img)
    window.show()

for i in range(80):
    render_wall(ceiling_wall, ti.Vector([1.0, 0.0, 0.0]), ti.Vector([0.0, 1.0, 0.0]), ti.Vector([0.0, 0.0, -1.0]))
    tonemap((i + 1) * 100, ceiling_wall)
    canvas.set_image(display_img)
    window.show()

for i in range(80):
    render_wall(bottom_wall, ti.Vector([1.0, 0.0, 0.0]), ti.Vector([0.0, 1.0, 0.0]), ti.Vector([0.0, 0.0, 1.0]))
    tonemap((i + 1) * 100, bottom_wall)
    canvas.set_image(display_img)
    window.show()

for i in range(80):
    render_wall(back_wall, ti.Vector([1.0, 0.0, 0.0]), ti.Vector([0.0, 0.0, 1.0]), ti.Vector([0.0, 1.0, 0.0]))
    tonemap((i + 1) * 100, back_wall)
    canvas.set_image(display_img)
    window.show()

def gen_code(arr):
    code = "    {\n"
    for i in range(arr.shape[0]):
        code += ("        {{ {}, {}, {} }},\n".format(arr[i, 0], arr[i, 1], arr[i, 2]))
    code += "    },\n"
    return code

code = "const glm::vec3 box_color_data[5][32 * 32] = {\n"

down_sample(down_sample_walls, left_wall)
code += gen_code(down_sample_walls.to_numpy().reshape(32 * 32, 3))

down_sample(down_sample_walls, right_wall)
code += gen_code(down_sample_walls.to_numpy().reshape(32 * 32, 3))

down_sample(down_sample_walls, ceiling_wall)
code += gen_code(down_sample_walls.to_numpy().reshape(32 * 32, 3))

down_sample(down_sample_walls, bottom_wall)
code += gen_code(down_sample_walls.to_numpy().reshape(32 * 32, 3))

down_sample(down_sample_walls, back_wall)
code += gen_code(down_sample_walls.to_numpy().reshape(32 * 32, 3))

code += "};"

cfile = open("../include/box_color_data.h", "wt")
cfile.write(code)
cfile.close()

# Bake SH

bake_sh(sh)
sh_np = sh.to_numpy() / 1000.0

for i in range(9):
    print("vec3({}, {}, {}),".format(sh_np[i, 0], sh_np[i, 1], sh_np[i, 2]))
