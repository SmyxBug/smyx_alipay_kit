package com.smyxalipaykit;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

/** SmyxalipaykitPlugin */
public class SmyxalipaykitPlugin implements FlutterPlugin, ActivityAware {

  private AliPayKitUtils aliPayKitUtils;

  public SmyxalipaykitPlugin() {
    aliPayKitUtils = new AliPayKitUtils();
  }

  public static void registWith(PluginRegistry.Registrar registrar) {
    AliPayKitUtils aliPayKitUtils = new AliPayKitUtils(registrar.context(), registrar.activity());
    aliPayKitUtils.startListening(registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    aliPayKitUtils.setApplicationContext(binding.getApplicationContext());
    aliPayKitUtils.setActivity(null);
    aliPayKitUtils.startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    aliPayKitUtils.stopListening();
    aliPayKitUtils.setActivity(null);
    aliPayKitUtils.setApplicationContext(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    aliPayKitUtils.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    aliPayKitUtils.setActivity(null);
  }

}
