// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_tencent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountTencentModel _$AccountTencentModelFromJson(Map<String, dynamic> json) {
  return AccountTencentModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..userid = json['userid'] as String
    ..txUserid = json['txUserid'] as String
    ..txUsersig = json['txUsersig'] as String;
}

Map<String, dynamic> _$AccountTencentModelToJson(
        AccountTencentModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'userid': instance.userid,
      'txUserid': instance.txUserid,
      'txUsersig': instance.txUsersig,
    };
