import 'package:json_annotation/json_annotation.dart';
import 'short_video_comment_model.dart';
import 'short_video_comment_model.dart';

part 'short_video_comment_model.g.dart';

@JsonSerializable()
class ShortVideoCommentModel {
      ShortVideoCommentModel();

  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  int id;
  int worksId;
  int replyTo;
  int belongTo;
  String bUserid;
  String replyName;
  String headPortrait;
  String name;
  String userid;
  int type;
  String content;
  int likes;
  int numberOfComments;
  int isLiked;
  bool isExpand;
  int replyCurrentPage;
  ShortVideoCommentModel parentComment;
  List<ShortVideoCommentModel> replyList;

  factory ShortVideoCommentModel.fromJson(Map<String,dynamic> json) => _$ShortVideoCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShortVideoCommentModelToJson(this);
}
