#pragma once

#include <memory>
#include <taichi/ui/gui/gui.h>
#include <taichi/ui/backends/vulkan/renderer.h>
#include <vector>

namespace demo {
class TextureDemoImpl;
class TextureDemo {
public:
  TextureDemo();
  ~TextureDemo();

  void Step();
private:
  std::unique_ptr<TextureDemoImpl> impl_{nullptr};
  std::shared_ptr<taichi::ui::vulkan::Gui> gui_{nullptr};
  std::unique_ptr<taichi::ui::vulkan::Renderer> renderer{nullptr};
  GLFWwindow *window{nullptr};
  taichi::ui::FieldInfo f_info;
  taichi::ui::SetImageInfo set_image_info;
};
}
