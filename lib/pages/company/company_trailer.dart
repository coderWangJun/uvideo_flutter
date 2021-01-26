import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/company_trailer_model.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CompanyTrailer extends StatefulWidget {
  final HomeCompanyModel companyModel;

  CompanyTrailer(this.companyModel);

  @override
  _CompanyTrailerState createState() => _CompanyTrailerState(this.companyModel);
}

class _CompanyTrailerState extends State<CompanyTrailer> {
  HomeCompanyModel companyModel;

  _CompanyTrailerState(companyModel) {
    this.companyModel = companyModel;
  }

  CompanyTrilerModel companyPageModel = CompanyTrilerModel();
  String url = "";
  String _title = "";

  @override
  void initState() {
    super.initState();
    _netWorkCompanyDetail();
  }

  _netWorkCompanyDetail() async {
    DioUtil.request("/company/getPromoDetail",
        parameters: {"id": companyModel.id}).then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        setState(() {
          companyPageModel = CompanyTrilerModel.fromJson(value["data"]);
          url = companyPageModel.worksUrl;
          _title = companyPageModel.companyName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBarWhite(
          title: _title,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildVideo(),
                _buildCompanyGroup(),
                _buildDetail(),
              ],
            ),
          ),
        ));
  }

  // 公司成员
  Widget _buildCompanyGroup() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromRGBO(255, 104, 32, 1),
                    size: 21,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromRGBO(255, 104, 32, 1),
                    size: 21,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromRGBO(255, 104, 32, 1),
                    size: 21,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromRGBO(255, 104, 32, 1),
                    size: 21,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    size: 21,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: 15,
                  ),
                  child: Text(
                    '7.7',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 104, 32, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: 5,
              top: 20,
              bottom: 20,
            ),
            child: Text(
              '【公司成员】',
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 40,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '制片人',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '梁静',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '制片人',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '管虎',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '制片人',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '管虎',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '制片人',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '管虎',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '导演',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '路阳',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '导演',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '赵宁宇',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 视频播放组件
  Widget _buildVideo() {
    return companyPageModel == null ||
            companyPageModel.worksUrl == null ||
            companyPageModel.worksUrl.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        companyPageModel.worksUrl ?? "",
                        playOptions: VideoPlayOptions(loop: true),
                        videoStyle: VideoStyle(
                            videoTopBarStyle: VideoTopBarStyle(show: false)),
                      )
                    ],
                  ),
                ),
                onPressed: () async {},
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(companyPageModel.companyName ?? "",
                          style: TextStyle(
                              fontSize: 17,
                              color: ColorConstants.textColor51,
                              fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }

  // 简介
  Widget _buildDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
          child: Text('简介',
              style: TextStyle(
                  fontSize: 17,
                  color: ColorConstants.textColor51,
                  fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
          child: Text(
              companyPageModel.details == null || companyPageModel.details == ""
                  ? "该公司很懒，什么也没留下"
                  : companyPageModel.details,
              style:
                  TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
        ),
      ],
    );
  }
}
