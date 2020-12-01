// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortVideoModel _$ShortVideoModelFromJson(Map<String, dynamic> json) {
  return ShortVideoModel()
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
    ..distance = (json['distance'] as num)?.toDouble()
    ..isLiked = json['isLiked'] as int
    ..hadBought = json['hadBought'] as int
    ..locked = json['locked'] as int
    ..positionNo = json['positionNo'] as int
    ..positionName = json['positionName'] as String
    ..skillTags = json['skillTags'] as String
    ..needUcoin = json['needUcoin'] as int
    ..ucoinAmount = (json['ucoinAmount'] as num)?.toDouble()
    ..freeSeconds = json['freeSeconds'] as int
    ..name = json['name'] as String
    ..nickname = json['nickname'] as String
    ..realname = json['realname'] as String
    ..phonenumber = json['phonenumber'] as String
    ..type = json['type'] as int
    ..typeName = json['typeName'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String
    ..selected = json['selected'] as bool;
}

Map<String, dynamic> _$ShortVideoModelToJson(ShortVideoModel instance) =>
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
      'hadBought': instance.hadBought,
      'locked': instance.locked,
      'positionNo': instance.positionNo,
      'positionName': instance.positionName,
      'skillTags': instance.skillTags,
      'needUcoin': instance.needUcoin,
      'ucoinAmount': instance.ucoinAmount,
      'freeSeconds': instance.freeSeconds,
      'name': instance.name,
      'nickname': instance.nickname,
      'realname': instance.realname,
      'phonenumber': instance.phonenumber,
      'type': instance.type,
      'typeName': instance.typeName,
      'headPortraitUrl': instance.headPortraitUrl,
      'selected': instance.selected,
    };
