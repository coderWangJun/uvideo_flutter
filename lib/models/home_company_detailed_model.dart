import 'package:json_annotation/json_annotation.dart';
import 'companyInDetailsSubRVO.dart';
import 'companyStaffEntity.dart';

part 'home_company_detailed_model.g.dart';

@JsonSerializable()
class HomeCompanyDetailedModel {
  HomeCompanyDetailedModel();

  String createdTime;
  String updatedTime;
  int id;
  String userid;
  String logoUrl;
  String ossName;
  String worksName;
  String worksUrl;
  String ossCoverName;
  String coverName;
  String coverUrl;
  String title;
  int needPeople;
  String companyName;
  int minSalary;
  int maxSalary;
  String skillTags;
  String salaryTreatmentString;
  int eduId;
  String diploma;
  int yearsOfExp;
  String yearsOfExpString;
  int industryNo;
  String industryName;
  int positionNo;
  String positionName;
  int cityNo;
  String cityName;
  double longitude;
  double latitude;
  int status;
  double distanceDouble;
  String distanceString;
  String isLiked;
  int isCollect;
  int likes;
  int numberOfComments;
  int numberOfForwarding;
  String jobDetails;
  CompanyInDetailsSubRVO companyInDetailsSubRVO;
  CompanyStaffEntity companyStaffEntity;

  factory HomeCompanyDetailedModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCompanyDetailedModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeCompanyDetailedModelToJson(this);
}
