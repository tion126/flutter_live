import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/pages/home/home_reommand_entity.dart';
import 'package:flutter_live/pages/live/live_room_entity.dart';
import 'package:flutter_live/pages/live/message_list.dart';
import 'package:flutter_live/pages/live/message_manager.dart';
import 'package:flutter_live/pages/player/dy_player.dart';
import 'package:flutter_live/pages/player/dy_player_controller.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/state/base_state_mixin.dart';
import 'package:flutter_live/utils/base_response.dart';
import 'package:flutter_live/utils/dio_utils.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/appbar.dart';
import 'package:flutter_live/widget/bb_image.dart';
import 'package:flutter_live/widget/button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

class LivePage extends StatefulWidget {
  final String url;
  LivePage(this.url);

  @override
  State<StatefulWidget> createState() {
    return LivePageState();
  }
}

class LivePageState extends State<LivePage> with BaseStateMixin,DYPlayerEventHandler {
  RefreshController refreshController = RefreshController();
  GlobalKey bannerKey = GlobalKey();
  LiveRoomEntity? datas;
  List<HomeRecList> recommandDatas = [];
  String url = "";
  DYPlayerController? playerController;

  @override
  void initialization() {
    super.initialization();
    this.loadData();
  }

  @override
  void loadData() async {
    await DioUtils.get(widget.url).then((resp) {
      var reg = RegExp(r"(?<=var\s\$ROOM\s\=)[^}]+}?");
      var json = reg.firstMatch(resp.data)?.group(0) ?? "";
      this.datas = LiveRoomEntity().fromJson(jsonDecode(json));
      MessageManager.share.rid = this.datas?.rid;
    });

    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var auth = Utils.genMD5Insensitive("${this.datas?.rid}$timestamp");

    await DioUtils.post(
        "https://playweb.douyucdn.cn/lapi/live/hlsH5Preview/${this.datas?.rid}",
        header: {
          'rid': this.datas?.rid,
          'time': timestamp,
          'auth': auth
        },
        params: {
          'rid': this.datas?.rid,
          'did': '10000000000000000000000000001501'
        }).then((value) {
      if (value.data['error'] != 0) {
        this.setError(BaseResponse(msg: value.data['msg']));
        return;
      }
      String rtmp = value.data['data']['rtmp_live'];
      RegExp reg = RegExp(r'(\d{1,7}[0-9a-zA-Z]+)_?\d{0,4}(/playlist|.m3u8)');
      String? key = reg.firstMatch(rtmp)?.group(1);
      this.url = "http://dyscdnali1.douyucdn.cn/live/$key.flv?uuid=";
      this.setIdle();
    }).catchError((e) {
      this.setError(e);
    });

    DioUtils.get<List<HomeRecList>>(
            "https://m.douyu.com/api/room/alikeList?rid=3125893&count=10")
        .then((value) {
      this.recommandDatas = value.data;
      this.viewRefresh();
    });
  }

  @override
  Widget body() {
    return AnnotatedRegion(child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [_live(), _tab()])), value: BarDefaultStyle);
  }

  void onPlayerCreate(DYPlayerController c){
    this.playerController = c;
    this.playerController?.start(url);
    this.playerController?.eventHandler = this;
  }
  @override
  void didTapBack(){
   BBRouter.pop();
  }

  Widget _live() {
    return Container(color: Colors.black,child: SafeArea(left: false,right: false,bottom: false,child: AspectRatio(
        aspectRatio: 375 / 210,
        child: DYPlayer(this.onPlayerCreate))));
  }

  Widget _tab() {
    return Expanded(
        child: Container(
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  SizedBox(
                      height: 40,
                      child: TabBar(
                          indicatorColor: COLOR_FF5D23,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: COLOR_FF5D23,
                          labelStyle:
                              TextStyle(fontSize: 16, fontWeight: BoldWeight),
                          unselectedLabelColor: COLOR_999999,
                          unselectedLabelStyle:
                              TextStyle(fontSize: 15, fontWeight: BoldWeight),
                          tabs: [Text("聊天"), Text("主播")])),
                  SizedBox(height: 2),
                  Container(height: 0.5, color: COLOR_EEEEEE),
                  Expanded(
                      child: TabBarView(children: [_message(), _roomInfo()]))
                ]))));
  }

  Widget _message() {
    return MessageList();
  }

  Widget _roomInfo() {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 34),
        child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10),
              Row(children: [
                BBImage(
                    url: this.datas?.avatar, height: 60, width: 60, radius: 30),
                SizedBox(width: 6),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(this.datas?.roomName ?? ""),
                      Text(this.datas?.nickname ?? ""),
                      Text("房间号 : ${this.datas?.rid}"),
                    ])),
                Container(height: 30, width: 1, color: COLOR_EEEEEE),
                Button(
                    child: Icon(Icons.share, color: COLOR_FF5D23),
                    height: 40,
                    width: 40,
                    onPressed: () {
                      Share.share(widget.url);
                    }),
              ]),
              SizedBox(height: 10),
              Text("主播公告"),
              SizedBox(height: 10),
              Text(this.datas?.notice ?? ""),
              Container(height: 0.5, color: COLOR_F5F6FA),
              SizedBox(height: 10),
              _recommand()
            ])));
  }

  Widget _recommand() {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: this.recommandDatas.length,
      itemBuilder: (BuildContext context, int index) {
        var model = this.recommandDatas[index];
        return InkWell(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Stack(children: [
                    AspectRatio(
                        aspectRatio: 194 / 109,
                        child: BBImage(
                            url: model.roomSrc, fit: BoxFit.cover, radius: 4)),
                    if (Utils.isNotEmpty(model.cate2Name))
                      Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                              padding: EdgeInsets.all(2),
                              child: Text(model.cate2Name ?? "",
                                  style: TextStyle(
                                      color: COLOR_EEEEEE, fontSize: 12)),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)))))
                  ]),
                  Text(model.roomName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  Container(
                      child: Row(children: [
                    Expanded(
                        child: Text(model.nickname ?? "",
                            style: TextStyle(color: COLOR_999999, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)),
                    BBImage(
                        url: "ic-account",
                        imageType: ImageContentType.assets,
                        height: 13,
                        width: 13,
                        color: COLOR_999999),
                    Text("${model.hn}",
                        style: TextStyle(color: COLOR_999999, fontSize: 13)),
                  ]))
                ])),
            onTap: () {
              BBRouter.pushReplacement(LivePage(
                  "https://m.douyu.com/${model.rid}?type=${model.cate2Name}"));
            });
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 5.0,
    );
  }
}
