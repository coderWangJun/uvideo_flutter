import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/app.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/models/home_resume_model.dart';
import 'package:youpinapp/pages/common/custom_notification.dart';
import 'package:youpinapp/pages/common/floating_button.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/pages/player/nearby_video_list.dart';
import 'package:youpinapp/pages/player/player_state_provider.dart';
import 'package:youpinapp/pages/player/video_player_vert_container.dart';
import 'package:youpinapp/pages/publish/publish_menu.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/company/company_page.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';

/// 个人账户的岗位页面
class PersonalPositionPage extends StatefulWidget {
  final VideoPlayType playType;
  final HomeResumeModel currentResumeModel;
  final int _showType = 0;
  PersonalPositionPage({
    Key key,
    this.playType,
    this.currentResumeModel,
  }) : super(key: key);

  @override
  _PersonalPositionPageState createState() => _PersonalPositionPageState();
}

class _PersonalPositionPageState extends State<PersonalPositionPage>
    with TickerProviderStateMixin {
  int _topSelectedIndex = 1;
  int _bottomSelectedIndex = 0;
  PlayerStateProvider _playerStateProvider = new PlayerStateProvider();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(
        title: "",
        actions: <Widget>[
          Container(
            width: 150,
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(
                      Icons.star_border,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    onPressed: () {
                      print('收藏');
                    },
                  ),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(
                      Icons.warning,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    onPressed: () {
                      print('举报');
                    },
                  ),
                ),
                Container(
                  width: 50,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(
                      Icons.launch,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    onPressed: () {
                      print('分享');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 顶部视频区域
            _topVideo(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: <Widget>[
                  // 标题区域
                  _topHeader(),
                  // 个人信息区域
                  _personalInfo(),
                  // 职位详情区域
                  _positionInfo(),
                  // 公司详情
                  _companyInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topVideo() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    constraints: BoxConstraints(minHeight: 200),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AwsomeVideoPlayer(
                          widget.currentResumeModel.worksUrl,
                          playOptions: VideoPlayOptions(loop: true),
                          videoStyle: VideoStyle(
                              videoTopBarStyle: VideoTopBarStyle(show: false)),
                        )
                      ],
                    ),
                  ),
                  onPressed: () async {},
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 10, bottom: 10),
                //   child: Text(
                //       widget.currentResumeModel.worksName ??
                //           g_accountManager.currentUser.phonenumber,
                //       style: TextStyle(
                //           fontSize: 17,
                //           color: ColorConstants.textColor51,
                //           fontWeight: FontWeight.bold)),
                // )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            child: Text(
              '重庆明艳文化传媒有限公司',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '影视后期',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '后期制作',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '5-10年',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '本科',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 180,
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              'null',
              style: TextStyle(
                color: Color.fromRGBO(0, 127, 255, 1),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalInfo() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  // child: Image.asset(),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              bottom: 2,
                            ),
                            child: Text(
                              '影视后期',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '重庆明艳文化传媒有限公司',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: Text(
                                  '无',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            width: 60,
            height: 60,
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Color.fromRGBO(0, 0, 0, 0.3),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _positionInfo() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Text(
                              '职位详情',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '需要五年以上工作经验的人',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '2020-10-23 更新',
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _companyInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  borderRadius: BorderRadius.circular(50),
                ),
                // child: Image.asset(),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            bottom: 2,
                          ),
                          child: Text(
                            '重庆明艳文化传媒有限公司',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'null',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerRight,
          width: 60,
          height: 60,
          child: InkWell(
            onTap: () {},
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Color.fromRGBO(0, 0, 0, 0.3),
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
