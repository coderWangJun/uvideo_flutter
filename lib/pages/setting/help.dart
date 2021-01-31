import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:get/get.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/agreement/agreement_detail_route.dart';

class UserHelp extends StatefulWidget {
  UserHelp({Key key}) : super(key: key);

  @override
  _UserHelpState createState() => _UserHelpState();
}

class _UserHelpState extends State<UserHelp> {
  List<Map<String, dynamic>> _helpFeedbackDatas = [
    {
      'index': 0,
      'title': '举报中心',
    },
    {
      'index': 1,
      'title': '我的认证',
    },
    {
      'index': 2,
      'title': '意见反馈',
    },
    {
      'index': 3,
      'title': '隐私政策',
      'forwardWidget': AgreementDetailRoute(
        "隐私政策",
        index: 3,
      ),
    },
    {
      'index': 4,
      'title': '防骗指南',
    },
    {
      'index': 5,
      'title': '注销账号',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void _requestFocusFn(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UiUtil.getAppBar("帮助与反馈"),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _requestFocusFn(context),
        child: Column(
          children: <Widget>[
            _buildSearch(),
            _buildContainer(),
            _buildStaffService(),
          ],
        ),
      ),
      // body: Container(
      //   child: SingleChildScrollView(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      //       child: Text("联系方式：\n\n     黄先生：18523453207\n     邮箱：2096221185@qq.com")
      //   ),
      // ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 44,
      padding: EdgeInsets.only(left: 20, right: 20, top: 14),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(1, 1, 1, 0.5),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '搜索',
            hintStyle: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              fontSize: 14,
              letterSpacing: 3,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return SingleChildScrollView(
      child: Column(
        children: _helpFeedbackDatas
            .map(
              (item) => _buildRowItem(
                index: item['index'],
                title: item['title'],
                forwardWidget: item['forwardWidget'],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRowItem({
    @required int index,
    @required String title,
    String value = '',
    Widget forwardWidget,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      margin: EdgeInsets.fromLTRB(
        20,
        index == 0 ? 10 : 0,
        20,
        0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ),
      ),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
                style:
                    TextStyle(fontSize: 15, color: ColorConstants.textColor51)),
            Row(
              children: <Widget>[
                Text(value,
                    style: TextStyle(
                        fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1))),
                SizedBox(width: 10),
                Image.asset(join(
                    AssetsUtil.assetsDirectoryCommon, "icon_forward_small.png"))
              ],
            )
          ],
        ),
        onTap: () async {
          if (forwardWidget != null) {
            await Get.to(forwardWidget);
          }
        },
      ),
    );
  }

  Widget _buildStaffService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Text(
            '人工客服',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
