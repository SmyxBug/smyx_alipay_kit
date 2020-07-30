part of 'ali_auth_result.dart';

AliAuthResult _$AliAuthResultFromJson(Map json) {
  return AliAuthResult(
    success: boolFromString(json['success'] as String),
    resultCode: intFromString(json['result_code'] as String),
    authCode: json['auth_code'] as String,
    userId: json['user_id'] as String,
  );
}

Map<String, dynamic> _$AliAuthResultToJson(AliAuthResult instance) => <String, dynamic> {
  'success': boolToString(instance.success),
  'result_code': intToString(instance.resultCode),
  'auth_code': instance.authCode,
  'user_id': instance.userId,
};