#include <thread>
#include <chrono>
#include <iostream>
#include "glm/glm.hpp"
#include "glm/ext.hpp"
#include "taichi/aot_demo/framework.hpp"

using namespace ti::aot_demo;

struct App3_implicit_fem : public App {
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t GRID_SIZE = 128;

  ti::AotModule module_;
  ti::ComputeGraph g_init_;
  ti::ComputeGraph g_substep_;

  ti::NdArray<float> hes_edge_;
  ti::NdArray<float> hes_vert_;
  ti::NdArray<float> x_;
  ti::NdArray<float> v_;
  ti::NdArray<float> f_;
  ti::NdArray<float> mul_ans_;
  ti::NdArray<int32_t> c2e_;
  ti::NdArray<float> b_;
  ti::NdArray<float> r0_;
  ti::NdArray<float> p0_;
  ti::NdArray<uint32_t> indices_;
  ti::NdArray<int32_t> vertices_;
  ti::NdArray<int32_t> edges_;
  ti::NdArray<float> ox_;
  ti::NdArray<float> alpha_scalar_;
  ti::NdArray<float> beta_scalar_;
  ti::NdArray<float> m_;
  ti::NdArray<float> B_;
  ti::NdArray<float> W_;
  ti::NdArray<float> dot_ans_;
  ti::NdArray<float> r_2_scalar_;

  std::unique_ptr<GraphicsTask> draw_mesh;

  virtual AppConfig cfg() const override final {
    AppConfig out {};
    out.app_name = "3_implicit_fem";
    out.framebuffer_width = 256;
    out.framebuffer_height = 256;
    return out;
  }
  virtual void initialize() override final {
    GraphicsRuntime& runtime = F_->runtime();
    Renderer& renderer = F_->renderer();

    module_ = runtime.load_aot_module("3_implicit_fem/assets/implicit_fem");
    g_init_ = module_.get_compute_graph("init");
    g_substep_ = module_.get_compute_graph("substep");

    AssetManager& asset_mgr = F_->asset_mgr();
    std::vector<uint32_t> c2e_data;
    std::vector<uint32_t> edges_data;
    std::vector<glm::uvec3> indices_data;
    std::vector<glm::vec3> ox_data;
    std::vector<uint32_t> vertices_data;
    asset_mgr.load_file_typed<uint32_t>("3_implicit_fem/assets/c2e.bin", c2e_data);
    asset_mgr.load_file_typed<uint32_t>("3_implicit_fem/assets/edges.bin", edges_data);
    asset_mgr.load_file_typed<glm::uvec3>("3_implicit_fem/assets/indices.bin", indices_data);
    asset_mgr.load_file_typed<glm::vec3>("3_implicit_fem/assets/ox.bin", ox_data);
    asset_mgr.load_file_typed<uint32_t>("3_implicit_fem/assets/vertices.bin", vertices_data);

    uint32_t nvert = ox_data.size();
    uint32_t nedge = edges_data.size() / 2;
    uint32_t nface = indices_data.size();
    uint32_t ncell = c2e_data.size() / 6;

    hes_edge_ = runtime.allocate_ndarray<float>({nedge});
    hes_vert_ = runtime.allocate_ndarray<float>({ncell});
    x_ = runtime.allocate_vertex_buffer(nvert, 3, true);
    v_ = runtime.allocate_ndarray<float>({nvert}, {3});
    f_ = runtime.allocate_ndarray<float>({nvert}, {3});
    mul_ans_ = runtime.allocate_ndarray<float>({nvert}, {3});
    c2e_ = runtime.allocate_ndarray<int>({ncell}, {6}, true);
    b_ = runtime.allocate_ndarray<float>({nvert}, {3});
    r0_ = runtime.allocate_ndarray<float>({nvert}, {3});
    p0_ = runtime.allocate_ndarray<float>({nvert}, {3});
    indices_ = runtime.allocate_index_buffer(nface, 3, true);
    vertices_ = runtime.allocate_ndarray<int>({ncell}, {4}, true);
    edges_ = runtime.allocate_ndarray<int>({nedge}, {2}, true);
    ox_ = runtime.allocate_ndarray<float>({nvert}, {3}, true);
    alpha_scalar_ = runtime.allocate_ndarray<float>();
    beta_scalar_ = runtime.allocate_ndarray<float>();
    m_ = runtime.allocate_ndarray<float>({nvert});
    B_ = runtime.allocate_ndarray<float>({ncell}, {3, 3});
    W_ = runtime.allocate_ndarray<float>({ncell});
    dot_ans_ = runtime.allocate_ndarray<float>();
    r_2_scalar_ = runtime.allocate_ndarray<float>();

    c2e_.write(c2e_data);
    edges_.write(edges_data);
    indices_.write(indices_data);
    ox_.write(ox_data);
    vertices_.write(vertices_data);

    glm::mat4 model2world = glm::mat4(1.0f);
    model2world = glm::scale(model2world, glm::vec3(2.0f));
    glm::mat4 camera2view = glm::perspective(glm::radians(45.0f), renderer.width() / (float)renderer.height(), 1e-5f, 1000.0f);
    glm::mat4 world2camera = glm::lookAt(glm::vec3(0, 0, 10), glm::vec3(0, 0, 0), glm::vec3(0, -1, 0));
    glm::mat4 world2view = camera2view * world2camera;

    draw_mesh = runtime.draw_mesh(x_, indices_)
      .model2world(model2world)
      .world2view(world2view)
      .color(glm::vec3(0,0,1))
      .build();

    g_init_["hes_edge"] = hes_edge_;
    g_init_["hes_vert"] = hes_vert_;
    g_init_["x"] = x_;
    g_init_["v"] = v_;
    g_init_["f"] = f_;
    g_init_["ox"] = ox_;
    g_init_["vertices"] = vertices_;
    g_init_["m"] = m_;
    g_init_["B"] = B_;
    g_init_["W"] = W_;
    g_init_["c2e"] = c2e_;
    g_init_.launch();

    const float DT = 7.5e-3f;

    g_substep_["x"] = x_;
    g_substep_["f"] = f_;
    g_substep_["vertices"] = vertices_;
    g_substep_["gravity_x"] = 0.0f;
    g_substep_["gravity_y"] = -9.8f;
    g_substep_["gravity_z"] = 0.0f;
    g_substep_["m"] = m_;
    g_substep_["B"] = B_;
    g_substep_["W"] = W_;
    g_substep_["b"] = b_;
    g_substep_["v"] = v_;
    g_substep_["mul_ans"] = mul_ans_;
    g_substep_["edges"] = edges_;
    g_substep_["hes_edge"] = hes_edge_;
    g_substep_["hes_vert"] = hes_vert_;
    g_substep_["r0"] = r0_;
    g_substep_["p0"] = p0_;
    g_substep_["dot_ans"] = dot_ans_;
    g_substep_["r_2_scalar"] = r_2_scalar_;
    g_substep_["alpha_scalar"] = alpha_scalar_;
    g_substep_["beta_scalar"] = beta_scalar_;
    g_substep_["k0"] = 0.0f;
    g_substep_["k1"] = 1.0f;
    g_substep_["k2"] = -1.0f;
    g_substep_["dt"] = DT;

    renderer.set_framebuffer_size(256, 256);

    std::cout << "initialized!" << std::endl;
  }
  virtual bool update() override final {
    g_substep_.launch();
    std::cout << "stepped! (fps=" << F_->fps() << ")" << std::endl;
    return true;
  }
  virtual void render() override final {
    Renderer& renderer = F_->renderer();
    renderer.enqueue_graphics_task(*draw_mesh);
  }
};

std::unique_ptr<App> create_app() {
  return std::unique_ptr<App>(new App3_implicit_fem);
}
