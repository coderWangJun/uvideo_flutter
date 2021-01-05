import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/company/company_basic_edit_01.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/provider/editCompany/companyEditIntroduce.dart';
import 'package:youpinapp/provider/editCompany/company_edit_all_provider.dart';
import 'package:youpinapp/provider/editCompany/inputTextFild.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/chooseScrollFragment.dart';
import 'package:youpinapp/utils/head_image_crop.dart';

class CompanyEditAll extends StatelessWidget{

  bool firstInto = false;


  CompanyEditAll({this.firstInto = false});

  TextStyle _itemTextStyle = TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1),fontWeight: FontWeight.w500);

  bool isEditComp = false;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: CompanyEditAllProvider(),
      onReady: (model){model.init();model.initData();},
      builder: (context,model,child){
        return Scaffold(
          appBar: PreferredSize(preferredSize: Size(double.infinity,44.0),
            child: AppBar(
              leading: IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
                ///back返回上一步
                Navigator.of(context)..pop();
              },),
              elevation: 0,
              brightness:Brightness.light,
              backgroundColor: Colors.white,
              actions: <Widget>[
                FlatButton(
                  child: Text("完成", style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                  onPressed: () {
                    if(firstInto && !isEditComp){
                      BotToast.showText(text: '请完成你的公司名片哦');
                      return;}
                    if(model.url == null || model.url == ""){
                      BotToast.showText(text: '公司Logo不能没有哦');
                      return;}
                    if(model.companyName == null || model.companyName == ""){
                      BotToast.showText(text: '公司名称不能没有哦');
                      return;}
                    Get.back(result: 1);
                  },
                )
              ],
          ),
          ),
          body: SingleChildScrollView(child:Container(
              width: double.infinity,
//              height: MediaQuery.of(context).size.height-44,
              color: Colors.white,
              padding: EdgeInsets.only(left: 20.0,right: 20.0),child:_getBody(context,model))),
        );
      },
    );
  }

  Widget _getBody(BuildContext context,CompanyEditAllProvider model){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.5,),
        Text(model.title,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 24.0,fontWeight: FontWeight.bold),),
        SizedBox(height: 14.0,),
        Text(model.titleMore,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 13.0,fontWeight: FontWeight.w500),),
        SizedBox(height: 30.5,),
        Text("${model.proValueTitle}${model.proValue}%",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 13.0,fontWeight: FontWeight.w500),),
        SizedBox(height:9.5,),
        //进度条
        Container(
          constraints: BoxConstraints(minHeight: 24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0)
          ),
          child:LinearProgressIndicator(
            value: model.proValue/100,
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(75, 152, 244, 1)),
        )),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("我的公司名片",style: _itemTextStyle,textAlign: TextAlign.start,),),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CompanyBasicEdit01(firstIntoFlag: firstInto,);
            })).then((value){
              if(value!=null){if(value){
                isEditComp = true;
              }}
            });
          },
        ),

        Container(
          width: MediaQuery.of(context).size.width-40,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0))
          ),
          padding: EdgeInsets.only(top: 17.5,bottom: 17.5),
          child: Text("基本信息${model.proAll}/${model.proAllMAx}",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontWeight: FontWeight.bold,fontSize: 15.0),),
        ),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("公司Logo",style: _itemTextStyle,textAlign: TextAlign.start,),),
              model.url != "" ?Image.network(model.url,width: 50,height: 50,) : SizedBox.shrink(),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: () async{
          //点击公司Logo
            var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
            if(pickedFile != null){
              Get.to(HeadImageCrop(pickedFile.path)).then((value){
                if(value != null){
                  model.uploadLogoImage(value as File);
                }
              });
            }
          },
        ),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("公司名称",style: _itemTextStyle,textAlign: TextAlign.start,),),
              model.companyName != "" ? Text(model.companyName,style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 0.5)),)
                  : model.getStringStatus("未完善"),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: (){
          //点击公司名称
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return inputTextFild("公司名称", model.companyName);
            })).then((value){
              model.changeCompanyName(value);
            });
          },
        ),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("公司介绍",style: _itemTextStyle,textAlign: TextAlign.start,),),
              model.introduce != "" ? model.itemStatusJXWS : model.getStringStatus("未完善"),
              SizedBox(width: 10.0,),
            ],
          ),),
          onTap: (){
            //点击公司简介
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return inputIntroduce(model.introduce);
            })).then((value){
              model.changeIntroduce(value);
            });
          },
        ),


        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("公司位置",style: _itemTextStyle,textAlign: TextAlign.start,),),
              model.address != "" ? Text(model.address,style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 0.5)),) :
              model.getStringStatus("未完善"),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: (){
            //点击公司位置
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return inputTextFild("公司位置", model.address);
            })).then((value){
              model.changeAddress(value);
            });
          },
        ),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("融资阶段",style: _itemTextStyle,textAlign: TextAlign.start,),),
              (model.financingStage != null && model.financingStage != "") ? Text(model.financingStage,style: _itemTextStyle) :
              model.getStringStatus("未完善"),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: (){
            //点击融资阶段
            List<String> data = [];
            for(int i=1;i<model.dataFinancing.length;i++){
              data.add(model.dataFinancing[i]["name"]);
            }
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context){
                return ChooseScrollFragment(data,defIndex: model.financingStageNo,);
              }
            ).then((value){
              if(value != null){
                model.changeFinancingStage(model.dataFinancing[value+1]["index"] as num);
              }
            });
          },
        ),

        GestureDetector(child:Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1),width: 1.0)),
          ),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Text("人员规模",style: _itemTextStyle,textAlign: TextAlign.start,),),
              (model.staffScaleName != "" && model.staffScaleName != null) ? Text(model.staffScaleName,style: _itemTextStyle) :
              model.getStringStatus("未完善"),
              SizedBox(width: 10.0,),
              Image.asset(join(AssetsUtil.assetsDirectoryCommon,"icon_forward_normal.png"))
            ],
          ),),
          onTap: (){
            //点击人员规模
            List<String> data = [];
            for(int i=1;i<model.dataStaff.length;i++){
              data.add(model.dataStaff[i]["name"]);
            }
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context){
                  return ChooseScrollFragment(data,defIndex: model.staffScaleNameNo);
                }
            ).then((value){
              if(value != null){
                model.changeStaffScaleName(model.dataStaff[value+1]["index"] as num);
              }
            });
          },
        ),

      ],
    );
  }

}