// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatisticModel _$UserStatisticModelFromJson(Map<String, dynamic> json) {
  return UserStatisticModel()
    ..circleCount = json['circleCount'] as int
    ..careCount = json['careCount'] as int
    ..registDays = json['registDays'] as int
    ..collectCount = json['collectCount'] as int
    ..fansCount = json['fansCount'] as int
    ..friendsCount = json['friendsCount'] as int
    ..likeCount = json['likeCount'] as int
    ..onlineJobCount = json['onlineJobCount'] as int
    ..workExpCount = json['workExpCount'] as int
    ..deliveryCount = json['deliveryCount'] as int
    ..effectScore = json['effectScore'] as int
    ..honestyScore = json['honestyScore'] as int
    ..assetsScore = (json['assetsScore'] as num)?.toDouble();
}

Map<String, dynamic> _$UserStatisticModelToJson(UserStatisticModel instance) =>
    <String, dynamic>{
      'circleCount': instance.circleCount,
      'careCount': instance.careCount,
      'registDays': instance.registDays,
      'collectCount': instance.collectCount,
      'fansCount': instance.fansCount,
      'friendsCount': instance.friendsCount,
      'likeCount': instance.likeCount,
      'onlineJobCount': instance.onlineJobCount,
      'workExpCount': instance.workExpCount,
      'deliveryCount': instance.deliveryCount,
      'effectScore': instance.effectScore,
      'honestyScore': instance.honestyScore,
      'assetsScore': instance.assetsScore,
    };
