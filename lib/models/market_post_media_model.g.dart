// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_post_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketPostMediaModel _$MarketPostMediaModelFromJson(Map<String, dynamic> json) {
  return MarketPostMediaModel()
    ..createdBy = json['created_by'] as String
    ..createdTime = json['created_time'] as String
    ..updatedBy = json['updated_by'] as String
    ..updatedTime = json['updated_time'] as String
    ..id = json['id'] as int
    ..ossName = json['ossName'] as String
    ..worksName = json['worksName'] as String
    ..worksUrl = json['worksUrl'] as String
    ..ossCoverName = json['ossCoverName'] as String
    ..coverName = json['coverName'] as String
    ..coverUrl = json['coverUrl'] as String;
}

Map<String, dynamic> _$MarketPostMediaModelToJson(
        MarketPostMediaModel instance) =>
    <String, dynamic>{
      'created_by': instance.createdBy,
      'created_time': instance.createdTime,
      'updated_by': instance.updatedBy,
      'updated_time': instance.updatedTime,
      'id': instance.id,
      'ossName': instance.ossName,
      'worksName': instance.worksName,
      'worksUrl': instance.worksUrl,
      'ossCoverName': instance.ossCoverName,
      'coverName': instance.coverName,
      'coverUrl': instance.coverUrl,
    };
