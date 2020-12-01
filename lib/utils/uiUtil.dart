import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/utils/assets_util.dart';

class UiUtil{

  ///颜色,只传一个RGB的三个值全是一样的，
  ///num必传
  ///   num num1 num2三个参数各代表RGB的一个参数，不传的就等于num的值
  ///   opacity透明度，默认1.0
  static Color getColor(int num,{int num1=-1,int num2=-1,double opacity = 1.0}){
    if(num1==-1){num1 = num;}
    if(num2==-1){num2 = num;}
    return Color.fromRGBO(num, num1, num2, opacity);
  }

  ///返回键
  ///图标是 <
  static Widget getBackLeading(){
    return IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
      Get.back();
    },);
  }

  ///TextStyle
  ///colorNum，fontSize 必传
  ///colorNum用于RGB三个值一样的，不一样这个值随便传，采用可选参数Color c -->可使用getColor方法
  ///fontSize表示字体大小
  ///  isBold是否加粗，默认不加粗
  static TextStyle getTextStyle(int colorNum,double fontSize,{bool isBold = false,Color c}){
    if(c==null){c = getColor(colorNum);}
    return TextStyle(color: c,fontSize: fontSize,fontWeight: isBold?FontWeight.bold:FontWeight.normal,decoration: TextDecoration.none);
  }

  ///头像
  ///  uri图片的url地址，可选参数path表示本地图片地址（path传了uri就随便传，反正没用）
  ///  mWidth宽度，mHeight默认等于mWidth
  ///  isOval 是否是圆形的，默认是true，false就是矩形
  static Widget getHeadImage(String uri,double mWidth,{double mHeight,bool isOval = true,String path = "",
    var mPadding = EdgeInsets.zero,var mBoxShadow,Color backColor = Colors.white}){
    if(mHeight==null || mHeight == 0){mHeight = mWidth;}
    return Container(
      padding: mPadding,
      width: mWidth, height: mHeight,
      decoration: BoxDecoration(
        boxShadow: mBoxShadow,
        color: backColor,
        image: DecorationImage(image: path == ""?
          NetworkImage(uri??=ImProvider.DEF_HEAD_IMAGE_URL):FileImage(File(path??=ImProvider.DEF_HEAD_IMAGE_URL))
            ,fit: BoxFit.cover),
        shape: isOval?BoxShape.circle:BoxShape.rectangle
      ),
    );
  }

  ///按钮样式
  ///不写了
  static Widget getContainer(double mHeight,double radius,Color backgroundColor,Widget childText,{double mWidth = double.infinity,
    BoxConstraints constraints,
    Border borders
  }){
    if(borders==null){
      borders = Border(top: BorderSide.none,left: BorderSide.none,right: BorderSide.none,bottom: BorderSide.none);
    }
    if(constraints!=null){
      return Container(
        height: mHeight,
        constraints: constraints,
        decoration: BoxDecoration(
            border: borders,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius)
        ),
        child: Center(child: childText,),
      );
    }else{
      return Container(
        width: mWidth,height: mHeight,
        decoration: BoxDecoration(
            border: borders,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius)
        ),
        child: Center(child: childText,),
      );
    }
  }

  ///导航栏
  static Widget getAppBar(String centerText, {
    Color backgroundColor = Colors.white,bool essIsLight = true,
    List<Widget> actionsListWidget,
    Widget leadingWidget,
    double fSize = 17.0}){
    return PreferredSize(
      preferredSize: Size(double.infinity, 44.0),
      child: AppBar(
        backgroundColor: backgroundColor,
        brightness: essIsLight?Brightness.light:Brightness.dark,
        leading: leadingWidget==null?IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
          Get.back();
        },):leadingWidget,
        elevation: 0,
        centerTitle: true,
        title: Text(centerText,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: fSize,fontWeight: FontWeight.bold),),
        actions: actionsListWidget!=null?actionsListWidget:[SizedBox.shrink()],
      ),
    );
  }

  static Widget getUserItems(double mHeight,double mWidth,double paddingValue,
      Widget headImage,
      List<Widget> userTopRow,List<Widget> userBotRow,
      Widget widgetEnd,{bool isHasBotBorder = true}
      ){
    return Container(
      width: mWidth,height: mHeight,
      padding: EdgeInsets.only(left: paddingValue,),
      decoration: BoxDecoration(
        border: isHasBotBorder?Border(bottom: BorderSide(color: UiUtil.getColor(235))):null
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
            headImage,
            SizedBox(width: 12.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: userTopRow,),
                Row(children: userBotRow,),
              ],
            ),]),
          Container(child:widgetEnd)
        ],
      ),
    );
  }
  
  
  static Widget getOkButtonCon(double mWidth,double mHeight,String mText,GestureTapCallback onTapOk,GestureTapCallback onTapNo,
      {double mRadius = 2.0,bool isHasNo = true,}){
    return Center(child:Container(
      width: mWidth,height: mHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black54,offset: Offset(2.0, 2.0),blurRadius: 4.0)],
        borderRadius: BorderRadius.circular(mRadius)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text("$mText",style: getTextStyle(51, 15.0),softWrap: true,),
          ),
          Row(
            mainAxisAlignment: isHasNo?MainAxisAlignment.spaceEvenly:MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  child:getContainer(36.0, 10.0, Colors.white,
                      Text("确认",style: getTextStyle(0, 14.0,c: getColor(75,num1: 152,num2: 244)),),mWidth: (mWidth/2-5.0)),
                  onTap: onTapOk,
              ),
              Visibility(visible: isHasNo,child: GestureDetector(
                child:getContainer(36.0, 10.0, Colors.white,
                    Text("取消",style: getTextStyle(0, 14.0,c: getColor(75,num1: 152,num2: 244)),),mWidth: (mWidth/2-5.0)),
                onTap: onTapNo,
              ),),
            ],
          )
        ],
      ),
    ));
  }

}