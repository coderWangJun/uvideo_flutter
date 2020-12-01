// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketCircleModel _$MarketCircleModelFromJson(Map<String, dynamic> json) {
  return MarketCircleModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..circleName = json['circleName'] as String
    ..marketTypeId = json['marketTypeId'] as int
    ..marketSubTypeId = json['marketSubTypeId'] as int
    ..shortContent = json['shortContent'] as String
    ..content = json['content'] as String
    ..logoUrl = json['logoUrl'] as String
    ..cityNo = json['cityNo'] as String
    ..cityName = json['cityName'] as String
    ..isJoined = json['isJoined'] as bool
    ..countOfPeople = json['countOfPeople'] as int
    ..countOfMarket = json['countOfMarket'] as int;
}

Map<String, dynamic> _$MarketCircleModelToJson(MarketCircleModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'circleName': instance.circleName,
      'marketTypeId': instance.marketTypeId,
      'marketSubTypeId': instance.marketSubTypeId,
      'shortContent': instance.shortContent,
      'content': instance.content,
      'logoUrl': instance.logoUrl,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'isJoined': instance.isJoined,
      'countOfPeople': instance.countOfPeople,
      'countOfMarket': instance.countOfMarket,
    };
