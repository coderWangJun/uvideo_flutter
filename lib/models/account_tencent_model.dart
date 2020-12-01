import 'package:json_annotation/json_annotation.dart';


part 'account_tencent_model.g.dart';

@JsonSerializable()
class AccountTencentModel {
      AccountTencentModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String userid;
  String txUserid;
  String txUsersig;

  factory AccountTencentModel.fromJson(Map<String,dynamic> json) => _$AccountTencentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountTencentModelToJson(this);
}
