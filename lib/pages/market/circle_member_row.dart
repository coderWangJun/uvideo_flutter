import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/circle_member_model.dart';

class CircleMemberRow extends StatefulWidget {
  final CircleMemberModel memberModel;
  //圈主的userId
  String mainUserId;

  CircleMemberRow(this.memberModel, this.mainUserId);

  @override
  _CircleMemberRowState createState() => _CircleMemberRowState();
}

class _CircleMemberRowState extends State<CircleMemberRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: Container(
                  color: ColorConstants.backgroundColor,
                  child: CachedNetworkImage(
                    imageUrl: widget.memberModel.headPortraitUrl ?? '',
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.memberModel.name ??= "",
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorConstants.textColor51,
                              fontWeight: FontWeight.w600)),
                      widget.memberModel.userid == widget.mainUserId
                          ? Container(
                              margin: EdgeInsets.only(left: 7),
                              width: 35,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.themeColorBlue,
                                  borderRadius: BorderRadius.circular(7.5)),
                              child: Text('圈主',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white)),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  widget.memberModel.companyName != null
                      ? Text(widget.memberModel.companyName ?? '',
                          style: TextStyle(
                              fontSize: 13, color: ColorConstants.textColor153))
                      : SizedBox.shrink()
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Lv${widget.memberModel.memberLevel ?? 1}',
                  style: TextStyle(
                      fontSize: 12, color: ColorConstants.themeColorBlue)),
              SizedBox(height: 5),
              Text(widget.memberModel.distanceString ?? "0.3km",
                  style: TextStyle(
                      fontSize: 12, color: ColorConstants.textColor153))
            ],
          )
        ],
      ),
    );
  }
}
