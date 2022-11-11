#include <cmath>
#include <iostream>
#include <numeric>
#include <taichi/cpp/taichi.hpp>

namespace {
void ti_check_error(const std::string& msg) {
  TiError error = ti_get_last_error(0, nullptr);
  if (error < TI_ERROR_SUCCESS) {
    throw std::runtime_error(msg);
  }
}
}

struct App0_tutorial {
  // This is different from what used in python script since compiled shaders are compatible with dynamic ndarray shape
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t N_ITER = 50;

  ti::Runtime runtime_;
  ti::AotModule module_;
  ti::ComputeGraph g_demo_;
  ti::NdArray<float> x_;

  App0_tutorial() {
    runtime_ = ti::Runtime(TI_ARCH_VULKAN);
    module_ = runtime_.load_aot_module("0_tutorial_cgraph/assets/tutorial");
    ti_check_error("load_aot_module failed");
    g_demo_ = module_.get_compute_graph("demo_graph");
    ti_check_error("get_compute_graph failed");
    x_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {}, /*host_accessible=*/true);
    ti_check_error("allocate_ndarray failed");
    std::cout << "Initialized!" << std::endl;
  }

  void run() {
    float base = 0.2;

    g_demo_["x"] = x_;
    g_demo_["base"] = base;

    g_demo_.launch();
    runtime_.wait();
    ti_check_error("cgraph launch failed");

    std::vector<float> dst(NPARTICLE);
    x_.read(dst);

    float sum = std::accumulate(dst.begin(), dst.end(), 0.);
    float expected = NPARTICLE * N_ITER * base;
    float threshold = 0.5;
    if (std::abs(sum - expected) < threshold) {
      std::cout << "Passed" << std::endl;
    } else {
      std::string err_str = "Expected: " + std::to_string(expected) + ", Got: " + std::to_string(sum);
      throw std::runtime_error(err_str);
    }
  }
};

int main(int argc, const char** argv) {
  App0_tutorial app;
  app.run();
  return 0;
}
