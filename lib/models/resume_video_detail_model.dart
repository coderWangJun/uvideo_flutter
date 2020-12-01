import 'package:json_annotation/json_annotation.dart';


part 'resume_video_detail_model.g.dart';

@JsonSerializable()
class ResumeVideoDetailModel {
      ResumeVideoDetailModel();

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
  String industryNo;
  String industryName;
  int positionNo;
  String positionName;
  int cityNo;
  String cityName;
  int longitude;
  int latitude;
  int distanceDouble;
  String distanceString;
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

  factory ResumeVideoDetailModel.fromJson(Map<String,dynamic> json) => _$ResumeVideoDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResumeVideoDetailModelToJson(this);
}
