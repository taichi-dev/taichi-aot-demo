#include "taichi/aot_demo/interop/cross_device_copy.hpp"
#include "taichi/aot_demo/interop/common_utils.hpp"
#include "taichi/aot_demo/renderer.hpp"


namespace ti {
namespace aot_demo {
namespace vulkan {


template class InteropHelper<double>;
template class InteropHelper<float>;
template class InteropHelper<uint32_t>;
template class InteropHelper<int>;

}
}
}
