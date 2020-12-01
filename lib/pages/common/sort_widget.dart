import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class SortWidget extends StatefulWidget {
  final List<String> columnTitles;
  final Color textColor;

  SortWidget(this.columnTitles, {this.textColor});

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: (widget.columnTitles != null && widget.columnTitles.length > 0) ? widget.columnTitles.map((title) {
          return Row(
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 15, color: widget.textColor ?? ColorConstants.textColor51.withOpacity(0.5), fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'sort_up_grey.png')),
                  SizedBox(height: 5),
                  Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'sort_down_grey.png')),
                ],
              )
            ],
          );
        }).toList() : SizedBox.shrink(),
      ),
    );
  }
}