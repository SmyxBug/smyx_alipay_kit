part of 'ali_resp.dart';

AliResp _$AliRespFromJson(Map json) {
  return AliResp(
    resultStatus: intFromString(json['resultStatus'] as String),
    result: json['result'] as String,
    memo: json['memo'] as String,
  );
}

Map<String, dynamic> _$AliRespToJson(AliResp instance) => <String, dynamic>{
  'resultStatus': intToString(instance.resultStatus),
  'result': instance.result,
  'memo': instance.memo,
};