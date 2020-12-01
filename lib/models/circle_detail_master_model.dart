import 'package:json_annotation/json_annotation.dart';


part 'circle_detail_master_model.g.dart';

@JsonSerializable()
class CircleDetailMasterModel {
      CircleDetailMasterModel();

  String id;
  String nickname;
  String realname;
  String phonenumber;
  String headPortraitUrl;

  factory CircleDetailMasterModel.fromJson(Map<String,dynamic> json) => _$CircleDetailMasterModelFromJson(json);
  Map<String, dynamic> toJson() => _$CircleDetailMasterModelToJson(this);
}
