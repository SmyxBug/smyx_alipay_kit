import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:smyxalipaykit/model/ali_resp.dart';

class Smyxalipaykit {

  /// 和原生建立通讯 name 需要和 原生代码里写的一致
  static const MethodChannel _channel = const MethodChannel('smyxalipaykit');
//============================= 此处是返回值处理区域 ===================================
  final StreamController<AliResp> authRespStreamController = StreamController<AliResp>.broadcast();
  final StreamController<AliResp> payRespStreamController = StreamController<AliResp>.broadcast();

  Smyxalipaykit() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onAuthResp' : // 授权接口返回数据
        authRespStreamController.add(AliResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case 'onPayResp' : // 支付接口返回数据
        payRespStreamController.add(AliResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  Stream<AliResp> authResp() {
    return authRespStreamController.stream;
  }

  Stream<AliResp> payResp() {
    return payRespStreamController.stream;
  }

//============================= 以下是API方法区域=======================================
  /// 调取原生代码判断是否安装了支付宝
  Future<bool> get isInstallAliPay async {
    final bool isInstall = await _channel.invokeMethod('isInstalledAliPay');
    return isInstall;
  }

  /// 调取原生方法授权 
  Future<void> aliAuth({@required String authInfo}) {
    /// aliAuth : 原生方法入口名字需一致
    /// authInfo : 参数名称需一致
    return _channel.invokeMethod('aliAuth', <String, dynamic>{"authInfo" : authInfo});
  }

  /// 调取原生方法支付 
  Future<void> aliPay({@required String orderInfo}) {
    /// aliPay : 原生方法入口名字需一致
    /// orderInfo : 参数名称需一致 (此参数是通过支付宝接口直接获取的加密后的需要自己写服务端获取然后再传递)
    /// 具体文档地址见：https://opendocs.alipay.com/open/54/106370
    return _channel.invokeMethod('aliPay', <String, dynamic>{"orderInfo" : orderInfo});
  }

}

