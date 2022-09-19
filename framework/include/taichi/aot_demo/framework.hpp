#pragma once
#include <vector>
#include <map>
#include <memory>
#include "glm/glm.hpp"
#define TI_WITH_VULKAN 1
#include "taichi/cpp/taichi.hpp"
#include "taichi/aot_demo/renderer.hpp"
#include "taichi/aot_demo/graphics_runtime.hpp"

// What you need to implement:
struct App {
  virtual const char* app_name() const = 0;
  virtual void initialize() = 0;
  virtual bool update(double t, double dt) = 0;
  virtual void render() = 0;
};

extern std::unique_ptr<App> create_app();


// -----------------------------------------------------------------------------

namespace ti {
namespace aot_demo {

class Framework {
  GraphicsRuntime runtime_;
  std::shared_ptr<class Renderer> renderer_;
  std::map<std::string, std::unique_ptr<GraphicsTask>> task_cache_;

public:
  Framework() {}
  Framework(TiArch arch, bool debug);
  Framework(const Framework&) = delete;
  Framework(Framework&& b) :
    runtime_(std::move(b.runtime_)), renderer_(std::move(b.renderer_)) {}
  ~Framework();

  Framework& operator=(Framework&& b) {
    runtime_ = std::move(b.runtime_);
    renderer_ = std::move(b.renderer_);
    return *this;
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
