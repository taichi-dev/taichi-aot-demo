#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <android/log.h>
#include <android/looper.h>
#include <android/sensor.h>
#include <android_native_app_glue.h>
#include <assert.h>
#include <jni.h>
#include <stdint.h>

#include <chrono>
#include <map>
#include <vector>

#define ALOGI(fmt, ...)                                                    \
    ((void)__android_log_print(ANDROID_LOG_INFO, "TaichiTest", "%s: " fmt, \
                               __FUNCTION__, ##__VA_ARGS__))
#define ALOGE(fmt, ...)                                                     \
    ((void)__android_log_print(ANDROID_LOG_ERROR, "TaichiTest", "%s: " fmt, \
                               __FUNCTION__, ##__VA_ARGS__))
#include "fem_app.h"

//#define ONLY_INIT

struct engine {
    struct android_app *state;

    const ASensor *acc_sensor;
    ASensorEventQueue *sensor_event_queue;
    ASensorManager *sensor_manager;

    FemApp *app;
    double g_x;
    double g_y;
    double g_z;
    bool init{false};
};

static jobject getGlobalContext(JNIEnv *env) {
    // Get the instance object of Activity Thread
    jclass activityThread = env->FindClass("android/app/ActivityThread");
    jmethodID currentActivityThread =
        env->GetStaticMethodID(activityThread, "currentActivityThread",
                               "()Landroid/app/ActivityThread;");
    jobject at =
        env->CallStaticObjectMethod(activityThread, currentActivityThread);
    // Get Application, which is the global Context
    jmethodID getApplication = env->GetMethodID(
        activityThread, "getApplication", "()Landroid/app/Application;");
    jobject context = env->CallObjectMethod(at, getApplication);
    return context;
}

static std::string GetExternalFilesDir(struct engine *engine) {
    std::string ret;

    engine->state->activity->vm->AttachCurrentThread(
        &engine->state->activity->env, NULL);
    JNIEnv *env = engine->state->activity->env;

    // getExternalFilesDir() - java
    jclass cls_Env = env->FindClass("android/app/NativeActivity");
    jmethodID mid = env->GetMethodID(cls_Env, "getExternalFilesDir",
                                     "(Ljava/lang/String;)Ljava/io/File;");
    jobject obj_File = env->CallObjectMethod(getGlobalContext(env), mid, NULL);
    jclass cls_File = env->FindClass("java/io/File");
    jmethodID mid_getPath =
        env->GetMethodID(cls_File, "getPath", "()Ljava/lang/String;");
    jstring obj_Path = (jstring)env->CallObjectMethod(obj_File, mid_getPath);

    ret = env->GetStringUTFChars(obj_Path, NULL);

    engine->state->activity->vm->DetachCurrentThread();

    return ret;
}

static void copyAssetsToDataDir(struct engine *engine, const char *folder) {
    const char *filename;
    auto dir =
        AAssetManager_openDir(engine->state->activity->assetManager, folder);
    std::string out_dir = GetExternalFilesDir(engine) + "/" + folder;
    std::filesystem::create_directories(out_dir);

    while ((filename = AAssetDir_getNextFileName(dir))) {
        std::ofstream out_file(out_dir + filename, std::ios::binary);
        std::string in_filepath = std::string(folder) + filename;
        AAsset *asset =
            AAssetManager_open(engine->state->activity->assetManager,
                               in_filepath.c_str(), AASSET_MODE_UNKNOWN);
        auto in_buffer = AAsset_getBuffer(asset);
        auto size = AAsset_getLength(asset);
        out_file.write((const char *)in_buffer, size);
    }
}

static int engine_init_display(struct engine *engine) {
    // Copy the assets from the AssetManager to internal storage so we can use a
    // file system path inside Taichi.
    // copyAssetsToDataDir(engine, "implicit_fem/");
    // copyAssetsToDataDir(engine, "shaders/render/");
    copyAssetsToDataDir(engine, "shaders/aot/implicit_fem/");
    copyAssetsToDataDir(engine, "shaders/render/");

    engine->app = new FemApp();
    engine->app->run_init(
        /*width=*/ANativeWindow_getWidth(engine->state->window),
        /*height=*/ANativeWindow_getHeight(engine->state->window),
        GetExternalFilesDir(engine), engine->state->window);

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

    ALOGI("Acceleration: g_x = %f, g_y = %f, g_z = %f", engine->g_x,
          engine->g_y, engine->g_z);
    float a_x = engine->g_x > 2 || engine->g_x < -2 ? -engine->g_x * 8 : 0;
    float a_y = engine->g_y > 2 || engine->g_y < -2 ? -engine->g_y * 8 : 0;
    float a_z = engine->g_z > 2 || engine->g_z < -2 ? -engine->g_z * 8 : 0;

    engine->app->run_render_loop(a_x, a_y, a_z);
}

static void engine_term_display(struct engine *engine) {
    engine->app->cleanup();
    delete engine->app;
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
            if (engine->state->window != NULL) {
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
    ASensorEvent event;

    memset(&engine, 0, sizeof(engine));
    state->userData = &engine;
    state->onAppCmd = engine_handle_cmd;
    state->onInputEvent = engine_handle_input;
    engine.state = state;

    // Setup Sensor Manager to receive events
    engine.sensor_manager = ASensorManager_getInstanceForPackage(
        "com.taichigraphics.aot_demos.implicit_fem");
    ALooper *looper = ALooper_forThread();
    if (looper == nullptr) {
        looper = ALooper_prepare(ALOOPER_PREPARE_ALLOW_NON_CALLBACKS);
    }
    engine.acc_sensor = ASensorManager_getDefaultSensor(
        engine.sensor_manager, ASENSOR_TYPE_ACCELEROMETER);
    engine.sensor_event_queue = ASensorManager_createEventQueue(
        engine.sensor_manager, looper, 4, nullptr, nullptr);
    ASensorEventQueue_enableSensor(engine.sensor_event_queue,
                                   engine.acc_sensor);
    ASensorEventQueue_setEventRate(engine.sensor_event_queue, engine.acc_sensor,
                                   ASensor_getMinDelay(engine.acc_sensor));

    while (1) {
        // Read all pending events.
        int ident;
        int events;
        struct android_poll_source *source;

        // If not animating, we will block forever waiting for events.
        // If animating, we loop until all events are read, then continue
        // to draw the next frame of animation.
        while ((ident = ALooper_pollAll(0, NULL, &events, (void **)&source)) >=
               0) {
            // Process this event.
            if (source != NULL) {
                source->process(state, source);
            }

            // Check if we are exiting.
            if (state->destroyRequested != 0) {
                engine_term_display(&engine);
                return;
            }

            // Process sensor events
            while (ASensorEventQueue_getEvents(engine.sensor_event_queue,
                                               &event, 1) > 0) {
                if (event.type == ASENSOR_TYPE_ACCELEROMETER) {
                    engine.g_x = event.data[0];
                    engine.g_y = event.data[1];
                    engine.g_z = event.data[2];
                }
            }
        }

        engine_draw_frame(&engine);
    }
}
// END_INCLUDE(all)
