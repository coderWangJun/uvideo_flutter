import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/global/color_constants.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  ValueChanged<String> onMySubmitted;
  SearchBar(this.hintText,{this.onMySubmitted});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(
          height: 36,
          child: TextField(
            enabled: false,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: EdgeInsets.only(left: 5, right: 5, top: 6),
              fillColor: Color.fromRGBO(238, 238, 238, 1),
              hintStyle: TextStyle(color: ColorConstants.textColor51.withOpacity(0.5), fontSize: 15),
              labelStyle: TextStyle(color: ColorConstants.textColor51, fontSize: 15),
              isDense: true,
              border: InputBorder.none,
            ),
            onSubmitted: widget.onMySubmitted,
          ),
        )
      )
    );
  }
}