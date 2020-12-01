import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/global/color_constants.dart';
import 'package:youpinapp/models/home_company_model.dart';
import 'package:youpinapp/pages/common/app_bar_white.dart';
import 'package:youpinapp/pages/publish/publish_invite_video.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/widgets/empty_widget.dart';

class CompanyJobManage extends StatefulWidget {
  @override
  _CompanyJobManage createState() => _CompanyJobManage();
}

class _CompanyJobManage extends State<CompanyJobManage> with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;

  List<HomeCompanyModel> _companyJobs = [];
  List<HomeCompanyModel> _companyJobsNormal = [];
  List<HomeCompanyModel> _companyJobsClosed = [];
  List<String> _tabbarTitles = ["全部", "开放中", "已关闭"];
  TabController _tabController;

  _CompanyJobManage() {
    _tabController = TabController(length: _tabbarTitles.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadCompanyJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWhite(title: "管理职位"),
      body: Column(
        children: <Widget>[
          _buildTabBarWidgets(),
          Expanded(
            child: _buildListWidgets(context),
          ),
          _buildButtonWidgets()
        ],
      ),
    );
  }

  Widget _buildTabBarWidgets() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConstants.dividerColor, width: 1)),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        indicatorColor: ColorConstants.themeColorBlue,
        indicatorPadding: EdgeInsets.only(bottom: 10),
        unselectedLabelColor: Colors.black.withOpacity(0.6),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        labelColor: ColorConstants.textColor51,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        controller: _tabController,
        tabs: _tabbarTitles.map((title) {
          return Tab(text: title);
        }).toList(),
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      )
    );
  }

  Widget _buildListWidgets(parentContext) {
    List<HomeCompanyModel> jobList = _companyJobs;
    if (_currentTabIndex == 1) {
      jobList = _companyJobsNormal;
    } else if (_currentTabIndex == 2) {
      jobList = _companyJobsClosed;
    }

    return jobList.length > 0 ? ListView.separated(
      itemCount: jobList.length,
      itemBuilder: (BuildContext context, int index) {
        HomeCompanyModel jobModel = jobList[index];

        String jobDesc = "";
        if (jobModel.cityName != null && jobModel.cityName != "") {
          jobDesc += "${jobModel.cityName}|";
        }
        if (jobModel.diploma != null && jobModel.diploma != "") {
          jobDesc += "${jobModel.diploma}|";
        }
        if (jobModel.yearsOfExpString != null && jobModel.yearsOfExpString != "") {
          jobDesc += "${jobModel.yearsOfExpString}|";
        }
        if (jobModel.salaryTreatmentString != null && jobModel.salaryTreatmentString != "") {
          jobDesc += "${jobModel.salaryTreatmentString}";
        }

        return Slidable(
          key: Key("$index"),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            height: 90,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: jobModel.coverUrl ?? "",
                  width: 106,
                  height: 60,
                  fit: BoxFit.cover,
                  color: Colors.grey.withOpacity(0.3),
                  colorBlendMode: BlendMode.color,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(jobModel.title, style: TextStyle(fontSize: 17, color: ColorConstants.textColor51, fontWeight: FontWeight.bold)),
                      (jobDesc != "") ? Text(jobDesc, style: TextStyle(fontSize: 13, color: ColorConstants.textColor153)) : SizedBox.shrink()
                    ],
                  ),
                ),
                (jobModel.status == 2) ? Text("已关闭", style: TextStyle(fontSize: 12, color: ColorConstants.textColor153)) : SizedBox.shrink()
              ],
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '修改',
              color: ColorConstants.themeColorBlue,
              icon: Icons.edit,
              onTap: () {
                _modifyJobAction(jobModel);
              },
            ),
            IconSlideAction(
              caption: '删除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                _deleteJobRequest(jobModel, parentContext);
              },
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: ColorConstants.dividerColor, height: 1);
      },
    ) : EmptyWidget();
  }

  Widget _buildButtonWidgets() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.themeColorBlue
          ),
          child: Text("发布新职位", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        onTap: () {
          Get.to(PublishInviteVideo());
        },
      ),
    );
  }

  void _loadCompanyJobs() {
    var params = {"queryType": "1"};
    DioUtil.request("/company/getMediaResume", parameters: params).then((response) {
      bool success = DioUtil.checkRequestResult(response, showToast: false);
      if (success) {
        _companyJobs.clear();
        _companyJobsNormal.clear();
        _companyJobsClosed.clear();

        List<dynamic> dataList = response['data'];
        List<HomeCompanyModel> modelList = dataList.map((json) {
          return HomeCompanyModel.fromJson(json);
        }).toList();
        _companyJobs.addAll(modelList);

        for (HomeCompanyModel jobModel in _companyJobs) {
          if (jobModel.status == 1) {
            _companyJobsNormal.add(jobModel);
          } else {
            _companyJobsClosed.add(jobModel);
          }
        }
      }

      setState(() { });
    });
  }

  // 点击修改按钮，进入岗位编辑页面
  void _modifyJobAction(HomeCompanyModel jobModel) {
    Get.to(PublishInviteVideo(jobId: jobModel.id));
  }

  // 删除岗位
  void _deleteJobRequest(jobModel, parentContext) {
    showDialog(context: parentContext, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("温馨提示"),
        content: Text("确定要删除吗？"),
        actions: <Widget>[
          FlatButton(
            child: Text("确定"),
            onPressed: () {
              Get.back();

              var params = {"id": jobModel.id};
              BotToast.showLoading();
              DioUtil.request("/company/deleteMediaResume", parameters: params).then((responseData) {
                bool success = DioUtil.checkRequestResult(responseData);
                if (success) {
                  BotToast.showText(text: responseData["msg"]);
                  _loadCompanyJobs();
                }
              }).whenComplete(() => BotToast.closeAllLoading());
            },
          ),
          FlatButton(
            child: Text("取消"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    });
  }
}