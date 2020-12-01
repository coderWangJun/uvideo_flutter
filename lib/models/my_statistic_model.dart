import 'package:json_annotation/json_annotation.dart';


part 'my_statistic_model.g.dart';

@JsonSerializable()
class MyStatisticModel {
      MyStatisticModel();

  int circleCount;
  int careCount;
  int registDays;
  int collectCount;
  int fansCount;
  int friendsCount;
  int likeCount;
  int onlineJobCount;
  int workExpCount;
  int deliveryCount;
  int effectScore;
  int honestyScore;
  double assetsScore;

  factory MyStatisticModel.fromJson(Map<String,dynamic> json) => _$MyStatisticModelFromJson(json);
  Map<String, dynamic> toJson() => _$MyStatisticModelToJson(this);
}
