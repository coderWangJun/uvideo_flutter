import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youpinapp/global/color_constants.dart';

class VideoPicker extends StatefulWidget {
  static Future<File> showVideoPicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
      return VideoPicker();
    });
  }

  @override
  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  final _imagePicker = new ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("拍照", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
                    onPressed: () async {
                      //var pickedFile = await ImagePicker.pickVideo(source: ImageSource.camera);
                      var pickedFile = await _imagePicker.getVideo(source: ImageSource.camera);
                      if (pickedFile != null) {
                        var tempFile = new File(pickedFile.path);
                        Navigator.of(context).pop(tempFile);
                      }
                    },
                  ),
                ),
                Divider(height: 1, color: ColorConstants.dividerColor),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("从相册中选择", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
                    onPressed: () async {
                      //var pickedFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
                      // var pickedFile = await _imagePicker.getVideo(source: ImageSource.gallery);
                      // if (pickedFile != null) {
                      //   var tempFile = new File(pickedFile.path);
                      //   Navigator.of(context).pop(tempFile);
                      // }
                      FilePickerResult result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp4']
                      );

                      if (result != null) {
                        File file = new File(result.files.single.path);
                        Navigator.of(context).pop(file);
                      }
                    },
                  ),
                )
              ],
            )
          ),
          Divider(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FlatButton(
              child: Text("取消", style: TextStyle(fontSize: 17, color: ColorConstants.textColor51)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}