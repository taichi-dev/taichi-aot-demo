package com.taichigraphics.aot_demos.implicit_fem;

import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

import androidx.appcompat.app.AppCompatActivity;


public class MainActivity extends AppCompatActivity {
    private VKSurfaceView vkSurfaceView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try
        {
            this.getSupportActionBar().hide();
        }
        catch (NullPointerException e){}
        vkSurfaceView = new VKSurfaceView(this);
        setContentView(vkSurfaceView);
    }
}
