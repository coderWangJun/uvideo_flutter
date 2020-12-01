// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleModel _$CircleModelFromJson(Map<String, dynamic> json) {
  return CircleModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..marketCircleLeaderEntity = json['marketCircleLeaderEntity']
    ..id = json['id'] as int
    ..circleName = json['circleName'] as String
    ..marketTypeId = json['marketTypeId'] as int
    ..marketSubTypeId = json['marketSubTypeId'] as int
    ..content = json['content'] as String
    ..logoUrl = json['logoUrl'] as String
    ..isJoined = json['isJoined'] as bool
    ..countOfPeople = json['countOfPeople'] as int
    ..countOfMarket = json['countOfMarket'] as int;
}

Map<String, dynamic> _$CircleModelToJson(CircleModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'marketCircleLeaderEntity': instance.marketCircleLeaderEntity,
      'id': instance.id,
      'circleName': instance.circleName,
      'marketTypeId': instance.marketTypeId,
      'marketSubTypeId': instance.marketSubTypeId,
      'content': instance.content,
      'logoUrl': instance.logoUrl,
      'isJoined': instance.isJoined,
      'countOfPeople': instance.countOfPeople,
      'countOfMarket': instance.countOfMarket,
    };
