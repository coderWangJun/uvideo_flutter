// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleMemberModel _$CircleMemberModelFromJson(Map<String, dynamic> json) {
  return CircleMemberModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..userid = json['userid'] as String
    ..marketTypeId = json['marketTypeId'] as int
    ..marketCircleId = json['marketCircleId'] as int
    ..name = json['name'] as String
    ..phonenumber = json['phonenumber'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..companyName = json['companyName'] as String
    ..companyJob = json['companyJob'] as String
    ..memberLevel = json['memberLevel'] as int
    ..distanceDouble = (json['distanceDouble'] as num)?.toDouble()
    ..distanceString = json['distanceString'] as String;
}

Map<String, dynamic> _$CircleMemberModelToJson(CircleMemberModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'userid': instance.userid,
      'marketTypeId': instance.marketTypeId,
      'marketCircleId': instance.marketCircleId,
      'name': instance.name,
      'phonenumber': instance.phonenumber,
      'headPortraitUrl': instance.headPortraitUrl,
      'companyName': instance.companyName,
      'companyJob': instance.companyJob,
      'memberLevel': instance.memberLevel,
      'distanceDouble': instance.distanceDouble,
      'distanceString': instance.distanceString,
    };
