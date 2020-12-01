import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/company/company_basic_edit.dart';
import 'package:youpinapp/pages/company/setting/company_edit.dart';
import 'package:youpinapp/pages/person/person_basic_edit.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

import '../../global/color_constants.dart';

class ChooseIdentityRoute extends StatefulWidget {
  @override
  _ChooseIdentityRouteState createState() => _ChooseIdentityRouteState();
}

class _ChooseIdentityRouteState extends State<ChooseIdentityRoute> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitleWidgets(),
            Expanded(
              child: _buildButtons(context)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('请选择您的身份', style: TextStyle(fontSize: 24, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('方便我们为您提供更准确的服务', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15, color: Color.fromRGBO(102, 102, 102, 1)))
        ],
      ),
    );
  }

  Widget _buildButtons(parentContext) {
    return Container(
      margin: EdgeInsets.only(top: 86, left: 25, right: 25, bottom: 75),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child:
            InkWell(
              child:Container(height: 130,child:
              Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:50,left: 20.0),
  //                margin: EdgeInsets.only(top: 32.5),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15),offset: Offset(1.5, 1.5),blurRadius: 7.5)]
                    ),
                    child: Container(alignment:Alignment.centerRight,margin: EdgeInsets.only(right: 25),child:Text('我要求职',
                       style: TextStyle(fontSize: 17, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold)),),
               ),
               ),
                Container(alignment:Alignment.bottomLeft,
                  child: Image.asset(join(AssetsUtil.assetsDirectoryLogin,'person01.png')),),
              ],),),
              onTap: () {
                _setUserIdentity(1).then((success) {
                  if (success) {
//                    Get.offAll(PersonBasicEdit());
                  ///路由跳转
                    Navigator.of(parentContext).push(MaterialPageRoute(builder: (context){
                      return PersonBasicEdit();
                    }));
                  }
                });
              },
            ),),
          Container(child:
            InkWell(
              child:Container(height: 130,child:
              Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:50,right: 20.0),
  //                margin: EdgeInsets.only(top: 32.5),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child:Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15),offset: Offset(1.5, 1.5),blurRadius: 7.5)]
                    ),
//                    elevation: 6,
                    child: Container(alignment:Alignment.centerLeft,margin: EdgeInsets.only(left: 25),child:Text('我要招人',
                        style: TextStyle(fontSize: 17, color: ColorConstants.themeColorBlue, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Container(alignment:Alignment.bottomRight,
                  child: Image.asset(join(AssetsUtil.assetsDirectoryLogin,'person02.png')),),
              ],),),
              onTap: () {
                _setUserIdentity(2).then((success) {
                  if (success) {
                    ///跳过
//                    Get.offAll(CompanyBasicEditRoute());
                  ///路由跳转
//                    Get.offAll(CompanyBasicEdit01());
                    Navigator.of(parentContext).push(MaterialPageRoute(builder: (context){
//                    return CompanyBasicEdit01();
//                      return CompanyBasicEditRoute();
                    return CompanyEditAll(firstInto: true,);
                  }));
                  }
                });
              },
            )),

///退出登录
//          FlatButton(padding:EdgeInsets.only(top: 20.0),
//              child: Text("退出登录",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: Color.fromRGBO(153, 153, 153, 1)),),
//            onPressed: (){
//            ///退出登录处理逻辑
//              print("退出登录！");
//            },)

          ],
        ),
      );
  }

  /// 设置用户身份
  ///
  /// @param inentityType 1 用户；2 企业
  /// @return
  Future<bool> _setUserIdentity(int identityType) async {
    var params = {"typeId": identityType};
    BotToast.showLoading();
    var responseData = await DioUtil.request("/user/switchIdentities", parameters: params);
    BotToast.closeAllLoading();

    bool success = DioUtil.checkRequestResult(responseData, showToast: true);
    return success;
  }
}