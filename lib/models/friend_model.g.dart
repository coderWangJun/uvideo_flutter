// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) {
  return FriendModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..userid = json['userid'] as String
    ..userHeadPortrait = json['userHeadPortrait'] as String
    ..nickname = json['nickname'] as String
    ..realname = json['realname'] as String
    ..phonenumber = json['phonenumber'] as String
    ..typeId = json['typeId'] as int
    ..typeName = json['typeName'] as String
    ..targetUserid = json['targetUserid'] as String
    ..targetUserHeadPortrait = json['targetUserHeadPortrait'] as String
    ..targetNickname = json['targetNickname'] as String
    ..targetRealname = json['targetRealname'] as String
    ..targetPhonenumber = json['targetPhonenumber'] as String
    ..targetTypeId = json['targetTypeId'] as int
    ..targetTypeName = json['targetTypeName'] as String
    ..careEachother = json['careEachother'] as bool;
}

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'userid': instance.userid,
      'userHeadPortrait': instance.userHeadPortrait,
      'nickname': instance.nickname,
      'realname': instance.realname,
      'phonenumber': instance.phonenumber,
      'typeId': instance.typeId,
      'typeName': instance.typeName,
      'targetUserid': instance.targetUserid,
      'targetUserHeadPortrait': instance.targetUserHeadPortrait,
      'targetNickname': instance.targetNickname,
      'targetRealname': instance.targetRealname,
      'targetPhonenumber': instance.targetPhonenumber,
      'targetTypeId': instance.targetTypeId,
      'targetTypeName': instance.targetTypeName,
      'careEachother': instance.careEachother,
    };
