// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherUserModel _$OtherUserModelFromJson(Map<String, dynamic> json) {
  return OtherUserModel()
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..name = json['name'] as String
    ..type = json['type'] as int
    ..level = json['level'] as int
    ..companyName = json['companyName'] as String
    ..positionName = json['positionName'] as String
    ..tags = json['tags'] as String
    ..isCared = json['isCared'] as int
    ..txUserid = json['txUserid'] as String
    ..countMap = json['countMap'] == null
        ? null
        : UserStatisticModel.fromJson(json['countMap'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OtherUserModelToJson(OtherUserModel instance) =>
    <String, dynamic>{
      'headPortraitUrl': instance.headPortraitUrl,
      'name': instance.name,
      'type': instance.type,
      'level': instance.level,
      'companyName': instance.companyName,
      'positionName': instance.positionName,
      'tags': instance.tags,
      'isCared': instance.isCared,
      'txUserid': instance.txUserid,
      'countMap': instance.countMap,
    };
