import 'package:json_annotation/json_annotation.dart';


part 'resume_video_model.g.dart';

@JsonSerializable()
class ResumeVideoModel {
      ResumeVideoModel();

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
  String title;
  String introduction;
  int minSalary;
  int maxSalary;
  String salaryTreatmentString;
  int positionNo;
  String positionName;
  int cityNo;
  String cityName;
  double longitude;
  double latitude;
  double distanceDouble;
  String distanceString;
  int locked;
  int isLiked;
  int likes;
  int numberOfComments;
  int numberOfForwarding;
  int hidden;
  String realname;
  String nickname;
  String eduName;
  String phonenumber;
  int workingYears;
  String headPortraitUrl;
  bool selected;

  factory ResumeVideoModel.fromJson(Map<String,dynamic> json) => _$ResumeVideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResumeVideoModelToJson(this);
}
