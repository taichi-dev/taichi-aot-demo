import argparse
import numpy as np
import os

import taichi as ti

parser = argparse.ArgumentParser()
parser.add_argument("--arch", type=str)
parser.add_argument("--aot", action='store_true', default=False)
args = parser.parse_args()

curr_dir = os.path.dirname(os.path.realpath(__file__))

def compile_demo(arch, aot):
    ti.init(arch=arch)

    if ti.lang.impl.current_cfg().arch != arch:
        return

    n_particles = 8192

    @ti.kernel
    def init(x: ti.types.ndarray(field_dim=1)):
        for i in x:
            x[i] = 0

    @ti.kernel
    def add_base(x: ti.types.ndarray(field_dim=1), base: ti.f32):
        for i in range(x.shape[0]):
            x[i] += base


    N_ITER = 50

    x = ti.ndarray(ti.f32, shape=(n_particles))

    if aot:
        mod = ti.aot.Module(arch)
        mod.add_kernel(init, template_args={'x': x})
        mod.add_kernel(add_base, template_args={'x': x})

        save_dir = os.path.join(curr_dir, "tutorial")
        os.makedirs(save_dir, exist_ok=True)
        mod.save(save_dir, '')
        print(f'Save compiled artifact to {save_dir}')
    else:
        print('Running the kernels in Python')
        init(x)
        for _ in range(N_ITER):
            add_base(x, 0.1)
        assert np.allclose(x.to_numpy().sum(), n_particles * N_ITER * 0.1)
        print('Passed verification!')

if __name__ == "__main__":
    assert args.arch == "vulkan"
    compile_demo(arch=ti.vulkan, aot=args.aot)
