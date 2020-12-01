import 'package:json_annotation/json_annotation.dart';


part 'circle_model.g.dart';

@JsonSerializable()
class CircleModel {
      CircleModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  dynamic marketCircleLeaderEntity;
  int id;
  String circleName;
  int marketTypeId;
  int marketSubTypeId;
  String content;
  String logoUrl;
  bool isJoined;
  int countOfPeople;
  int countOfMarket;

  factory CircleModel.fromJson(Map<String,dynamic> json) => _$CircleModelFromJson(json);
  Map<String, dynamic> toJson() => _$CircleModelToJson(this);
}
