// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showreel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowreelModel _$ShowreelModelFromJson(Map<String, dynamic> json) {
  return ShowreelModel()
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
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..numberOfForwarding = json['numberOfForwarding'] as int
    ..title = json['title'] as String
    ..content = json['content'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..distance = json['distance'] as int
    ..isLiked = json['isLiked'] as int
    ..locked = json['locked'] as int
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..nickname = json['nickname'] as String
    ..realname = json['realname'] as String
    ..phonenumber = json['phonenumber'] as String
    ..type = json['type'] as int
    ..typeName = json['typeName'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String;
}

Map<String, dynamic> _$ShowreelModelToJson(ShowreelModel instance) =>
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
      'likes': instance.likes,
      'numberOfComments': instance.numberOfComments,
      'numberOfForwarding': instance.numberOfForwarding,
      'title': instance.title,
      'content': instance.content,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'distance': instance.distance,
      'isLiked': instance.isLiked,
      'locked': instance.locked,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'nickname': instance.nickname,
      'realname': instance.realname,
      'phonenumber': instance.phonenumber,
      'type': instance.type,
      'typeName': instance.typeName,
      'headPortraitUrl': instance.headPortraitUrl,
    };
