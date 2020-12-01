// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResumeModel _$HomeResumeModelFromJson(Map<String, dynamic> json) {
  return HomeResumeModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..userid = json['userid'] as String
    ..ossName = json['ossName'] as String
    ..worksName = json['worksName'] as String
    ..worksUrl = json['worksUrl'] as String
    ..ossCoverName = json['ossCoverName'] as String
    ..coverName = json['coverName'] as String
    ..coverUrl = json['coverUrl'] as String
    ..title = json['title'] as String
    ..introduction = json['introduction'] as String
    ..minSalary = json['minSalary'] as int
    ..maxSalary = json['maxSalary'] as int
    ..skillTags = json['skillTags'] as String
    ..salaryTreatmentString = json['salaryTreatmentString'] as String
    ..positionNo = json['positionNo'] as int
    ..positionName = json['positionName'] as String
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..distanceDouble = (json['distanceDouble'] as num)?.toDouble()
    ..distanceString = json['distanceString'] as String
    ..locked = json['locked'] as int
    ..isLiked = json['isLiked'] as int
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..numberOfForwarding = json['numberOfForwarding'] as int
    ..hidden = json['hidden'] as int
    ..realname = json['realname'] as String
    ..nickname = json['nickname'] as String
    ..eduName = json['eduName'] as String
    ..phonenumber = json['phonenumber'] as String
    ..workingYears = json['workingYears'] as int
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..selected = json['selected'] as bool;
}

Map<String, dynamic> _$HomeResumeModelToJson(HomeResumeModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'userid': instance.userid,
      'ossName': instance.ossName,
      'worksName': instance.worksName,
      'worksUrl': instance.worksUrl,
      'ossCoverName': instance.ossCoverName,
      'coverName': instance.coverName,
      'coverUrl': instance.coverUrl,
      'title': instance.title,
      'introduction': instance.introduction,
      'minSalary': instance.minSalary,
      'maxSalary': instance.maxSalary,
      'skillTags': instance.skillTags,
      'salaryTreatmentString': instance.salaryTreatmentString,
      'positionNo': instance.positionNo,
      'positionName': instance.positionName,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'distanceDouble': instance.distanceDouble,
      'distanceString': instance.distanceString,
      'locked': instance.locked,
      'isLiked': instance.isLiked,
      'likes': instance.likes,
      'numberOfComments': instance.numberOfComments,
      'numberOfForwarding': instance.numberOfForwarding,
      'hidden': instance.hidden,
      'realname': instance.realname,
      'nickname': instance.nickname,
      'eduName': instance.eduName,
      'phonenumber': instance.phonenumber,
      'workingYears': instance.workingYears,
      'headPortraitUrl': instance.headPortraitUrl,
      'selected': instance.selected,
    };
