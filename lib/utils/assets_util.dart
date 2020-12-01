

class AssetsUtil {
  // Common图片目录路径
  static final String assetsDirectoryCommon = 'assets/images/common';

  // 登录注册相关的图片存放目录
  static final String assetsDirectoryLogin = 'assets/images/login';

  // 求职铃相关的图片目录
  static final String assetsDirectoryRing = 'assets/images/ring';

  // 首页图片存放的目录
  static final String assetsDirectoryHome = 'assets/images/home';

  // 集市相关图片存放的目录
  static final String assetsDirectoryMarket = 'assets/images/market';

  // 圈子相关图片存放的目录
  static final String assetsDirectoryCircle = 'assets/images/circle';

  // 聊天相关图片存放的目录
  static final String assetsDirectoryChat = 'assets/images/chat';

  // 我的相关图片存放的目录
  static final String assetsDirectoryMine = 'assets/images/mine';

  // 我的相关图片存放的目录
  static final String assetsDirectoryPerson = 'assets/images/person';

  // 设置界面相关的图片存放路径
  static final String assetsDirectorySetting = 'assets/images/setting';

  // 发布相关的图片存放路径
  static final String assetsDirectoryPublish = 'assets/images/publish';

  // 简历封面
  static final String assetsDirectoryResume = 'assets/images/home/resume';

  // 视频存放目录
  static final String assetsVideoDirectory = 'assets/videos';

  // 获取文件绝对路径
  static String pathForAsset(String dirPath, String fileName) {
    return "$dirPath/$fileName";
  }
}

String imagePath(String dirName, String imageName) {
  return "assets/images/$dirName/$imageName";
}

//
//Image getAssetImage(String dirName, String imageName) {
//  return Image.asset("assets/images/$dirName/$imageName");
//}