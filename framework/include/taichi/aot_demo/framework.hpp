#pragma once
#include <chrono>
#include <taichi/aot_demo/common.hpp>
#include "taichi/aot_demo/renderer.hpp"
#include "taichi/aot_demo/graphics_runtime.hpp"
#include "taichi/aot_demo/asset_manager.hpp"

struct AppConfig {
  const char* app_name = "taichi";
  uint32_t framebuffer_width = 64;
  uint32_t framebuffer_height = 32;
};

// What you need to implement:
struct App {
  virtual ~App() {}

  virtual AppConfig cfg() const = 0;
  virtual void initialize() = 0;
  virtual bool update() = 0;
  virtual void render() = 0;
};

extern std::unique_ptr<App> create_app();


// -----------------------------------------------------------------------------

// This should be implemented in platform entry points.
extern std::unique_ptr<ti::aot_demo::AssetManager> create_asset_manager();

namespace ti {
namespace aot_demo {

class Framework {
  GraphicsRuntime runtime_;
  std::shared_ptr<class Renderer> renderer_;
  std::unique_ptr<AssetManager> asset_mgr_;

  uint32_t frame_;
  std::chrono::steady_clock::time_point tic0_;
  std::chrono::steady_clock::time_point tic_;
  std::chrono::steady_clock::time_point toc_;

public:
  Framework() {}
  Framework(const AppConfig& app_cfg, TiArch arch, bool debug);
  Framework(const Framework&) = delete;
  Framework(Framework&& b) :
    runtime_(std::move(b.runtime_)),
    renderer_(std::move(b.renderer_)),
    asset_mgr_(std::move(b.asset_mgr_)),
    frame_(std::exchange(b.frame_, 0)),
    tic0_(std::move(b.tic0_)),
    tic_(std::move(b.tic_)),
    toc_(std::move(b.toc_)) {}
  ~Framework();

  Framework& operator=(Framework&& b) {
    runtime_ = std::move(b.runtime_);
    renderer_ = std::move(b.renderer_);
    asset_mgr_ = std::move(b.asset_mgr_);
    frame_ = std::exchange(b.frame_, 0);
    tic0_ = std::move(b.tic0_);
    tic_ = std::move(b.tic_);
    toc_ = std::move(b.toc_);
    return *this;
  }

  inline void next_frame() {
    renderer_->next_frame();
    ++frame_;
    tic_ = std::exchange(toc_, std::chrono::steady_clock::now());
  }
  constexpr uint32_t frame() const {
    return frame_;
  }
  constexpr double t() const {
    return std::chrono::duration<double>(toc_ - tic0_).count();
  }
  constexpr double dt() const {
    return std::chrono::duration<double>(toc_ - tic_).count();
  }
  constexpr double fps() const {
    return 1.0 / dt();
  }

  // You usually need this in `initialize`.
  // WARNING: DO NOT load assets yourself in your initialization code because it
  // doesn't guarantee multi-platform compatibility.
  inline AssetManager& asset_mgr() {
    return *asset_mgr_;
  }
  // You usually need this in `initialize` and `update`.
  inline GraphicsRuntime& runtime() {
    return runtime_;
  }
  // You usually need this in `render`.
  inline Renderer& renderer() {
    return *renderer_;
  }
};

extern Framework F;

} // namespace renderer
} // namespce ti
