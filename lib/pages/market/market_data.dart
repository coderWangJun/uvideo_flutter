import 'package:path/path.dart';
import 'package:youpinapp/utils/assets_util.dart';

var recommendList = [
  {'avatarUrl': 'assets/images/market/market_avatar.png', 'name': '羡羡的小兔叽', 'subName': '', 'publishTime': '5', 'publishFrom': '校友集', 'coin': '10', 'shareCount': '6669', 'commentCount': '685 ', 'praiseCount': '2596',
    'content': '优秀的人做什么都这么优秀的吗?', 'videoConver': 'assets/images/market/market_img_content.png', 'videoUrl': 'assets/videos/resume_video1.mp4', 'atList': [], 'imgs': []},
  {'avatarUrl': 'assets/images/market/market_avatar.png', 'name': '羡羡的小兔叽', 'subName': '', 'publishTime': '6', 'publishFrom': '校友集', 'coin': '20', 'shareCount': '6669', 'commentCount': '685 ', 'praiseCount': '2596',
    'content': '优秀的人做什么都这么优秀的吗?', 'videoConver': '', 'videoUrl': '', 'atList': ['小兔几'], 'imgs': ['assets/images/market/market_img_content.png', 'assets/images/market/market_img_content.png', 'assets/images/market/market_img_content.png', 'assets/images/market/market_img_content.png', 'assets/images/market/market_img_content.png']},
  {'avatarUrl': 'assets/images/market/market_avatar.png', 'name': 'UI设计-Fang', 'subName': '明艳广告', 'publishTime': '5', 'publishFrom': '广告集', 'coin': '10', 'shareCount': '6669', 'commentCount': '685 ', 'praiseCount': '2596',
    'content': '做广告，找我们~', 'videoConver': '', 'videoUrl': '', 'atList': [], 'imgs': []},
];

var circleHomeList = [
  {'avatar': join(AssetsUtil.assetsDirectoryMarket, 'market_avatar.png'), 'name': '羡羡的小兔叽', 'time': '5', 'content': '优秀的人做什么都这么优秀的吗?', 'tags': ['摄影制作', '短视频制作'],
    'cover': join(AssetsUtil.assetsDirectoryMarket, 'market_img_content.png'), 'shareCount': '6669', 'commentCount': '685', 'praiseCount': '2596'},
  {'avatar': join(AssetsUtil.assetsDirectoryMarket, 'market_avatar.png'), 'name': 'UI设计-Fang', 'time': '6', 'content': '面试的人都好优秀啊，有什么办法提升自己的吗？', 'tags': ['摄影制作'],
    'cover': join(AssetsUtil.assetsDirectoryMarket, 'market_img_content.png'), 'shareCount': '6669', 'commentCount': '685', 'praiseCount': '2596'},
];

var relateSchools = [
  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_gongshang.png'), 'name': '重工'},
  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_chongyi.png'), 'name': '重医'},
  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_chongshi.png'), 'name': '重师'}
];

var focusSchools = [
  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_gongshang.png'), 'name': '重工', 'desc': '校友圈为大家提供方便，欢迎加入呀~'},
//  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_gongshang.png'), 'name': '重工', 'desc': '校友圈为大家提供方便，欢迎加入呀~'},
];

var createdSchools = [
  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_chongda.png'), 'name': '重大', 'desc': '校友圈为大家提供方便，欢迎加入呀~'},
//  {'logo': join(AssetsUtil.assetsDirectoryMarket, 'logo_chongda.png'), 'name': '重大', 'desc': '校友圈为大家提供方便，欢迎加入呀~'},
];