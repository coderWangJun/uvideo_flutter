import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/provider/editPerson/person_edit_01.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PersonBasicEditSecond extends StatelessWidget{

  PersonEditSecond personEditSecond;

  PersonBasicEditSecond(this.personEditSecond);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: PersonEditSecond(),
      onReady: (model){
        if(personEditSecond.firstInit){
          model.skillText = personEditSecond.skillText;
          model.count = personEditSecond.count;
          model.firstInit = personEditSecond.firstInit;
        }
        else{
          model.initValue();
        }
        },
      builder: (context,model,child){
        return Scaffold(
          appBar: PreferredSize(child:
              AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                leading:IconButton(icon: Image.asset(join(AssetsUtil.assetsDirectoryCommon,"nav_back_black.png")),onPressed: (){
                  ///back返回上一步
                  Navigator.of(context)..pop(null);
                },),
                elevation: 0,
//                actions: <Widget>[
//                  GestureDetector(
//                    child: Center(child:Text("跳 过",style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1),fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
//                    onTap: (){
//                      //点击保存
//                      print("${model.realName}---${model.birthdayString}---${model.workTimeString}");
//                      model.saveAndUpdateUser();
//                    },
//                  ),
//                  SizedBox(width: 20.0,)
//                ],
              )
              , preferredSize: Size(double.infinity,44.0)),
          body: _getBody(context,model),
          bottomNavigationBar:FlatButton(child:Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width-40,
            margin: EdgeInsets.only(right: 20.0,left: 20.0,bottom: 60.0),
            height: 44.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(75, 152, 244, 1),
            ),
              child: Text("完成",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0,color: Colors.white),),),
          onPressed: (){
            //点击保存
            model.saveTags();
            Navigator.of(context)..pop(model);
          },
          )
        );
      },
    );
  }


  Widget _getBody(BuildContext context,PersonEditSecond model){
    int position = -1;
    List<Widget> skillList = model.skillText.map((e){
      position++;
      return _getSkillItem(context,e,model,position);
    }).toList();
    //尾部添加一个自定义元素，position设置999
    skillList.add(_getSkillItem(context,{
      "skillName" : "+自定义",
      "skillNo"   : 999,
      "flag"      : true
    }, model, 999));
    return Container(
      width: double.infinity,height: double.infinity,color: Colors.white,
      padding: EdgeInsets.only(left: 20.0),
      child: SingleChildScrollView(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              //column开始
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("技能标签",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0,color: Color.fromRGBO(51, 51, 51, 1)),),
                SizedBox(height: 5.0,),
                Text("输入或者选择技能标签，最多3个",style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: 13.0),),
                SizedBox(height: 10.0,),
                Wrap(
                  children: skillList
                ),
              ],
            ),
          ],)
      ),
    );
  }

  //item中由flag，skillName，skillNo---->暂时不知道skillNo怎么样先放在里面
  Widget _getSkillItem(BuildContext context,Map item,PersonEditSecond model,int position){
    Map map = new Map();
    if(item["flag"] as bool){
      map = model.onItem;
    }else{
      map = model.unItem;
    }
    return GestureDetector(
      child:Container(
        margin: EdgeInsets.only(right: 10.0,bottom: 10.0),
        height: 24.0,
        padding: EdgeInsets.only(left: 10.0,right: 10.0),
        decoration: BoxDecoration(
          color: map["backColor"],
          borderRadius: BorderRadius.circular(5.0),
            ),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Text(item["skillName"],style:
              TextStyle(color: map["textColor"],fontSize: 12.0),textAlign: TextAlign.center,
          ),],)
        ),
      onTap: (){
        if(position!=999){
          model.changeItemState(position);
        }else{
          //点击自定义的逻辑
          showInputDialog(context, model);
//          model.addUserInputSkill("摸鱼~~~");
        }
      },
    );
  }

  void showInputDialog(BuildContext context,PersonEditSecond model){
    String skillText = "";
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("自定义",style: TextStyle(fontWeight: FontWeight.bold),),
          content: TextField(
            decoration: InputDecoration(
              hintText: "请输入自定义标签",
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value){
              if(value!=null){
                skillText = value;
              }
            },
          ),
//          title: Center(
//            child: Text("自定义标签",style: TextStyle(
//              color: Colors.black,fontWeight: FontWeight.bold,
//            ),),
//          ),
          actions: <Widget>[
            FlatButton(onPressed: (){
                Navigator.of(context)..pop();
                model.addUserInputSkill(skillText);
              }, child: Text("完成")),
          ],
        );
      }

    );
  }

}