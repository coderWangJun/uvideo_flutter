// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyVideoModel _$CompanyVideoModelFromJson(Map<String, dynamic> json) {
  return CompanyVideoModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..userid = json['userid'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..ossName = json['ossName'] as String
    ..worksName = json['worksName'] as String
    ..worksUrl = json['worksUrl'] as String
    ..ossCoverName = json['ossCoverName'] as String
    ..coverName = json['coverName'] as String
    ..coverUrl = json['coverUrl'] as String
    ..title = json['title'] as String
    ..details = json['details'] as String
    ..companyName = json['companyName'] as String
    ..industryNo = json['industryNo'] as int
    ..industryName = json['industryName'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..hidden = json['hidden'] as int
    ..selected = json['selected'] as bool;
}

Map<String, dynamic> _$CompanyVideoModelToJson(CompanyVideoModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'userid': instance.userid,
      'headPortraitUrl': instance.headPortraitUrl,
      'ossName': instance.ossName,
      'worksName': instance.worksName,
      'worksUrl': instance.worksUrl,
      'ossCoverName': instance.ossCoverName,
      'coverName': instance.coverName,
      'coverUrl': instance.coverUrl,
      'title': instance.title,
      'details': instance.details,
      'companyName': instance.companyName,
      'industryNo': instance.industryNo,
      'industryName': instance.industryName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'hidden': instance.hidden,
      'selected': instance.selected,
    };
