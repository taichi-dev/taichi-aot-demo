#include <chrono>
#include "taichi/aot_demo/framework.hpp"
#include "gft/args.hpp"

struct AppCFG {
  std::string output_prefix = "";
  uint32_t frame_count = 1;
  TiArch arch = TI_ARCH_VULKAN;
  bool debug = false;
} CFG;

void initialize() {
  namespace args = liong::args;
  std::string arch_lit = "vulkan";

  args::init_arg_parse(ti::aot_demo::app_name, "One of the Taichi AOT demos.");
  args::reg_arg<args::StringParser>("-o", "--output-prefix", CFG.output_prefix,
    "Prefix of the output BMP files.");
  args::reg_arg<args::UintParser>("-f", "--frames", CFG.frame_count,
    "Number of frames to run, or 0 to run forever.");
  args::reg_arg<args::StringParser>("", "--arch", arch_lit,
    "Arch of Taichi runtime.");
  args::reg_arg<args::SwitchParser>("", "--debug", CFG.debug,
    "Enable Vulkan validation layers.");

  if (arch_lit == "vulkan") {
    CFG.arch = TI_ARCH_VULKAN;
  } else {
    throw std::runtime_error("unsupported arch");
  }
};

int main(int argc, const char** argv) {
  initialize();

  ti::aot_demo::F = ti::aot_demo::Framework(CFG.arch, CFG.debug);

  ti::aot_demo::initialize();
  auto tic0 = std::chrono::steady_clock::now();
  auto tic = std::chrono::steady_clock::now();
  for (;;) {
    auto toc = std::chrono::steady_clock::now();
    double t = std::chrono::duration<double>(toc - tic0).count();
    double dt = std::chrono::duration<double>(toc - tic).count();
    tic = toc;
    if (!ti::aot_demo::step(t, dt)) {
      break;
    }
  }

  return 0;
}
