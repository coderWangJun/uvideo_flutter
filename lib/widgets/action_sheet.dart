import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youpinapp/global/color_constants.dart';

class ActionSheet extends StatefulWidget {
  final List<String> titles;
  final String cancelTitle;

  ActionSheet(this.titles, {this.cancelTitle});

  @override
  _ActionSheetState createState() => _ActionSheetState();

  static Future<int> show(BuildContext context, List<String> titles) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ActionSheet(titles);
      }
    );
  }
}

class _ActionSheetState extends State<ActionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.titles.length * 50.0 + 80.0,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
              height: widget.titles.length * 50.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: widget.titles.map((e) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(bottom: widget.titles.last == e ? BorderSide.none : BorderSide(color: ColorConstants.dividerColor, width: 0.5))
                    ),
                    child: FlatButton(
                      child: Text(e, style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
                      onPressed: () async {
                        int index = widget.titles.indexOf(e);
                        Get.back(result: index);
                      },
                    ),
                  );
                }).toList(),
              )
          ),
          Divider(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FlatButton(
              child: Text("取消", style: TextStyle(fontSize: 17, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold)),
              onPressed: () {
                Get.back();
              },
            ),
          )
        ],
      ),
    );
  }
}