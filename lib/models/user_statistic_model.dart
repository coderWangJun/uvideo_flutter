import 'package:json_annotation/json_annotation.dart';


part 'user_statistic_model.g.dart';

@JsonSerializable()
class UserStatisticModel {
      UserStatisticModel();

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

  factory UserStatisticModel.fromJson(Map<String,dynamic> json) => _$UserStatisticModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatisticModelToJson(this);
}
