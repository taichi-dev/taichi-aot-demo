#include <chrono>
#include "taichi/aot_demo/framework.hpp"

int main(int argc, const char** argv) {
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
