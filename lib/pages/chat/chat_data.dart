import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

var chatMarketList = [
  {'head': 'assets/images/chat/chat_msg_head1.png', 'name': '羡羡', 'publishTime': '6', 'publishFrom': '校友集', 'content': '好怀念啊~', 'marketImg': 'assets/images/chat/chat_market_img1.png', 'marketAt': '羡羡的小兔叽', 'marketContent': '今天去学校了，变化好多啊，有朋友 在附近吗？出来玩'},
  {'head': 'assets/images/chat/chat_msg_head2.png', 'name': '羡羡的小兔叽', 'publishTime': '8', 'publishFrom': '校友集', 'content': '嗯嗯，他们那边的苹果也很脆很甜', 'marketImg': 'assets/images/chat/chat_market_img2.png', 'marketAt': '羡羡', 'marketContent': '东路超市这边菜比较新鲜，性价比也 很高，以前怎么没发现。。'}
];

var lookList = [
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header1.png'), 'name': '陈先生', 'work': '文诺电子商务', 'coverImg': join(AssetsUtil.assetsDirectoryChat, 'chat_look_img1.png'), 'lookAt': '06-05  查看了你的作品'},
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header2.png'), 'name': '唐女士', 'work': '中景科技', 'coverImg': join(AssetsUtil.assetsDirectoryChat, 'chat_look_img2.png'), 'lookAt': '05-31  查看了你的简历'},
];

var ringList = [
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header3.png'), 'name': '李女士', 'work': '明艳传媒   人事专员', 'distance': '5km', 'time': '6月8日', 'duration': '通话时长：00:50', 'icon': join(AssetsUtil.assetsDirectoryChat, 'icon_chat_camera.png')},
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header4.png'), 'name': '陈先生', 'work': '文诺电子商务   人事...', 'distance': '18km', 'time': '6月2日', 'duration': '通话时长：11:12', 'icon': join(AssetsUtil.assetsDirectoryChat, 'icon_chat_tel.png')},
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header5.png'), 'name': '刘女士', 'work': '曼哒服装    行政', 'distance': '800m', 'time': '5月31日', 'duration': '通话时长：05:36', 'icon': join(AssetsUtil.assetsDirectoryChat, 'icon_chat_tel.png')},
];

var chatRecordList = [
  {'type': '1', 'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header1.png'), 'name': '虚拟机2', 'jobTitle': '明艳传媒公司', 'time': '6月8日', 'status': '已读', 'msg': '嗯嗯，好的','sessionid':'f10a5d13d8ab43768e78a9a6f9db06c2'},
  {'type': '1', 'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header2.png'), 'name': '虚拟机1', 'jobTitle': '天胡教育', 'time': '6月3日', 'status': '新招呼', 'msg': '你好，我们急招UI设计师，求贤若...','sessionid':'b21c62f3eea2442b8f61ee6f9ce5c70e'},
  {'type': '1', 'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header3.png'), 'name': '陈先生', 'jobTitle': '文诺电子商务', 'time': '5月30日', 'status': '送达', 'msg': '您好，请问贵司还在招UI岗位吗？','sessionid':'b21c62f3eea2442b8f61ee6f9ce5c70e'},
  {'type': '2', 'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header4.png'), 'name': '虚拟机3', 'time': '5月30日', 'status': '送达', 'focus': '关注', 'msg': '最近有时间吗？','sessionid':'4ef0d62884234da1ae1ee9042947681c'},
  {'type': '2', 'head': join(AssetsUtil.assetsDirectoryChat, 'chat_header5.png'), 'name': '真机测试', 'time': '5月30日', 'status': '已读', 'focus': '互相关注', 'msg': '好吧，我下午过来','sessionid':'82f935708c9c4a2ba360857401140ead'},
];

var noticeList = [
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_official.png'), 'type': '官方通知', 'time': '6月7日', 'content': '这样的自我介绍，才能在面试中脱颖而出'},
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_notice.png'), 'type': '系统通知', 'time': '5月31日', 'content': '检测到有新版本，是否更新？'},
  {'head': join(AssetsUtil.assetsDirectoryChat, 'chat_official.png'), 'type': '官方通知', 'time': '5月6日', 'content': '面试管问离职原因，怎么回答最好？'},
];