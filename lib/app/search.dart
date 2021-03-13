import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youpinapp/app/account.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/utils/event_bus.dart';

class SearchManager extends ChangeNotifier {
  String requestUrl = "";
  SearchParameters searchParam;
  int _cur_data_type = 0;
  num nowPage = 2;
  static final num MAX_SIZE = 10;
  bool isHasNextPage = true;
  bool isLoadingFree = true;

  bool couldFlash = false;

  static List<int> VALUE_INDEX = [0, 0, 0, 0, 0, 0, 0];
  static List<int> DEF_POSITION = [0, 0, 0, 0, 0, 0, 0];

  List<HomeCompanyModel> modelListCom = [];
  List<HomeResumeModel> modelListRes = [];

  List<int> searchParamValueIndex = [0, 0, 0, 0, 0, 0, 0];
  List<int> searchParamDefPosition = [0, 0, 0, 0, 0, 0, 0];

  String nowCity = "全部";
  num nowCityId;
  bool isInit = false; // 是否是初始化操作

  //清空条件值
  clear() {
    searchParamValueIndex = [0, 0, 0, 0, 0, 0, 0];
    searchParamDefPosition = [0, 0, 0, 0, 0, 0, 0];
  }

  reBuild() {
    notifyListeners();
  }

  init() {
    this.isInit = true;
    g_eventBus.on(GlobalEvent.accountInitialized, (arg) {
      initCom();
      initReu();
    });
    if (g_accountManager.currentUser != null) {
      initCom();
      initReu();
    }
  }

  getRefresh(int _cur_data_type) {
    this._cur_data_type = _cur_data_type;
    print('isLoadingFree========= $isLoadingFree');
    print('_cur_data_type========= $_cur_data_type');
    if (isLoadingFree) {
      isHasNextPage = true;
      nowPage = 1;
      modelListRes.clear();
      modelListCom.clear();
      // if (_cur_data_type != 3) {
      //   modelListRes.clear();
      // } else {
      //   modelListCom.clear();
      // }
      getMorePage();
    }
  }

  getMorePage() {
    if (isHasNextPage && isLoadingFree) {
      isLoadingFree = false;
      bool flag = _cur_data_type != 3;
      if (_cur_data_type == 0) {
        requestUrl = "/user/getMediaWorks"; //作品
      } else if (_cur_data_type == 1 || _cur_data_type == 2) {
        if (g_accountManager.currentUser != null &&
            g_accountManager.currentUser.typeId == 1) {
          requestUrl = "/resume/getMediaResume"; //简历
        } else {
          requestUrl = "/company/getMediaResume"; //岗位
        }
        // } else if (_cur_data_type == 2) {
        //   requestUrl = "/company/getMediaResume"; //岗位
      } else {
        requestUrl = "/company/getPromo"; //企宣
      }

      // if (g_accountManager.currentUser.typeId != 1) {
      //   requestUrl = "/resume/getMediaResume";
      // } else {
      //   requestUrl = "/company/getMediaResume";
      //   flag = false;
      // }
      if (searchParam == null) {
        searchParam = SearchParameters();
      }
      searchParam.size = MAX_SIZE;
      searchParam.current = nowPage;
      print("-----------------------${searchParam.toParam()}");
      DioUtil.request(requestUrl, parameters: searchParam.toParam())
          .then((value) {
        if (DioUtil.checkRequestResult(value)) {
          if (value['data'] != null) {
            List<dynamic> dataList = value['data'];
            if (flag) {
              if (this.isInit) {
                this.isInit = false;
                modelListRes = dataList.map((json) {
                  return HomeResumeModel.fromJson(json);
                }).toList();
                modelListCom = dataList.map((json) {
                  return HomeCompanyModel.fromJson(json);
                }).toList();
              } else {
                modelListRes.addAll(dataList.map((json) {
                  return HomeResumeModel.fromJson(json);
                }).toList());
              }

              /// 临时解决初次加载数据 数据紊乱
              print('modelListCom================= $modelListCom');
              print('modelListRes================= $modelListRes');
              print('dataList================= $dataList');

              notifyListeners();
            } else {
              modelListCom.addAll(dataList.map((json) {
                return HomeCompanyModel.fromJson(json);
              }).toList());
              notifyListeners();
            }
            if (dataList.length < MAX_SIZE) {
              isHasNextPage = false;
            } else {
              nowPage++;
            }
          } else {
            isHasNextPage = false;
          }
        } else {
          isHasNextPage = false;
        }
        notifyListeners();
        isLoadingFree = true;
      });
    }
  }

  //提供初始化方法
  initReu() {
    DioUtil.request("/resume/getMediaResume").then((value) {
//      DioUtil.request("/resume/getMediaResume").then((value){
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value['data'];
        if (dataList != null) {
          modelListRes = dataList.map((json) {
            return HomeResumeModel.fromJson(json);
          }).toList();
        } else {
          modelListRes = [];
        }
        notifyListeners();
      }
    });
  }

  //提供初始化方法
  initCom() {
    /// 岗位
    DioUtil.request("/company/getMediaResume").then((value) {
//      DioUtil.request("/company/getMediaResume").then((value){
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value['data'];
        if (dataList != null) {
          modelListCom = dataList.map((json) {
            return HomeCompanyModel.fromJson(json);
          }).toList();

          /// 临时解决初次加载数据 数据紊乱
          if (this.isInit) {
            modelListRes.clear();
            this.isInit = false;
            modelListRes = dataList.map((json) {
              return HomeResumeModel.fromJson(json);
            }).toList();
          }
        } else {
          modelListCom = [];
        }
        print("完成");
        notifyListeners();
      }
    });
  }

  getProjects(SearchParameters searchParameters) {
    //查作品
    if (searchParameters.industryNo != 0) {
      searchParameters.cityNo = nowCityId;
    }
    searchParam = searchParameters;
    DioUtil.request("/user/getMediaWorks", parameters: searchParam.toParam())
        .then((value) {
//      DioUtil.request("/resume/getMediaResume").then((value){
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value['data'];
        if (dataList != null) {
          modelListRes = dataList.map((json) {
            return HomeResumeModel.fromJson(json);
          }).toList();
        } else {
          modelListRes = [];
        }
        print("完成");
        notifyListeners();
      }
    });
  }

//企宣
  getCompanyShow(SearchParameters searchParameters) {
    if (searchParameters.industryNo != 0) {
      searchParameters.cityNo = nowCityId;
    }
    searchParam = searchParameters;
    BotToast.showLoading();
    DioUtil.request("/company/getPromo", parameters: searchParam.toParam())
        .then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value["data"];
        if (dataList != null) {
          modelListCom = dataList.map((json) {
            return HomeCompanyModel.fromJson(json);
          }).toList();
        }
      } else {
        modelListCom = [];
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  getUseSimpleIntr() {
    //简历
  }

  getPositions() {
    //岗位
  }

  //岗位
  getRefreshListCompany(SearchParameters searchParameters) {
    if (searchParameters.industryNo != 0) {
      searchParameters.cityNo = nowCityId;
    }
    searchParam = searchParameters;
    BotToast.showLoading();
    DioUtil.request("/company/getMediaResume",
            parameters: searchParam.toParam())
        .then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value['data'];
        if (dataList != null) {
          modelListCom = dataList.map((json) {
            return HomeCompanyModel.fromJson(json);
          }).toList();
        } else {
          modelListCom = [];
        }
        notifyListeners();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }

  //查简历
  getRefreshListResume(SearchParameters searchParameters) {
    if (searchParameters.industryNo != 0) {
      searchParameters.cityNo = nowCityId ??= null;
    }
    searchParam = searchParameters;
    BotToast.showLoading();
    DioUtil.request("/resume/getMediaResume", parameters: searchParam.toParam())
        .then((value) {
      if (DioUtil.checkRequestResult(value, showToast: false)) {
        List<dynamic> dataList = value['data'];
        if (dataList != null) {
          modelListRes = dataList.map((json) {
            return HomeResumeModel.fromJson(json);
          }).toList();
        } else {
          modelListRes = [];
        }
        notifyListeners();
      }
    }).whenComplete(() => BotToast.closeAllLoading());
  }
}

class SearchParameters {
  //要查询的目标userid (不传就是查登录用户) (queryType需要传1)
  String userid;

  //经度
  double longitude;

  //纬度
  double latitude;

  //分页查询currentPage
  num current;

  //分页查询size
  num size;

  //行业编号
  num industryNo;

  //职位编号
  num positionNo;

  //按岗位名称搜(模糊)
  String positionName;

  //按公司名称搜(精确)
  String companyName;

  //城市编号
  num cityNo;

  //城市名
  String cityName;

  //按发布的标题搜
  String title;

  //查询类型 0/不传 所有公司 1.指定公司2.关注公司3.附近公司(需要传经纬度)
  //查询类型 0/不传 所有用户1.指定用户2.关注用户3.附近用户(需要传经纬度)
  num queryType;

  //学历index (字典接口返回)
  num diploma;

  //薪资档次index (字典接口返回)
  num salaryTreatment;

  //工作年限档次index (字典接口返回)
  num yearsOfExp;

  //公司融资阶段类型no(字典接口返回)
  num financingStageNo;

  //公司人员规模类型no(字典接口返回)
  num staffScaleNo;

  //求职状态index (字典接口返回)
  num jobStatus;

  //模糊匹配
  String searchStr;

  Map<String, dynamic> toParam() {
    return {
      'userid': userid,
      'longitude': longitude,
      'latitude': latitude,
      'current': current,
      'size': size,
      'industryNo': industryNo,
      'positionNo': positionNo,
      'positionName': positionName,
      'companyName': companyName,
      'cityNo': cityNo,
      'cityName': cityName,
      'title': title,
      'queryType': queryType,
      'diploma': diploma,
      'salaryTreatment': salaryTreatment,
      'yearsOfExp': yearsOfExp,
      'financingStageNo': financingStageNo,
      'staffScaleNo': staffScaleNo,
      'jobStatus': jobStatus,
      'searchStr': searchStr
    };
  }
}
