#include <iostream>
#include "taichi/aot_demo/framework.hpp"
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

Framework::Framework(const AppConfig &app_cfg, const EntryPointConfig& entry_point_cfg) {

  RendererConfig config{};
  config.debug = entry_point_cfg.debug;
  config.framebuffer_width = app_cfg.framebuffer_width;
  config.framebuffer_height = app_cfg.framebuffer_height;
  config.client_arch = entry_point_cfg.client_arch;

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
