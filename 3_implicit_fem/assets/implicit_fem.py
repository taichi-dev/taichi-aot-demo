import argparse
import os

import numpy as np
import taichi as ti

parser = argparse.ArgumentParser()
parser.add_argument('--dim', type=int, default=3)
parser.add_argument('--jit', default=False, action='store_true')
parser.add_argument("--arch", default="vulkan", type=str)
args = parser.parse_args()
    
curr_dir = os.path.dirname(os.path.realpath(__file__))

# TODO: asserts cuda or vulkan backend
if args.arch == "vulkan":
    arch = ti.vulkan
else:
    assert False
ti.init(arch=arch, offline_cache=False, vk_api_version="1.0")

def get_path(*segs):
    return os.path.join(curr_dir, *segs)


c2e_np = np.fromfile(get_path('c2e.bin'), dtype=np.int32).reshape(-1, 6)
vertices_np = np.fromfile(get_path('vertices.bin'), dtype=np.int32).reshape(-1, 4)
indices_np = np.fromfile(get_path('indices.bin'), dtype=np.int32).reshape(-1, 3)
edges_np = np.fromfile(get_path('edges.bin'), dtype=np.int32).reshape(-1, 2)
ox_np = np.fromfile(get_path('ox.bin'), dtype=np.float32).reshape(-1, 3)

n_edges = edges_np.shape[0]
n_verts = ox_np.shape[0]
n_cells = c2e_np.shape[0]
n_faces = indices_np.shape[0]

E, nu = 5e5, 0.0
mu, la = E / (2 * (1 + nu)), E * nu / ((1 + nu) * (1 - 2 * nu))  # lambda = 0
density = 1000.0
epsilon = 1e-5
dt = 7.5e-3
num_substeps = int(2e-2 / dt + 0.5)
aspect_ratio = 2.0

x = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
v = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
f = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
mul_ans = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
m = ti.ndarray(dtype=ti.f32, shape=n_verts)

B = ti.Matrix.ndarray(args.dim, args.dim, dtype=ti.f32, shape=n_cells)
W = ti.ndarray(dtype=ti.f32, shape=n_cells)

gravity = [0, -9.8, 0]

ox = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
vertices = ti.Vector.ndarray(4, dtype=ti.i32, shape=n_cells)
indices = ti.field(ti.i32, shape=n_faces * 3)
edges = ti.Vector.ndarray(2, dtype=ti.i32, shape=n_edges)
c2e = ti.Vector.ndarray(6, dtype=ti.i32, shape=n_cells)

hes_edge = ti.ndarray(dtype=ti.f32, shape=edges.shape)
hes_vert = ti.ndarray(dtype=ti.f32, shape=ox.shape)

b = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
r0 = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
p0 = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
alpha_scalar = ti.ndarray(ti.f32, shape=())
beta_scalar = ti.ndarray(ti.f32, shape=())

dot_ans = ti.ndarray(ti.f32, shape=())
r_2_scalar = ti.ndarray(ti.f32, shape=())

ox.from_numpy(ox_np)
vertices.from_numpy(vertices_np)
indices.from_numpy(indices_np.reshape(-1))

edges.from_numpy(np.array(list(edges_np)))
c2e.from_numpy(c2e_np)


@ti.kernel
def clear_ndarray(hes_edge: ti.types.ndarray(field_dim=1), hes_vert: ti.types.ndarray(field_dim=1)):
    for I in ti.grouped(hes_edge):
        hes_edge[I] = 0
    for I in ti.grouped(hes_vert):
        hes_vert[I] = 0


@ti.func
def Ds(verts, x: ti.template()):
    return ti.Matrix.cols(
        [x[verts[i]] - x[verts[3]] + epsilon for i in range(3)])


@ti.func
def ssvd(F):
    U, sig, V = ti.svd(F)
    if U.determinant() < 0:
        for i in ti.static(range(3)):
            U[i, 2] *= -1
        sig[2, 2] = -sig[2, 2]
    if V.determinant() < 0:
        for i in ti.static(range(3)):
            V[i, 2] *= -1
        sig[2, 2] = -sig[2, 2]
    return U, sig, V


@ti.func
def get_force_func(c, verts, x: ti.template(), f: ti.template(), B: ti.template(), W: ti.template()):
    F = Ds(verts, x) @ B[c]
    P = ti.Matrix.zero(ti.f32, 3, 3)
    U, sig, V = ssvd(F)
    P = 2 * mu * (F - U @ V.transpose())
    H = -W[c] * P @ B[c].transpose()
    for i in ti.static(range(3)):
        force = ti.Vector([H[j, i] for j in range(3)])
        f[verts[i]] += force
        f[verts[3]] -= force


@ti.kernel
def get_force(
        x: ti.types.ndarray(field_dim=1), f: ti.types.ndarray(field_dim=1),
        vertices: ti.types.ndarray(field_dim=1), g_x: ti.f32, g_y: ti.f32, g_z: ti.f32, m: ti.types.ndarray(field_dim=1), B: ti.types.ndarray(field_dim=1), W: ti.types.ndarray(field_dim=1)):
    for c in vertices:
        get_force_func(c, vertices[c], x, f, B, W)
    for u in f:
        g = ti.Vector([g_x, g_y, g_z])
        f[u] += g * m[u]


@ti.kernel
def get_matrix(c2e: ti.types.ndarray(field_dim=1), vertices: ti.types.ndarray(field_dim=1), B: ti.types.ndarray(field_dim=1), W: ti.types.ndarray(field_dim=1), hes_edge: ti.types.ndarray(field_dim=1), hes_vert: ti.types.ndarray(field_dim=1)):
    for c in vertices:
        verts = vertices[c]
        W_c = W[c]
        B_c = B[c]
        hes = ti.Matrix.zero(ti.f32, 12, 12)
        for u in ti.static(range(4)):
            for d in ti.static(range(3)):
                dD = ti.Matrix.zero(ti.f32, 3, 3)
                if ti.static(u == 3):
                    for j in ti.static(range(3)):
                        dD[d, j] = -1
                else:
                    dD[d, u] = 1
                dF = dD @ B_c
                dP = 2.0 * mu * dF
                dH = -W_c * dP @ B_c.transpose()
                for i in ti.static(range(3)):
                    for j in ti.static(range(3)):
                        hes[i * 3 + j, u * 3 + d] = -dt**2 * dH[j, i]
                        hes[3 * 3 + j, u * 3 + d] += dt**2 * dH[j, i]

        z = 0
        for u_i in ti.static(range(4)):
            u = verts[u_i]
            for v_i in ti.static(range(4)):
                v = verts[v_i]
                if u < v:
                    hes_edge[c2e[c][z]] += hes[u_i * 3, v_i * 3]
                    z += 1
        for zz in ti.static(range(4)):
            hes_vert[verts[zz]] += hes[zz * 3, zz * 3]


@ti.kernel
def matmul_edge(ret: ti.types.ndarray(field_dim=1), vel: ti.types.ndarray(field_dim=1),
        edges: ti.types.ndarray(field_dim=1), m: ti.types.ndarray(field_dim=1), hes_edge: ti.types.ndarray(field_dim=1), hes_vert: ti.types.ndarray(field_dim=1)):
    for i in ret:
        ret[i] = vel[i] * m[i] + hes_vert[i] * vel[i]
    for e in edges:
        u = edges[e][0]
        v = edges[e][1]
        ret[u] += hes_edge[e] * vel[v]
        ret[v] += hes_edge[e] * vel[u]


@ti.kernel
def add(ans: ti.types.ndarray(field_dim=1), a: ti.types.ndarray(field_dim=1), k: ti.f32,
        b: ti.types.ndarray(field_dim=1)):
    for i in ans:
        ans[i] = a[i] + k * b[i]


@ti.kernel
def add_scalar_ndarray(ans: ti.types.ndarray(field_dim=1), a: ti.types.ndarray(field_dim=1),
                       k: ti.f32, scalar: ti.types.ndarray(field_dim=0),
                       b: ti.types.ndarray(field_dim=1)):
    for i in ans:
        ans[i] = a[i] + k * scalar[None] * b[i]


@ti.kernel
def dot2scalar(a: ti.types.ndarray(field_dim=1), b: ti.types.ndarray(field_dim=1), dot_ans: ti.types.ndarray(field_dim=0)):
    dot_ans[None] = 0.0
    for i in a:
        dot_ans[None] += a[i].dot(b[i])


@ti.kernel
def get_b(v: ti.types.ndarray(field_dim=1), b: ti.types.ndarray(field_dim=1), f: ti.types.ndarray(field_dim=1), m: ti.types.ndarray(field_dim=1)):
    for i in b:
        b[i] = m[i] * v[i] + dt * f[i]


@ti.kernel
def ndarray_to_ndarray(ndarray: ti.types.ndarray(field_dim=1), other: ti.types.ndarray(field_dim=1)):
    for I in ti.grouped(ndarray):
        ndarray[I] = other[I]


@ti.kernel
def fill_ndarray(ndarray: ti.types.ndarray(field_dim=1), val: ti.f32):
    for I in ti.grouped(ndarray):
        ndarray[I] = [val, val, val]


@ti.kernel
def init_r_2(dot_ans: ti.types.ndarray(field_dim=0), r_2_scalar: ti.types.ndarray(field_dim=0)):
    r_2_scalar[None] = dot_ans[None]


@ti.kernel
def update_alpha(alpha_scalar: ti.types.ndarray(field_dim=0), dot_ans: ti.types.ndarray(field_dim=0), r_2_scalar: ti.types.ndarray(field_dim=0)):
    alpha_scalar[None] = r_2_scalar[None] / (dot_ans[None] + epsilon)


@ti.kernel
def update_beta_r_2(beta_scalar: ti.types.ndarray(field_dim=0), dot_ans: ti.types.ndarray(field_dim=0), r_2_scalar: ti.types.ndarray(field_dim=0)):
    beta_scalar[None] = dot_ans[None] / (r_2_scalar[None] + epsilon)
    r_2_scalar[None] = dot_ans[None]


def cg(it):
    get_force(x, f, vertices, gravity[0], gravity[1], gravity[2], m, B, W)
    get_b(v, b, f, m)
    # matmul_edge(mul_ans, v, edges, m, hes_edge, hes_vert)
    matmul_edge(mul_ans, v, edges, m, hes_edge, hes_vert)
    add(r0, b, -1, mul_ans)

    ndarray_to_ndarray(p0, r0)
    dot2scalar(r0, r0, dot_ans)
    init_r_2(dot_ans, r_2_scalar)
    CG_ITERS = 10
    for _ in range(CG_ITERS):
        matmul_edge(mul_ans, p0, edges, m, hes_edge, hes_vert)
        dot2scalar(p0, mul_ans, dot_ans)
        update_alpha(alpha_scalar, dot_ans, r_2_scalar)
        add_scalar_ndarray(v, v, 1, alpha_scalar, p0)
        add_scalar_ndarray(r0, r0, -1, alpha_scalar, mul_ans)
        dot2scalar(r0, r0, dot_ans)
        update_beta_r_2(beta_scalar, dot_ans, r_2_scalar)
        add_scalar_ndarray(p0, r0, 1, beta_scalar, p0)
    fill_ndarray(f, 0)
    add(x, x, dt, v)


@ti.kernel
def init(x: ti.types.ndarray(field_dim=1), v: ti.types.ndarray(field_dim=1), f: ti.types.ndarray(field_dim=1),
        ox: ti.types.ndarray(field_dim=1), vertices: ti.types.ndarray(field_dim=1, element_shape=(4,)), m: ti.types.ndarray(field_dim=1), B: ti.types.ndarray(field_dim=1), W: ti.types.ndarray(field_dim=1)):
    for u in x:
        x[u] = ox[u]
        v[u] = [0.0] * 3
        f[u] = [0.0] * 3
        m[u] = 0.0
    for c in vertices:
        F = Ds(vertices[c], x)
        B[c] = F.inverse()
        W[c] = ti.abs(F.determinant()) / 6
        for i in ti.static(range(4)):
            m[vertices[c][i]] += W[c] / 4 * density


@ti.kernel
def floor_bound(x: ti.types.ndarray(field_dim=1), v: ti.types.ndarray(field_dim=1)):
    bounds = ti.Vector([1, aspect_ratio, 1])
    for u in x:
        for i in ti.static(range(3)):
            if x[u][i] < -bounds[i]:
                x[u][i] = -bounds[i]
                if v[u][i] < 0:
                    v[u][i] = 0
            if x[u][i] > bounds[i]:
                x[u][i] = bounds[i]
                if v[u][i] > 0:
                    v[u][i] = 0


def substep():
    g_substep.run({'x': x, 'f': f, 'vertices': vertices,
        'gravity_x': gravity[0], 'gravity_y': gravity[1], 'gravity_z': gravity[2],
        'm': m, 'B': B, 'W': W, 'b': b, 'v': v, 'mul_ans': mul_ans, 'edges': edges,
        'hes_edge': hes_edge, 'hes_vert': hes_vert, 'r0': r0, 'k2': -1.0, 'p0': p0,
        'dot_ans': dot_ans, 'r_2_scalar': r_2_scalar, 'alpha_scalar': alpha_scalar,
        'beta_scalar': beta_scalar, 'k0': 0.0, 'k1': 1.0, 'dt': dt})


def run_aot():
    mod = ti.aot.Module(ti.vulkan)
    mod.add_graph('init', g_init)
    mod.add_graph('substep', g_substep)
    
    save_dir = os.path.join(curr_dir, "implicit_fem")
    os.makedirs(save_dir, exist_ok=True)
    mod.save(save_dir, '')
    print('AOT done')


@ti.kernel
def convert_to_field(x: ti.types.ndarray(field_dim=1), y: ti.template()):
    for I in ti.grouped(x):
        y[I] = x[I]


sym_hes_edge = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'hes_edge', ti.f32, field_dim=len(edges.shape))
sym_hes_vert = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'hes_vert', ti.f32, field_dim=len(ox.shape))
sym_x = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'x', ti.f32, field_dim=1, element_shape=(args.dim,))
sym_v = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'v', ti.f32, field_dim=1, element_shape=(args.dim,))
sym_f = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'f', ti.f32, field_dim=1, element_shape=(args.dim,))
sym_ox = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'ox', ti.f32, field_dim=1, element_shape=(args.dim,))
sym_vertices = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'vertices', ti.i32, field_dim=1, element_shape=(4,))
sym_m = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'm', ti.f32, field_dim=1)
sym_B = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'B', ti.f32, field_dim=1, element_shape=(args.dim, args.dim))
sym_W = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'W', ti.f32, field_dim=1)
sym_c2e = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'c2e', ti.i32, field_dim=1, element_shape=(6,))

g_init_builder = ti.graph.GraphBuilder()
g_init_builder.dispatch(clear_ndarray, sym_hes_edge, sym_hes_vert)
g_init_builder.dispatch(init, sym_x, sym_v, sym_f, sym_ox, sym_vertices, sym_m, sym_B, sym_W)
g_init_builder.dispatch(get_matrix, sym_c2e, sym_vertices, sym_B, sym_W, sym_hes_edge, sym_hes_vert)

g_init = g_init_builder.compile()

sym_gravity_x = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'gravity_x', ti.f32)
sym_gravity_y = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'gravity_y', ti.f32)
sym_gravity_z = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'gravity_z', ti.f32)
sym_b = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'b', ti.f32, field_dim=1, element_shape=(3,))
sym_mul_ans = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'mul_ans', ti.f32, field_dim=1, element_shape=(args.dim,))
sym_edges = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'edges', ti.i32, field_dim=1, element_shape=(2,))
sym_r0 = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'r0', ti.f32, field_dim=1, element_shape=(3,))

sym_k0 = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'k0', ti.f32)
sym_k1 = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'k1', ti.f32)
sym_k2 = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'k2', ti.f32)
sym_p0 = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'p0', ti.f32, field_dim=1, element_shape=(3,))
sym_dot_ans = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'dot_ans', ti.f32, field_dim=0)
sym_r_2_scalar = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'r_2_scalar', ti.f32, field_dim=0)
sym_alpha_scalar = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'alpha_scalar', ti.f32, field_dim=0)
sym_beta_scalar = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, 'beta_scalar', ti.f32, field_dim=0)
sym_dt = ti.graph.Arg(ti.graph.ArgKind.SCALAR, 'dt', ti.f32)

g_substep_builder = ti.graph.GraphBuilder()

seq_cg = g_substep_builder.create_sequential()
seq_cg.dispatch(matmul_edge, sym_mul_ans, sym_p0, sym_edges, sym_m, sym_hes_edge, sym_hes_vert)
seq_cg.dispatch(dot2scalar, sym_p0, sym_mul_ans, sym_dot_ans)
seq_cg.dispatch(update_alpha, sym_alpha_scalar, sym_dot_ans, sym_r_2_scalar)
seq_cg.dispatch(add_scalar_ndarray, sym_v, sym_v, sym_k1, sym_alpha_scalar, sym_p0)
seq_cg.dispatch(add_scalar_ndarray, sym_r0, sym_r0, sym_k2, sym_alpha_scalar, sym_mul_ans)
seq_cg.dispatch(dot2scalar, sym_r0, sym_r0, sym_dot_ans)
seq_cg.dispatch(update_beta_r_2, sym_beta_scalar, sym_dot_ans, sym_r_2_scalar)
seq_cg.dispatch(add_scalar_ndarray, sym_p0, sym_r0, sym_k1, sym_beta_scalar, sym_p0)

CG_ITERS = 10
for j in range(num_substeps):
    g_substep_builder.dispatch(get_force, sym_x, sym_f, sym_vertices, sym_gravity_x, sym_gravity_y, sym_gravity_z, sym_m, sym_B, sym_W)
    g_substep_builder.dispatch(get_b, sym_v, sym_b, sym_f, sym_m)
    g_substep_builder.dispatch(matmul_edge, sym_mul_ans, sym_v, sym_edges, sym_m, sym_hes_edge, sym_hes_vert)
    g_substep_builder.dispatch(add, sym_r0, sym_b, sym_k2, sym_mul_ans)
    g_substep_builder.dispatch(ndarray_to_ndarray, sym_p0, sym_r0)
    g_substep_builder.dispatch(dot2scalar, sym_r0, sym_r0, sym_dot_ans)
    g_substep_builder.dispatch(init_r_2, sym_dot_ans, sym_r_2_scalar)

    for i in range(CG_ITERS):
        g_substep_builder.append(seq_cg)

    g_substep_builder.dispatch(fill_ndarray, sym_f, sym_k0)
    g_substep_builder.dispatch(add, sym_x, sym_x, sym_dt, sym_v)
g_substep_builder.dispatch(floor_bound, sym_x, sym_v)

g_substep = g_substep_builder.compile()

def run_ggui():
    res = (600, int(600*aspect_ratio))
    window = ti.ui.Window("Implicit FEM", res, vsync=True)

    canvas = window.get_canvas()
    scene = ti.ui.Scene()
    camera = ti.ui.make_camera()
    camera.position(0.0, 1.5, 2.95)
    camera.lookat(0.0, 0.0, 0.0)
    camera.fov(55)

    x_field = ti.Vector.field(3, dtype=ti.f32, shape=n_verts)

    def handle_interaction(window):
        global gravity
        gravity = [0, -9.8, 0]
        if window.is_pressed('i'):
            gravity = [0, 0, -9.8]
        if window.is_pressed('k'):
            gravity = [0, 0, 9.8]
        if window.is_pressed('o'):
            gravity = [0, 9.8, 0]
        if window.is_pressed('u'):
            gravity = [0, -9.8, 0]
        if window.is_pressed('l'):
            gravity = [9.8, 0, 0]
        if window.is_pressed('j'):
            gravity = [-9.8, 0, 0]

    def render():
        convert_to_field(x, x_field)
        camera.track_user_inputs(window,
                                 movement_speed=0.03,
                                 hold_key=ti.ui.RMB)
        scene.set_camera(camera)

        scene.ambient_light((0.1, ) * 3)

        scene.point_light(pos=(0.5, 10.0, 0.5), color=(0.5, 0.5, 0.5))
        scene.point_light(pos=(10.0, 10.0, 10.0), color=(0.5, 0.5, 0.5))

        scene.mesh(x_field, indices, color=(0.73, 0.33, 0.23))

        canvas.scene(scene)

    while window.running:
        substep()
        if window.is_pressed('r'):
            init(x, v, f, ox, vertices, m, B, W)
        if window.is_pressed(ti.GUI.ESCAPE):
            break
        handle_interaction(window)

        render()

        window.show()

if __name__ == '__main__':
    print(f'dt={dt} num_substeps={num_substeps}')
    if not args.jit:
        run_aot()
    else:
        g_init.run({'hes_edge': hes_edge, 'hes_vert': hes_vert, 'x': x, 'v': v, 'f': f, 'ox': ox, 'vertices': vertices, 'm': m, 'B': B,
            'W':W, 'c2e': c2e})
        run_ggui()
