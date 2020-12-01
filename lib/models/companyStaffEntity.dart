import 'package:json_annotation/json_annotation.dart';


part 'companyStaffEntity.g.dart';

@JsonSerializable()
class CompanyStaffEntity {
      CompanyStaffEntity();

  String createdBy;
  String createdTime;
  String userid;
  String headPortraitUrl;
  int sex;
  String sexName;
  String name;
  String email;
  String position;

  factory CompanyStaffEntity.fromJson(Map<String,dynamic> json) => _$CompanyStaffEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyStaffEntityToJson(this);
}
