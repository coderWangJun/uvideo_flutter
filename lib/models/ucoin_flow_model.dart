import 'package:json_annotation/json_annotation.dart';


part 'ucoin_flow_model.g.dart';

@JsonSerializable()
class UcoinFlowModel {
      UcoinFlowModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  int id;
  String userid;
  int tradeFrom;
  int tradeType;
  double tradeAmount;
  double balance;

  factory UcoinFlowModel.fromJson(Map<String,dynamic> json) => _$UcoinFlowModelFromJson(json);
  Map<String, dynamic> toJson() => _$UcoinFlowModelToJson(this);
}
