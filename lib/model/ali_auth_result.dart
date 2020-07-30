/// 支付宝支付授权接口返回值中的result字段分支
import 'package:smyxalipaykit/utils/converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ali_auth_result.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class AliAuthResult {

  final bool success;
  final int resultCode;
  final String authCode;
  final String userId;

  AliAuthResult({
    this.success,
    this.resultCode,
    this.authCode,
    this.userId
  });

  /// 反序列化
  factory AliAuthResult.fromJson(Map<dynamic, dynamic> json) => _$AliAuthResultFromJson(json);

  @JsonKey(
    fromJson: boolFromString,
    toJson: boolToString, 
  )

  /// 序列化
  Map<dynamic, dynamic> toJson() => _$AliAuthResultToJson(this);

}