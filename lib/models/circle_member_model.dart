import 'package:json_annotation/json_annotation.dart';


part 'circle_member_model.g.dart';

@JsonSerializable()
class CircleMemberModel {
      CircleMemberModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String userid;
  int marketTypeId;
  int marketCircleId;
  String name;
  String phonenumber;
  String headPortraitUrl;
  String companyName;
  String companyJob;
  int memberLevel;
  double distanceDouble;
  String distanceString;

  factory CircleMemberModel.fromJson(Map<String,dynamic> json) => _$CircleMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$CircleMemberModelToJson(this);
}
