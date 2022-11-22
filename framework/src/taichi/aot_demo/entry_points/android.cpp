#include <iostream>
#include <chrono>
#include "taichi/aot_demo/framework.hpp"
#include "gft/args.hpp"
#include "gft/util.hpp"
#include <android/log.h>
#include <android_native_app_glue.h>
#define VK_USE_PLATFORM_ANDROID_KHR 1
#include <vulkan/vulkan.h>

static_assert(TI_AOT_DEMO_ANDROID_APP, "android native lib must be provided");
struct Config {
  AAssetManager* asset_mgr;
} CFG;

void initialize(android_app* state) {
  CFG.asset_mgr = state->activity->assetManager;
};

namespace {

// Assets are loaded via Android asset manager.
class AndroidAssetManager : public ti::aot_demo::AssetManager {
  AAssetManager* asset_mgr_;

public:
  AndroidAssetManager(AAssetManager* asset_mgr) : asset_mgr_(asset_mgr) {}

  virtual bool load_file(const char* path, std::vector<uint8_t>& data) override final {
    AAsset* file = AAssetManager_open(asset_mgr_, path, AASSET_MODE_BUFFER);
    if (file == nullptr) {
      return false;
    }
    size_t size = AAsset_getLength(file);
    data.resize(size);
    AAsset_read(file, data.data(), size);
    AAsset_close(file);
    return !data.empty();
  }
  virtual bool load_text(const char* path, std::string& str) override final{
    AAsset* file = AAssetManager_open(asset_mgr_, path, AASSET_MODE_BUFFER);
    if (file == nullptr) {
      return false;
    }
    size_t size = AAsset_getLength(file);
    str.resize(size);
    AAsset_read(file, (void*)str.data(), size);
    AAsset_close(file);
    return !str.empty();
  }
};

} // namespace

std::unique_ptr<ti::aot_demo::AssetManager> create_asset_manager() {
  return std::unique_ptr<ti::aot_demo::AssetManager>(new AndroidAssetManager(CFG.asset_mgr));
}

namespace {

struct AndroidApp {
  std::unique_ptr<App> app = nullptr;
  bool is_active = false;
};

static void on_app_cmd_callback(struct android_app* state, int32_t cmd) {
  AndroidApp* app = (AndroidApp*)state->userData;
  switch (cmd) {
    case APP_CMD_INIT_WINDOW:
    {
      std::unique_ptr<App> app2 = create_app();
      const AppConfig app_cfg = app2->cfg();

      auto F = std::make_shared<ti::aot_demo::Framework>(app_cfg, false);
      app2->set_framework(F);

      ti::aot_demo::Renderer& renderer = F->renderer();

      app2->initialize(TI_ARCH_VULKAN);

      renderer.set_surface_window(state->window);

      app->app = std::move(app2);
      app->is_active = true;
      break;
    }
    case APP_CMD_TERM_WINDOW:
    {
      app->is_active = false;
      app->app.reset();
      break;
    }
    case APP_CMD_GAINED_FOCUS:
    {
      app->is_active = true;
      break;
    }
    case APP_CMD_LOST_FOCUS:
    {
      app->is_active = false;
      break;
    }
    default:
      break;
  }
}

} // namespace


void android_main(struct android_app* state) {
  initialize(state);

  std::unique_ptr<AndroidApp> app = std::make_unique<AndroidApp>();
  state->userData = app.get();
  state->onAppCmd = on_app_cmd_callback;

  for (;;) {
    // Read all pending events.
    int events;
    struct android_poll_source* source;

    // If not animating, we will block forever waiting for events.
    // If animating, we loop until all events are read, then continue
    // to draw the next frame of animation.
    while ((ALooper_pollAll(app->is_active ? 0 : -1, nullptr, &events, (void**)&source)) >= 0) {
      if (source != nullptr) {
        source->process(state, source);
      }

      if (state->destroyRequested != 0) {
        app.reset();
        return;
      }
    }

    if (app->is_active && app->app != nullptr) {
      ti::aot_demo::Framework& F = *app->app->F_;
      if (!app->app->update()) {
        F.next_frame();
        return;
      }

      F.renderer().begin_render();
      app->app->render();
      F.renderer().end_render();

      F.renderer().present_to_surface();

      F.next_frame();
    }
  }
}

extern "C" {
#include <android_native_app_glue.c>
}
