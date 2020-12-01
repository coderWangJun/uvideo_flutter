
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http_parser/http_parser.dart';

///枚举上传的oss文件类型，图片or视频
enum UpFileType{ image,video }

///枚举上传到的oss文件，暂时只有 集市视频 与 视频封面
enum UpFileUrlType{ marketVideo,marketCoverImage }
class UpLoadBackData{
  String fileOssName;
  String fileURL;
}
class OssUpLoad{

  //路径前缀
  static final String PREV_HEAD = "http://mingyankeji.oss-cn-chengdu.aliyuncs.com/";

  static final String OSS_KEY_ID = "LTAI4GDRbwvuszWXHCNebT2j";
  static final String OSS_KEY_SEC = "K3YlnEblDGXDiBPSGvO9Yh4InEnfl8";

  /// ---(必传) path->文件路径 , UpFileType->文件类型 , urlType上传到的文件位置,不同资源放在不同的OSS文件夹下
  /// ---(可选) onSendProgress->可传入监控进度的回调函数


  ///后台上传需要！返回一个实体类来保存数据，返回null就是上传失败了，需要判空处理
  static Future<UpLoadBackData> upLoad(String path,UpFileType theType,UpFileUrlType urlType,{ProgressCallback onSendProgress}) async{
    String mWhere = "";
    switch(urlType){
      case UpFileUrlType.marketVideo:       mWhere = "market/";break;
      case UpFileUrlType.marketCoverImage:  mWhere = "market-cover/";break;
    }
    UpLoadBackData fileData = new UpLoadBackData();
    String policyText = '{"expiration": "2090-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    List<int> policyTextUtf8 = utf8.encode(policyText);
    String policyBase64 = base64.encode(policyTextUtf8);
    List<int> policy = utf8.encode(policyBase64);
    List<int> key = utf8.encode(OSS_KEY_SEC);
    List<int> signaturePre = new Hmac(sha1, key).convert(policy).bytes;
    String signature = base64.encode(signaturePre);
    Dio dio = new Dio(BaseOptions(responseType: ResponseType.plain,contentType: "multipart/form-data"));
    String fileName = path.substring(path.lastIndexOf("."),path.length);
    fileData.fileOssName = _getRamName() + fileName;
    fileName = fileData.fileOssName;
    var contentTypeX;
    switch(theType){
      case UpFileType.video:contentTypeX = MediaType("video","mp4");break;
      case UpFileType.image:contentTypeX = MediaType("image","jpg");break;
    }
    FormData data = new FormData.fromMap({
      "Filename" :  fileName,         //  上传的文件名
      "key"      :  mWhere + fileName,  //  上传保存的路径
      "policy"   :  policyBase64,
      "OSSAccessKeyId" : OSS_KEY_ID,
      "success_action_status" : "200",
      "signature" : signature,
      "file"     :  await MultipartFile.fromFile(path,filename: fileName,contentType:contentTypeX)
    });

    try{
      Response response = await dio.post(
          "http://mingyankeji.oss-cn-chengdu.aliyuncs.com",
          data: data,
          onSendProgress: onSendProgress
      );
      fileName = mWhere + fileName;
      if(response.statusCode==200) {
        fileData.fileURL = PREV_HEAD+fileName;
        print("=================>url:----->>>+${PREV_HEAD+fileName}");
        return fileData;
      }else{
        return null;
      }
    }on DioError catch(e){
      print(e.message);
      return null;
    }
  }

  static String _getRamName(){
    String names = "abcdefghigklmnopqrstuvwxyz123456789";
    String fileName = "";
    var time = new DateTime.now();
    fileName = fileName + time.year.toString()+time.month.toString()+time.day.toString();
    for(int i=0;i<9;i++){
      int a = Random().nextInt(names.length-1);
      fileName = fileName+ names[a];
    }
    return fileName;
  }
}
