import 'package:json_annotation/json_annotation.dart';



@JsonSerializable()
class FensModel {
  FensModel();

  String name;
  String targetUserHeadPortrait;
  String companyName;
  String position;

  factory FensModel.fromJson(Map<String, dynamic> json) =>
      _$FensModelFromJson(json);

  Map<String, dynamic> toJson() => _$FensModelToJson(this);

  FensModel _$FensModelFromJson(Map<String, dynamic> json) {
    return FensModel()
      ..name = json['name'] as String
      ..targetUserHeadPortrait = json['targetUserHeadPortrait'] as String
      ..companyName = json['companyName'] as String
      ..position = json['position'] as String;

  }
  Map<String, dynamic> _$FensModelToJson(FensModel instance) =>
      <String, dynamic>{
        'name': instance.name,
        'targetUserHeadPortrait': instance.targetUserHeadPortrait,
        'companyName': instance.companyName,
        'position': instance.position,

      };
}
