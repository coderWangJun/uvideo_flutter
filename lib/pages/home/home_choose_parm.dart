import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/provider/choose_tiaojian_search.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';

class HomeChooseParm extends StatefulWidget{

  SearchManager model;

  HomeChooseParm(this.model);

  @override
  State createState() {
    return HomeChooseParmImpl();
  }
}
class HomeChooseParmImpl extends State<HomeChooseParm>{


  List<Widget> _itemList = [SizedBox.shrink(),SizedBox.shrink(),SizedBox.shrink(),SizedBox.shrink(),SizedBox.shrink(),SizedBox.shrink(),SizedBox.shrink(),];

  BuildContext _context;

  ChooseTiaoJian _chooseTiaoJian = ChooseTiaoJian();

  ///暂存选择的条件
  List<int> _paramValueIndex = new List();
  List<int> _paramPosition = new List();


  ///list直接用=赋值的话改变该变量的值单例变量的值也变了，对象直接赋值=>应该是引用了同一地址
  @override
  void initState() {
    super.initState();

//    _paramValueIndex = _allParameter.searchParamValueIndex;
//    _paramPosition = _allParameter.searchParamDefPosition;
    _paramValueIndex.addAll(widget.model.searchParamValueIndex);
    _paramPosition.addAll(widget.model.searchParamValueIndex);
    _getJsonData();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ChangeNotifierProvider<ChooseTiaoJian>(create: (_)=>_chooseTiaoJian,child:
      Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              brightness: Brightness.light,
              leading: IconButton(
                icon: Image.asset(join(AssetsUtil.assetsDirectoryHome,"Fork.png")),
                onPressed: (){
                  Navigator.of(context)..pop();
                },
              ),
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: _itemList
                        ),
                      )
                ),
              ),
            Container(
              height: 65,
              width: MediaQuery.of(_context).size.width,
              padding: EdgeInsets.only(top: 12.5,bottom: 12.5,left: 20.0,right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 23,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(75, 152, 244, 1),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: FlatButton(
                        child: Text("清除",style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        onPressed: (){
                          _chooseTiaoJian.reset();
                          _paramValueIndex.clear();
                          _paramValueIndex.addAll(SearchManager.VALUE_INDEX);
                          _paramPosition.clear();
                          _paramPosition.addAll(SearchManager.DEF_POSITION);
//                          _paramPosition = AllParameter.SEARCH_PARAM_DEF_POSITION;
//                          _paramValueIndex = AllParameter.SEARCH_PARAM_VALUE_INDEX;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 9.5,),
                  Expanded(
                    flex: 42,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(79, 154, 247, 1),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: FlatButton(
                        child: Text("确定",style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                        onPressed: (){
                          widget.model.searchParamValueIndex.clear();
                          widget.model.searchParamValueIndex.addAll(_paramValueIndex);
                          widget.model.searchParamDefPosition.clear();
                          widget.model.searchParamDefPosition.addAll(_paramPosition);
                          SearchParameters sea = SearchParameters();
                          sea.diploma = _paramValueIndex[0];
                          sea.jobStatus = _paramValueIndex[1];
                          sea.salaryTreatment = _paramValueIndex[2];
                          sea.yearsOfExp = _paramValueIndex[3];
                          sea.industryNo = _paramValueIndex[4];
                          sea.staffScaleNo = _paramValueIndex[5];
                          sea.financingStageNo = _paramValueIndex[6];
//                          Provider.of<SearchManager>(context,listen: false).getRefreshListCompany(sea);
                          int flagType = g_accountManager.currentUser.typeId;
                          if(flagType==1){
                            widget.model.getRefreshListCompany(sea);
                          }else if(flagType==2){
                            widget.model.getRefreshListResume(sea);
                          }
                          Navigator.of(context)..pop();
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],),)
        );
  }

  _getJsonData() async{
    DioUtil.request("/resource/getPublishAndSearchOptions",method: 'GET').then((responseData){
      if(DioUtil.checkRequestResult(responseData)){
        if(responseData["data"]["diplomaList"]!=null){_getItemChoose(0, "学历要求", responseData["data"]["diplomaList"] as List);}
        if(responseData["data"]["jobStatusList"]!=null){_getItemChoose(1, "到岗时间", responseData["data"]["jobStatusList"] as List);}
        if(responseData["data"]["salaryTreatmentList"]!=null){_getItemChoose(2, "薪资待遇", responseData["data"]["salaryTreatmentList"] as List);}
        if(responseData["data"]["yearsOfExpList"]!=null){_getItemChoose(3, "经验要求", responseData["data"]["yearsOfExpList"] as List);}
        if(responseData["data"]["industryList"]!=null){_getItemChoose(4, "行业", responseData["data"]["industryList"] as List);}
        if(responseData["data"]["staffScaleList"]!=null){_getItemChoose(5, "公司规模", responseData["data"]["staffScaleList"] as List);}
        if(responseData["data"]["financingStageList"]!=null){_getItemChoose(6, "融资阶段", responseData["data"]["financingStageList"] as List);}
      }
    });
  }

  _getItemChoose(int index,String title,List value) async{
        List<Widget> listButton = new List();

        for(int i=0;i<value.length;i++){
          if(i == _paramPosition[index]){
            _chooseTiaoJian.add(index, true);
          }else{
            _chooseTiaoJian.add(index, false);
          }
          Widget wid = _getButtonItem(value[i]["name"] as String,index,i,value[i]["index"] as num);
          listButton.add(wid);
        }
        listButton.toList();
        Widget item = Container(
          margin: EdgeInsets.only(bottom: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(title,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 17.0,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
              ),
              Wrap(
                spacing: 10.0,
                children: listButton,
              )
            ],
          ),
        );

        setState(() {
          _itemList[index] = item;
        });
  }

  ///name: 显示的名字  index: 属于哪一个模块  position: 在该模块中属于第几个  valueIndex: 传入后台的值
  Widget _getButtonItem(String name,int index,int position,int valueIndex){
    return Consumer(builder : (BuildContext context,ChooseTiaoJian ctj,Widget child){
      return Container(
              margin: EdgeInsets.only(top: 10.0),
              width: MediaQuery.of(_context).size.width/3-20.0,
              height: 35.0,
              decoration: ctj.data[index][position]["dec"],
              child: FlatButton(
                child: Text(name,style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w500,color: ctj.data[index][position]["color"]),textAlign: TextAlign.center,),
                onPressed: (){
                  ///点击框框
                  _chooseTiaoJian.tap(index,position);
//                  _chooseTiaoJian.changeValue(index, valueIndex,position);
                  _paramPosition[index] = position;
                  _paramValueIndex[index] = valueIndex;
                },
              ),
          );
    });
  }


}