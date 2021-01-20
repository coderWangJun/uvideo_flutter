package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
      io.agora.agorartcengine.AgoraRtcEnginePlugin.registerWith(shimPluginRegistry.registrarFor("io.agora.agorartcengine.AgoraRtcEnginePlugin"));
    flutterEngine.getPlugins().add(new com.example.awsome_video_player.AwsomeVideoPlayerPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.connectivity.ConnectivityPlugin());
    flutterEngine.getPlugins().add(new com.mr.flutter.plugin.filepicker.FilePickerPlugin());
    flutterEngine.getPlugins().add(new com.baidu.flutter_bmfbase.FlutterBmfbasePlugin());
      com.baidu.bdmap_location_flutter_plugin.LocationFlutterPlugin.registerWith(shimPluginRegistry.registrarFor("com.baidu.bdmap_location_flutter_plugin.LocationFlutterPlugin"));
    flutterEngine.getPlugins().add(new com.baidu.flutter_bmfmap.FlutterBmfmapPlugin());
    flutterEngine.getPlugins().add(new com.baidu.flutter_bmfutils.FlutterBmfutilsPlugin());
      com.example.flutter_drag_scale.FlutterDragScalePlugin.registerWith(shimPluginRegistry.registrarFor("com.example.flutter_drag_scale.FlutterDragScalePlugin"));
      com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.registerWith(shimPluginRegistry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
      com.dooboolab.fluttersound.FlutterSoundPlugin.registerWith(shimPluginRegistry.registrarFor("com.dooboolab.fluttersound.FlutterSoundPlugin"));
    flutterEngine.getPlugins().add(new com.lykhonis.imagecrop.ImageCropPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.imagepicker.ImagePickerPlugin());
      com.zaihui.installplugin.InstallPlugin.registerWith(shimPluginRegistry.registrarFor("com.zaihui.installplugin.InstallPlugin"));
    flutterEngine.getPlugins().add(new com.github.sososdk.orientation.OrientationPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new com.baseflow.permissionhandler.PermissionHandlerPlugin());
      flutter.plugins.screen.screen.ScreenPlugin.registerWith(shimPluginRegistry.registrarFor("flutter.plugins.screen.screen.ScreenPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    flutterEngine.getPlugins().add(new top.huic.tencent_im_plugin.TencentImPlugin());
    flutterEngine.getPlugins().add(new com.jarvan.tobias.TobiasPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
      xyz.justsoft.video_thumbnail.VideoThumbnailPlugin.registerWith(shimPluginRegistry.registrarFor("xyz.justsoft.video_thumbnail.VideoThumbnailPlugin"));
    flutterEngine.getPlugins().add(new creativecreatorormaybenot.wakelock.WakelockPlugin());
  }
}
