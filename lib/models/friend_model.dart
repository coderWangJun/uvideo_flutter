import 'package:json_annotation/json_annotation.dart';


part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
      FriendModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String userid;
  String userHeadPortrait;
  String nickname;
  String realname;
  String phonenumber;
  int typeId;
  String typeName;
  String targetUserid;
  String targetUserHeadPortrait;
  String targetNickname;
  String targetRealname;
  String targetPhonenumber;
  int targetTypeId;
  String targetTypeName;
  bool careEachother;

  factory FriendModel.fromJson(Map<String,dynamic> json) => _$FriendModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}
