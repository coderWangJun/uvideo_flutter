import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/pages/publish/publish_market_post.dart';
import 'package:youpinapp/pages/ring/ring_waiting.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/event_bus.dart';
import 'package:youpinapp/widgets/action_sheet.dart';

class FloatingButton {
  static Widget buildJobRingButton(String tag, {EdgeInsets margin}) {
    bool ringSwitch = AccountManager.instance.ringSwitch ?? false;

    if (ringSwitch) {
      return Container(
        width: 35,
        height: 35,
        margin: margin ?? EdgeInsets.only(bottom: 60, right: 10),
        child: FloatingActionButton(
            heroTag: tag,
            child: Image.asset(join(AssetsUtil.assetsDirectoryCommon, 'job_ring.png')),
            backgroundColor: Color.fromRGBO(33, 187, 137, 1),
            onPressed: () {
              g_eventBus.emit(GlobalEvent.stopPlayEvent);
              Get.to(RingWaiting());
            }),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  // 圈子类型id，12345对应推荐、校友、同乡、行业、创业
  static Widget buildMarketPublishButton(BuildContext context, String tag, int typeId, {int circleId}) {
    print("当前类型ID：$typeId");
    return Container(
      width: 42,
      height: 42,
      margin: EdgeInsets.only(bottom: 40, right: 10),
      child: FloatingActionButton(
        heroTag: tag,
        backgroundColor: ColorConstants.themeColorBlue,
        child: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_publish.png')),
        onPressed: () {
          //Get.to(PublishMarketPost());
          ActionSheet.show(context, ["发布图文", "发布视频"]).then((index) {
            if (index != null) {
              // index 1 发布图文；2 发布视频
              if (circleId != null) {
                Get.to(PublishMarketPost(index + 1, typeId, circleId: circleId));
              } else {
                Get.to(PublishMarketPost(index + 1, typeId));
              }
            }
          });
        },
      ),
    );
  }
}