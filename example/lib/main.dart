import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smyxalipaykit/smyxalipaykit.dart';
import 'package:smyxalipaykit/model/ali_resp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Smyxalipaykit smyxalipaykit = Smyxalipaykit();
  StreamSubscription<AliResp> _auth; // 调用原生授权接口
  StreamSubscription<AliResp> _pay; // 调用原生支付接口

  @override
  void initState() {
    super.initState();
    _auth = smyxalipaykit.authResp().listen(listenAuth);
    _pay = smyxalipaykit.payResp().listen(listenPay);
  }

  void listenAuth(AliResp aliResp) {
    print('>>>>>>>>>>>>>>>>>>>>> 接受授权返回参数然后调用服务端获取用户具体信息.....');
    print(aliResp.toJson());
    // TODO：此处可以调用服务端获取用户具体信息
  }

  void listenPay(AliResp aliResp) {
    print('>>>>>>>>>>>>>>>>>>>>> 接受打印支付订单返回参数.....');
    print(aliResp.toJson());
    // TODO：此处可以在把成功的订单数据入库到数据库
  }

  @override
  void dispose() {
    _auth?.cancel();
    _auth = null;
    _pay?.cancel();
    _pay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('环境检查'),
              onTap: () {
                var isInstall = smyxalipaykit.isInstallAliPay;
                print('>>>>>>>>>>>>>>>>>>>>>>>>> isInstall >>> ' + isInstall.toString());
              },
            ),
            ListTile(
              title: Text('应用授权'),
              onTap: () {
                print('>>>>>>>>>>>>>>>>>>>>>>>>> 应用授权 >>> ');
                // TODO: 此处的应用授权信息加密字符串是需要通过服务端获取
                // TODO: (我是java后端,所以对接了java的接口很简单他会直接返回一个字符串直接使用,参考文档:https://opendocs.alipay.com/open/54/106370)
                smyxalipaykit.aliAuth(authInfo: "");
              },
            ),
            ListTile(
              title: Text('支付订单'),
              onTap: () {
                print('>>>>>>>>>>>>>>>>>>>>>>>>> 支付订单 >>> ');
                // TODO: 此处的订单信息是需要通过服务端获取
                // TODO: (我是java后端,所以对接了java的接口很简单他会直接返回一个字符串直接使用,参考文档:https://opendocs.alipay.com/open/54/106370)
                smyxalipaykit.aliPay(orderInfo: "");
              },
            ),
          ],
        ),
      ),
    );
  }
}
