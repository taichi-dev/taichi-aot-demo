import argparse
import os

import taichi as ti

parser = argparse.ArgumentParser()
parser.add_argument("--arch", default="vulkan", type=str)
args = parser.parse_args()

curr_dir = os.path.dirname(os.path.realpath(__file__))

if args.arch == "vulkan":
    arch = ti.vulkan
elif args.arch == "opengl":
    arch = ti.opengl
else:
    assert False
ti.init(arch=arch)

n = 320
canvas = ti.ndarray(dtype=ti.f32, shape=(n * 2, n))


@ti.func
def complex_sqr(z):
    return ti.Vector([z[0]**2 - z[1]**2, z[1] * z[0] * 2])


ti.types.rw_texture(num_dimensions=2,
                                                   fmt=ti.Format.r32f,
                                                   lod=0)

@ti.kernel
def fractal(t: ti.f32, canvas: ti.types.rw_texture(num_dimensions=2,
                                                   fmt=ti.Format.r32f,
                                                   lod=0)):
    for i, j in ti.ndrange(640, 320):  # Parallelized over all pixels
        c = ti.Vector([-0.8, ti.cos(t) * 0.2])
        z = ti.Vector([i / n - 1, j / n - 0.5]) * 2
        iterations = 0
        while z.norm() < 20 and iterations < 50:
            z = complex_sqr(z) + c
            iterations += 1

        color = 1 - iterations * 0.02
        canvas.store(ti.Vector([i, j]), ti.Vector([color, color, color, 1.0]))


sym_t = ti.graph.Arg(ti.graph.ArgKind.SCALAR,
                     "t",
                     ti.f32,
                     element_shape=())
sym_canvas = ti.graph.Arg(ti.graph.ArgKind.RWTEXTURE,
                          'canvas',
                          channel_format=ti.f32,
                          shape=(n * 2, n),
                          num_channels=1)

gb = ti.graph.GraphBuilder()
gb.dispatch(fractal, sym_t, sym_canvas)
graph = gb.compile()

mod = ti.aot.Module(ti.vulkan)
mod.add_graph('fractal', graph)

save_dir = os.path.join(curr_dir, "fractal")
os.makedirs(save_dir, exist_ok=True)
mod.save(save_dir)
print('AOT done')
