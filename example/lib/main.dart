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
  // 调用原生支付接口
  StreamSubscription<AliResp> _pay;

  @override
  void initState() {
    super.initState();
    _pay = smyxalipaykit.payResp().listen(listenPay);
  }

  void listenPay(AliResp aliResp) {
    print('>>>>>>>>>>>>>>>>>>>>> 接受打印支付订单返回参数.....');
    print(aliResp.toJson());
    // TODO：此处可以在把成功的订单数据入库到数据库
  }

  @override
  void dispose() {
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
              title: Text('支付订单'),
              onTap: () {
                print('>>>>>>>>>>>>>>>>>>>>>>>>> 支付订单 >>> ');
                // TODO: 此处的订单信息是需要通过服务端获取
                // TODO: (我是java后端,所以对接了java的接口很简单他会直接返回一个字符串直接使用,参考文档:https://opendocs.alipay.com/open/54/106370)
                smyxalipaykit.aliPay(orderInfo: "alipay_sdk=alipay-sdk-java-4.8.10.ALL&app_id=2021001180666492&biz_content=%7B%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22APP1596102226395%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22App%E6%94%AF%E4%BB%98%E6%B5%8B%E8%AF%95Java%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fwww.zhenaiyongcun.com%2F&sign=W4otWfAQWSxcucsWZ8%2BsMWq3ej5d5DespisDHpLb9374SINb9P9xeiyG38UTHvRo0ZCimQpyBnMpXGKAeBTmdxclHhGRkSade8VpDujJB9rPmJ7yxnl56cBdljU05ev1mT6WLagDr5tzCnp9dSNYKa7c1hawwY0%2FQg9o8V9MdSbOPbI0xdtoQU8AnbJ%2FAFp9I%2FMNStPt9cDFOkiZ%2FIWRW4XNGd9G2aZUy7n9PClPTGo%2BbJhgwe0YG5t19LTRlJ%2B1%2F0PXa66fRHFKy7MjOKFLxKbRPH7E4AJ2d%2FtiBtz8qIlKIVLflXnJj7MSy0%2B4Ew3XA8wzQesEfIgOdkORAPau5g%3D%3D&sign_type=RSA2&timestamp=2020-07-30+17%3A43%3A46&version=1.0");
              },
            ),
          ],
        ),
      ),
    );
  }
}
