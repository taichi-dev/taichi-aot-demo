package com.taichigraphics.aot_demos.implicit_fem;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private VKSurfaceView vkSurfaceView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        vkSurfaceView = new VKSurfaceView(this);
        setContentView(vkSurfaceView);
    }
}
