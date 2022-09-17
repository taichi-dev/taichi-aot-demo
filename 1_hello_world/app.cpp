#include <thread>
#include <chrono>
#include <iostream>
#include "taichi/aot_demo/framework.hpp"

namespace ti {
namespace aot_demo {

extern Framework F;

ti::NdArray<float> ndarray;

void initialize() {
  ti::Runtime& runtime = F.runtime();
  ndarray = runtime.allocate_ndarray<float>({5}, {});

  std::cout << "initialized!" << std::endl;
}
bool step(double t, double dt) {
  std::this_thread::sleep_for(std::chrono::seconds(1));

  std::cout << "stepped! (t=" << t << "s; dt=" << dt << "s)" << std::endl;
  return true;
}

} // namespace aot_demo
} // namespace ti
