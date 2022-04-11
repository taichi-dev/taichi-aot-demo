/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.taichigraphics.aot_demos.implicit_fem;

import android.content.Context;
import android.content.res.AssetManager;
import android.view.SurfaceHolder;
import android.view.Surface;
import android.view.SurfaceView;

import androidx.annotation.NonNull;

public class VKSurfaceView extends SurfaceView implements SurfaceHolder.Callback2 {
    private static final String TAG = "VKSurfaceView";
    private RendererThread mRendererThread;
    private AccelerationSensor sensor;

    public VKSurfaceView(Context context) {
        super(context);

        SurfaceHolder holder = getHolder();
        holder.addCallback(this);
        sensor = new AccelerationSensor(context);
    }

    // @TODO: Define a Renderer Class instead of calling the NativeLib directly like the GLSurfaceView
    // is doing.
    public void start() {
        mRendererThread = new VKSurfaceView.RendererThread(getContext());
        mRendererThread.start();
    }

    @Override
    public void surfaceRedrawNeeded(@NonNull SurfaceHolder surfaceHolder) {
        // @TODO: Implement a force render() in our Rendering Thread
    }

    @Override
    public void surfaceCreated(@NonNull SurfaceHolder surfaceHolder) {
        mRendererThread.surfaceCreated(surfaceHolder);
    }

    @Override
    public void surfaceChanged(@NonNull SurfaceHolder surfaceHolder, int format, int width, int height) {
        mRendererThread.onWindowResize(width, height);
    }

    @Override
    public void surfaceDestroyed(@NonNull SurfaceHolder surfaceHolder) {
        mRendererThread.surfaceDestroyed();
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();

        mRendererThread = new VKSurfaceView.RendererThread(getContext());
        mRendererThread.start();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        mRendererThread.requestExitAndWait();
    }

    public void onPause() {
        if (mRendererThread != null) {
            mRendererThread.onPause();
        }
    }

    public void onResume() {
        if (mRendererThread != null) {
            mRendererThread.onResume();
        }
    }

    private class RendererThread extends Thread {
        public boolean mDone;

        private final Context mContext;
        private final RendererThreadManager sRendererThreadManager = new RendererThreadManager();
        private int mWidth;
        private int mHeight;
        private SurfaceHolder mHolder;
        private boolean mHasSurface;
        private boolean mWaitingForSurface;
        private boolean mSizeChanged;
        private boolean mPaused;

        RendererThread(@NonNull final Context context) {
            super();

            mContext = context;
            mWidth = 0;
            mHeight = 0;
            mSizeChanged = false;
            mWaitingForSurface = false;
            mHasSurface = false;
            mPaused = false;
            mDone = false;
        }

        @Override
        public void run() {
            setName("RendererThread " + getId());

            try {
                guardedRun();
            } catch (InterruptedException e) {
                // fail thru
            } finally {
                sRendererThreadManager.threadExiting(this);
            }
        }

        private void guardedRun() throws InterruptedException {
            while (!isDone()) {
                // Update the asynchronous state (window size)
                int w = 0;
                int h = 0;
                boolean changed = false;

                synchronized (sRendererThreadManager) {
                    while (true) {
                        if (mDone) {
                            break;
                        }

                        if (!mHasSurface) {
                            if (!mWaitingForSurface) {
                                mWaitingForSurface = true;
                                sRendererThreadManager.notifyAll();
                            }
                        }

                        if ((!mPaused) && (mWidth > 0) && (mHeight > 0)) {
                            changed = mSizeChanged;
                            w = mWidth;
                            h = mHeight;
                            mSizeChanged = false;
                            if (mHasSurface && mWaitingForSurface) {
                                // Create VK/GL Context in native library by passing the Native Window (Surface)
                                // In case of OpenGL, no need to create a GLSurfaceView here, we can do it in the
                                // native code
                                NativeLib.init(mContext.getAssets(), mHolder.getSurface());

                                changed = true;
                                mWaitingForSurface = false;
                                sRendererThreadManager.notifyAll();
                            }

                            break;
                        }

                        sRendererThreadManager.wait();
                    }
                }

                if (changed) {
                    NativeLib.resize(mHolder.getSurface(), w, h);
                }

                if ((w > 0) && (h > 0)) {
                    NativeLib.render(mHolder.getSurface(), sensor.gravity[0], sensor.gravity[1], sensor.gravity[2]);
                }
            }
        }

        public void surfaceCreated(SurfaceHolder holder) {
            mHolder = holder;
            synchronized (sRendererThreadManager) {
                mHasSurface = true;
                sRendererThreadManager.notifyAll();
            }
        }

        public void surfaceDestroyed() {
            synchronized (sRendererThreadManager) {
                NativeLib.destroy(mHolder.getSurface());
                mHasSurface = false;
                sRendererThreadManager.notifyAll();
                while (!mWaitingForSurface && isAlive() && !mDone) {
                    try {
                        sRendererThreadManager.wait();
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        }

        private boolean isDone() {
            synchronized (sRendererThreadManager) {
                return mDone;
            }
        }

        public void onPause() {
            synchronized (sRendererThreadManager) {
                mPaused = true;
                if (mHolder != null) {
                    NativeLib.pause(mHolder.getSurface());
                }
                sRendererThreadManager.notifyAll();
            }
        }

        public void onResume() {
            synchronized (sRendererThreadManager) {
                mPaused = false;
                if (mHolder != null) {
                    NativeLib.resume(mHolder.getSurface());
                }
                sRendererThreadManager.notifyAll();
            }
        }

        public void onWindowResize(int w, int h) {
            synchronized (sRendererThreadManager) {
                mWidth = w;
                mHeight = h;
                mSizeChanged = true;
                sRendererThreadManager.notifyAll();
            }
        }

        public void requestExitAndWait() {
            // don't call this from GLThread thread or it is a guaranteed
            // deadlock!
            synchronized (sRendererThreadManager) {
                mDone = true;
                sRendererThreadManager.notifyAll();
            }

            try {
                join();
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
            }
        }

        private class RendererThreadManager {
            public synchronized void threadExiting(VKSurfaceView.RendererThread thread) {
                thread.mDone = true;
                notifyAll();
            }
        }
    }
}

class NativeLib {
    static {
        System.loadLibrary("taichi-implicit-fem");
    }

    public static native void init(AssetManager assets, Surface surface);
    public static native void destroy(Surface surface);
    public static native void pause(Surface surface);
    public static native void resume(Surface surface);
    public static native void resize(Surface surface, int width, int height);
    public static native void render(Surface surface, float g_x, float g_y, float g_z);
}
