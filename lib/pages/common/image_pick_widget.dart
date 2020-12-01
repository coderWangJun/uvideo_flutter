import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickWidget extends StatefulWidget {
  final double width;
  final int columnCount;
  final Function() imagePicked;

  ImagePickWidget({this.width, this.columnCount = 3, this.imagePicked});

  _ImagePickWidgetState createState() => _ImagePickWidgetState();
}

class _ImagePickWidgetState extends State<ImagePickWidget> {
  double _gridWidth;
  List<dynamic> _selectedAssets = [];

  @override
  void initState() {
    super.initState();

    if (widget.width == 0) {
      _gridWidth = (ScreenUtil.mediaQueryData.size.width - 60) / widget.columnCount;
    } else {
      _gridWidth = widget.width / widget.columnCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _selectedAssets.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(238, 238, 238, 0.5),
            borderRadius: BorderRadius.circular(8)
          ),
        );
      }
    );
  }

}