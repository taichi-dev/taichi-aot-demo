package com.taichigraphics.aot_demos.implicit_fem;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
//import android.util.log;

public class AccelerationSensor implements SensorEventListener {
  private Context context;
  public float[] gravity;
  private SensorManager sensorManager;
  private Sensor sensor;

  public AccelerationSensor(Context _context) {
    context = _context;
    sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
    sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    //if (sensor == null) Log.e("error", "ACCELERATION SENSOR NOT SUPPORTED");
    gravity = new float[3];
    if (sensor == null) return;
    sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME);
  }

  @Override
  public void onSensorChanged(SensorEvent event) {
      gravity[0] = event.values[0];
      gravity[1] = event.values[1];
      gravity[2] = event.values[2];
  }

  @Override
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
    return;
  }
}

