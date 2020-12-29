// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel()
    ..id = json['id'] as String
    ..phonenumber = json['phonenumber'] as String
    ..typeId = json['typeId'] as int
    ..typeName = json['typeName'] as String
    ..tXIMUser = json['tXIMUser'] == null
        ? null
        : AccountTencentModel.fromJson(json['tXIMUser'] as Map<String, dynamic>)
    ..ucoinAmount = (json['ucoinAmount'] as num)?.toDouble()
    ..token = json['token'] as String
    ..isSetPwd = json['isSetPwd'] as int
    ..userData = json['userData'] == null
        ? null
        : AccountPersonModel.fromJson(json['userData'] as Map<String, dynamic>)
    ..companyData = json['companyData'] == null
        ? null
        : AccountCompanyModel.fromJson(
            json['companyData'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phonenumber': instance.phonenumber,
      'typeId': instance.typeId,
      'typeName': instance.typeName,
      'tXIMUser': instance.tXIMUser,
      'ucoinAmount': instance.ucoinAmount,
      'token': instance.token,
      'userData': instance.userData,
      'companyData': instance.companyData,
      'isSetPwd': instance.isSetPwd,
    };
