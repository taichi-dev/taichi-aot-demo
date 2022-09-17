#include <vector>
#include <map>
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

// What you need to implement:
extern void initialize();
extern bool step(double t, double dt);



// -----------------------------------------------------------------------------


class Framework {
  ti::Runtime runtime_;
  std::unique_ptr<class Renderer> renderer_;
  std::map<std::string, std::unique_ptr<GraphicsTask>> task_cache_;

public:
  Framework() {}
  Framework(TiArch arch, bool debug);
  Framework(const Framework&) = delete;
  Framework(Framework&& b) :
    runtime_(std::move(b.runtime_)), renderer_(std::move(b.renderer_)) {}

  Framework& operator=(Framework&& b) {
    runtime_ = std::move(b.runtime_);
    renderer_ = std::move(b.renderer_);
    return *this;
  }

  // Add your drawing functions here.
  Framework& draw_points(ti::NdArray<float>& points);

  constexpr const ti::Runtime& runtime() const {
    return runtime_;
  }
  constexpr ti::Runtime& runtime() {
    return runtime_;
  }
};

extern Framework F;

} // namespace renderer
} // namespce ti
