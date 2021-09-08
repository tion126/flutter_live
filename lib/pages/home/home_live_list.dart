import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/pages/home/home_live_entity.dart';
import 'package:flutter_live/pages/live/live_page.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/state/base_state_mixin.dart';
import 'package:flutter_live/utils/dio_utils.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/bb_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeLiveList extends StatefulWidget {

  final String? type;
  HomeLiveList(this.type);
  
  @override
  State<StatefulWidget> createState() {
    return HomeLiveListState();
  }
}

class HomeLiveListState extends State<HomeLiveList>
  with AutomaticKeepAliveClientMixin,BaseStateMixin{
  
  @override
  bool get wantKeepAlive => true;

  int page = 1;
  RefreshController refreshController = RefreshController();
  List<HomeLiveCategoryList> datas = [];

  @override
  void initialization() {
    super.initialization();
    this.loadData();
  }


  @override
  Widget body() {
    return  SmartRefresher(
          controller: refreshController,
          onRefresh: this.loadData,
          enablePullUp: true,
          onLoading: () {
            this.loadData(pageNum: this.page + 1);
          },
          child: _contentList());
  }
  
  Widget _contentList(){

    return StaggeredGridView.countBuilder(
              padding: EdgeInsets.only(left: 10, right: 10),
              crossAxisCount: 2,
              itemCount: this.datas.length,
              itemBuilder: (BuildContext context, int index) {
                var model = this.datas[index];
                return InkWell(
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Stack(children: [
                            AspectRatio(
                                aspectRatio: 194 / 109,
                                child: BBImage(
                                    url: model.roomSrc,
                                    fit: BoxFit.cover,
                                    radius: 4)),
                            if (Utils.isNotEmpty(model.hn))
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Row(children: [
                                        BBImage(url: "ic-hot",height: 11,width: 11,imageType: ImageContentType.assets),
                                        Text(model.hn!,
                                          style: TextStyle(
                                              color: COLOR_EEEEEE,
                                              fontSize: 12))
                                      ]),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)))))
                          ]),
                          Text(model.roomName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          Text(model.nickname ?? "",
                                    style: TextStyle(
                                        color: COLOR_999999, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                        ])),
                    onTap: () {
                      BBRouter.push(LivePage("https://m.douyu.com/${model.rid}?type=${widget.type}"));
                    });
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 5.0,
            );
  }

  void loadData({int pageNum = 1}) {
    DioUtils.get<HomeLiveEntity>("https://m.douyu.com/api/room/list?page=$pageNum&type=${widget.type}").then((value) {
      HomeLiveEntity data = value.data;
      if (pageNum == 1 && data.xList?.length == 0) {
        this.setEmpty();
        return;
      }
      if (pageNum == 1) {
        this.datas = data.xList ?? [];
      } else {
        this.datas.addAll(data.xList ?? []);
      }

      this.page = pageNum;
      this.refreshController.refreshCompleted();
      this.refreshController.loadComplete();
      this.setIdle();
      if ((data.pageCount ?? 0) <= (data.nowPage ?? 0)) {
        this.refreshController.loadNoData();
      }
    }).catchError((err) {
      this.refreshController.refreshFailed();
      this.setError(err);
    });
  }

}
