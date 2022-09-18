#include <vector>
#include <map>
#include <memory>
#include "taichi/aot_demo/renderer.hpp"

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
  ti::Runtime runtime_;
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

  ti::NdArray<float> allocate_vertex_buffer(
    uint32_t vertex_component_count,
    uint32_t vertex_count,
    bool host_access = false
  ) const;
  ti::NdArray<uint32_t> allocate_index_buffer(
    uint32_t index_count,
    bool host_access = false
  ) const;

  // Add your drawing functions here.
  std::unique_ptr<GraphicsTask> create_draw_points_task(
    const ti::NdArray<float>& points
  ) const;

  constexpr const ti::Runtime& runtime() const {
    return runtime_;
  }
  constexpr ti::Runtime& runtime() {
    return runtime_;
  }
  constexpr const Renderer& renderer() const {
    return *renderer_;
  }
  constexpr Renderer& renderer() {
    return *renderer_;
  }
};

extern Framework F;

} // namespace renderer
} // namespce ti
