import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/company_page_model.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';

class CompanyPage extends StatefulWidget {
  final String userId;

  CompanyPage(this.userId);

  @override
  _CompanyPageState createState() => _CompanyPageState(this.userId);
}

class _CompanyPageState extends State<CompanyPage> {
  String userId;

  _CompanyPageState(userId) {
    this.userId = userId;
  }

  CompanyPageModel companyPageModel = CompanyPageModel();

  @override
  void initState() {
    super.initState();
    _netWorkCompanyDetail();
  }

  _netWorkCompanyDetail() async {
    DioUtil.request("/company/getCompany", parameters: {"userid": userId}).then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        setState(() {
          companyPageModel = CompanyPageModel.fromJson(value["data"]);
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
                _buildName(),
                _buildAddress(),
              ],
            ),
          ),
        ));
  }

  // 公司名称logo
  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${companyPageModel.companyName ?? ""}',
                    style: TextStyle(
                        fontSize: 24,
                        color: ColorConstants.textColor51,
                        fontWeight: FontWeight.bold)),
                Text(
                    '${companyPageModel.financingStageName ?? ""} ${companyPageModel.staffScaleName ?? ""}',
                    style: TextStyle(fontSize: 12, color: ColorConstants.textColor51)),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              companyPageModel.logoUrl,
              width: 65,
              height: 65,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }

  // 公司地址
  Widget _buildAddress() {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('公司地址',
                style: TextStyle(
                    fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
            Text('${companyPageModel.address ?? ""}',
                style: TextStyle(
                    fontSize: 13, color: Color(0XFF333333))),
          ],
        ),
      ),
    );
  }
}
