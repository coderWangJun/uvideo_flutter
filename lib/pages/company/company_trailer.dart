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
  String url="";

  @override
  void initState() {
    super.initState();
    _netWorkCompanyDetail();
  }


  _netWorkCompanyDetail() async {
    DioUtil.request("/company/getPromoDetail", parameters: {"id": companyModel.id}).then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        setState(() {
          companyPageModel = CompanyTrilerModel.fromJson(value["data"]);
          url=companyPageModel.worksUrl;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBarWhite(),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildVideo(),
                _buildDetail()
              ],
            ),
          ),
        ));
  }
  // 视频播放组件
  Widget _buildVideo() {
    return companyPageModel.worksUrl.isEmpty? Container():
      Column(
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
                  companyPageModel.worksUrl??"",
                  playOptions: VideoPlayOptions(loop: true),
                  videoStyle: VideoStyle(videoTopBarStyle: VideoTopBarStyle(show: false)),
                )
              ],
            ),
          ),
          onPressed: () async {},
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10,left: 15),
          child: Text(companyPageModel.companyName ??"",
              style: TextStyle(
                  fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
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
          padding: EdgeInsets.only(top: 10, bottom: 10,left: 15),
          child: Text('简介',
              style: TextStyle(
                  fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10,left: 15),
          child: Text(companyPageModel.details ?? "" ,
              style: TextStyle(
                  fontSize: 15, color: ColorConstants.textColor51)),
        ),
      ],
    );
  }
}
