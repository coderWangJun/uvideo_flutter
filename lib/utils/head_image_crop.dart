
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:image_crop/image_crop.dart';

class HeadImageCrop extends StatefulWidget{

  String path = "";

  HeadImageCrop(this.path);

  @override
  _HeadImageCropState createState() => _HeadImageCropState();
}
class _HeadImageCropState extends State<HeadImageCrop>{

  double baseLeft,baseTop,imageWidth,imageScale = 1;
  Image imageView;

  final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(height: MediaQuery.of(context).size.height*0.8,
            child: Crop.file(File(widget.path),key: cropKey,aspectRatio: 1.0,alwaysShowGrid: true,)
              ,),
            RaisedButton(onPressed: (){
              _crop(widget.path);
            },child: Text("完成"),)
          ],
        ),
      ),
    );
  }

  Future<void> _crop(String path) async{
    final crop = cropKey.currentState;
    final area = crop.area;
    if(area != null){
      await ImageCrop.cropImage(
        file: File(path),area: area
      ).then((value){
        Get.back(result: value);
      }).catchError((e){
        print("裁剪出错了");
        Get.back(result: null);
      });
    }
  }
}