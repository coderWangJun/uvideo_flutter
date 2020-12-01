import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/friend_model.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class PublishAtFriends extends StatefulWidget {
  final FriendModel selectedFriendModel;

  PublishAtFriends({this.selectedFriendModel});

  @override
  _PublishAtFriendsState createState() => _PublishAtFriendsState();
}

class _PublishAtFriendsState extends State<PublishAtFriends> {
  int _selectedIndex = -1;
  int _selectedCount = 0;
  List<FriendModel> _friendList = [];
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
    
    _loadFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          //_buildSearch(),
          Expanded(
            child: _buildFriendList()
          )
        ],
      ),
    );
  }
  
  Widget _buildAppBar() {
    String rightButtonTitle = '完成';
//    if (_selectedCount > 0) {
//      rightButtonTitle = '完成（$_selectedCount）';
//    }

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
      title: Center(
        child: Text('选择好友', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(rightButtonTitle, style: TextStyle(fontSize: 17, color: Color.fromRGBO(153, 153, 153, 1))),
          onPressed: () {
            if (_selectedIndex == -1) {
              BotToast.showText(text: "请选择好友");
            } else {
              FriendModel friendModel = _friendList[_selectedIndex];
              Get.back(result: friendModel);
            }
          },
        )
      ],
    );
  }

  Widget _buildSearch() {
    return Container(
      width: double.infinity,
      height: 68,
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.circular(14)
        ),
        child: TextField(
          maxLines: 1,
          controller: _textEditingController,
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

  Widget _buildFriendList() {
    if (_friendList.length == 0) {
      return EmptyWidget();
    } else {
      return ListView.builder(itemBuilder: (BuildContext context, int index) {
        FriendModel friendModel = _friendList[index];

        return InkWell(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(join(AssetsUtil.assetsDirectoryCommon, (index == _selectedIndex) ? 'radio_checked.png' : 'radio_unchecked.png')),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      imageUrl: friendModel.targetUserHeadPortrait ?? "",
                      placeholder: (BuildContext context, String url) {
                        return Image.asset(imagePath("common", "def_avatar.png"), width: 40, height: 40, fit: BoxFit.cover,);
                      },
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(friendModel.targetNickname ?? "", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                    //SizedBox(height: 9),
                    //Text("", style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1)))
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              if (_selectedIndex != index) {
                _selectedIndex = index;
                _selectedCount = 1;
              } else {
                _selectedIndex = -1;
                _selectedCount = 0;
              }
            });
          },
        );
      }, itemCount: _friendList.length);
    }
  }
  
  void _loadFriendList() {
    DioUtil.request("/user/getUserFriendsList").then((response) {
      print(response);
      bool success = DioUtil.checkRequestResult(response);
      if (success) {
        List<dynamic> dataList = response["data"];
        if (dataList != null && dataList.length > 0) {
          for (int i = 0; i < dataList.length; i++) {
            var json = dataList[i];
            FriendModel tempModel = FriendModel.fromJson(json);
            if (widget.selectedFriendModel != null && widget.selectedFriendModel.targetUserid == tempModel.targetUserid) {
              _selectedIndex = i;
            }

            _friendList.add(tempModel);
          }
        }

        setState(() { });
      }
    });
  }
}