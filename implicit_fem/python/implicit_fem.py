import argparse
import os
import pathlib
import shutil

import numpy as np
import taichi as ti

parser = argparse.ArgumentParser()
parser.add_argument('--dim', type=int, default=3)
parser.add_argument('--aot', default=False, action='store_true')
args = parser.parse_args()

# TODO: asserts cuda or vulkan backend
ti.init(arch=ti.vulkan)

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))


def get_rel_path(*segs):
    return os.path.join(SCRIPT_PATH, *segs)


c2e_np = np.load(get_rel_path('c2e.npy'))
vertices_np = np.load(get_rel_path('vertices_np.npy'))
indices_np = np.load(get_rel_path('indices_np.npy'))
edges_np = np.load(get_rel_path('edges_np.npy'))
ox_np = np.load(get_rel_path('ox_np.npy'))

n_edges = edges_np.shape[0]
n_verts = ox_np.shape[0]
n_cells = c2e_np.shape[0]
n_faces = indices_np.shape[0]

E, nu = 5e5, 0.0
mu, la = E / (2 * (1 + nu)), E * nu / ((1 + nu) * (1 - 2 * nu))  # lambda = 0
density = 1000.0
epsilon = 1e-5
dt = 2.5e-3
num_substeps = int(1e-2 / dt + 0.5)

x = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
v = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
f = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
mul_ans = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
m = ti.field(dtype=ti.f32, shape=n_verts)

B = ti.Matrix.field(args.dim, args.dim, dtype=ti.f32, shape=n_cells)
W = ti.field(dtype=ti.f32, shape=n_cells)

gravity = [0, -9.8, 0]

ox = ti.Vector.ndarray(args.dim, dtype=ti.f32, shape=n_verts)
vertices = ti.Vector.ndarray(4, dtype=ti.i32, shape=n_cells)
indices = ti.field(ti.i32, shape=n_faces * 3)
edges = ti.Vector.ndarray(2, dtype=ti.i32, shape=n_edges)
c2e = ti.Vector.ndarray(6, dtype=ti.i32, shape=n_cells)

hes_edge = ti.field(dtype=ti.f32, shape=edges.shape)
hes_vert = ti.field(dtype=ti.f32, shape=ox.shape)

b = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
r0 = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
p0 = ti.Vector.ndarray(3, dtype=ti.f32, shape=n_verts)
alpha_scalar = ti.ndarray(ti.f32, shape=())
beta_scalar = ti.ndarray(ti.f32, shape=())

dot_ans = ti.field(ti.f32, shape=())
r_2_scalar = ti.field(ti.f32, shape=())

ox.from_numpy(ox_np)
vertices.from_numpy(vertices_np)
indices.from_numpy(indices_np.reshape(-1))

edges.from_numpy(np.array(list(edges_np)))
c2e.from_numpy(c2e_np)


@ti.kernel
def clear_field():
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
def get_force_func(c, verts, x: ti.template(), f: ti.template()):
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
        x: ti.types.ndarray(), f: ti.types.ndarray(),
        vertices: ti.types.ndarray(), g_x: ti.f32, g_y: ti.f32, g_z: ti.f32):
    for c in vertices:
        get_force_func(c, vertices[c], x, f)
    for u in f:
        g = ti.Vector([g_x, g_y, g_z])
        f[u] += g * m[u]


@ti.kernel
def get_matrix(c2e: ti.types.ndarray(), vertices: ti.types.ndarray()):
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
def matmul_edge(ret: ti.types.ndarray(), vel: ti.types.ndarray(),
                edges: ti.types.ndarray()):
    for i in ret:
        ret[i] = vel[i] * m[i] + hes_vert[i] * vel[i]
    for e in edges:
        u = edges[e][0]
        v = edges[e][1]
        ret[u] += hes_edge[e] * vel[v]
        ret[v] += hes_edge[e] * vel[u]


@ti.kernel
def add(ans: ti.types.ndarray(), a: ti.types.ndarray(), k: ti.f32,
        b: ti.types.ndarray()):
    for i in ans:
        ans[i] = a[i] + k * b[i]


@ti.kernel
def add_scalar_ndarray(ans: ti.types.ndarray(), a: ti.types.ndarray(),
                       k: ti.f32, scalar: ti.types.ndarray(),
                       b: ti.types.ndarray()):
    for i in ans:
        ans[i] = a[i] + k * scalar[None] * b[i]


@ti.kernel
def dot2scalar(a: ti.types.ndarray(), b: ti.types.ndarray()):
    dot_ans[None] = 0.0
    for i in a:
        dot_ans[None] += a[i].dot(b[i])


@ti.kernel
def get_b(v: ti.types.ndarray(), b: ti.types.ndarray(), f: ti.types.ndarray()):
    for i in b:
        b[i] = m[i] * v[i] + dt * f[i]


@ti.kernel
def ndarray_to_ndarray(ndarray: ti.types.ndarray(), other: ti.types.ndarray()):
    for I in ti.grouped(ndarray):
        ndarray[I] = other[I]


@ti.kernel
def fill_ndarray(ndarray: ti.types.ndarray(), val: ti.f32):
    for I in ti.grouped(ndarray):
        ndarray[I] = [val, val, val]


@ti.kernel
def init_r_2():
    r_2_scalar[None] = dot_ans[None]


@ti.kernel
def update_alpha(alpha_scalar: ti.types.ndarray()):
    alpha_scalar[None] = r_2_scalar[None] / (dot_ans[None] + epsilon)


@ti.kernel
def update_beta_r_2(beta_scalar: ti.types.ndarray()):
    beta_scalar[None] = dot_ans[None] / (r_2_scalar[None] + epsilon)
    r_2_scalar[None] = dot_ans[None]


def cg(it):
    get_force(x, f, vertices, gravity[0], gravity[1], gravity[2])
    get_b(v, b, f)
    matmul_edge(mul_ans, v, edges)
    matmul_edge(mul_ans, v, edges)
    add(r0, b, -1, mul_ans)

    ndarray_to_ndarray(p0, r0)
    dot2scalar(r0, r0)
    init_r_2()
    CG_ITERS = 10
    for _ in range(CG_ITERS):
        matmul_edge(mul_ans, p0, edges)
        dot2scalar(p0, mul_ans)
        update_alpha(alpha_scalar)
        add_scalar_ndarray(v, v, 1, alpha_scalar, p0)
        add_scalar_ndarray(r0, r0, -1, alpha_scalar, mul_ans)
        dot2scalar(r0, r0)
        update_beta_r_2(beta_scalar)
        add_scalar_ndarray(p0, r0, 1, beta_scalar, p0)
    fill_ndarray(f, 0)
    add(x, x, dt, v)


@ti.kernel
def advect():
    for p in x:
        v[p] += dt * (f[p] / m[p])
        x[p] += dt * v[p]
        f[p] = ti.Vector([0, 0, 0])


@ti.kernel
def init(x: ti.types.ndarray(), v: ti.types.ndarray(), f: ti.types.ndarray(),
         ox: ti.types.ndarray(), vertices: ti.types.ndarray()):
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
def floor_bound(x: ti.types.ndarray(), v: ti.types.ndarray()):
    for u in x:
        for i in ti.static(range(3)):
            if x[u][i] < -1:
                x[u][i] = -1
                if v[u][i] < 0:
                    v[u][i] = 0
            if x[u][i] > 1:
                x[u][i] = 1
                if v[u][i] > 0:
                    v[u][i] = 0


def substep():
    for i in range(num_substeps):
        cg(i)
    floor_bound(x, v)


def run_aot():
    cwd = os.getcwd()
    if cwd != SCRIPT_PATH:
        raise RuntimeError(
            f'AOT must be done in the script path {SCRIPT_PATH}')
    dir_name = os.path.join('..', 'shaders', 'aot', 'implicit_fem')
    shutil.rmtree(dir_name, ignore_errors=True)
    pathlib.Path(dir_name).mkdir(parents=True, exist_ok=False)

    mod = ti.aot.Module(ti.vulkan)
    mod.add_kernel(get_force,
                   template_args={
                       'x': x,
                       'f': f,
                       'vertices': vertices
                   })
    mod.add_kernel(init,
                   template_args={
                       'x': x,
                       'v': v,
                       'f': f,
                       'ox': ox,
                       'vertices': vertices
                   })
    mod.add_kernel(floor_bound, template_args={'x': x, 'v': v})
    mod.add_kernel(get_matrix,
                   template_args={
                       'c2e': c2e,
                       'vertices': vertices
                   })
    mod.add_kernel(matmul_edge,
                   template_args={
                       'ret': mul_ans,
                       'vel': x,
                       'edges': edges
                   })
    mod.add_kernel(add, template_args={'ans': x, 'a': x, 'b': v})
    mod.add_kernel(add_scalar_ndarray,
                   template_args={
                       'ans': x,
                       'a': x,
                       'scalar': alpha_scalar,
                       'b': v
                   })
    mod.add_kernel(dot2scalar, template_args={'a': r0, 'b': r0})
    mod.add_kernel(get_b, template_args={'v': v, 'b': b, 'f': f})
    mod.add_kernel(ndarray_to_ndarray,
                   template_args={
                       'ndarray': p0,
                       'other': r0
                   })
    mod.add_kernel(fill_ndarray, template_args={
        'ndarray': f,
    })
    mod.add_kernel(clear_field)
    mod.add_kernel(init_r_2)
    mod.add_kernel(update_alpha,
                   template_args={
                       'alpha_scalar': alpha_scalar,
                   })
    mod.add_kernel(update_beta_r_2,
                   template_args={
                       'beta_scalar': beta_scalar,
                   })
    mod.save(dir_name, '')
    print('AOT done')


@ti.kernel
def convert_to_field(x: ti.types.ndarray(), y: ti.template()):
    for I in ti.grouped(x):
        y[I] = x[I]


def run_ggui():
    res = (800, 600)
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
            init(x, v, f)
        if window.is_pressed(ti.GUI.ESCAPE):
            break
        handle_interaction(window)

        render()

        window.show()


def generate_data_header_file_for_aot():
    def write_array(x, t, name, f):
        if t is float:
            f.write('float {}'.format(name))
        else:
            f.write('int {}'.format(name))
        if len(x.shape) == 2:
            f.write('[{}][{}] = '.format(x.shape[0], x.shape[1]))
            f.write('{')
            for i in range(x.shape[0]):
                f.write('{')
                for j in range(x.shape[1]):
                    f.write(str(t(x[i, j])) + ',')
                f.write('},')
            f.write('};\n')
        elif len(x.shape) == 1:
            f.write('[{}] = '.format(x.shape[0]))
            f.write('{')
            for i in range(x.shape[0]):
                f.write(str(t(x[i])) + ',')
            f.write('};\n')

    data_header_path = get_rel_path('..', 'include', 'mesh_data.h')
    if os.path.exists(data_header_path):
        os.remove(data_header_path)
    with open(data_header_path, 'w') as f:
        f.write('constexpr int N_VERTS = {};\n'.format(n_verts))
        f.write('constexpr int N_CELLS = {};\n'.format(n_cells))
        f.write('constexpr int N_FACES = {};\n'.format(n_faces))
        f.write('constexpr int N_EDGES = {};\n'.format(n_edges))
        write_array(ox_np, float, 'ox_data', f)
        write_array(vertices_np, int, 'vertices_data', f)
        write_array(indices_np.reshape(-1), int, 'indices_data', f)
        write_array(edges_np, int, 'edges_data', f)
        write_array(c2e_np, int, 'c2e_data', f)


if __name__ == '__main__':
    print(f'dt={dt} num_substeps={num_substeps}')
    if args.aot:
        run_aot()
        generate_data_header_file_for_aot()
    else:
        clear_field()
        init(x, v, f, ox, vertices)
        get_matrix(c2e, vertices)
        run_ggui()
