package com.smyxalipaykit;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;

import androidx.annotation.NonNull;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.PayTask;

import java.lang.ref.WeakReference;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AliPayKitUtils implements MethodChannel.MethodCallHandler {

    private Context applicationContext;
    private Activity activity;

    private MethodChannel channel;

    public AliPayKitUtils() {
        super();
    }

    public AliPayKitUtils(Context applicationContext, Activity activity) {
        this.applicationContext = applicationContext;
        this.activity = activity;
    }

    public void setApplicationContext(@NonNull Context applicationContext) {
        this.applicationContext = applicationContext;
    }

    public void setActivity(@NonNull Activity activity) {
        this.activity = activity;
    }

    public void startListening(@NonNull BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "smyxalipaykit");
        channel.setMethodCallHandler(this);
    }

    public void stopListening() {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if ("isInstalledAliPay".equals(call.method)) { // 是否安装了支付宝
            boolean isInstalled = false;
            try {
                final PackageManager packageManager = applicationContext.getPackageManager();
                PackageInfo packageInfo = packageManager.getPackageInfo("com.eg.android.AlipayGphone", PackageManager.GET_SIGNATURES);
                isInstalled = null != packageInfo;
            } catch (Exception e) {
                e.printStackTrace();
            }
            result.success(isInstalled);
        } else if ("aliAuth".equals(call.method)) { // 支付宝授权
            final String authInfo = call.argument("authInfo");
            final WeakReference<Activity> activityWeakReference = new WeakReference<>(activity);
            new AsyncTask<String, String, Map<String, String>>() {
                @Override
                protected Map<String, String> doInBackground(String... strings) {
                    Activity activity = activityWeakReference.get();
                    if (null != activity && !activity.isFinishing()) {
                        AuthTask authTask = new AuthTask(activity);
                        Map<String, String> authV2 = authTask.authV2(authInfo, true);
                        return authV2;
                    }
                    return null;
                }
                @Override
                protected void onPostExecute(Map<String, String> result) {
                    if (null != result) {
                        Activity activity = activityWeakReference.get();
                        if (null != activity && !activity.isFinishing()) {
                            if (channel != null) {
                                channel.invokeMethod("onAuthResp", result);
                            }
                        }
                    }
                }
            }.execute();
            result.success(null);
        } else if ("aliPay".equals(call.method)) { // 支付宝支付
            final String orderInfo = call.argument("orderInfo");
            final WeakReference<Activity> activityWeakReference = new WeakReference<>(activity);
            new AsyncTask<String, String, Map<String, String>>() {
                @Override
                protected Map<String, String> doInBackground(String... strings) {
                    Activity activity = activityWeakReference.get();
                    if (null != activity && !activity.isFinishing()) {
                        PayTask payTask = new PayTask(activity);
                        Map<String, String> payV2 = payTask.payV2(orderInfo, true);
                        return payV2;
                    }
                    return null;
                }
                @Override
                protected void onPostExecute(Map<String, String> result) {
                    if (null != result) {
                        Activity activity = activityWeakReference.get();
                        if (null != activity && !activity.isFinishing()) {
                            if (channel != null) {
                                channel.invokeMethod("onPayResp", result);
                            }
                        }
                    }
                }
            }.execute();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

}
