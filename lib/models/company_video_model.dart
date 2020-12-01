import 'package:json_annotation/json_annotation.dart';


part 'company_video_model.g.dart';

@JsonSerializable()
class CompanyVideoModel {
      CompanyVideoModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  int id;
  String userid;
  String headPortraitUrl;
  String ossName;
  String worksName;
  String worksUrl;
  String ossCoverName;
  String coverName;
  String coverUrl;
  String title;
  String details;
  String companyName;
  int industryNo;
  String industryName;
  double longitude;
  double latitude;
  int hidden;
  bool selected;

  factory CompanyVideoModel.fromJson(Map<String,dynamic> json) => _$CompanyVideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyVideoModelToJson(this);
}
