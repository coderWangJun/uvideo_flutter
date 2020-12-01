import 'package:json_annotation/json_annotation.dart';


part 'companyInDetailsSubRVO.g.dart';

@JsonSerializable()
class CompanyInDetailsSubRVO {
      CompanyInDetailsSubRVO();

  String logoUrl;
  String financingStageName;
  String staffScaleName;
  String industryName;
  double longitude;
  double latitude;

  factory CompanyInDetailsSubRVO.fromJson(Map<String,dynamic> json) => _$CompanyInDetailsSubRVOFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyInDetailsSubRVOToJson(this);
}
