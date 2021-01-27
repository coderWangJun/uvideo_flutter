import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:youpinapp/app/search.dart';
import 'package:youpinapp/models/home_company_model.dart';
import 'package:youpinapp/pages/home/company_detail.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class HomeGridCompany extends StatefulWidget {
  final Map categoryMap;

  HomeGridCompany(this.categoryMap);

  @override
  _HomeGridCompanyState createState() => _HomeGridCompanyState();
}

class _HomeGridCompanyState extends State<HomeGridCompany> {
  List<HomeCompanyModel> _companyList = [];

  SearchParameters searchParameters = SearchParameters();
  ScrollController _scrollController;

  @override
  void didUpdateWidget(HomeGridCompany oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 行业切换后重新加载数据
    _loadCompanyList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    // 调试时模拟器的宽度是178
    double gridWidth = (ScreenUtil.mediaQueryData.size.width - 55) / 2;
    double gridHeight = 170;
    double widthScale = gridWidth / gridHeight;
//    double gridHeight = 220 * widthScale; // 图片110，下边的文字80，加起来是190

    if (_companyList.length > 0) {
      return GridView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: gridWidth,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: widthScale),
        children: _companyList.map((companyModel) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Color.fromRGBO(239, 239, 239, 1), width: 1)),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child: CachedNetworkImage(
                                imageUrl: companyModel.coverUrl,
                                width: (ScreenUtil.mediaQueryData.size.width -
                                        55) /
                                    2,
                                height: gridHeight - 70,
                                fit: BoxFit.cover ?? "")),
                        Image.asset(
                            join(AssetsUtil.assetsDirectoryCommon,
                                'video_play.png'),
                            width: 80.w,
                            height: 80.h)
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Color.fromRGBO(239, 239, 239, 1),
                                width: 1))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(companyModel.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    fontSize: 30.w,
                                    fontWeight: FontWeight.w900)),
                            Expanded(
                              child: Text(
                                  companyModel.salaryTreatmentString ?? "",
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color.fromRGBO(79, 154, 247, 1),
                                      fontSize: 25.w,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                  imageUrl: companyModel.headPortraitUrl ?? "",
                                  width: 24,
                                  height: 24,
                                  placeholder: (context, imageProvider) {
                                    return Image.asset(
                                        join(AssetsUtil.assetsDirectoryHome,
                                            'company_avatar_circle.png'),
                                        width: 24,
                                        height: 24);
                                  }),
                            ),
                            SizedBox(width: 5.w),
                            Text(companyModel.companyName ?? "云达科技",
                                style: TextStyle(
                                    fontSize: 22.w,
                                    color: Color.fromRGBO(102, 102, 102, 1)))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              // 点击格格
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return CompanyDetail(companyModel);
              }));
            },
          );
        }).toList(),
      );
    } else {
      return Container(
        constraints: BoxConstraints.expand(),
        child: EmptyWidget(
          showTitle: "空空如也",
        ),
      );
    }
  }

//加载企业列表
  void _loadCompanyList() async {
    var params = {};
    if (widget.categoryMap != null && widget.categoryMap['index'] != -1) {
      params['industryNo'] = widget.categoryMap['index'];
    }
    print(params);

    DioUtil.request('/company/getMediaResume', parameters: params)
        .then((responseData) {
      _companyList.clear();

      bool success = DioUtil.checkRequestResult(responseData, showToast: false);
      if (success) {
        List<dynamic> dataList = responseData['data'];
        List<HomeCompanyModel> modelList = dataList.map((json) {
          return HomeCompanyModel.fromJson(json);
        }).toList();

        _companyList.addAll(modelList);
      }

      setState(() {});
    });
  }
}
