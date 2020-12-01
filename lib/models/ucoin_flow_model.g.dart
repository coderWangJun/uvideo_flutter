// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ucoin_flow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UcoinFlowModel _$UcoinFlowModelFromJson(Map<String, dynamic> json) {
  return UcoinFlowModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..userid = json['userid'] as String
    ..tradeFrom = json['tradeFrom'] as int
    ..tradeType = json['tradeType'] as int
    ..tradeAmount = (json['tradeAmount'] as num)?.toDouble()
    ..balance = (json['balance'] as num)?.toDouble();
}

Map<String, dynamic> _$UcoinFlowModelToJson(UcoinFlowModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'userid': instance.userid,
      'tradeFrom': instance.tradeFrom,
      'tradeType': instance.tradeType,
      'tradeAmount': instance.tradeAmount,
      'balance': instance.balance,
    };
