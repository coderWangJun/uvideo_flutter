import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:youpinapp/utils/dio_util.dart';

class ChatMessageHuiFu extends StatefulWidget{

  int reply;
  int belong;
  int marketId;

  ChatMessageHuiFu(this.reply, this.belong, this.marketId);

  @override
  _ChatMessageHuiFuState createState() => _ChatMessageHuiFuState();
}
class _ChatMessageHuiFuState extends State<ChatMessageHuiFu>{

  TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size(double.infinity,44.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(onTap: (){
                Get.back();}, child: Text(
                "取消",style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),fontSize: 15.0
              ),
              )),
              Expanded(child:Text("回复评论",textAlign: TextAlign.center,style: TextStyle(
            color: Color.fromRGBO(51, 51, 51, 1),fontSize: 17.0,fontWeight: FontWeight.bold
          ),)),],),

          actions: <Widget>[
            RaisedButton(onPressed: (){
              //发送
              DioUtil.request("/market/updateMarketComment",
                  parameters: {
                    "marketId":widget.marketId,
                    "replyTo":widget.reply,
                    "belongTo":widget.belong,
                    "content":_controller.text}).then((value){
                Get.back();
              });
            },color:Colors.white,elevation:0,child: Container(decoration: BoxDecoration(
                  color: Color.fromRGBO(79, 153, 247, 1),
                  borderRadius: BorderRadius.circular(14.0)
              ),width: 65.0,height: 28.0,child:
                Center(child:Text("发送",style: TextStyle(
                  color: Colors.white,fontSize: 15.0
                ),))
                ,)
              ,)
          ],
        ),
      ),

      body: Column(children: <Widget>[
        Expanded(child: Container(decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromRGBO(221, 221, 221, 1)))
        ),padding: EdgeInsets.symmetric(vertical: 13.0,horizontal: 20.0),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 7,
            decoration: InputDecoration(
              hintText: "写评论...",
              hintStyle: TextStyle(
                color: Color.fromRGBO(153, 153, 153, 1),fontSize: 15.0
              ),
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(borderSide:BorderSide.none)
            ),
          ),
        )
        ,),

        Container(decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
          height: 35,width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(icon: Icon(Icons.alternate_email)
                  , onPressed: (){
                      print("@人");
                  }),

              IconButton(icon: Icon(Icons.sentiment_satisfied)
                  , onPressed: (){
                    print("表情包");
                  }),
            ],
          ),
        ),
      ],)
    );
  }
}