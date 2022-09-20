#include <fstream>
#include <chrono>
#include "taichi/aot_demo/framework.hpp"
#include "gft/args.hpp"
#include "gft/util.hpp"

struct AppCFG {
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
  } else {
    throw std::runtime_error("unsupported arch");
  }
};

int main(int argc, const char** argv) {
  std::unique_ptr<App> app = create_app();

  initialize(app->app_name(), argc, argv);

  ti::aot_demo::F = ti::aot_demo::Framework(CFG.arch, CFG.debug);
  ti::aot_demo::Framework& F = ti::aot_demo::F;
  ti::Runtime& runtime = F.runtime();
  ti::aot_demo::Renderer& renderer = F.renderer();

  app->initialize();

  uint32_t width = renderer.width();
  uint32_t height = renderer.height();
  ti::NdArray<uint8_t> framebuffer =
    runtime.allocate_ndarray<uint8_t>({width, height}, {4}, true);

  auto tic0 = std::chrono::steady_clock::now();
  auto tic = std::chrono::steady_clock::now();
  for (uint32_t i = 0; i < CFG.frame_count; ++i) {
    auto toc = std::chrono::steady_clock::now();
    double t = std::chrono::duration<double>(toc - tic0).count();
    double dt = std::chrono::duration<double>(toc - tic).count();
    tic = toc;

    if (!app->update(t, dt)) {
      renderer.next_frame();
      break;
    }

    renderer.begin_frame();
    app->render();
    renderer.end_frame();
    renderer.present_to_ndarray(framebuffer);

    std::string index = std::to_string(i);
    std::string zero_padding(4 - index.size(), '0');
    std::string path = CFG.output_prefix + zero_padding + std::to_string(i) + ".bmp";
    liong::util::save_bmp((const uint32_t*)framebuffer.map(), width, height, path.c_str());
    framebuffer.unmap();

    renderer.next_frame();
  }

  return 0;
}
