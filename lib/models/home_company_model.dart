import 'package:json_annotation/json_annotation.dart';

part 'home_company_model.g.dart';

@JsonSerializable()
class HomeCompanyModel {
  HomeCompanyModel();

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
  int needPeople;
  int minSalary;
  int maxSalary;
  String salaryTreatmentString;
  int eduId;
  String diploma;
  int yearsOfExp;
  String yearsOfExpString;
  int locked;
  int positionNo;
  String positionName;
  int cityNo;
  String cityName;
  double longitude;
  String logoUrl;
  double latitude;
  int status;
  double distanceDouble;
  String distanceString;
  int isLiked;
  int likes;
  int numberOfComments;
  int numberOfForwarding;
  String jobDetails;
  String keywordsTags;

  factory HomeCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeCompanyModelToJson(this);
}
