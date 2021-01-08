import 'package:json_annotation/json_annotation.dart';
import 'account_tencent_model.dart';
import 'account_person_model.dart';
import 'account_company_model.dart';


@JsonSerializable()
class CompanyTrilerModel {
  CompanyTrilerModel();

  int id;
  String companyName;
  String financingStageName;
  String staffScaleName;
  String logoUrl;
  String address;
  String worksUrl;
  String details;



  factory CompanyTrilerModel.fromJson(Map<String, dynamic> json) => CompanyTrilerModel()
    ..id = json['id'] as int
    ..financingStageName = json['financingStageName'] as String
    ..staffScaleName = json['staffScaleName'] as String
    ..companyName = json['companyName'] as String
    ..address = json['address'] as String
    ..worksUrl = json['worksUrl'] as String
    ..details = json['details'] as String
    ..logoUrl = json['logoUrl'] as String;

  Map<String, dynamic> toJson() => _$CompanyTrilerModelToJson(this);

  Map<String, dynamic> _$CompanyTrilerModelToJson(CompanyTrilerModel instance) => <String, dynamic>{
        'id': instance.id,
        'companyName': instance.companyName,
        'financingStageName': instance.financingStageName,
        'staffScaleName': instance.staffScaleName,
        'logoUrl': instance.logoUrl,
        'worksUrl': instance.worksUrl,
        'details': instance.details,
        'address': instance.address,

      };
}
