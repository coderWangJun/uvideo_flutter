import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/assets_util.dart';

class ChooseMarketPriv extends StatefulWidget {
  final int initialIndex;

  ChooseMarketPriv({this.initialIndex});

  _ChooseMarketPrivState createState() => _ChooseMarketPrivState();
}

class _ChooseMarketPrivState extends State<ChooseMarketPriv> {
  int _selectedIndex = -1;
  List<Map<String, dynamic>> _items = [
    {"index": 0, "title": "公开", "subTitle": "所有圈集可见"},
    {"index": 1, "title": "私密", "subTitle": "仅添加的圈集可见"},
  ];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWhite(
        title: "谁可以看",
        actions: [
          FlatButton(
            child: Text("完成", style: TextStyle(fontSize: 17, color: Color.fromRGBO(52, 52, 52, 1))),
            onPressed: () {
              if (_selectedIndex != -1) {
                Get.back(result: _items[_selectedIndex]);
              } else {
                BotToast.showText(text: "请选择隐私类型");
              }
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _items.length,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> itemMap = _items[index];

            return InkWell(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5), width: 1))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemMap["title"], style: TextStyle(fontSize: 15, color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.bold)),
                          Text(itemMap["subTitle"], style: TextStyle(fontSize: 12, color: Color.fromRGBO(154, 154, 154, 1))),
                        ],
                      ),
                    ),
                    _selectedIndex == index ? Image.asset(imagePath("common", "icon_selected.png")) : SizedBox.shrink()
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
            );
        }),
      ),
    );
  }
}