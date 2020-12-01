import 'package:flutter/cupertino.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/chat/chat_data.dart';

class ChatNotice extends StatefulWidget {
  @override
  _ChatNoticeState createState() => _ChatNoticeState();
}

class _ChatNoticeState extends State<ChatNotice> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noticeList.length,
      itemBuilder: (BuildContext context, int index) {
        var rowData = noticeList[index];

        return Container(
          padding: EdgeInsets.only(top: 12.5, bottom: 12.5, left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Image.asset(rowData['head']),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(rowData['type'], style: TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
                        Text(rowData['time'], style: TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)))
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(rowData['content'], style: TextStyle(fontSize: 12, color: ColorConstants.textColor51))
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}