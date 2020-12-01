// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleDetailModel _$CircleDetailModelFromJson(Map<String, dynamic> json) {
  return CircleDetailModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..marketCircleLeaderEntity = json['marketCircleLeaderEntity'] == null
        ? null
        : CircleDetailMasterModel.fromJson(
            json['marketCircleLeaderEntity'] as Map<String, dynamic>)
    ..id = json['id'] as int
    ..circleName = json['circleName'] as String
    ..marketTypeId = json['marketTypeId'] as int
    ..marketSubTypeId = json['marketSubTypeId'] as int
    ..shortContent = json['shortContent'] as String
    ..content = json['content'] as String
    ..logoUrl = json['logoUrl'] as String
    ..cityNo = json['cityNo'] as int
    ..cityName = json['cityName'] as String
    ..isJoined = json['isJoined'] as bool
    ..countOfPeople = json['countOfPeople'] as int
    ..countOfMarket = json['countOfMarket'] as int;
}

Map<String, dynamic> _$CircleDetailModelToJson(CircleDetailModel instance) =>
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
      'shortContent': instance.shortContent,
      'content': instance.content,
      'logoUrl': instance.logoUrl,
      'cityNo': instance.cityNo,
      'cityName': instance.cityName,
      'isJoined': instance.isJoined,
      'countOfPeople': instance.countOfPeople,
      'countOfMarket': instance.countOfMarket,
    };
