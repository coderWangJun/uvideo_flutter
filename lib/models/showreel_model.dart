import 'package:json_annotation/json_annotation.dart';


part 'showreel_model.g.dart';

@JsonSerializable()
class ShowreelModel {
      ShowreelModel();

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
  int distance;
  int isLiked;
  int locked;
  int cityNo;
  String cityName;
  String nickname;
  String realname;
  String phonenumber;
  int type;
  String typeName;
  String headPortraitUrl;

  factory ShowreelModel.fromJson(Map<String,dynamic> json) => _$ShowreelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowreelModelToJson(this);
}
