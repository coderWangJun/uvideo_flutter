import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class FensModel {
  FensModel();

  String name;
  String targetUserHeadPortrait;
  String companyName;
  String position;
  String userid;

  factory FensModel.fromJson(Map<String, dynamic> json) => FensModel()
    ..name = json['name'] as String
    ..targetUserHeadPortrait = json['targetUserHeadPortrait'] as String
    ..companyName = json['companyName'] as String
    ..userid = json['userid'] as String
    ..position = json['position'] as String;

  Map<String, dynamic> toJson() => _$FensModelToJson(this);

  Map<String, dynamic> _$FensModelToJson(FensModel instance) =>
      <String, dynamic>{
        'name': instance.name,
        'targetUserHeadPortrait': instance.targetUserHeadPortrait,
        'companyName': instance.companyName,
        'position': instance.position,
        'userid': instance.userid,
      };
}
