import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_data.dart';
import 'package:youpinapp/utils/assets_util.dart';

class ChatMessageLook extends StatefulWidget {
  @override
  _ChatMessageLookState createState() => _ChatMessageLookState();
}

class _ChatMessageLookState extends State<ChatMessageLook> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20),
      itemCount: lookList.length,
      itemBuilder: (BuildContext context, int index) {
        var rowData = lookList[index];

        return Container(
          padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(rowData['head']),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(rowData['name'], style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                        SizedBox(width: 5),
                        Text(rowData['work'], style: TextStyle(fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1))),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(rowData['lookAt'], style: TextStyle(fontSize: 12, color: ColorConstants.textColor51)),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(rowData['coverImg']),
                  Image.asset(join(AssetsUtil.assetsDirectoryChat, 'chat_icon_play.png'))
                ],
              )
            ],
          ),
        );
      }
    );
  }
}