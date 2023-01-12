import argparse
import os

from taichi.examples.patterns import taichi_logo
from taichi.lang.impl import grouped

import taichi as ti

parser = argparse.ArgumentParser()
parser.add_argument("--arch", type=str)
args = parser.parse_args()

def get_save_dir(name, arch):
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    return os.path.join(curr_dir, f"{name}_{arch}")

if args.arch == "cuda":
    arch = ti.cuda
elif args.arch == "x64":
    arch = ti.x64
else:
    assert False

ti.init(arch=arch)

n = 512
img_h = 680
img_w = 680

img = ti.field(dtype=ti.f32, shape=(img_h, img_w))

x = ti.field(dtype=ti.i32)
block1 = ti.root.pointer(ti.ij, n // 64)
block2 = block1.pointer(ti.ij, 4)
block3 = block2.pointer(ti.ij, 4)
block3.dense(ti.ij, 4).place(x)

arr = ti.ndarray(ti.f32, shape=(img_h, img_w))
@ti.kernel
def img_to_ndarray(arr: ti.types.ndarray()):
    for I in grouped(img):
        arr[I] = img[I]


@ti.kernel
def fill_img():
    img.fill(0.05)


@ti.kernel
def block1_deactivate_all():
    for I in ti.grouped(block3):
        ti.deactivate(block3, I)

    for I in ti.grouped(block2):
        ti.deactivate(block2, I)

    for I in ti.grouped(block1):
        ti.deactivate(block1, I)


@ti.kernel
def activate(t: ti.f32):
    for i, j in ti.ndrange(n, n):
        p = ti.Vector([i, j]) / n
        p = ti.math.rotation2d(ti.sin(t)) @ (p - 0.5) + 0.5

        if taichi_logo(p) == 0:
            x[i, j] = 1


@ti.func
def scatter(i):
    return i + i // 4 + i // 16 + i // 64 + 2


@ti.kernel
def paint():
    for i, j in ti.ndrange(n, n):
        t = x[i, j]
        block1_index = ti.rescale_index(x, block1, [i, j])
        block2_index = ti.rescale_index(x, block2, [i, j])
        block3_index = ti.rescale_index(x, block3, [i, j])
        t += ti.is_active(block1, block1_index)
        t += ti.is_active(block2, block2_index)
        t += ti.is_active(block3, block3_index)
        img[scatter(i), scatter(j)] = 1 - t / 4


def save_kernels(arch):
    m = ti.aot.Module(arch)

    m.add_kernel(fill_img, template_args={})
    m.add_kernel(block1_deactivate_all, template_args={})
    m.add_kernel(activate, template_args={})
    m.add_kernel(paint, template_args={})
    m.add_kernel(img_to_ndarray, template_args={'arr': arr})

    m.add_field("x", x)
    m.add_field("img", img)

    save_dir = get_save_dir("taichi_sparse", args.arch)
    os.makedirs(save_dir, exist_ok=True)
    m.save(save_dir)

if __name__ == '__main__':
    save_kernels(arch=arch)
