package com.ypin.youpinapp;

import android.content.Context;

import androidx.multidex.MultiDex;
import io.flutter.app.FlutterApplication;

public class MyApp extends FlutterApplication {

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(base);
    }
}
