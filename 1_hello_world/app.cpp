#include <thread>
#include <chrono>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

ti::NdArray<float> ndarray;


void initialize() {

}
bool step(double t, double dt) {
  std::this_thread::sleep_for(std::chrono::seconds(1));
  return true;
}

} // namespace aot_demo
} // namespace ti
