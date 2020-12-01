import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/app/storage.dart';
import 'package:youpinapp/pages/home/home_choose_city.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/provider/tap_icon_search_provider.dart';
import 'package:youpinapp/utils/assets_util.dart';

class TapIconSearch extends StatelessWidget{

  SearchManager searchModel;

  TapIconSearch(this.searchModel);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: TapIconSearchProvider(),
      onReady: (model){model.init();},
      builder: (context,model,child){
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity,44.0),
            child: AppBar(
                brightness: Brightness.light,
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      height: 27.0,
                      child:GestureDetector(child:
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(searchModel.nowCity,style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: 15.0),textAlign: TextAlign.end,),
                            Icon(Icons.arrow_drop_down,color: Color.fromRGBO(102, 102, 102, 1),size: 12.0,)
                          ],
                        ),
                        onTap: (){
                        //点击城市
                          searchModel.couldFlash = false;
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return HomeChooseCity(searchModel,provider: model,);
                          }));
                        },
                    ),),
                  Expanded(child: Container(
                      height: 27.0,
                      padding: EdgeInsets.only(left: 13.5,right: 13.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.5),
                        color: Color.fromRGBO(244, 244, 244, 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'icon_search.png'),color: Color.fromRGBO(153, 153, 153, 1),),
                          Expanded(child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            height: 27.0,
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value){
                                int accType = g_accountManager.currentUser.typeId;
                                SearchParameters params = SearchParameters();
                                params.searchStr = value;
                                if(accType == 1){//个人
                                  //查询
                                  searchModel.getRefreshListCompany(params);
                                }else if(accType == 2){//公司
                                  //查询
                                  searchModel.getRefreshListResume(params);
                                }
                                g_storageManager.addStorageList(StorageManager.USER_SEARCH_HISTORY, value).then((value){
                                  Navigator.of(context)..pop();
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "请输入职位/公司/行业/技能",
                                hintStyle: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontSize: 12.0),
                              border: OutlineInputBorder(borderSide: BorderSide.none)
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),)
                ],),
                actions: <Widget>[
                  GestureDetector(
                    child: Center(
                      child: Text("取消",style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: 15.0),textAlign: TextAlign.start,),
                    ),
                    onTap: (){
                      Navigator.of(context)..pop();
                    },
                  ),
                  SizedBox(width: 20.0,)
                ],
              ),),
          body: _GetBody(model,context),
        );
    },
    );
  }

  Widget _GetBody(TapIconSearchProvider model,BuildContext context){
    return Container(color: Colors.white,padding: EdgeInsets.only(left: 20.0),height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(child:Column(
       children: <Widget>[
         Visibility(
           visible: model.isShowFlag,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Container(
                    child: Text("搜索历史",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1)),),),
                   IconButton(icon: Icon(Icons.delete_outline),color: Color.fromRGBO(153, 153, 153, 1),
                      onPressed: (){
                          model.changeShowFlag();
                          g_storageManager.removeStorage(StorageManager.USER_SEARCH_HISTORY);
                      },
                   )
                 ],),
               Wrap(
                 children: _getListSearchHistory(model),
               ),
             ],
           ),
         ),


//         Column(
//           children: <Widget>[
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(top:50.0,bottom: 10.0),
//                   child: Text("在线职位",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0,color: Color.fromRGBO(51, 51, 51, 1)),),),
//               ],),
//
//                Container(height: 55.0,child:ListView(scrollDirection: Axis.horizontal,children: _getListOnLineWorks(model),)),
//           ],
//         )


       ],
      ),));
  }

  List<Widget> _getListSearchHistory(TapIconSearchProvider model){
    List<Widget> history = new List();
    model.searchHistory.forEach((value){
      Widget item = GestureDetector(child:Container(padding: EdgeInsets.only(right: 20.0),child:
          Text(value,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 12.0),),),
          onTap: (){
            int accType = g_accountManager.currentUser.typeId;
            SearchParameters params = SearchParameters();
            params.searchStr = value;
            if(accType == 1){//个人
              //查询
              searchModel.getRefreshListCompany(params);
            }else if(accType == 2){//公司
              //查询
              searchModel.getRefreshListResume(params);
            }
          },
      );
      history.add(item);
    });
    return history;
  }
}

  List<Widget> _getListOnLineWorks(TapIconSearchProvider model){
      if(model.onLineWorks.length>0){
          List<Widget> onLineWorks = model.onLineWorks.map((e){
              return GestureDetector(child:Container(color:Color.fromRGBO(244, 244, 244, 1),height: 55.0,padding:EdgeInsets.all(5.0),margin: EdgeInsets.only(right: 20.0),child:
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(e["name"],style: TextStyle(fontSize: 13,color: Color.fromRGBO(51, 51, 51, 1)),),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("${e["city"]}·",style: TextStyle(fontSize: 12,color: Color.fromRGBO(153, 153, 153, 1)),),
                      Text("${e["money"]}",style: TextStyle(fontSize: 12,color: Color.fromRGBO(79, 154, 247, 1)),),
                ],)
              ],),),
                onTap: (){
                    print("点击了${e["name"]}+++>>>${e["id"]}");
                },
              );
          }).toList();
          return onLineWorks;
      }else{
        return [];
      }
  }