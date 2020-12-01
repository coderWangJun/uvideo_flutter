import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PublishChooseLocation extends StatefulWidget {
  @override
  _PublishChooseLocationState createState() => _PublishChooseLocationState();
}

class _PublishChooseLocationState extends State<PublishChooseLocation> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _locationList = [];

  _PublishChooseLocationState() {
    _locationList.add({'name': '不显示位置', 'addr': ''});
    _locationList.add({'name': '逸翠庄园', 'addr': '重庆市渝北区湖云街8号'});
    _locationList.add({'name': '重庆市渝北区', 'addr': '重庆市渝北区'});
    _locationList.add({'name': '重庆保利高尔夫球会', 'addr': '重庆市渝北区北部新区经开园龙怀街1号'});
    _locationList.add({'name': '重庆保利花园皇冠假日酒店', 'addr': '重庆市渝北区北部新区经开园龙怀街1号'});
    _locationList.add({'name': '逸翠庄园·君玺', 'addr': '重庆市渝北区北部新区经开园龙怀街1号'});
    _locationList.add({'name': '逸翠庄园·君玺', 'addr': '重庆市渝北区龙怀街2号'});
    _locationList.add({'name': '逸翠庄园(南区)', 'addr': '重庆市渝北区湖云街8号'});
    _locationList.add({'name': '保利国际高尔夫花园', 'addr': '重庆市渝北区留云街1号'});
    _locationList.add({'name': '保利·高尔夫华庭', 'addr': '重庆渝北区湖云街12号（汽博中心附近）'});
    _locationList.add({'name': '金溪中学', 'addr': '重庆市渝北区湖云街8号东南方向150米'});
    _locationList.add({'name': '金领汇', 'addr': '重庆市渝北区湖影街绿地翠谷一期'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          _buildSearch(),
          Expanded(
            child: _buildList(),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      leading: IconButton(
        icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
        onPressed: () {
          Get.back();
        },
      ),
      title: Container(
        alignment: Alignment.center,
        child: Text('所在位置', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'btn_refresh.png')),
          onPressed: () {
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
          style: TextStyle(fontSize: 15, color: Color.fromRGBO(1, 1, 1, 1)),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search)
          ),
          onSubmitted: (text) {
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_locationList.length > 0) {
      return ListView.separated(
        itemCount: _locationList.length,
        itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> locationMap = _locationList[index];

        return InkWell(
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(locationMap['name'], style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                        SizedBox(height: (locationMap['addr'] != null && locationMap['addr'] != '') ? 5 : 0),
                        Text(locationMap['addr'], style: TextStyle(fontSize: 12, color: ColorConstants.textColor153))
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
          height: 1,
          margin: EdgeInsets.only(left: 20, right: 20),
          color: Color.fromRGBO(238, 238, 238, 1),
        );
      });
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text('暂无数据', style: TextStyle(fontSize: 15, color: ColorConstants.textColor153)),
      );
    }
  }
}