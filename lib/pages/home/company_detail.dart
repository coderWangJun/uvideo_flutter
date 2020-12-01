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
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CompanyDetail extends StatefulWidget {
  final HomeCompanyModel companyModel;

  CompanyDetail(this.companyModel);

  @override
  _CompanyDetailState createState() => _CompanyDetailState(this.companyModel);
}

class _CompanyDetailState extends State<CompanyDetail> {
  HomeCompanyModel companyModel;
  
  _CompanyDetailState(companyModel) {
    this.companyModel = companyModel;
  }

  HomeCompanyDetailedModel homeCompanyDetailedModel = HomeCompanyDetailedModel();


  @override
  void initState() {
    homeCompanyDetailedModel.companyInDetailsSubRVO = CompanyInDetailsSubRVO();
    homeCompanyDetailedModel.companyStaffEntity = CompanyStaffEntity();
    super.initState();
    _netWorkCompanyDetail();
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 60),
          child: Column(
            children: <Widget>[
              _buildVideo(),
              _buildJobRow(),
              _buildCompanyAvatar(),
              _buildJobDesc(),
              _buildCompanyAvatar1(),
//              _buildMap(),
              _buildWarning(),
//              _buildButtons()
            ],
          ),
        ),
      )
    );
  }

  // 构建AppBar
  Widget _buildAppBar(parentContext) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 44),
      child: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'nav_back_black.png')),
              onPressed: () {
                Navigator.of(parentContext).pop();
              },
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_favo.png')),
                ),
                IconButton(
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_warn_grey.png')),
                ),
                IconButton(
                  icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_share.png')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // 视频播放组件
  Widget _buildVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0),
          child: Container(
            width: double.infinity,
            color: Colors.black,
            constraints: BoxConstraints(
              minHeight: 200
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AwsomeVideoPlayer(
                  this.companyModel.worksUrl,
                  playOptions: VideoPlayOptions(
                    loop: true
                  ),
                  videoStyle: VideoStyle(
                    videoTopBarStyle: VideoTopBarStyle(
                      show: false
                    )
                  ),
                )
              ],
            ),
          ),
          onPressed: () async {
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(this.companyModel.companyName ?? g_accountManager.currentUser.phonenumber, style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  // 招聘岗位
  Widget _buildJobRow() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConstants.dividerColor))
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///职位名称
                      Text('${homeCompanyDetailedModel.title}', style: TextStyle(fontSize: 25, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Text('${homeCompanyDetailedModel.cityName}', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
                          Container(width: 0.5, height: 11, color: Color.fromRGBO(210, 210, 210, 1), margin: EdgeInsets.only(left: 14, right: 14)),
                          Text('${homeCompanyDetailedModel.yearsOfExpString}', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),
                          Container(width: 0.5, height: 11, color: Color.fromRGBO(210, 210, 210, 1), margin: EdgeInsets.only(left: 14, right: 14)),
                          Text('${homeCompanyDetailedModel.diploma}', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1)))
                        ],
                      )
                    ],
                  ),
                ),
                Text('${homeCompanyDetailedModel.salaryTreatmentString}', style: TextStyle(fontSize: 20, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 公司头像
  Widget _buildCompanyAvatar() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(top: 20, bottom: 20),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorConstants.dividerColor))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///公司logo
//          Image.network("${homeCompanyDetailedModel.companyInDetailsSubRVO.logoUrl}"),
            ClipOval(child:Image.network(homeCompanyDetailedModel.companyStaffEntity.headPortraitUrl??=ImProvider.DEF_HEAD_IMAGE_URL,width: 50.0,height: 50.0,fit: BoxFit.cover,),),
            //Image.asset(join(AssetsUtil.assetsDirectoryHome, 'company_avatar_circle.png')),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(homeCompanyDetailedModel.companyStaffEntity.name??="", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      //可以写刚刚活跃
                      Text('', style: TextStyle(fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1)))
                    ],
                  ),
                  SizedBox(height: 3),
                  Text('${homeCompanyDetailedModel.companyName??=""}  ${homeCompanyDetailedModel.companyStaffEntity.position??=""}', style: TextStyle(fontSize: 13, color: ColorConstants.textColor51))
                ],
              ),
            ),
            Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
          ],
        ),
      ),
      onTap: () {
        Get.to(UserDetailRoute(userId: companyModel.userid));
      },
    );
  }

  // 职位描述
  Widget _buildJobDesc() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('职位详情', style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
              Text('${homeCompanyDetailedModel.createdTime!=null?DataTimeToString.toTextString(DateTime.parse(homeCompanyDetailedModel.createdTime)):""} 更新', style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1)))
            ],
          ),
          SizedBox(height: 15),
          Text('${homeCompanyDetailedModel.jobDetails}',
              style: TextStyle(fontSize: 13, color: Color.fromRGBO(101, 101, 101, 1))),

        ],
      ),
    );
  }

  // 公司头像
  Widget _buildCompanyAvatar1() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Image.asset(join(AssetsUtil.assetsDirectoryHome, 'company_avatar_rect.png')),
          ClipOval(child:Image.network(homeCompanyDetailedModel.companyInDetailsSubRVO.logoUrl??=ImProvider.DEF_HEAD_IMAGE_URL,width: 50.0,height: 50.0,fit: BoxFit.cover,),),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///公司部分
                Text('${homeCompanyDetailedModel.companyName??=""}', style: TextStyle(fontSize: 15, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text('${homeCompanyDetailedModel.companyInDetailsSubRVO.financingStageName??=""}', style: TextStyle(fontSize: 13, color: ColorConstants.textColor51))
              ],
            ),
          ),
          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_forward_small.png'))
        ],
      ),
    );
  }

  // 地图
  Widget _buildMap() {
    return Container(
      child: Image.asset(join(AssetsUtil.assetsDirectoryHome, 'company_map.png',), width: ScreenUtil.mediaQueryData.size.width - 40, fit: BoxFit.cover),
    );
  }

  // 温馨提示
  Widget _buildWarning() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_warn_red.png')),
              SizedBox(width: 5),
              Text('温馨提示', style: TextStyle(fontSize: 13, color: Color.fromRGBO(199, 37, 0, 1)))
            ],
          ),
          SizedBox(height: 10),
          Text('该Boss承诺名下所有职位不向您收费，如有不实，请立即举报', style: TextStyle(fontSize: 13, color: ColorConstants.textColor51))
        ],
      ),
    );
  }

  // 底部按钮
  Widget _buildButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 130,
                height: 40,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: ColorConstants.themeColorBlue),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text('不感兴趣', style: TextStyle(fontSize: 15, color: ColorConstants.themeColorBlue)),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorConstants.themeColorBlue,
                    border: Border.all(width: 1, color: ColorConstants.themeColorBlue),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text('继续沟通', style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: 130,
            height: 40,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: ColorConstants.themeColorBlue),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Text('已投简历', style: TextStyle(fontSize: 15, color: ColorConstants.themeColorBlue)),
          ),
        ],
      ),
    );
  }

  _netWorkCompanyDetail() async{
    DioUtil.request("/company/getMediaResumeDetails",parameters: {"id":"${companyModel.id}"}).then((value){
      if(DioUtil.checkRequestResult(value,showToast: false)){
        setState(() {
          homeCompanyDetailedModel = HomeCompanyDetailedModel.fromJson(value["data"]);
          if(homeCompanyDetailedModel.companyInDetailsSubRVO==null){
            homeCompanyDetailedModel.companyInDetailsSubRVO = CompanyInDetailsSubRVO();
          }
          if(homeCompanyDetailedModel.companyStaffEntity==null){
            homeCompanyDetailedModel.companyStaffEntity = CompanyStaffEntity();
          }
        });
      }
    });
  }
}