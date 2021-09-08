import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/pages/home/home_reommand_entity.dart';
import 'package:flutter_live/pages/live/live_page.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/state/base_state_mixin.dart';
import 'package:flutter_live/utils/dio_utils.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/bb_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeRecommandList extends StatefulWidget {
  HomeRecommandList();

  @override
  State<StatefulWidget> createState() {
    return HomeRecommandListState();
  }
}

class HomeRecommandListState extends State<HomeRecommandList>
    with AutomaticKeepAliveClientMixin,BaseStateMixin {
  RefreshController refreshController = RefreshController();
  List<HomeRecommandEntity> datas = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initialization() {
    super.initialization();
    this.loadData();
  }

  @override
  Widget body() {
    return SmartRefresher(
        controller: refreshController,
        onRefresh: this.loadData,
        child: _contentList());
  }

  Widget _contentList() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: this.datas.length,
        itemBuilder: (ctx, index) {
          var model1 = this.datas[index];
          return Container(
              child: Column(children: [
            Container(
                child: Row(children: [
                  BBImage(url: model1.icon, height: 20, width: 20),
                  SizedBox(width: 5,),
                  Expanded(
                      child: Text(model1.tabName ?? "",
                          style: TextStyle(color: COLOR_333333, fontSize: 14))),
                  Text("更多",
                      style: TextStyle(color: COLOR_666666, fontSize: 12)),
                  BBImage(
                      url: "ic-arrow-right",
                      imageType: ImageContentType.assets,
                      height: 10,
                      width: 10,
                      color: COLOR_999999),
                ]),
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 10)),
            StaggeredGridView.countBuilder(
              padding: EdgeInsets.only(left: 10, right: 10),
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: model1.xList?.length,
              itemBuilder: (BuildContext context, int index) {
                var model2 = model1.xList?[index];
                return InkWell(
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Stack(children: [
                            AspectRatio(
                                aspectRatio: 194 / 109,
                                child: BBImage(
                                    url: model2?.roomSrc,
                                    fit: BoxFit.cover,
                                    radius: 4)),
                            if (Utils.isNotEmpty(model2?.hn))
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Row(children: [
                                        BBImage(url: "ic-hot",height: 11,width: 11,imageType: ImageContentType.assets),
                                        Text(model2!.hn!,
                                          style: TextStyle(
                                              color: COLOR_EEEEEE,
                                              fontSize: 12))
                                      ]),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)))))
                          ]),
                          Text(model2?.roomName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          Text(model2?.nickname ?? "",
                                    style: TextStyle(
                                        color: COLOR_999999, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                        ])),
                    onTap: () {
                      BBRouter.push(LivePage("https://m.douyu.com/${model2?.rid}?type=${model2?.cate2Name}"));
                    });
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 5.0,
            )
          ]));
        });
  }

  void loadData() {
    DioUtils.get<List<HomeRecommandEntity>>("https://m.douyu.com/api/home/mix").then((value) {
      this.datas = value.data;
      this.setIdle();
      this.refreshController.refreshCompleted();
    }).catchError((err) {
      this.refreshController.refreshFailed();
      this.setError(err);
    });
  }


}
