import numpy as np
import taichi as ti

ti.init(arch=ti.vulkan)

@ti.kernel
def taichi_add(in_ten: ti.types.ndarray(), out_ten: ti.types.ndarray(), addend: ti.i32):
    for i, j, k in in_ten:
        out_ten[i, j, k] = ti.cast(ti.cast(in_ten[i, j, k], ti.i32) + addend, ti.u8)

in_ten = ti.ndarray(dtype=ti.u8, shape=(320, 320, 4))
out_ten = ti.ndarray(dtype=ti.u8, shape=(320, 320, 4))
in_ten.from_numpy(np.ones((320, 320, 4), dtype=np.uint8))
out_ten.from_numpy(np.ones((320, 320, 4), dtype=np.uint8))
addend = 3

arg_0 = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, "in_ten", dtype=ti.u8, field_dim=3)
arg_1 = ti.graph.Arg(ti.graph.ArgKind.NDARRAY, "out_ten", dtype=ti.u8, field_dim=3)
arg_2 = ti.graph.Arg(ti.graph.ArgKind.SCALAR, "addend", ti.i32)
g = ti.graph.GraphBuilder()
g.dispatch(taichi_add, arg_0, arg_1, arg_2)
g = g.compile()

g.run({"in_ten": in_ten, "out_ten": out_ten, "addend": addend})
print(out_ten.to_numpy())

m = ti.aot.Module(ti.vulkan)
m.add_graph("taichi_add", g)
m.save("models/taichi_aot", "")
