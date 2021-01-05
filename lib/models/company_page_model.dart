import 'package:json_annotation/json_annotation.dart';
import 'account_tencent_model.dart';
import 'account_person_model.dart';
import 'account_company_model.dart';


@JsonSerializable()
class CompanyPageModel {
  CompanyPageModel();

  String id;
  String companyName;
  String financingStageName;
  String staffScaleName;
  String logoUrl;
  String address;



  factory CompanyPageModel.fromJson(Map<String, dynamic> json) => CompanyPageModel()
    ..id = json['id'] as String
    ..financingStageName = json['financingStageName'] as String
    ..staffScaleName = json['staffScaleName'] as String
    ..companyName = json['companyName'] as String
    ..address = json['address'] as String
    ..logoUrl = json['logoUrl'] as String;

  Map<String, dynamic> toJson() => _$CompanyPageModelToJson(this);

  Map<String, dynamic> _$CompanyPageModelToJson(CompanyPageModel instance) => <String, dynamic>{
        'id': instance.id,
        'companyName': instance.companyName,
        'financingStageName': instance.financingStageName,
        'staffScaleName': instance.staffScaleName,
        'logoUrl': instance.logoUrl,
        'address': instance.address,

      };
}
