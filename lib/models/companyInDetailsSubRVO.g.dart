// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyInDetailsSubRVO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyInDetailsSubRVO _$CompanyInDetailsSubRVOFromJson(
    Map<String, dynamic> json) {
  return CompanyInDetailsSubRVO()
    ..logoUrl = json['logoUrl'] as String
    ..financingStageName = json['financingStageName'] as String
    ..staffScaleName = json['staffScaleName'] as String
    ..industryName = json['industryName'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble();
}

Map<String, dynamic> _$CompanyInDetailsSubRVOToJson(
        CompanyInDetailsSubRVO instance) =>
    <String, dynamic>{
      'logoUrl': instance.logoUrl,
      'financingStageName': instance.financingStageName,
      'staffScaleName': instance.staffScaleName,
      'industryName': instance.industryName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
