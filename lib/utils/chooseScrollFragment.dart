import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:youpinapp/provider/baseView.dart';

//自定义弹出滚动选择框(传入一个List<String>，返回一个整型数组下标)

class ChooseScrollFragmentProvider with ChangeNotifier{

  //保存当前选择的第几个
  int index = 0;

  Map _un1 = {
    "color" : Color.fromRGBO(51, 51, 51, 0.5),
    "scale" : 1.0
  };

  Map _un2 = {
    "color" : Color.fromRGBO(51, 51, 51, 0.5),
    "scale" : 0.8
  };

  Map _on = {
    "color" : Colors.blue,
    "scale" : 1.2
  };

  List<Map> stuList = [];

  init(List<String> items){
    items.forEach((element) {
      stuList.add(_un2);
    });
    stuList[0] = _on;
    stuList[1] = _un2;
  }

  changeChooseSta(int position){
    int i = 0;
    stuList.forEach((element) {
      stuList[i] = _un2;
      i++;
    });
    stuList[position] = _on;
    if(position!=0&&position!=stuList.length-1){
      stuList[position-1]= _un1;
      stuList[position+1]= _un1;
    }else if(position == 0){
      stuList[1]= _un1;
    }else if(position == stuList.length-1){
      stuList[position-1] = _un1;
    }
    index = position;
    notifyListeners();
  }
}

class ChooseScrollFragment extends StatelessWidget{

  List<String> items;

  //还没完善此逻辑，--->想法是可传入初始默认选中谁
  int defIndex = 0;
  ChooseScrollFragment(this.items,{this.defIndex});

  ScrollController controller = ScrollController();
  int _position = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      model: ChooseScrollFragmentProvider(),
      onReady:(model){model.init(items);} ,
      builder: (context,model,child){
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                bottom: 10,
                child:_getListView(context,model,items))
          ],
        );
      },
    );
  }

  Widget _getListView(BuildContext context,ChooseScrollFragmentProvider model,List<String> items){
    controller.addListener(() {
      double a = controller.position.pixels/50;
      if(a<=0){a = 0;}
      if(_position != a.floor()){
        _position = a.floor();
        if(_position>items.length-1){
          _position = items.length-1;
        }
        model.changeChooseSta(_position);
      }
    });

    List<Widget> mList = new List();

    mList.add(SizedBox(height: 90.0,));
    int index = -1;
    items.forEach((element) {
      index++;
      Widget mWidget = _getItems(element,index,model);
      mList.add(mWidget);
    });
    mList.add(SizedBox(height: 110.0,));

    return Container(
      width: MediaQuery.of(context).size.width-50,
      height: 280.0,
      margin: EdgeInsets.only(left: 25.0,right: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)))
            ),
            width: MediaQuery.of(context).size.width-50,
            height: 44.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(onPressed: (){Navigator.of(context)..pop(model.index);},
                    child:Text("确 认",style:
                  TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Color.fromRGBO(51, 51, 51, 0.7)),)),
            ),
          ),

          Expanded(
            child: ListView(
              //包裹内容，回弹效果
              physics: BouncingScrollPhysics(),
              controller: controller,
              children: mList
            ),
          )
        ],
      ),
    );
  }

  Widget _getItems(String value,int index,ChooseScrollFragmentProvider model){


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      height: 50.0,
      child: Center(
            child:Transform.scale(
              alignment: Alignment.center,
              scale: model.stuList[index]["scale"],
              child: Container(child:Text(value,style: TextStyle(
                  color: model.stuList[index]["color"],
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  decoration: TextDecoration.none),
                softWrap: true,
                textAlign: TextAlign.center,
              ),)
        )
      ),
    );
  }
}