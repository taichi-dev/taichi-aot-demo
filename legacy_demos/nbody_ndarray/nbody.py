import taichi as ti

ti.init(use_gles=True, arch=ti.opengl, allow_nv_shader_extension=False)

# gravitational constant 6.67408e-11, using 1 for simplicity
G = 1
PI = 3.141592653

# number of planets
N = 1000
# unit mass
m = 5
# galaxy size
galaxy_size = 0.4
# planet radius (for rendering)
planet_radius = 1
# init vel
init_vel = 120

# time-step size
h = 1e-5
# substepping
substepping = 10

# pos, vel and force of the planets
# Nx2 vectors
#pos = ti.Vector.field(2, ti.f32, N)
#vel = ti.Vector.field(2, ti.f32, N)
#force = ti.Vector.field(2, ti.f32, N)

@ti.kernel
def initialize(pos: ti.any_arr(element_dim=1), vel: ti.any_arr(element_dim=1)):
    center=ti.Vector([0.5, 0.5])
    for i in pos:
        theta = ti.random() * 2 * PI
        r = (ti.sqrt(ti.random()) * 0.7 + 0.3) * galaxy_size
        offset = r * ti.Vector([ti.cos(theta), ti.sin(theta)])
        pos[i] = center+offset
        vel[i] = [-offset.y, offset.x]
        vel[i] *= init_vel

@ti.kernel
def compute_force(pos: ti.any_arr(element_dim=1), vel: ti.any_arr(element_dim=1), force: ti.any_arr(element_dim=1)):

    # clear force
    for i in pos:
        force[i] = ti.Vector([0.0, 0.0])

    # compute gravitational force
    for i in pos:
        p = pos[i]
        #for j in range(i): # bad memory footprint and load balance, but better CPU performance
        #    diff = p-pos[j]
        #    r = diff.norm(1e-5)

        #    # gravitational force -(GMm / r^2) * (diff/r) for i
        #    f = -G * m * m * (1.0/r)**3 * diff

        #    # assign to each particle
        #    force[i] += f
        #    force[j] += -f
        for j in pos:# double the computation for a better memory footprint and load balance
            if i != j:
                diff = p-pos[j]
                r = diff.norm(1e-5)

                # gravitational force -(GMm / r^2) * (diff/r) for i
                f = -G * m * m * (1.0/r)**3 * diff

                # assign to each particle
                force[i] += f
    dt = h/substepping
    for i in pos:
        #symplectic euler
        vel[i].atomic_add(dt*force[i]/m)
        pos[i].atomic_add(dt*vel[i])

pos = ti.Vector.ndarray(2, ti.f32, N)
vel = ti.Vector.ndarray(2, ti.f32, N)
force = ti.Vector.ndarray(2, ti.f32, N)

gui = ti.GUI('N-body problem', (512, 512))


def run():
    initialize(pos, vel)
    while gui.running:

        for i in range(substepping):
            compute_force(pos, vel, force)

        gui.clear(0x112F41)
        gui.circles(pos.to_numpy(), color=0xffffff, radius=planet_radius)
        gui.show()

def aot():
    m = ti.aot.Module(ti.opengl)
    m.add_kernel(initialize, (pos, vel))
    m.add_kernel(compute_force, (pos, vel, force))

    dir_name = 'nbody_aot'
    m.save(dir_name)
    #with open(os.path.join(dir_name, 'metadata.json')) as json_file:
    #    json.load(json_file)

#aot()
run()
