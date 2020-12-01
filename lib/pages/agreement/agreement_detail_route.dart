import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/appText.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class AgreementDetailRoute extends StatelessWidget {
  final String title;
  int index;
  AgreementDetailRoute(this.title,{this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtil.getAppBar(title),
      body: Container(
        child: SingleChildScrollView(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child:index!=3?
                Text(index==0?AppText.fwxy:AppText.yhxy)
                :
                Text("隐私政策：\n\n${AppText.fwxy}\n\n\n\n\n服务协议：\n\n${AppText.yhxy}")
        ),
      ),
    );
  }
}