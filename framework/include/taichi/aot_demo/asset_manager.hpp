#pragma once
#include "taichi/aot_demo/common.hpp"
#include "gft/util.hpp"

namespace ti {
namespace aot_demo {

class AssetManager {
public:
  virtual ~AssetManager() {}

  // Load a binary file at the given `path`. Returns true if the `data` is
  // succesfully, fully loaded.
  virtual bool load_file(const char* path, std::vector<uint8_t>& data) = 0;
  template<typename T>
  bool load_file_typed(const char* path, std::vector<T>& data) {
    std::vector<uint8_t> data2;
    if (!load_file(path, data2)) {
      return false;
    }
    assert(data2.size() % sizeof(T) == 0);
    data.resize(data2.size() / sizeof(T));
    std::memcpy(data.data(), data2.data(), data2.size());
    return true;
  }
  // Load a textual file at the given `path`. Returns true if the `str` is
  // succesfully, fully loaded.
  virtual bool load_text(const char* path, std::string& str) = 0;
};

// Assets are loaded via current working directory (CWD).
class CwdAssetManager : public AssetManager {
  virtual bool load_file(const char* path, std::vector<uint8_t>& data) override final {
    data = liong::util::load_file(path);
    return data.size() != 0;
  }
  virtual bool load_text(const char* path, std::string& str) override final{
    str = liong::util::load_text(path);
    return str.size() != 0;
  }
  
};

} // namespace aot_demo
} // namespace ti
