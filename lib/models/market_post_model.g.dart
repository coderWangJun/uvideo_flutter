// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketPostModel _$MarketPostModelFromJson(Map<String, dynamic> json) {
  return MarketPostModel()
    ..createdBy = json['created_by'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updated_by'] as String
    ..updatedTime = json['updated_time'] as String
    ..id = json['id'] as int
    ..userid = json['userid'] as String
    ..publishTypeId = json['publishTypeId'] as int
    ..title = json['title'] as String
    ..content = json['content'] as String
    ..picUrl = json['picUrl'] as String
    ..keywords = json['keywords'] as String
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..numberOfForwarding = json['numberOfForwarding'] as int
    ..replyCount = json['replyCount'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..distance = json['distance'] as String
    ..isLiked = json['isLiked'] as int
    ..cityName = json['cityName'] as String
    ..rewarded = json['rewarded'] as int
    ..marketWorksList = (json['marketWorksList'] as List)
        ?.map((e) => e == null
            ? null
            : MarketPostMediaModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..marketTypeId = json['marketTypeId'] as int
    ..marketTypeName = json['marketTypeName'] as String
    ..marketCircleId = json['marketCircleId'] as int
    ..marketCircleName = json['marketCircleName'] as String
    ..ucoinAmount = (json['ucoinAmount'] as num)?.toDouble()
    ..name = json['name'] as String
    ..type = json['type'] as int
    ..typeName = json['typeName'] as String
    ..companyName = json['companyName'] as String
    ..headPortraitUrl = json['headPortraitUrl'] as String;
}

Map<String, dynamic> _$MarketPostModelToJson(MarketPostModel instance) =>
    <String, dynamic>{
      'created_by': instance.createdBy,
      'createdTime': instance.createdTime,
      'updated_by': instance.updatedBy,
      'updated_time': instance.updatedTime,
      'id': instance.id,
      'userid': instance.userid,
      'publishTypeId': instance.publishTypeId,
      'title': instance.title,
      'content': instance.content,
      'picUrl': instance.picUrl,
      'keywords': instance.keywords,
      'likes': instance.likes,
      'cityName': instance.cityName,
      'numberOfComments': instance.numberOfComments,
      'numberOfForwarding': instance.numberOfForwarding,
      'replyCount': instance.replyCount,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'rewarded': instance.rewarded,
      'distance': instance.distance,
      'isLiked': instance.isLiked,
      'marketWorksList': instance.marketWorksList,
      'marketTypeId': instance.marketTypeId,
      'marketTypeName': instance.marketTypeName,
      'marketCircleId': instance.marketCircleId,
      'marketCircleName': instance.marketCircleName,
      'ucoinAmount': instance.ucoinAmount,
      'name': instance.name,
      'type': instance.type,
      'typeName': instance.typeName,
      'companyName': instance.companyName,
      'headPortraitUrl': instance.headPortraitUrl,
    };
