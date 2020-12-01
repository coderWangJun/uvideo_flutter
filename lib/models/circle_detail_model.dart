import 'package:json_annotation/json_annotation.dart';
import 'circle_detail_master_model.dart';

part 'circle_detail_model.g.dart';

@JsonSerializable()
class CircleDetailModel {
      CircleDetailModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  CircleDetailMasterModel marketCircleLeaderEntity;
  int id;
  String circleName;
  int marketTypeId;
  int marketSubTypeId;
  String shortContent;
  String content;
  String logoUrl;
  int cityNo;
  String cityName;
  bool isJoined;
  int countOfPeople;
  int countOfMarket;

  factory CircleDetailModel.fromJson(Map<String,dynamic> json) => _$CircleDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$CircleDetailModelToJson(this);
}
