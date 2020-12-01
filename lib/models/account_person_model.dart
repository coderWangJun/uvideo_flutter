import 'package:json_annotation/json_annotation.dart';


part 'account_person_model.g.dart';

@JsonSerializable()
class AccountPersonModel {
      AccountPersonModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String id;
  String phonenumber;
  String realname;
  String nickname;
  String tags;
  String birthday;
  int roleId;
  String roleName;
  int cityNo;
  String cityName;
  int areaNo;
  String areaName;
  String startWorkingTime;
  String tXIMUser;
  String headPortraitUrl;
  double ucoinAmount;
  int sexId;
  String sexName;
  String positionName;
  String companyName;
  int positionNo;
  int jobStatusId;
  String jobStatusName;
  int eduId;
  String eduName;
  int typeId;
  String typeName;
  String username;
  String email;
  int startTime;

  factory AccountPersonModel.fromJson(Map<String,dynamic> json) => _$AccountPersonModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountPersonModelToJson(this);
}
