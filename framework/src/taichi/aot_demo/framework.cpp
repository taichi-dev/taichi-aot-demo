#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

std::string get_arch_name(TiArch arch) {
  switch (arch) {
    case TI_ARCH_VULKAN:
      return "vulkan";
    case TI_ARCH_METAL:
      return "metal";
    case TI_ARCH_CUDA:
      return "cuda";
    case TI_ARCH_X64:
      return "x64";
    case TI_ARCH_ARM64:
      return "arm64";
    case TI_ARCH_OPENGL:
      return "opengl";
    case TI_ARCH_GLES:
      return "gles";
    default:
      assert(false);
      return "<unknown arch " + std::to_string(int(arch)) + ">";
  }
}

Framework::Framework(const AppConfig &app_cfg, const EntryPointConfig& entry_point_cfg) {

  RendererConfig config{};
  config.debug = entry_point_cfg.debug;
  config.framebuffer_width = app_cfg.framebuffer_width;
  config.framebuffer_height = app_cfg.framebuffer_height;
  config.client_arch = entry_point_cfg.client_arch;

  auto it =
      std::find(app_cfg.supported_archs.begin(), app_cfg.supported_archs.end(),
                entry_point_cfg.client_arch);
  if (it == app_cfg.supported_archs.end()) {
    std::cout << get_arch_name(entry_point_cfg.client_arch)
              << " is not a supported arch:";
    for (TiArch arch : app_cfg.supported_archs) {
      std::cout << " " << get_arch_name(arch);
    }
    std::cout << std::endl;
    exit(0);
  }

  renderer_ = std::make_shared<Renderer>(config);
  asset_mgr_ = create_asset_manager();

  frame_ = 0;
  tic0_ = std::chrono::steady_clock::now();
  tic_ = std::chrono::steady_clock::now();
  toc_ = std::chrono::steady_clock::now();
  std::cout << "framework initialized" << std::endl;
}
Framework::~Framework() {
  if (renderer_ != nullptr) {
    asset_mgr_.reset();
    renderer_.reset();

    std::cout << "framework finalized" << std::endl;
  }
}

} // namespace aot_demo
} // namespace ti
