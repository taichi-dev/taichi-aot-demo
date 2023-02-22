#include <cmath>
#include <iostream>
#include <numeric>
#include <taichi/cpp/taichi.hpp>

struct App0_tutorial {
  // This is different from what used in python script since compiled shaders are compatible with dynamic ndarray shape
  static const uint32_t NPARTICLE = 8192 * 2;
  static const uint32_t N_ITER = 50;

  ti::Runtime runtime_;
  ti::AotModule module_;
  ti::Kernel k_init_;
  ti::Kernel k_add_base_;
  ti::NdArray<float> x_;

  App0_tutorial() {
    runtime_ = ti::Runtime(TI_ARCH_VULKAN);
    module_ = runtime_.load_aot_module("0_tutorial_kernel/assets/tutorial");
    ti::check_last_error();
    k_init_ = module_.get_kernel("init");
    k_add_base_ = module_.get_kernel("add_base");
    ti::check_last_error();
    x_ = runtime_.allocate_ndarray<float>({NPARTICLE}, {}, /*host_accessible=*/true);
    ti::check_last_error();
    std::cout << "Initialized!" << std::endl;
  }

  void run() {
    float base = 0.2;

    k_init_.push_arg(x_);
    k_init_.launch();
    k_add_base_.push_arg(x_);
    k_add_base_.push_arg(base);
    for (int i = 0; i < N_ITER; i++) {
      k_add_base_.launch();
    }
    runtime_.wait();
    ti::check_last_error();

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
