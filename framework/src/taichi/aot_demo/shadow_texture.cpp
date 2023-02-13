#pragma once
#include "taichi/aot_demo/shadow_texture.hpp"
#include <taichi/taichi_core.h>
#include <taichi/cpp/taichi.hpp>
#include "taichi/aot_demo/renderer.hpp"

namespace ti {
namespace aot_demo {

ShadowTexture::ShadowTexture(const std::shared_ptr<Renderer> &renderer,
                             const ti::Image &client_image,
                             ShadowTextureUsage usage) : renderer_(renderer) {
  TiImageAllocateInfo iai{};
  iai.dimension = client_image.dimension();
  iai.extent = client_image.extent();
  iai.mip_level_count = client_image.mip_level_count();
  iai.format = client_image.format();
  ti::Image image = renderer->runtime_.allocate_image(iai);

  usage_ = usage;
  image_ = std::move(image);
  client_image_ =
      ti::Image(renderer_->client_runtime_, client_image, client_image.dimension(), client_image.extent(),
                client_image.mip_level_count(), client_image.format(), false);
}

ShadowTexture::~ShadowTexture() {
  image_.destroy();
}

void ShadowTexture::copy_from_vulkan_() {
  ti::Runtime &client_runtime = renderer_->client_runtime();

  assert(client_runtime.arch() == TI_ARCH_VULKAN);
  client_runtime.copy_image_device_to_device(image_.slice(),
                                             client_image_.slice());
}

void ShadowTexture::update() {
  switch (renderer_->client_runtime_.arch()) {
    case TI_ARCH_VULKAN:
      copy_from_vulkan_();
      break;
    default:
      assert(false);
  }
  image_.transition_to(TI_IMAGE_LAYOUT_SHADER_READ);
}

} // namespace aot_demo
} // namespace ti
