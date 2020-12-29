import 'package:json_annotation/json_annotation.dart';
import 'account_tencent_model.dart';
import 'account_person_model.dart';
import 'account_company_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  AccountModel();

  String id;
  String phonenumber;
  int typeId;
  String typeName;
  AccountTencentModel tXIMUser;
  double ucoinAmount;
  String token;
  String isSetPwd;
  AccountPersonModel userData;
  AccountCompanyModel companyData;

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
