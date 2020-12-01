import 'package:json_annotation/json_annotation.dart';


part 'industry_model.g.dart';

@JsonSerializable()
class IndustryModel {
      IndustryModel();

  String pinyin;
  String sname;
  String name;
  int id;
  String circleName;

  factory IndustryModel.fromJson(Map<String,dynamic> json) => _$IndustryModelFromJson(json);
  Map<String, dynamic> toJson() => _$IndustryModelToJson(this);
}
