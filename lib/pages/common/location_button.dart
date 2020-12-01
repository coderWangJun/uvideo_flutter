import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

class LocationButton extends StatefulWidget {
  final String locationName;
  final double fontSize;
  final Color textColor;

  LocationButton({this.locationName = '区域', this.fontSize = 13.0, @required this.textColor});

  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 0,
      height: 0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(widget.locationName, style: TextStyle(fontSize: widget.fontSize, color: widget.textColor)),
            SizedBox(width: 6),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'sort_down_black.png'))
          ],
        ),
      ),
    );
  }
}