import 'package:json_annotation/json_annotation.dart';


part 'account_company_model.g.dart';

@JsonSerializable()
class AccountCompanyModel {
      AccountCompanyModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String id;
  String phonenumber;
  String logoUrl;
  String companyName;
  String fullName;
  int industryNo;
  String industryName;
  int financingStageNo;
  String financingStageName;
  int staffScaleNo;
  String staffScaleName;
  String officialWebsite;
  String introduce;
  String completeness;
  String legalPerson;
  String registrationTime;
  String registeredCapital;
  int businessStatusNo;
  String businessStatusName;
  String registeredAddress;
  double longitude;
  double latitude;
  String address;
  String unifiedCreditCode;
  String businessScope;
  String goToWorkTime;
  String goOffWorkTime;
  int restPatternNo;
  String restPatternName;
  int isWorkOvertimeNo;
  String isWorkOvertimeName;
  String benefitsTags;
  int typeId;
  String typeName;
  String username;
  String email;

  factory AccountCompanyModel.fromJson(Map<String,dynamic> json) => _$AccountCompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountCompanyModelToJson(this);
}
