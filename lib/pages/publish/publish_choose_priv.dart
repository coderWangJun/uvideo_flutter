import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PublishChossePriv extends StatefulWidget {
  @override
  _PublishChossePrivState createState() => _PublishChossePrivState();
}

class _PublishChossePrivState extends State<PublishChossePriv> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _optionList = [];

  _PublishChossePrivState() {
    _optionList.add({'title': '公开', 'subTitle': '所有圈集可见'});
    _optionList.add({'title': '私密', 'subTitle': '仅添加的圈集可见'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildListView(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
        onPressed: () {
          Get.back();
        },
      ),
      title: Container(
        alignment: Alignment.center,
        child: Center(
          child: Text('谁可以看', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('完成', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
          onPressed: () {
            Get.back();
          },
        )
      ],
    );
  }

  Widget _buildListView() {
    return ListView.separated(itemBuilder: (BuildContext context, int index) {
      Map<String, dynamic> optionMap = _optionList[index];

      return InkWell(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(optionMap['title'], style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                    Text(optionMap['subTitle'], style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
                  ],
                ),
              ),
              (index == _selectedIndex) ? Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_selected.png')) : SizedBox.shrink()
            ],
          )
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      );
    }, separatorBuilder: (BuildContext context, int index) {
      return Container(
        color: ColorConstants.dividerColor,
        height: 0.5,
        padding: EdgeInsets.only(left: 20, right: 20),
      );
    }, itemCount: _optionList.length, padding: EdgeInsets.only(left: 20, right: 20, bottom: 20));
  }
}