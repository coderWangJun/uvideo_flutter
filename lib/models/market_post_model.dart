import 'package:json_annotation/json_annotation.dart';
import 'market_post_media_model.dart';

part 'market_post_model.g.dart';

@JsonSerializable()
class MarketPostModel {
      MarketPostModel();

  @JsonKey(name: 'created_by') String createdBy;
  String createdTime;
  @JsonKey(name: 'updated_by') String updatedBy;
  @JsonKey(name: 'updated_time') String updatedTime;
  int id;
  String userid;
  int publishTypeId;
  String title;
  String content;
  String picUrl;
  String keywords;
  int likes;
  int numberOfComments;
  int numberOfForwarding;
  String replyCount;
  double longitude;
  double latitude;
  String distance;
  int isLiked;
  List<MarketPostMediaModel> marketWorksList;
  int marketTypeId;
  String marketTypeName;
  int marketCircleId;
  String marketCircleName;
  double ucoinAmount;
  String cityName;
  String name;
  int rewarded;
  int type;
  String typeName;
  String companyName;
  String headPortraitUrl;

  factory MarketPostModel.fromJson(Map<String,dynamic> json) => _$MarketPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketPostModelToJson(this);
}
