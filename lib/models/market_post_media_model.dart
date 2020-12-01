import 'package:json_annotation/json_annotation.dart';


part 'market_post_media_model.g.dart';

@JsonSerializable()
class MarketPostMediaModel {
      MarketPostMediaModel();

  @JsonKey(name: 'created_by') String createdBy;
  @JsonKey(name: 'created_time') String createdTime;
  @JsonKey(name: 'updated_by') String updatedBy;
  @JsonKey(name: 'updated_time') String updatedTime;
  int id;
  String ossName;
  String worksName;
  String worksUrl;
  String ossCoverName;
  String coverName;
  String coverUrl;

  factory MarketPostMediaModel.fromJson(Map<String,dynamic> json) => _$MarketPostMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketPostMediaModelToJson(this);
}
