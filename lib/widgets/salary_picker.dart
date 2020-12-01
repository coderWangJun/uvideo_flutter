import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/global/color_constants.dart';

class SalaryPicker extends StatefulWidget {
  final List<dynamic> salaryList;

  SalaryPicker(this.salaryList);

  static Future<dynamic> show(BuildContext parentContext, List<dynamic> salaryList) {
    return showModalBottomSheet(
        context: parentContext,
        builder: (BuildContext context) {
      return SalaryPicker(salaryList);
    });
  }

  @override
  _SalaryPickerState createState() => _SalaryPickerState();
}

class _SalaryPickerState extends State<SalaryPicker> {
  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;
  List<dynamic> _minSalaryList = [];
  List<dynamic> _maxSalaryList = [];

  @override
  void initState() {
    super.initState();

    _minSalaryList.add(0);
    _minSalaryList.addAll(widget.salaryList);
    _maxSalaryList = _minSalaryList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 0.5))
            ),
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
                Text("薪资范围", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    child: Text("确定"),
                    onPressed: () {
                      var resultMap = {
                        "minSalary": _minSalaryList[_selectedIndex1],
                        "maxSalary": _maxSalaryList[_selectedIndex2]
                      };
                      Get.back(result: resultMap);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    children: _minSalaryList != null ? _minSalaryList.map((salary) {
                      return Center(
                        child: Text(salary == 0 ? "面议" : "$salary", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                      );
                    }).toList() : SizedBox(),
                    onSelectedItemChanged: (position) {
                      _selectedIndex1 = position;
                      _selectedIndex2 = 0;

                      if (_selectedIndex1 == 0) {
                        _maxSalaryList = _minSalaryList;
                      } else {
                        _maxSalaryList = _minSalaryList.sublist(position + 1);
                      }

                      setState(() { });
                    },
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    children: _maxSalaryList != null ? _maxSalaryList.map((salary) {
                      return Center(
                        child: Text(salary == 0 ? "面议" : "$salary", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                      );
                    }).toList() : SizedBox(),
                    onSelectedItemChanged: (position) {
                      _selectedIndex2 = position;

                      setState(() { });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}