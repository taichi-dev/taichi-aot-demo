#include <fstream>
#include <chrono>
#include "taichi/aot_demo/framework.hpp"
#include "gft/args.hpp"
#include "gft/util.hpp"

#include <iostream>

struct Config {
  std::string output_prefix = "";
  uint32_t frame_count = 2;
  TiArch arch = TI_ARCH_VULKAN;
  bool debug = false;
} CFG;

void initialize(const char* app_name, int argc, const char** argv) {
  namespace args = liong::args;
  std::string arch_lit = "vulkan";

  args::init_arg_parse(app_name, "One of the Taichi AOT demos.");
  args::reg_arg<args::StringParser>("-o", "--output-prefix", CFG.output_prefix,
    "Prefix of the output BMP files.");
  args::reg_arg<args::UintParser>("-f", "--frames", CFG.frame_count,
    "Number of frames to run, or 0 to run forever.");
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
  } else {
    throw std::runtime_error("unsupported arch");
  }
};

std::unique_ptr<ti::aot_demo::AssetManager> create_asset_manager() {
  return std::unique_ptr<ti::aot_demo::AssetManager>(new ti::aot_demo::CwdAssetManager);
}

void save_framebuffer_to_bmp(const ti::NdArray<uint8_t>& framebuffer, uint32_t i) {
  std::string index = std::to_string(i);
  std::string zero_padding(4 - index.size(), '0');
  std::string path = CFG.output_prefix + zero_padding + std::to_string(i) + ".bmp";
  liong::util::save_bmp((const uint32_t*)framebuffer.map(),
    framebuffer.shape().dims[0],
    framebuffer.shape().dims[1],
    path.c_str());
  framebuffer.unmap();
}

int main(int argc, const char** argv) {
#ifdef TI_LIB_DIR
  // This is for CUDA/CPU AOT only
  // TI_LIB_DIR set by cmake
  std::string ti_lib_dir = (TI_LIB_DIR);
  setenv("TI_LIB_DIR", ti_lib_dir.c_str(), 1/*overwrite*/);
#endif

  std::unique_ptr<App> app = create_app();
  const AppConfig& app_cfg = app->cfg();

  initialize(app_cfg.app_name, argc, argv);

  auto F = std::make_shared<ti::aot_demo::Framework>(app_cfg, CFG.debug);
  app->set_framework(F);
  
  ti::aot_demo::GraphicsRuntime& runtime = F->runtime();
  ti::aot_demo::Renderer& renderer = F->renderer();

  app->initialize(CFG.arch);

  uint32_t width = renderer.width();
  uint32_t height = renderer.height();
  ti::NdArray<uint8_t> framebuffer =
    runtime.allocate_ndarray<uint8_t>({width, height}, {4}, true);

  for (uint32_t i = 0; i < CFG.frame_count; ++i) {
    if (!app->update()) {
      F->next_frame();
      break;
    }

    renderer.begin_render();
    app->render();
    renderer.end_render();

    renderer.present_to_ndarray(framebuffer);
    F->next_frame();

    save_framebuffer_to_bmp(framebuffer, i);
  }
  return 0;
}
