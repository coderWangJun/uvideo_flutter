// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_detail_master_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleDetailMasterModel _$CircleDetailMasterModelFromJson(
    Map<String, dynamic> json) {
  return CircleDetailMasterModel()
    ..id = json['id'] as String
    ..nickname = json['nickname'] as String
    ..realname = json['realname'] as String
    ..phonenumber = json['phonenumber'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String;
}

Map<String, dynamic> _$CircleDetailMasterModelToJson(
        CircleDetailMasterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'realname': instance.realname,
      'phonenumber': instance.phonenumber,
      'headPortraitUrl': instance.headPortraitUrl,
    };
