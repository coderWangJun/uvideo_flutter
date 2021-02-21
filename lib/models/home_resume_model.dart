import 'package:json_annotation/json_annotation.dart';


part 'home_resume_model.g.dart';

@JsonSerializable()
class HomeResumeModel {
      HomeResumeModel();

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
  String skillTags;
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
  int isCollect;
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

  factory HomeResumeModel.fromJson(Map<String,dynamic> json) => _$HomeResumeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeResumeModelToJson(this);
}
