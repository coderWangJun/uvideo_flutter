// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_video_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortVideoCommentModel _$ShortVideoCommentModelFromJson(
    Map<String, dynamic> json) {
  return ShortVideoCommentModel()
    ..createdBy = json['createdBy'] as String
    ..createdTime = json['createdTime'] as String
    ..updatedBy = json['updatedBy'] as String
    ..updatedTime = json['updatedTime'] as String
    ..id = json['id'] as int
    ..worksId = json['worksId'] as int
    ..replyTo = json['replyTo'] as int
    ..belongTo = json['belongTo'] as int
    ..bUserid = json['bUserid'] as String
    ..replyName = json['replyName'] as String
    ..headPortrait = json['headPortrait'] as String
    ..name = json['name'] as String
    ..userid = json['userid'] as String
    ..type = json['type'] as int
    ..content = json['content'] as String
    ..likes = json['likes'] as int
    ..numberOfComments = json['numberOfComments'] as int
    ..isLiked = json['isLiked'] as int
    ..isExpand = json['isExpand'] as bool
    ..replyCurrentPage = json['replyCurrentPage'] as int
    ..parentComment = json['parentComment'] == null
        ? null
        : ShortVideoCommentModel.fromJson(
            json['parentComment'] as Map<String, dynamic>)
    ..replyList = (json['replyList'] as List)
        ?.map((e) => e == null
            ? null
            : ShortVideoCommentModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ShortVideoCommentModelToJson(
        ShortVideoCommentModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'updatedBy': instance.updatedBy,
      'updatedTime': instance.updatedTime,
      'id': instance.id,
      'worksId': instance.worksId,
      'replyTo': instance.replyTo,
      'belongTo': instance.belongTo,
      'bUserid': instance.bUserid,
      'replyName': instance.replyName,
      'headPortrait': instance.headPortrait,
      'name': instance.name,
      'userid': instance.userid,
      'type': instance.type,
      'content': instance.content,
      'likes': instance.likes,
      'numberOfComments': instance.numberOfComments,
      'isLiked': instance.isLiked,
      'isExpand': instance.isExpand,
      'replyCurrentPage': instance.replyCurrentPage,
      'parentComment': instance.parentComment,
      'replyList': instance.replyList,
    };
