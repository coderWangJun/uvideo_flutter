import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/core/drag_scale_widget.dart';
import 'package:youpinapp/utils/uiUtil.dart';

class ImageBig extends StatefulWidget{
  List<String> mImageUrls;
  int index = 0;
  ImageBig(this.mImageUrls,{this.index});
  @override
  _ImageBigState createState() => _ImageBigState();
}

class _ImageBigState extends State<ImageBig>{


  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = new PageController(initialPage:widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: UiUtil.getAppBar("图片详情",backgroundColor: Colors.black,essIsLight: false),
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        children:widget.mImageUrls.map((e){
          return _getImageItems(e);
      }).toList(),)
    );
  }

  Widget _getImageItems(String imageUrl){
    return Center(child: DragScaleContainer(
      doubleTapStillScale: false,
      child: new Image(image: NetworkImage(imageUrl)),
    ),);
  }
}