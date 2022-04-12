// BEGIN_INCLUDE(all)
#include <android/log.h>
#include <android_native_app_glue.h>
#include <errno.h>
#include <jni.h>

#include <cassert>
#include <cstdlib>
#include <cstring>
#include <initializer_list>
#include <memory>

#include "fem_app.h"

#define ALOGI(fmt, ...)                                                  \
  ((void)__android_log_print(ANDROID_LOG_INFO, "TaichiTest", "%s: " fmt, \
                             __FUNCTION__, ##__VA_ARGS__))
#define ALOGE(fmt, ...)                                                   \
  ((void)__android_log_print(ANDROID_LOG_ERROR, "TaichiTest", "%s: " fmt, \
                             __FUNCTION__, ##__VA_ARGS__))

struct engine {
  struct android_app *app{nullptr};
  std::unique_ptr<FemApp> fem{nullptr};
  bool init{false};
};

static int engine_init_display(struct engine *engine) {
  if (!engine->fem) {
    engine->fem = std::make_unique<FemApp>();
  }
  auto *window = engine->app->window;
  engine->fem->run_init(
      /*width=*/ANativeWindow_getWidth(window),
      /*height=*/ANativeWindow_getHeight(window), "/data/local/tmp/", window);
  engine->init = true;

  return 0;
}

/**
 * Just the current frame in the display.
 */
static void engine_draw_frame(struct engine *engine) {
  if (!engine->init) {
    // No display.
    return;
  }
  engine->fem->run_render_loop();
}

static void engine_term_display(struct engine *engine) {
  // @TODO: to implement
}

static int32_t engine_handle_input(struct android_app *app,
                                   AInputEvent *event) {
  // Implement input with Taichi Kernel
  return 0;
}

static void engine_handle_cmd(struct android_app *app, int32_t cmd) {
  struct engine *engine = (struct engine *)app->userData;
  switch (cmd) {
    case APP_CMD_INIT_WINDOW:
      // The window is being shown, get it ready.
      if (engine->app->window != NULL) {
        engine_init_display(engine);
        engine_draw_frame(engine);
      }
      break;
    case APP_CMD_TERM_WINDOW:
      // The window is being hidden or closed, clean it up.
      engine_term_display(engine);
      break;
  }
}

void android_main(struct android_app *state) {
  struct engine engine;

  memset(&engine, 0, sizeof(engine));
  state->userData = &engine;
  state->onAppCmd = engine_handle_cmd;
  state->onInputEvent = engine_handle_input;
  engine.app = state;

  while (1) {
    // Read all pending events.
    int ident;
    int events;
    struct android_poll_source *source;

    // If not animating, we will block forever waiting for events.
    // If animating, we loop until all events are read, then continue
    // to draw the next frame of animation.
    while ((ident = ALooper_pollAll(0, NULL, &events, (void **)&source)) >= 0) {
      // Process this event.
      ALOGI("ident=%d", ident);
      if (source != NULL) {
        source->process(state, source);
      }

      // Check if we are exiting.
      if (state->destroyRequested != 0) {
        engine_term_display(&engine);
        return;
      }
    }
    ALOGI("loop");

    engine_draw_frame(&engine);
  }
}
// END_INCLUDE(all)
