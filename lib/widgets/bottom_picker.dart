import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/global/color_constants.dart';

class BottomPicker extends StatefulWidget {
  final List<dynamic> options;
  final String title;

  BottomPicker(this.options, this.title);

  static Future<dynamic> showPicker(BuildContext parentContext, List<dynamic> options, {String title}) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: parentContext,
      builder: (BuildContext context) {
        return BottomPicker(options, title);
      }
    );
  }

  @override
  _BottomPickerState createState() => _BottomPickerState();
}

class _BottomPickerState extends State<BottomPicker> {
  int _currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildTitleWidgets(context),
          Expanded(
            child: _buildOptionWidgets(),
          )
        ],
      )
    );
  }

  Widget _buildTitleWidgets(parentContext) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              child: Text("取消"),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Text(widget.title ?? "", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              child: Text("确定"),
              onPressed: () {
                Get.back(result: widget.options[_currentPosition]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionWidgets() {
    return CupertinoPicker(
      itemExtent: 50,
      children: widget.options != null ? widget.options.map((e) {
        return Center(
          child: Text(e["name"]),
        );
      }).toList() : SizedBox.shrink(),
      onSelectedItemChanged: (position){
        _currentPosition = position;
      },
    );
  }
}