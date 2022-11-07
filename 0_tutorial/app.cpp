#include <cmath>
#include <iostream>
#include <numeric>
#include <taichi/cpp/taichi.hpp>

struct App0_tutorial {
  static const uint32_t NPARTICLE = 8192 * 2;

  ti::Runtime runtime_;
  ti::AotModule module_;
  ti::ComputeGraph g_demo_;
  ti::NdArray<float> x_;

  App0_tutorial() {
    runtime_ = ti::Runtime(TI_ARCH_VULKAN);
    module_ = runtime_.load_aot_module("0_tutorial/assets/tutorial");
    g_demo_ = module_.get_compute_graph("demo_graph");
    x_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {}, true);
    std::cout << "Initialized!" << std::endl;
  }

  bool run() {
    float base = 0.2;

    g_demo_["x"] = x_;
    g_demo_["base"] = base;

    g_demo_.launch();
    runtime_.wait();

    std::vector<float> dst(NPARTICLE);
    x_.read(dst);

    float sum = std::accumulate(dst.begin(), dst.end(), 0.);
    float expected = NPARTICLE * 50 * base;
    if (std::abs(sum - expected) < 0.1) {
      std::cout << "Passed" << std::endl;
    } else {
      std::string err_str = "Expected: " + std::to_string(expected) + ", Got: " + std::to_string(sum);
      throw std::runtime_error(err_str);
    }

    return true;
  }
};

int main(int argc, const char** argv) {
  App0_tutorial app;
  app.run();
  return 0;
}
