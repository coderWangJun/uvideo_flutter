// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountPersonModel _$AccountPersonModelFromJson(Map<String, dynamic> json) {
  return AccountPersonModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as String
    ..phonenumber = json['phonenumber'] as String
    ..realname = json['realname'] as String
    ..nickname = json['nickname'] as String
    ..tags = json['tags'] as String
    ..birthday = json['birthday'] as String
    ..roleId = json['roleId'] as int
    ..roleName = json['roleName'] as String
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..areaNo = json['areaNo'] as int
    ..areaName = json['areaName'] as String
    ..startWorkingTime = json['startWorkingTime'] as String
    ..tXIMUser = json['tXIMUser'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..ucoinAmount = (json['ucoinAmount'] as num)?.toDouble()
    ..sexId = json['sexId'] as int
    ..sexName = json['sexName'] as String
    ..positionName = json['positionName'] as String
    ..companyName = json['companyName'] as String
    ..positionNo = json['positionNo'] as int
    ..jobStatusId = json['jobStatusId'] as int
    ..jobStatusName = json['jobStatusName'] as String
    ..eduId = json['eduId'] as int
    ..eduName = json['eduName'] as String
    ..typeId = json['typeId'] as int
    ..typeName = json['typeName'] as String
    ..username = json['username'] as String
    ..email = json['email'] as String
    ..startTime = json['startTime'] as int;
}

Map<String, dynamic> _$AccountPersonModelToJson(AccountPersonModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'phonenumber': instance.phonenumber,
      'realname': instance.realname,
      'nickname': instance.nickname,
      'tags': instance.tags,
      'birthday': instance.birthday,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'areaNo': instance.areaNo,
      'areaName': instance.areaName,
      'startWorkingTime': instance.startWorkingTime,
      'tXIMUser': instance.tXIMUser,
      'headPortraitUrl': instance.headPortraitUrl,
      'ucoinAmount': instance.ucoinAmount,
      'sexId': instance.sexId,
      'sexName': instance.sexName,
      'positionName': instance.positionName,
      'companyName': instance.companyName,
      'positionNo': instance.positionNo,
      'jobStatusId': instance.jobStatusId,
      'jobStatusName': instance.jobStatusName,
      'eduId': instance.eduId,
      'eduName': instance.eduName,
      'typeId': instance.typeId,
      'typeName': instance.typeName,
      'username': instance.username,
      'email': instance.email,
      'startTime': instance.startTime,
    };
