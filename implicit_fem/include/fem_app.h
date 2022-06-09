#pragma once

#include <taichi/runtime/gfx/aot_module_loader_impl.h>
#include <taichi/backends/vulkan/vulkan_common.h>
#include <taichi/backends/vulkan/vulkan_loader.h>
#include <taichi/backends/vulkan/vulkan_program.h>
#include <taichi/gui/gui.h>
#include <taichi/inc/constants.h>
#include <taichi/ui/backends/vulkan/renderer.h>

#include <memory>
#include <vector>

#include "box_color_data.h"
#include "mesh_data.h"

constexpr float DT = 7.5e-3;
constexpr int NUM_SUBSTEPS = 2;
constexpr int CG_ITERS = 8;
constexpr float ASPECT_RATIO = 2.0f;

void load_data(taichi::lang::gfx::GfxRuntime* vulkan_runtime,
               taichi::lang::DeviceAllocation& alloc, const void* data,
               size_t size) {
  char* const device_arr_ptr =
      reinterpret_cast<char*>(vulkan_runtime->get_ti_device()->map(alloc));
  std::memcpy(device_arr_ptr, data, size);
  vulkan_runtime->get_ti_device()->unmap(alloc);
}

struct ColorVertex {
  glm::vec3 pos;
  glm::vec3 color;
};

void build_wall(int face, std::vector<ColorVertex>& vertices,
                std::vector<int>& indices, glm::vec3 axis_x, glm::vec3 axis_y,
                glm::vec3 base) {
  int base_vertex = int(vertices.size());

  for (int j = 0; j < 32; j++) {
    for (int i = 0; i < 32; i++) {
      glm::vec3 pos = base + axis_x * ((float(i) / 31.0f) * 2.0f - 1.0f) +
                      axis_y * ((float(j) / 31.0f) * 2.0f - 1.0f);
      pos.y *= ASPECT_RATIO;
      vertices.push_back(ColorVertex{pos, box_color_data[face][i + j * 32]});
    }
  }

  for (int j = 0; j < 31; j++) {
    for (int i = 0; i < 31; i++) {
      int i00 = base_vertex + (i + j * 32);
      int i01 = base_vertex + (i + (j + 1) * 32);
      int i10 = base_vertex + ((i + 1) + j * 32);
      int i11 = base_vertex + ((i + 1) + (j + 1) * 32);

      indices.push_back(i00);
      indices.push_back(i01);
      indices.push_back(i10);

      indices.push_back(i01);
      indices.push_back(i10);
      indices.push_back(i11);
    }
  }
}

class FemApp {
 public:
  void run_init(int width, int height, std::string path_prefix,
                taichi::ui::TaichiWindow* window) {
    using namespace taichi::lang;
    width_ = width;
    height_ = height;

#ifdef ANDROID
    const std::vector<std::string> extensions = {
        VK_KHR_SURFACE_EXTENSION_NAME,
        VK_KHR_ANDROID_SURFACE_EXTENSION_NAME,
        VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME,
    };
#else
    std::vector<std::string> extensions = {
        VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME,
        VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
    };

    uint32_t glfw_ext_count = 0;
    const char** glfw_extensions;
    glfw_extensions = glfwGetRequiredInstanceExtensions(&glfw_ext_count);

    for (int i = 0; i < glfw_ext_count; ++i) {
      extensions.push_back(glfw_extensions[i]);
    }
#endif  // ANDROID
    // Create a Vulkan Device
    taichi::lang::vulkan::VulkanDeviceCreator::Params evd_params;
    evd_params.api_version = VK_API_VERSION_1_2;
    evd_params.additional_instance_extensions = extensions;
    evd_params.additional_device_extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};
    evd_params.is_for_ui = false;
    evd_params.surface_creator = nullptr;

    embedded_device_ =
        std::make_unique<taichi::lang::vulkan::VulkanDeviceCreator>(evd_params);

    device_ = static_cast<taichi::lang::vulkan::VulkanDevice*>(
        embedded_device_->device());

    {
      taichi::lang::SurfaceConfig config;
      config.vsync = true;
      config.window_handle = window;
      config.width = width_;
      config.height = height_;
      surface_ = device_->create_surface(config);
    }

    {
      taichi::lang::ImageParams params;
      params.dimension = ImageDimension::d2D;
      params.format = BufferFormat::depth32f;
      params.initial_layout = ImageLayout::undefined;
      params.x = width_;
      params.y = height_;
      params.export_sharing = false;

      depth_allocation_ = device_->create_image(params);
    }

    // Initialize our Vulkan Program pipeline
    host_result_buffer_.resize(taichi_result_buffer_entries);
    taichi::lang::gfx::GfxRuntime::Params params;
    params.host_result_buffer = host_result_buffer_.data();
    params.device = embedded_device_->device();
    vulkan_runtime_ =
        std::make_unique<taichi::lang::gfx::GfxRuntime>(std::move(params));

    std::string shader_source = path_prefix + "/shaders/aot/implicit_fem";
    taichi::lang::gfx::AotModuleParams aot_params{shader_source,
                                                     vulkan_runtime_.get()};
    module_ = taichi::lang::aot::Module::load(taichi::Arch::vulkan, aot_params);
    auto root_size = module_->get_root_size();
    // printf("root buffer size=%ld\n", root_size);
    vulkan_runtime_->add_root_buffer(root_size);

    loaded_kernels_.get_force_kernel = module_->get_kernel("get_force");
    loaded_kernels_.init_kernel = module_->get_kernel("init");
    loaded_kernels_.floor_bound_kernel = module_->get_kernel("floor_bound");
    loaded_kernels_.get_matrix_kernel = module_->get_kernel("get_matrix");
    loaded_kernels_.matmul_edge_kernel = module_->get_kernel("matmul_edge");
    loaded_kernels_.add_kernel = module_->get_kernel("add");
    loaded_kernels_.add_scalar_ndarray_kernel =
        module_->get_kernel("add_scalar_ndarray");
    loaded_kernels_.dot2scalar_kernel = module_->get_kernel("dot2scalar");
    loaded_kernels_.get_b_kernel = module_->get_kernel("get_b");
    loaded_kernels_.ndarray_to_ndarray_kernel =
        module_->get_kernel("ndarray_to_ndarray");
    loaded_kernels_.fill_ndarray_kernel = module_->get_kernel("fill_ndarray");
    loaded_kernels_.clear_field_kernel = module_->get_kernel("clear_field");
    loaded_kernels_.init_r_2_kernel = module_->get_kernel("init_r_2");
    loaded_kernels_.update_alpha_kernel = module_->get_kernel("update_alpha");
    loaded_kernels_.update_beta_r_2_kernel =
        module_->get_kernel("update_beta_r_2");

    // Prepare Ndarray for model
    taichi::lang::Device::AllocParams alloc_params;
    alloc_params.host_write = true;
    // x
    alloc_params.size = N_VERTS * 3 * sizeof(float);
    alloc_params.usage =
        taichi::lang::AllocUsage::Vertex | taichi::lang::AllocUsage::Storage;
    devalloc_x_ = device_->allocate_memory(alloc_params);
    alloc_params.usage = taichi::lang::AllocUsage::Storage;
    // v
    devalloc_v_ = device_->allocate_memory(alloc_params);
    // f
    devalloc_f_ = device_->allocate_memory(alloc_params);
    // mul_ans
    devalloc_mul_ans_ = device_->allocate_memory(alloc_params);
    // c2e
    alloc_params.size = N_CELLS * 6 * sizeof(int);
    devalloc_c2e_ = device_->allocate_memory(alloc_params);
    // b
    alloc_params.size = N_VERTS * 3 * sizeof(float);
    devalloc_b_ = device_->allocate_memory(alloc_params);
    // r0
    devalloc_r0_ = device_->allocate_memory(alloc_params);
    // p0
    devalloc_p0_ = device_->allocate_memory(alloc_params);
    // indices
    alloc_params.size = N_FACES * 3 * sizeof(int);
    alloc_params.usage = taichi::lang::AllocUsage::Index;
    devalloc_indices_ = device_->allocate_memory(alloc_params);
    alloc_params.usage = taichi::lang::AllocUsage::Storage;
    // vertices
    alloc_params.size = N_CELLS * 4 * sizeof(int);
    devalloc_vertices_ = device_->allocate_memory(alloc_params);
    // edges
    alloc_params.size = N_EDGES * 2 * sizeof(int);
    devalloc_edges_ = device_->allocate_memory(alloc_params);
    // ox
    alloc_params.size = N_VERTS * 3 * sizeof(float);
    devalloc_ox_ = device_->allocate_memory(alloc_params);

    alloc_params.size = sizeof(float);
    devalloc_alpha_scalar_ = device_->allocate_memory(alloc_params);
    devalloc_beta_scalar_ = device_->allocate_memory(alloc_params);

    load_data(vulkan_runtime_.get(), devalloc_indices_, indices_data,
              sizeof(indices_data));
    load_data(vulkan_runtime_.get(), devalloc_c2e_, c2e_data, sizeof(c2e_data));
    load_data(vulkan_runtime_.get(), devalloc_vertices_, vertices_data,
              sizeof(vertices_data));
    load_data(vulkan_runtime_.get(), devalloc_ox_, ox_data, sizeof(ox_data));
    load_data(vulkan_runtime_.get(), devalloc_edges_, edges_data,
              sizeof(edges_data));

    memset(&host_ctx_, 0, sizeof(taichi::lang::RuntimeContext));
    host_ctx_.result_buffer = host_result_buffer_.data();
    loaded_kernels_.clear_field_kernel->launch(&host_ctx_);

    host_ctx_.set_arg_devalloc(0, devalloc_x_, {N_VERTS}, {3, 1});
    host_ctx_.set_arg_devalloc(1, devalloc_v_, {N_VERTS}, {3, 1});
    host_ctx_.set_arg_devalloc(2, devalloc_f_, {N_VERTS}, {3, 1});
    host_ctx_.set_arg_devalloc(3, devalloc_ox_, {N_VERTS}, {3, 1});
    host_ctx_.set_arg_devalloc(4, devalloc_vertices_, {N_CELLS}, {4, 1});
    // init(x, v, f, ox, vertices)
    loaded_kernels_.init_kernel->launch(&host_ctx_);
    // get_matrix(c2e, vertices)
    host_ctx_.set_arg_devalloc(0, devalloc_c2e_, {N_CELLS}, {6, 1});
    host_ctx_.set_arg_devalloc(1, devalloc_vertices_, {N_CELLS}, {4, 1});
    loaded_kernels_.get_matrix_kernel->launch(&host_ctx_);
    vulkan_runtime_->synchronize();

    {
      build_wall(0, cornell_box_vertices_, cornell_box_indicies_,
                 glm::vec3(0.0, 1.0, 0.0), glm::vec3(0.0, 0.0, 1.0),
                 glm::vec3(-1.0, 0.0, 0.0));
      build_wall(1, cornell_box_vertices_, cornell_box_indicies_,
                 glm::vec3(0.0, 1.0, 0.0), glm::vec3(0.0, 0.0, 1.0),
                 glm::vec3(1.0, 0.0, 0.0));
      build_wall(2, cornell_box_vertices_, cornell_box_indicies_,
                 glm::vec3(0.0, 0.0, 1.0), glm::vec3(1.0, 0.0, 0.0),
                 glm::vec3(0.0, 1.0, 0.0));
      build_wall(3, cornell_box_vertices_, cornell_box_indicies_,
                 glm::vec3(0.0, 0.0, 1.0), glm::vec3(1.0, 0.0, 0.0),
                 glm::vec3(0.0, -1.0, 0.0));
      build_wall(4, cornell_box_vertices_, cornell_box_indicies_,
                 glm::vec3(0.0, 1.0, 0.0), glm::vec3(1.0, 0.0, 0.0),
                 glm::vec3(0.0, 0.0, -1.0));
    }

    {
      auto vert_code =
          taichi::ui::read_file(path_prefix + "/shaders/render/box.vert.spv");
      auto frag_code =
          taichi::ui::read_file(path_prefix + "/shaders/render/box.frag.spv");

      std::vector<PipelineSourceDesc> source(2);
      source[0] = {PipelineSourceType::spirv_binary, frag_code.data(),
                   frag_code.size(), PipelineStageType::fragment};
      source[1] = {PipelineSourceType::spirv_binary, vert_code.data(),
                   vert_code.size(), PipelineStageType::vertex};

      RasterParams raster_params;
      raster_params.prim_topology = TopologyType::Triangles;
      raster_params.polygon_mode = PolygonMode::Fill;
      raster_params.depth_test = true;
      raster_params.depth_write = true;

      std::vector<VertexInputBinding> vertex_inputs = {
          {/*binding=*/0, /*stride=*/6 * sizeof(float), /*instance=*/false}};
      std::vector<VertexInputAttribute> vertex_attribs;
      vertex_attribs.push_back({/*location=*/0, /*binding=*/0,
                                /*format=*/BufferFormat::rgb32f,
                                /*offset=*/0});
      vertex_attribs.push_back({/*location=*/1, /*binding=*/0,
                                /*format=*/BufferFormat::rgb32f,
                                /*offset=*/3 * sizeof(float)});

      render_box_pipeline_ = device_->create_raster_pipeline(
          source, raster_params, vertex_inputs, vertex_attribs);

      alloc_params = Device::AllocParams{};
      alloc_params.host_write = true;
      // x
      alloc_params.size = sizeof(ColorVertex) * cornell_box_vertices_.size();
      alloc_params.usage = taichi::lang::AllocUsage::Vertex;
      devalloc_box_verts_ = device_->allocate_memory(alloc_params);
      alloc_params.size = sizeof(int) * cornell_box_indicies_.size();
      alloc_params.usage = taichi::lang::AllocUsage::Index;
      devalloc_box_indices_ = device_->allocate_memory(alloc_params);
      load_data(vulkan_runtime_.get(), devalloc_box_verts_,
                cornell_box_vertices_.data(),
                sizeof(ColorVertex) * cornell_box_vertices_.size());
      load_data(vulkan_runtime_.get(), devalloc_box_indices_,
                cornell_box_indicies_.data(),
                sizeof(int) * cornell_box_indicies_.size());
    }
    {
      auto vert_code = taichi::ui::read_file(
          path_prefix + "/shaders/render/surface.vert.spv");
      auto frag_code = taichi::ui::read_file(
          path_prefix + "/shaders/render/surface.frag.spv");

      std::vector<PipelineSourceDesc> source(2);
      source[0] = {PipelineSourceType::spirv_binary, frag_code.data(),
                   frag_code.size(), PipelineStageType::fragment};
      source[1] = {PipelineSourceType::spirv_binary, vert_code.data(),
                   vert_code.size(), PipelineStageType::vertex};

      RasterParams raster_params;
      raster_params.prim_topology = TopologyType::Triangles;
      raster_params.depth_test = true;
      raster_params.depth_write = true;

      std::vector<VertexInputBinding> vertex_inputs = {
          {/*binding=*/0, /*stride=*/3 * sizeof(float), /*instance=*/false}};
      std::vector<VertexInputAttribute> vertex_attribs;
      vertex_attribs.push_back({/*location=*/0, /*binding=*/0,
                                /*format=*/BufferFormat::rgb32f,
                                /*offset=*/0});

      render_mesh_pipeline_ = device_->create_raster_pipeline(
          source, raster_params, vertex_inputs, vertex_attribs);
    }

    render_constants_ = device_->allocate_memory(
        {sizeof(RenderConstants), true, false, false, AllocUsage::Uniform});
  }

  void run_render_loop(float g_x = 0, float g_y = -9.8, float g_z = 0) {
    using namespace taichi::lang;
    for (int i = 0; i < NUM_SUBSTEPS; i++) {
      // get_force(x, f, vertices)
      host_ctx_.set_arg_devalloc(0, devalloc_x_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_f_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(2, devalloc_vertices_, {N_CELLS}, {4, 1});
      host_ctx_.set_arg<float>(3, g_x);
      host_ctx_.set_arg<float>(4, g_y);
      host_ctx_.set_arg<float>(5, g_z);
      loaded_kernels_.get_force_kernel->launch(&host_ctx_);
      // get_b(v, b, f)
      host_ctx_.set_arg_devalloc(0, devalloc_v_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_b_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(2, devalloc_f_, {N_VERTS}, {3, 1});
      loaded_kernels_.get_b_kernel->launch(&host_ctx_);

      // matmul_edge(mul_ans, v, edges)
      host_ctx_.set_arg_devalloc(0, devalloc_mul_ans_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_v_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(2, devalloc_edges_, {N_EDGES}, {2, 1});
      loaded_kernels_.matmul_edge_kernel->launch(&host_ctx_);
      // add(r0, b, -1, mul_ans)
      host_ctx_.set_arg_devalloc(0, devalloc_r0_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_b_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg<float>(2, -1.0f);
      host_ctx_.set_arg_devalloc(3, devalloc_mul_ans_, {N_VERTS}, {3, 1});
      loaded_kernels_.add_kernel->launch(&host_ctx_);
      // ndarray_to_ndarray(p0, r0)
      host_ctx_.set_arg_devalloc(0, devalloc_p0_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_r0_, {N_VERTS}, {3, 1});
      loaded_kernels_.ndarray_to_ndarray_kernel->launch(&host_ctx_);
      // dot2scalar(r0, r0)
      host_ctx_.set_arg_devalloc(0, devalloc_r0_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_r0_, {N_VERTS}, {3, 1});
      loaded_kernels_.dot2scalar_kernel->launch(&host_ctx_);
      // init_r_2()
      loaded_kernels_.init_r_2_kernel->launch(&host_ctx_);

      for (int i = 0; i < CG_ITERS; i++) {
        // matmul_edge(mul_ans, p0, edges);
        host_ctx_.set_arg_devalloc(0, devalloc_mul_ans_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_p0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(2, devalloc_edges_, {N_EDGES}, {2, 1});
        loaded_kernels_.matmul_edge_kernel->launch(&host_ctx_);
        // dot2scalar(p0, mul_ans)
        host_ctx_.set_arg_devalloc(0, devalloc_p0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_mul_ans_, {N_VERTS}, {3, 1});
        loaded_kernels_.dot2scalar_kernel->launch(&host_ctx_);
        host_ctx_.set_arg_devalloc(0, devalloc_alpha_scalar_, {1});
        loaded_kernels_.update_alpha_kernel->launch(&host_ctx_);
        // add(v, v, alpha, p0)
        host_ctx_.set_arg_devalloc(0, devalloc_v_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_v_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg<float>(2, 1.0f);
        host_ctx_.set_arg_devalloc(3, devalloc_alpha_scalar_, {1});
        host_ctx_.set_arg_devalloc(4, devalloc_p0_, {N_VERTS}, {3, 1});
        loaded_kernels_.add_scalar_ndarray_kernel->launch(&host_ctx_);
        // add(r0, r0, -alpha, mul_ans)
        host_ctx_.set_arg_devalloc(0, devalloc_r0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_r0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg<float>(2, -1.0f);
        host_ctx_.set_arg_devalloc(3, devalloc_alpha_scalar_, {1});
        host_ctx_.set_arg_devalloc(4, devalloc_mul_ans_, {N_VERTS}, {3, 1});
        loaded_kernels_.add_scalar_ndarray_kernel->launch(&host_ctx_);

        // r_2_new = dot(r0, r0)
        host_ctx_.set_arg_devalloc(0, devalloc_r0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_r0_, {N_VERTS}, {3, 1});
        loaded_kernels_.dot2scalar_kernel->launch(&host_ctx_);

        host_ctx_.set_arg_devalloc(0, devalloc_beta_scalar_, {1});
        loaded_kernels_.update_beta_r_2_kernel->launch(&host_ctx_);

        // add(p0, r0, beta, p0)
        host_ctx_.set_arg_devalloc(0, devalloc_p0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg_devalloc(1, devalloc_r0_, {N_VERTS}, {3, 1});
        host_ctx_.set_arg<float>(2, 1.0f);
        host_ctx_.set_arg_devalloc(3, devalloc_beta_scalar_, {1});
        host_ctx_.set_arg_devalloc(4, devalloc_p0_, {N_VERTS}, {3, 1});
        loaded_kernels_.add_scalar_ndarray_kernel->launch(&host_ctx_);
      }

      // fill_ndarray(f, 0)
      host_ctx_.set_arg_devalloc(0, devalloc_f_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg<float>(1, 0);
      loaded_kernels_.fill_ndarray_kernel->launch(&host_ctx_);

      // add(x, x, dt, v)
      host_ctx_.set_arg_devalloc(0, devalloc_x_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg_devalloc(1, devalloc_x_, {N_VERTS}, {3, 1});
      host_ctx_.set_arg<float>(2, DT);
      host_ctx_.set_arg_devalloc(3, devalloc_v_, {N_VERTS}, {3, 1});
      loaded_kernels_.add_kernel->launch(&host_ctx_);
    }
    // floor_bound(x, v)
    host_ctx_.set_arg_devalloc(0, devalloc_x_, {N_VERTS}, {3, 1});
    host_ctx_.set_arg_devalloc(1, devalloc_v_, {N_VERTS}, {3, 1});
    loaded_kernels_.floor_bound_kernel->launch(&host_ctx_);
    vulkan_runtime_->synchronize();

    // Render elements
    auto stream = device_->get_graphics_stream();
    auto cmd_list = stream->new_command_list();
    bool color_clear = true;
    std::vector<float> clear_colors = {0.03, 0.05, 0.08, 1};
    auto semaphore = surface_->acquire_next_image();
    auto image = surface_->get_target_image();
    cmd_list->begin_renderpass(
        /*xmin=*/0, /*ymin=*/0, /*xmax=*/width_,
        /*ymax=*/height_, /*num_color_attachments=*/1, &image, &color_clear,
        &clear_colors, &depth_allocation_,
        /*depth_clear=*/true);

    RenderConstants* constants =
        (RenderConstants*)device_->map(render_constants_);
    constants->proj = glm::perspective(
        glm::radians(55.0f), float(width_) / float(height_), 0.1f, 10.0f);
    constants->proj[1][1] *= -1.0f;
#ifdef ANDROID
    constexpr float kCameraZ = 4.85f;
#else
    constexpr float kCameraZ = 4.8f;
#endif
    constants->view = glm::lookAt(glm::vec3(0.0, 0.0, kCameraZ),
                                  glm::vec3(0, 0, 0), glm::vec3(0, 1.0, 0));
    device_->unmap(render_constants_);

    // Draw box
    {
      auto resource_binder = render_box_pipeline_->resource_binder();
      resource_binder->buffer(0, 0, render_constants_.get_ptr(0));
      resource_binder->vertex_buffer(devalloc_box_verts_.get_ptr(0));
      resource_binder->index_buffer(devalloc_box_indices_.get_ptr(0), 32);

      cmd_list->bind_pipeline(render_box_pipeline_.get());
      cmd_list->bind_resources(resource_binder);
      cmd_list->draw_indexed(cornell_box_indicies_.size());
    }
    // Draw mesh
    {
      auto resource_binder = render_mesh_pipeline_->resource_binder();
      resource_binder->buffer(0, 0, render_constants_.get_ptr(0));
      resource_binder->vertex_buffer(devalloc_x_.get_ptr(0));
      resource_binder->index_buffer(devalloc_indices_.get_ptr(0), 32);

      cmd_list->bind_pipeline(render_mesh_pipeline_.get());
      cmd_list->bind_resources(resource_binder);
      cmd_list->draw_indexed(N_FACES * 3);
    }

    cmd_list->end_renderpass();
    stream->submit_synced(cmd_list.get(), {semaphore});

    surface_->present_image();
  }

  void cleanup() {
    device_->dealloc_memory(devalloc_x_);
    device_->dealloc_memory(devalloc_v_);
    device_->dealloc_memory(devalloc_f_);
    device_->dealloc_memory(devalloc_mul_ans_);
    device_->dealloc_memory(devalloc_c2e_);
    device_->dealloc_memory(devalloc_b_);
    device_->dealloc_memory(devalloc_r0_);
    device_->dealloc_memory(devalloc_p0_);
    device_->dealloc_memory(devalloc_indices_);
    device_->dealloc_memory(devalloc_vertices_);
    device_->dealloc_memory(devalloc_edges_);
    device_->dealloc_memory(devalloc_ox_);
    device_->dealloc_memory(devalloc_alpha_scalar_);
    device_->dealloc_memory(devalloc_beta_scalar_);

    device_->dealloc_memory(devalloc_box_indices_);
    device_->dealloc_memory(devalloc_box_verts_);
    device_->dealloc_memory(render_constants_);
    device_->destroy_image(depth_allocation_);
  }

 private:
  struct RenderConstants {
    glm::mat4 proj;
    glm::mat4 view;
  };

  struct ImplicitFemKernels {
    taichi::lang::aot::Kernel* init_kernel{nullptr};
    taichi::lang::aot::Kernel* get_vertices_kernel{nullptr};
    taichi::lang::aot::Kernel* get_indices_kernel{nullptr};
    taichi::lang::aot::Kernel* get_force_kernel{nullptr};
    taichi::lang::aot::Kernel* advect_kernel{nullptr};
    taichi::lang::aot::Kernel* floor_bound_kernel{nullptr};
    taichi::lang::aot::Kernel* get_b_kernel{nullptr};
    taichi::lang::aot::Kernel* matmul_cell_kernel{nullptr};
    taichi::lang::aot::Kernel* ndarray_to_ndarray_kernel{nullptr};
    taichi::lang::aot::Kernel* fill_ndarray_kernel{nullptr};
    taichi::lang::aot::Kernel* add_ndarray_kernel{nullptr};
    taichi::lang::aot::Kernel* dot_kernel{nullptr};
    taichi::lang::aot::Kernel* add_kernel{nullptr};
    taichi::lang::aot::Kernel* update_alpha_kernel{nullptr};
    taichi::lang::aot::Kernel* update_beta_r_2_kernel{nullptr};
    taichi::lang::aot::Kernel* add_scalar_ndarray_kernel{nullptr};
    taichi::lang::aot::Kernel* dot2scalar_kernel{nullptr};
    taichi::lang::aot::Kernel* init_r_2_kernel{nullptr};
    taichi::lang::aot::Kernel* get_matrix_kernel{nullptr};
    taichi::lang::aot::Kernel* clear_field_kernel{nullptr};
    taichi::lang::aot::Kernel* matmul_edge_kernel{nullptr};
  };

  std::vector<uint64_t> host_result_buffer_;
  std::unique_ptr<taichi::lang::vulkan::VulkanDeviceCreator> embedded_device_{
      nullptr};
  taichi::lang::vulkan::VulkanDevice* device_{nullptr};
  std::unique_ptr<taichi::lang::gfx::GfxRuntime> vulkan_runtime_{nullptr};
  std::unique_ptr<taichi::lang::aot::Module> module_{nullptr};
  ImplicitFemKernels loaded_kernels_;
  taichi::lang::RuntimeContext host_ctx_;

  std::vector<ColorVertex> cornell_box_vertices_;
  std::vector<int> cornell_box_indicies_;

  int width_{0};
  int height_{0};

  taichi::lang::DeviceAllocation devalloc_x_;
  taichi::lang::DeviceAllocation devalloc_v_;
  taichi::lang::DeviceAllocation devalloc_f_;
  taichi::lang::DeviceAllocation devalloc_mul_ans_;
  taichi::lang::DeviceAllocation devalloc_c2e_;
  taichi::lang::DeviceAllocation devalloc_b_;
  taichi::lang::DeviceAllocation devalloc_r0_;
  taichi::lang::DeviceAllocation devalloc_p0_;
  taichi::lang::DeviceAllocation devalloc_indices_;
  taichi::lang::DeviceAllocation devalloc_vertices_;
  taichi::lang::DeviceAllocation devalloc_edges_;
  taichi::lang::DeviceAllocation devalloc_ox_;
  taichi::lang::DeviceAllocation devalloc_alpha_scalar_;
  taichi::lang::DeviceAllocation devalloc_beta_scalar_;

  std::unique_ptr<taichi::lang::Surface> surface_{nullptr};
  std::unique_ptr<taichi::lang::Pipeline> render_box_pipeline_{nullptr};
  std::unique_ptr<taichi::lang::Pipeline> render_mesh_pipeline_{nullptr};
  taichi::lang::DeviceAllocation devalloc_box_verts_;
  taichi::lang::DeviceAllocation devalloc_box_indices_;
  taichi::lang::DeviceAllocation depth_allocation_;
  taichi::lang::DeviceAllocation render_constants_;
};
