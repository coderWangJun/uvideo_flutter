// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'industry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndustryModel _$IndustryModelFromJson(Map<String, dynamic> json) {
  return IndustryModel()
    ..pinyin = json['pinyin'] as String
    ..sname = json['sname'] as String
    ..name = json['name'] as String
    ..id = json['id'] as int
    ..circleName = json['circleName'] as String;
}

Map<String, dynamic> _$IndustryModelToJson(IndustryModel instance) =>
    <String, dynamic>{
      'pinyin': instance.pinyin,
      'sname': instance.sname,
      'name': instance.name,
      'id': instance.id,
      'circleName': instance.circleName,
    };
