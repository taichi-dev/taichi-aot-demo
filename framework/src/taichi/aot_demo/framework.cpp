#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

Framework F;

Framework::Framework(TiArch arch, bool debug) {
  renderer_ = std::make_unique<Renderer>(debug);
  if (arch == renderer_->arch()) {
    runtime_ = ti::Runtime(renderer_->runtime(), false);
  } else {
    runtime_ = ti::Runtime(arch);
  }
}

} // namespace aot_demo
} // namespace ti