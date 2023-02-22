#include <iostream>
#include <chrono>
#include "taichi/aot_demo/framework.hpp"
#include "gft/args.hpp"
#include "gft/util.hpp"

static_assert(TI_AOT_DEMO_GLFW, "glfw must be provided");

struct Config {
  TiArch arch = TI_ARCH_VULKAN;
  bool debug = false;
} CFG;

void initialize(const char* app_name, int argc, const char** argv) {
  namespace args = liong::args;
  std::string arch_lit = "vulkan";

  args::init_arg_parse(app_name, "One of the Taichi AOT demos.");
  args::reg_arg<args::StringParser>("", "--arch", arch_lit,
    "Arch of Taichi runtime.");
  args::reg_arg<args::SwitchParser>("", "--debug", CFG.debug,
    "Enable Vulkan validation layers.");

  args::parse_args(argc, argv);

  if (arch_lit == "vulkan") {
    CFG.arch = TI_ARCH_VULKAN;
  } else if(arch_lit == "x64") {
    CFG.arch = TI_ARCH_X64;
  } else if(arch_lit == "cuda") {
    CFG.arch = TI_ARCH_CUDA;
  } else if(arch_lit == "opengl") {
    CFG.arch = TI_ARCH_OPENGL;
  } else {
    throw std::runtime_error("unsupported arch");
  }
};

std::unique_ptr<ti::aot_demo::AssetManager> create_asset_manager() {
  return std::unique_ptr<ti::aot_demo::AssetManager>(new ti::aot_demo::CwdAssetManager);
}

namespace {

void glfw_error_callback(int code, const char *description) {
  std::cout << "glfw error " << code << ": " << description << std::endl;
  glfwTerminate();
  std::abort();
}

GLFWwindow* create_glfw_window(const AppConfig& app_cfg, const ti::aot_demo::Renderer& renderer) {
  GLFWwindow *glfw_window = nullptr;

  if (glfwInit() != GLFW_TRUE) {
    std::cout << "glfw cannot initialize" << std::endl;
    glfwTerminate();
    std::abort();
  }

  glfwInitVulkanLoader(renderer.loader());
  glfwSetErrorCallback(glfw_error_callback);

  if (glfwVulkanSupported() != GLFW_TRUE) {
      std::cout << "glfw doesn't support vulkan" << std::endl;
      glfwTerminate();
      std::abort();
  }

  glfwWindowHint(GLFW_VISIBLE, GLFW_TRUE);
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  glfwWindowHint(GLFW_SCALE_TO_MONITOR, GLFW_TRUE);
  glfw_window = glfwCreateWindow(
    app_cfg.framebuffer_width,
    app_cfg.framebuffer_height,
    app_cfg.app_name, nullptr, nullptr);

  glfwShowWindow(glfw_window);
  return glfw_window;
}

}

int main(int argc, const char** argv) {
// FIXME: (penguinliong) @jim19930609 Maybe setting this var in scripts can be
// a better option.
#if !defined(_WIN32) && defined(TI_LIB_DIR)
  // This is for CUDA/CPU AOT only
  // TI_LIB_DIR set by cmake
  std::string ti_lib_dir = (TI_LIB_DIR);
  setenv("TI_LIB_DIR", ti_lib_dir.c_str(), 1/*overwrite*/);
#endif
  
  std::unique_ptr<App> app = create_app();
  const AppConfig app_cfg = app->cfg();

  initialize(app_cfg.app_name, argc, argv);

  auto F = std::make_shared<ti::aot_demo::Framework>(app_cfg, CFG.debug);
  app->set_framework(F);
  
  ti::aot_demo::GraphicsRuntime& runtime = F->runtime();
  ti::aot_demo::Renderer& renderer = F->renderer();

  app->initialize(CFG.arch);

  GLFWwindow* glfw_window = create_glfw_window(app_cfg, renderer);
  renderer.set_surface_window(glfw_window);

  while (!glfwWindowShouldClose(glfw_window)) {
    if (!app->update()) {
      F->next_frame();
      glfwSetWindowShouldClose(glfw_window, GLFW_TRUE);
      continue;
    }

    renderer.begin_render();
    app->render();
    renderer.end_render();

    renderer.present_to_surface();

    glfwPollEvents();
    F->next_frame();
  }

  glfwDestroyWindow(glfw_window);

  glfwTerminate();
  return 0;
}
