import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';
import 'package:youpinapp/app/imProvider.dart';
import 'package:youpinapp/models/index.dart';
import 'package:youpinapp/pages/market/circle_more/circle_detail.dart';
import 'package:youpinapp/pages/market/market_list_detail.dart';
import 'package:youpinapp/pages/person/user_detail_route.dart';
import 'package:youpinapp/provider/baseView.dart';
import 'package:youpinapp/utils/assets_util.dart';
import 'package:youpinapp/utils/dataTime_string.dart';
import 'package:youpinapp/utils/dio_util.dart';
import 'package:youpinapp/utils/uiUtil.dart';
import 'package:youpinapp/widgets/empty_widget.dart';
import 'package:youpinapp/widgets/single_video_player.dart';

class MarketPostList extends StatefulWidget {
  List<MarketPostModel> postList;
  String apiUrl = '/market/getMarketList';
  Map params = {};
  bool refreshByMine = false;
  MarketPostListProvider marketPostListProvider;
  bool scrollerFlag= false;
  ScrollController controller;
  bool darkModel = false;
  MarketPostList(this.postList,this.apiUrl,this.params,{this.refreshByMine = false,this.controller,this.marketPostListProvider,this.scrollerFlag = false, this.darkModel = false});

  @override
  _MarketPostListState createState() => _MarketPostListState(marketPostListProvider);
}

class _MarketPostListState extends State<MarketPostList> with AutomaticKeepAliveClientMixin{

  ScrollController scrollController;
  MarketPostListProvider marketPostListProvider;

  _MarketPostListState(this.marketPostListProvider);

  @override
  void initState() {
    if(marketPostListProvider==null){
      marketPostListProvider = new MarketPostListProvider();
    }
    super.initState();
  }

  int i = 0;


  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if((widget.postList==null || widget.postList.length == 0)&&!widget.refreshByMine){
      if(i==0){
        i=1;
        return SizedBox.shrink();
      }else{
        return EmptyWidget(showTitle: "空空如也",);
      }
    } else{
      return BaseView(model: marketPostListProvider,
        onReady: (model){
        model.params = widget.params;
        scrollController = widget.controller??=new ScrollController();
        if(widget.refreshByMine){
          model.getRefresh(widget.apiUrl,widget.params);
        }else{
          model.mPostModel = widget.postList??=[];
        }
        scrollController.addListener(() {
          if(scrollController.position.pixels>=scrollController.position.maxScrollExtent){
            model.getMorePage(widget.apiUrl);
          }
        });
        model.initProvider();},
        onDispose: (model){},
        builder: (context,model,child){
          return Container(
            padding: EdgeInsets.only(top: 20),
            constraints: BoxConstraints.expand(),
            child: RefreshIndicator(child: _buildCommentList(model),onRefresh: () async{
              model.getRefresh(widget.apiUrl,widget.params);
            },)
      );
      },);
    }
  }


  // 推荐列表
  Widget _buildCommentList(MarketPostListProvider model) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 20.0),
      child: model.mPostModel.length>0?ListView.separated(
        physics: widget.refreshByMine && !widget.scrollerFlag?NeverScrollableScrollPhysics():BouncingScrollPhysics(),
        controller: widget.refreshByMine && !widget.scrollerFlag?null:scrollController,
        itemCount: model.mPostModel.length,
        itemBuilder: (BuildContext context, int index) {
          MarketPostModel postModel = model.mPostModel[index];

          return GestureDetector(behavior: HitTestBehavior.opaque,child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildRowHead(postModel,index,model),
              _buildContent(postModel,index,model),
              _buildVideo(postModel,index,model),
              _buildImageGrid(postModel,index,model),
              SizedBox(height: 20.0,),
              postModel.cityName!=null&&postModel.cityName!=""?
              UiUtil.getContainer(20.0, 5.0, UiUtil.getColor(238),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(join(AssetsUtil.assetsDirectoryHome,"home_locator.png"),width: 14.0,height: 14.0,),
                      Text(postModel.cityName??="",
                        style: UiUtil.getTextStyle(154, 13.0),)
                    ],
                  ),
                  mWidth: 70.0)
              :SizedBox.shrink(),

              _buildBottomButtons(postModel,index,model)
            ],
          ),onTap: (){
            Get.to(MarketListDetail(model.mPostModel[index],model.itemStuMap[index])).then((value){
              if(value!=null){
                if(value==1){
                  model.getRefresh(widget.apiUrl,widget.params);
                }else{
                  model.notifyChangeStateByBack(value, index);
                }
              }
            });
          },);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 15, color: Colors.transparent);
        },
      ):model.emp,
    );
  }

  // 头像
  Widget _buildRowHead(MarketPostModel postModel, int index,MarketPostListProvider model) {
    bool flagIsHasCircleName = false;
    if(postModel.marketCircleName!=null&&postModel.marketCircleName!=''){flagIsHasCircleName = true;}
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              GestureDetector(behavior: HitTestBehavior.opaque,child:Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(237, 237, 237, 1), width: 1),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(imageUrl: postModel.headPortraitUrl??=ImProvider.DEF_HEAD_IMAGE_URL, width: 50, height: 50) ,
                ),
              ),onTap: (){
                Get.to(UserDetailRoute(userId:postModel.userid));
              },),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(postModel.name ?? "", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: widget.darkModel ? Colors.white : Color.fromRGBO(1, 1, 1, 1))),
                      SizedBox(width: 5),
                      Text(postModel.companyName ?? "", style: TextStyle(fontSize: 13, color: Color.fromRGBO(141, 141, 141, 1)))
                    ],
                  ),
                  Row(children: <Widget>[

                    Text.rich(TextSpan(
                        children: [
                          TextSpan(text:'${DataTimeToString.toTextString(DateTime.parse(postModel.createdTime))}发布', style: TextStyle(fontSize: 13, color: Color.fromRGBO(141, 141, 141, 1))),
                          TextSpan(text: flagIsHasCircleName?"于":"", style: TextStyle(fontSize: 13, color: Color.fromRGBO(141, 141, 141, 1))),
                        ]
                    )),
                          Visibility(visible: flagIsHasCircleName,child: GestureDetector(child:
                              Text(postModel.marketCircleName??="", style: TextStyle(fontSize: 13, color: Color.fromRGBO(75, 152, 244, 1))),
                            onTap: (){
                              Get.to(CircleDetail(postModel.marketCircleId));
                            },),)
                  ],),
                ],
              )
            ],
          ),
        ),
        postModel.ucoinAmount!=0.0?Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_coin.png')),
            Divider(color: Colors.transparent, height: 2),
            Text('${postModel.ucoinAmount}优币', style: TextStyle(fontSize: 10, color: Color.fromRGBO(255, 221, 61, 1)))
          ],
        ):SizedBox.shrink(),
      ],
    );
  }

  // 内容
  Widget _buildContent(MarketPostModel postModel, int index,MarketPostListProvider model) {
    List<InlineSpan> spans = [];
    spans.add(TextSpan(text: postModel.content, style: TextStyle(fontSize: 15, color: widget.darkModel ? Colors.white : Color.fromRGBO(1, 1, 1, 1))));

    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      alignment: Alignment.centerLeft,
      child: Text.rich(TextSpan(
          children: spans
      )),
    );
  }

  // 视频
  Widget _buildVideo(MarketPostModel postModel, int index,MarketPostListProvider model) {
    if (postModel.publishTypeId == 2) { // 1 图片+文字；2 视频+文字
      List<MarketPostMediaModel> mediaList = postModel.marketWorksList;
      if (mediaList.length > 0) {
        MarketPostMediaModel mediaItem = mediaList[0];
        return Container(
          alignment: Alignment.centerLeft,
          child: GestureDetector(behavior: HitTestBehavior.opaque,child:Container(width: 130.0,height: 220.0,child:Stack(children: <Widget>[
            UiUtil.getHeadImage(mediaItem.coverUrl, 130.0,mHeight: 220.0,isOval: false),
            Align(alignment: Alignment.center,child:
              UiUtil.getContainer(30.0, 15.0, UiUtil.getColor(235,opacity: 0.4), Icon(Icons.play_arrow,color: UiUtil.getColor(255,opacity: 0.6),),mWidth: 30.0)
            )
              ],),),
          onTap: (){
            Get.to(SingleVideoPlayer(mediaItem.worksUrl));
          },)
        );
      }
    }

    return SizedBox.shrink();
  }

  // 图片列表
  Widget _buildImageGrid(MarketPostModel listItem, int index,MarketPostListProvider model) {
    List<MarketPostMediaModel> mediaList = listItem.marketWorksList;
    int numConunt = 3;
    if (listItem.publishTypeId == 1 && mediaList.length > 0) {// 1 图片+文字；2 视频+文字
      if(mediaList.length<3){numConunt = mediaList.length;}
      return GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numConunt,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1
        ),
        children: mediaList.map((MarketPostMediaModel mediaModel) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: mediaModel.worksUrl??=ImProvider.DEF_HEAD_IMAGE_URL, fit: BoxFit.cover),
          );
        }).toList(),
      );
    }

    return SizedBox.shrink();
  }

  // 底部按钮
  Widget _buildBottomButtons(MarketPostModel postModel, int index,MarketPostListProvider model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
//        ButtonTheme(
//          minWidth: 0,
//          child: FlatButton.icon(onPressed: null,
//              icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_share.png')),
//              label: Text('${postModel.numberOfForwarding}', style: TextStyle(color: widget.darkModel ? Colors.white : Colors.black))),
//        ),

        SizedBox(width: 40,),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton.icon(onPressed: null,
              icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_comment.png')),
              label: Text('${postModel.numberOfComments}', style: TextStyle(color: widget.darkModel ? Colors.white : Colors.black))),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton.icon(onPressed: (){//点赞
            model.changePraiseStu(index,postModel.id);
          },
              icon: Image.asset(join(AssetsUtil.assetsDirectoryMarket, 'market_praise.png'),color: model.itemStuMap[index]["praiseColor"],),
              label: Text('${model.itemStuMap[index]["praiseNum"]}', style: TextStyle(color: widget.darkModel ? Colors.white : Colors.black))),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class MarketPostListProvider extends ChangeNotifier{

  bool loadingFree = true;

  static final Color praiseColor_un = Colors.grey;
  static final Color praiseColor_on = Colors.red;

  List<MarketPostModel> mPostModel = [];

  Map<int,Map> itemStuMap = {};

  Widget emp = SizedBox.shrink();

  //服务器默认的，不建议更改
  static final int sizeNum = 10;
  int nowPage = 2;
  //是否还有下一页
  bool isHasNext = true;


  Map params = {};

  initProvider(){
    Color colors;
    int index  = 0;
    mPostModel.forEach((element) {
    if(mPostModel[index].isLiked == null){colors = praiseColor_un;}else{colors = praiseColor_on;}
    Map def = {"praiseColor" : colors , "praiseNum" : mPostModel[index].likes??0};
    itemStuMap[index] = def;
    index++;
    });
  }

  //点赞
  changePraiseStu(int index,num id){
      if(itemStuMap[index]["praiseColor"]==praiseColor_un){
        DioUtil.request("/market/addLikes",parameters: {"id" : id , "flag" : 1}).then((value){if(DioUtil.checkRequestResult(value)){
          itemStuMap[index]["praiseColor"] = praiseColor_on;
          itemStuMap[index]["praiseNum"] = itemStuMap[index]["praiseNum"] + 1;
          notifyListeners();
        }});
      }else{
        DioUtil.request("/market/addLikes",parameters: {"id" : id , "flag" : 2}).then((value){if(DioUtil.checkRequestResult(value)){
          itemStuMap[index]["praiseColor"] = praiseColor_un;
          itemStuMap[index]["praiseNum"] =  itemStuMap[index]["praiseNum"] - 1;
          notifyListeners();
        }});
      }
  }

  getMorePage(String uri){
    if(isHasNext && loadingFree){
      loadingFree = false;
      List<MarketPostModel> mList = [];
      params['current'] = nowPage;
      params['size'] = sizeNum;
      DioUtil.request(uri,parameters: params).then((value){if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
        mList = (value['data'] as List).map((e){
          return MarketPostModel.fromJson(e);
        }).toList();
        if(mList.length<sizeNum){isHasNext = false;}
        nowPage++;
        mPostModel.addAll(mList);
        initProvider();
        notifyListeners();
      }else{isHasNext = false;}}
      loadingFree  = true;
      });
    }
  }

  getRefresh(String uri , Map param){
    params = param;
    List<MarketPostModel> mList = [];
    isHasNext = true;
    nowPage = 1;
    params['current'] = nowPage;
    params['size'] = sizeNum;
    DioUtil.request(uri,parameters: params).then((value){if(DioUtil.checkRequestResult(value)){if(value['data']!=null){
      mList = (value['data'] as List).map((e){
        return MarketPostModel.fromJson(e);
      }).toList();
      if(mList.length<sizeNum){isHasNext = false;}
      mPostModel.clear();
      nowPage++;
      mPostModel.addAll(mList);
      initProvider();
      notifyListeners();
    }else{isHasNext = false;
    mPostModel.clear();
    emp = EmptyWidget(showTitle:"空空如也",);
    notifyListeners();}
    }else{
      isHasNext = false;
      mPostModel.clear();
      emp = EmptyWidget(showTitle:"空空如也",);
      notifyListeners();
    }});
  }

  notifyChangeStateByBack(Map value , int index){
    itemStuMap[index] = value;
    notifyListeners();
  }


}