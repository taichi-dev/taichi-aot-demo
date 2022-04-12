// BEGIN_INCLUDE(all)
#include <android/log.h>
#include <android/sensor.h>
#include <android_native_app_glue.h>
// #include <hardware/sensors.h>
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
  ASensorVector gravity;
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
  engine->gravity.x = 0;
  engine->gravity.y = -9.8f;
  engine->gravity.z = 0;

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
  engine->fem->run_render_loop(engine->gravity.x, engine->gravity.y,
                               engine->gravity.z);
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

  ASensorManager *sensor_manager = ASensorManager_getInstanceForPackage(
      "com.taichigraphics.aot_demos.implicit_fem");
  if (!sensor_manager) {
    fprintf(stderr, "Failed to get a sensor manager\n");
    return;
  }
  ASensorList sensor_list;
  int sensor_count = ASensorManager_getSensorList(sensor_manager, &sensor_list);
  ALOGI("Found %d sensors\n", sensor_count);
  for (int i = 0; i < sensor_count; i++) {
    ALOGI("Found %s\n", ASensor_getName(sensor_list[i]));
  }
  constexpr int kLooperId = 1;
  ASensorEventQueue *queue = ASensorManager_createEventQueue(
      sensor_manager, ALooper_prepare(ALOOPER_PREPARE_ALLOW_NON_CALLBACKS),
      kLooperId, NULL /* no callback */, NULL /* no data */);
  if (!queue) {
    fprintf(stderr, "Failed to create a sensor event queue\n");
    return;
  }

  while (1) {
    const ASensor *sensor = ASensorManager_getDefaultSensor(
        sensor_manager, ASENSOR_TYPE_ACCELEROMETER);

    if (sensor && !ASensorEventQueue_enableSensor(queue, sensor)) {
      // Read all pending events.
      int ident;
      int events;
      struct android_poll_source *source;

      // If not animating, we will block forever waiting for events.
      // If animating, we loop until all events are read, then continue
      // to draw the next frame of animation.
      ident = ALooper_pollAll(5, NULL, &events, (void **)&source);
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
      if (ident == kLooperId) {
        ASensorEvent data;
        constexpr int kNumEvents = 1;
        if (ASensorEventQueue_getEvents(queue, &data, kNumEvents)) {
          const auto accl = data.acceleration;
          ALOGI("Acceleration: x = %f, y = %f, z = %f\n", accl.x, accl.y,
                accl.z);
          engine.gravity = accl;
        }
      }
      // ASensorEventQueue_disableSensor(queue, sensor);
    }

    ALOGI("loop");

    engine_draw_frame(&engine);
  }
}
// END_INCLUDE(all)
