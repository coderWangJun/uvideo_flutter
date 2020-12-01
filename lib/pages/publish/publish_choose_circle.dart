import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PublishChooseCircle extends StatefulWidget {
  @override
  _PublishChooseCircleState createState() => _PublishChooseCircleState();
}

class _PublishChooseCircleState extends State<PublishChooseCircle> {
  int _selectedIndex = -1;
  int _selectedCount = 0;
  List<Map<String, dynamic>> _circleList = [];

  _PublishChooseCircleState() {
    _circleList.add({'icon': Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'logo_gongshang.png')), 'name': '重工', 'focusCount': 500, 'postCount': 500});
    _circleList.add({'icon': Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'logo_chongda.png')), 'name': '重大', 'focusCount': 500, 'postCount': 500});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSearch(),
          Expanded(
            child: _buildCircleList()
          )
        ],
      ),
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
        child: Text('添加圈集', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
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

  Widget _buildSearch() {
    return Container(
      height: 68,
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.circular(14)
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search)
          ),
        ),
      )
    );
  }

  Widget _buildCircleList() {
    if (_circleList.length > 0) {
      return ListView.builder(
        itemExtent: 65,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        itemCount: _circleList.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> circleMap = _circleList[index];

          return InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(join(AssetsUtil.assetsDirectoryCommon, (index == _selectedIndex) ? 'radio_checked.png' : 'radio_unchecked.png')),
                Container(
                  margin: EdgeInsets.only(left: 12.5, right: 12.5),
                  child: circleMap['icon'],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(circleMap['name'], style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(text: '关注:', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
                              TextSpan(text: '${circleMap['focusCount']}', style: TextStyle(fontSize: 13, color:ColorConstants.themeColorBlue)),
                            ]
                          )),
                          SizedBox(width: 20),
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(text: '帖子:', style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
                              TextSpan(text: '${circleMap['postCount']}', style: TextStyle(fontSize: 13, color:ColorConstants.themeColorBlue)),
                            ]
                          ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            onTap: () {
              setState(() {
                if (index == _selectedIndex) {
                  _selectedIndex = -1;
                  _selectedCount = 0;
                } else {
                  _selectedIndex = index;
                  _selectedCount = 1;
                }
              });
            },
          );
        }
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Center(
          child: Text('暂无数据', style: TextStyle(fontSize: 15, color: Colors.green)),
        ),
      );
    }
  }
}