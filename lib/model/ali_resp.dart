/// 支付宝统一接口返回值定义
import 'package:smyxalipaykit/utils/converter.dart';
import 'package:smyxalipaykit/model/ali_auth_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ali_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true
)
class AliResp {
  
  final int resultStatus; // 支付宝返回的状态返回值：具体见(https://opendocs.alipay.com/open/218/105327)
  final String result; // 支付宝返回的结果数据
  final String memo; // 支付宝返回的保留参数，一般无内容。

  AliResp({
    this.resultStatus,
    this.result,
    this.memo
  });

  /// 反序列化
  factory AliResp.fromJson(Map<dynamic, dynamic> json) => _$AliRespFromJson(json);

  @JsonKey(
    fromJson: intFromString,
    toJson: intToString,
  )

  AliAuthResult parseAuthResult() {
    if (resultStatus == 9000 && null != result && result.isNotEmpty) {
      Map<String, String> params = Uri.parse('alipay://alipay?$result').queryParameters;
      return AliAuthResult.fromJson(params);
    }
    return null;
  }

  /// 序列化
  Map<dynamic, dynamic> toJson() => _$AliRespToJson(this);

}