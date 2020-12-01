import 'package:json_annotation/json_annotation.dart';
import 'user_statistic_model.dart';

part 'other_user_model.g.dart';

@JsonSerializable()
class OtherUserModel {
      OtherUserModel();

  String headPortraitUrl;
  String name;
  int type;
  int level;
  String companyName;
  String positionName;
  String tags;
  int isCared;
  String txUserid;
  UserStatisticModel countMap;

  factory OtherUserModel.fromJson(Map<String,dynamic> json) => _$OtherUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$OtherUserModelToJson(this);
}
