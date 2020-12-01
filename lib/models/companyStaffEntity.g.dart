// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyStaffEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyStaffEntity _$CompanyStaffEntityFromJson(Map<String, dynamic> json) {
  return CompanyStaffEntity()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..userid = json['userid'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..sex = json['sex'] as int
    ..sexName = json['sexName'] as String
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..position = json['position'] as String;
}

Map<String, dynamic> _$CompanyStaffEntityToJson(CompanyStaffEntity instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'userid': instance.userid,
      'headPortraitUrl': instance.headPortraitUrl,
      'sex': instance.sex,
      'sexName': instance.sexName,
      'name': instance.name,
      'email': instance.email,
      'position': instance.position,
    };
