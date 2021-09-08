import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/pages/home/home_category_entity.dart';
import 'package:flutter_live/pages/home/home_live_list.dart';
import 'package:flutter_live/pages/home/home_recommand_list.dart';
import 'package:flutter_live/state/base_state_mixin.dart';
import 'package:flutter_live/utils/dio_utils.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/appbar.dart';
import 'package:flutter_live/widget/bb_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with BaseStateMixin {
  List<HomeCategoryEntity> homeCategoryDatas = [];

  @override
  void initialization() {
    super.initialization();
    this.loadData();
  }

  void loadData() async {
    DioUtils.get<List<HomeCategoryEntity>>(
            "https://m.douyu.com/api/cate/recList?cid=&ct=")
        .then((value) {
      this.homeCategoryDatas = value.data;
      this.setIdle();
      print(this.homeCategoryDatas);
    }).catchError((e){
      this.setError(e);
    });
  }

  @override
  Widget body() {
    return DefaultTabController(
        length: this.homeCategoryDatas.length + 1,
        child: Scaffold(
            appBar:
                DefaultAppBar(showBackButton: false, titleWidget: _search()),
            backgroundColor: Colors.white,
            body: Column(children: [
              SizedBox(height: 10),
              TabBar(
                  labelPadding: EdgeInsets.only(left: 12, right: 12),
                  isScrollable: true,
                  labelColor: COLOR_FF5D23,
                  labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: BoldWeight,
                      color: COLOR_2D3863),
                  unselectedLabelColor: COLOR_3F3F3F,
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: RegularWeight,
                      color: COLOR_787E96),
                  indicatorPadding: EdgeInsets.only(left: 12, right: 12),
                  indicatorColor: COLOR_FF5D23,
                  tabs: [
                    Text("推荐"),
                    ...this
                        .homeCategoryDatas
                        .map<Widget>((e) => Text(e.name ?? ""))
                  ]),
              SizedBox(height: 10),
              Expanded(
                  child: TabBarView(children: [
                HomeRecommandList(),
                ...this
                    .homeCategoryDatas
                    .map<Widget>((e) => HomeLiveList(e.shortName))
                    .toList()
              ]))
            ])));
  }

  Widget _search() {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: COLOR_EEEEEE),
        child: Row(children: [
          SizedBox(width: 10),
          BBImage(
              url: "ic-search",
              imageType: ImageContentType.assets,
              height: 16,
              width: 16,
              color: COLOR_333333),
          SizedBox(width: 5),
          Text("搜索",
              style: TextStyle(
                  fontSize: 12, color: COLOR_666666, fontWeight: RegularWeight))
        ]));
  }
}
