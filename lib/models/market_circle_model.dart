import 'package:json_annotation/json_annotation.dart';


part 'market_circle_model.g.dart';

@JsonSerializable()
class MarketCircleModel {
      MarketCircleModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  int id;
  String circleName;
  int marketTypeId;
  int marketSubTypeId;
  String shortContent;
  String content;
  String logoUrl;
  String cityNo;
  String cityName;
  bool isJoined;
  int countOfPeople;
  int countOfMarket;

  factory MarketCircleModel.fromJson(Map<String,dynamic> json) => _$MarketCircleModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketCircleModelToJson(this);
}
