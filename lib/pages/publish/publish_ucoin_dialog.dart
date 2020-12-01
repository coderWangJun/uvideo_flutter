import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
//import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/utils/assets_util.dart';

class PublishUcoinDialog extends StatefulWidget {

  static Future<int> showUcoinDialog(BuildContext context) async {
    return showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return PublishUcoinDialog();
    });
  }

  @override
  _PublishUcoinDialogState createState() => _PublishUcoinDialogState();
}

class _PublishUcoinDialogState extends State<PublishUcoinDialog> {
  int _currentCoin = -1;
  bool _isFocus = false;
  FocusNode _focusNode = new FocusNode();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _currentCoin = -1;
        _isFocus = !_isFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        padding: EdgeInsets.all(20),
        width: ScreenUtil.mediaQueryData.size.width - 40,
        height: 255,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Material(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitleWidgets(),
                    _buildCoinWidgets(),
                    _buildTipWidgets(),
                    _buildCommitButton(context)
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: ButtonTheme(
                    minWidth: 0,
                    height: 26,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Image.asset(join(AssetsUtil.assetsDirectoryCommon, "alert_close.png"), width: 26, height: 26),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidgets() {
    return Container(
      height: 26,
      alignment: Alignment.center,
      child: Text("收费发布", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCoinWidgets() {
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 140) / 4;
    double gridHeight = 70.0;
    double aspectRatio = gridWidth / gridHeight;

    List<Widget> childWidgets = [
      _buildCoinGrid(5, "初阶", "5U币"),
      _buildCoinGrid(10, "中阶", "10U币"),
      _buildCoinGrid(20, "高阶", "20U币"),
      _buildCustomCoinGrid()
    ];

    if (_isFocus) {
      gridWidth = ScreenUtil.mediaQueryData.size.width - 80;
      aspectRatio = gridWidth / gridHeight;
      childWidgets = [_buildCustomCoinGrid()];
    }

    return Container(
      height: 70,
      margin: EdgeInsets.only(top: 30),
      child: GridView(
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: _isFocus ? 1 : 4,
            childAspectRatio: aspectRatio
        ),
        children: childWidgets,
      ),
    );
  }
  Widget _buildCoinGrid(int buttonIndex, String title, String coin) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: _currentCoin == buttonIndex ? ColorConstants.themeColorBlue : Color.fromRGBO(238, 238, 238, 0.5),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 11, color: _currentCoin == buttonIndex ? Colors.white : Color.fromRGBO(102, 102, 102, 1))),
            SizedBox(height: 5),
            Text(coin, style: TextStyle(fontSize: 13, color: _currentCoin == buttonIndex ? Colors.white : ColorConstants.themeColorBlue))
          ],
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();

        setState(() {
          _currentCoin = buttonIndex;
        });
      },
    );
  }
  Widget _buildCustomCoinGrid() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 0.5),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("自定义", style: TextStyle(fontSize: 11, color: Color.fromRGBO(102, 102, 102, 1))),
          SizedBox(height: 5),
          Container(
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              maxLines: 1,
              focusNode: _focusNode,
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: ColorConstants.textColor153),
              decoration: InputDecoration(
                fillColor: Colors.red,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.all(0),
                border: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstants.textColor153.withOpacity(0.5)))
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTipWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text("备注：用于首页作品知识收费项目", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)),
    );
  }

  Widget _buildCommitButton(parentContent) {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: ColorConstants.themeColorBlue,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text("发布", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      onTap: () {
        if (_currentCoin > 0) {
          Get.back(result: _currentCoin);
        } else {
          int inputCoin = 0;
          if (_textEditingController.text != "") {
            inputCoin = int.parse(_textEditingController.text);
          }

          if (inputCoin > 0) {
            Get.back(result: inputCoin);
          } else {
            BotToast.showText(text: "请选择或输入U币");
          }
        }
      },
    );
  }
}