// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountCompanyModel _$AccountCompanyModelFromJson(Map<String, dynamic> json) {
  return AccountCompanyModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as String
    ..phonenumber = json['phonenumber'] as String
    ..logoUrl = json['logoUrl'] as String
    ..companyName = json['companyName'] as String
    ..fullName = json['fullName'] as String
    ..industryNo = json['industryNo'] as int
    ..industryName = json['industryName'] as String
    ..financingStageNo = json['financingStageNo'] as int
    ..financingStageName = json['financingStageName'] as String
    ..staffScaleNo = json['staffScaleNo'] as int
    ..staffScaleName = json['staffScaleName'] as String
    ..officialWebsite = json['officialWebsite'] as String
    ..introduce = json['introduce'] as String
    ..completeness = json['completeness'] as String
    ..legalPerson = json['legalPerson'] as String
    ..registrationTime = json['registrationTime'] as String
    ..registeredCapital = json['registeredCapital'] as String
    ..businessStatusNo = json['businessStatusNo'] as int
    ..businessStatusName = json['businessStatusName'] as String
    ..registeredAddress = json['registeredAddress'] as String
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..address = json['address'] as String
    ..unifiedCreditCode = json['unifiedCreditCode'] as String
    ..businessScope = json['businessScope'] as String
    ..goToWorkTime = json['goToWorkTime'] as String
    ..goOffWorkTime = json['goOffWorkTime'] as String
    ..restPatternNo = json['restPatternNo'] as int
    ..restPatternName = json['restPatternName'] as String
    ..isWorkOvertimeNo = json['isWorkOvertimeNo'] as int
    ..isWorkOvertimeName = json['isWorkOvertimeName'] as String
    ..benefitsTags = json['benefitsTags'] as String
    ..typeId = json['typeId'] as int
    ..typeName = json['typeName'] as String
    ..username = json['username'] as String
    ..email = json['email'] as String;
}

Map<String, dynamic> _$AccountCompanyModelToJson(
        AccountCompanyModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'phonenumber': instance.phonenumber,
      'logoUrl': instance.logoUrl,
      'companyName': instance.companyName,
      'fullName': instance.fullName,
      'industryNo': instance.industryNo,
      'industryName': instance.industryName,
      'financingStageNo': instance.financingStageNo,
      'financingStageName': instance.financingStageName,
      'staffScaleNo': instance.staffScaleNo,
      'staffScaleName': instance.staffScaleName,
      'officialWebsite': instance.officialWebsite,
      'introduce': instance.introduce,
      'completeness': instance.completeness,
      'legalPerson': instance.legalPerson,
      'registrationTime': instance.registrationTime,
      'registeredCapital': instance.registeredCapital,
      'businessStatusNo': instance.businessStatusNo,
      'businessStatusName': instance.businessStatusName,
      'registeredAddress': instance.registeredAddress,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'address': instance.address,
      'unifiedCreditCode': instance.unifiedCreditCode,
      'businessScope': instance.businessScope,
      'goToWorkTime': instance.goToWorkTime,
      'goOffWorkTime': instance.goOffWorkTime,
      'restPatternNo': instance.restPatternNo,
      'restPatternName': instance.restPatternName,
      'isWorkOvertimeNo': instance.isWorkOvertimeNo,
      'isWorkOvertimeName': instance.isWorkOvertimeName,
      'benefitsTags': instance.benefitsTags,
      'typeId': instance.typeId,
      'typeName': instance.typeName,
      'username': instance.username,
      'email': instance.email,
    };
