import 'package:json_annotation/json_annotation.dart';


part 'short_video_model.g.dart';

@JsonSerializable()
class ShortVideoModel {
      ShortVideoModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  int id;
  String userid;
  String ossName;
  String worksName;
  String worksUrl;
  String ossCoverName;
  String coverName;
  String coverUrl;
  int likes;
  int numberOfComments;
  int numberOfForwarding;
  String title;
  String content;
  double longitude;
  double latitude;
  double distance;
  int isLiked;
  int hadBought;
  int locked;
  int positionNo;
  String positionName;
  String skillTags;
  int needUcoin;
  double ucoinAmount;
  int freeSeconds;
  String name;
  String nickname;
  String realname;
  String phonenumber;
  int type;
  String typeName;
  String headPortraitUrl;
  bool selected;

  factory ShortVideoModel.fromJson(Map<String,dynamic> json) => _$ShortVideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShortVideoModelToJson(this);
}
