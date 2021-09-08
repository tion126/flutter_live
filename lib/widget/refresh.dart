import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

var indicatorStyle =
    TextStyle(fontSize: 13, color: COLOR_3F3F3F);


class RefreshFooter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RefreshFooterState();
  }
}

class RefreshFooterState extends State<RefreshFooter>{
  @override
  Widget build(BuildContext context) {
    return CustomFooter(
    builder: (context,mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = Text("下拉加载更多", style: indicatorStyle);
      } else if (mode == LoadStatus.loading) {
        body = Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          CupertinoActivityIndicator(),
          Text("正在加载更多数据", style: indicatorStyle)
        ]);
      } else if (mode == LoadStatus.failed) {
        body = Text("加载失败", style: indicatorStyle);
      } else if (mode == LoadStatus.canLoading) {
        body = Text("下拉加载更多", style: indicatorStyle);
      } else {
        body = Text("暂无更多数据", style: indicatorStyle);
      }
      return Container(
        height: 55.0,
        child: Center(child: body),
      );
    },
   );
  }
}



class RefreshHeader extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RefreshHeaderState();
  }
}

class RefreshHeaderState extends State<RefreshHeader>{

  double offset = 0;
  RefreshStatus status = RefreshStatus.idle;
  double opacity = 0.2;
  double height = 60;

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
    height: height,
    onOffsetChange: (e){
      this.offset = e;
      this.offsetChange();
    },
    onModeChange: (m){
      this.status = m ?? RefreshStatus.idle;
    },
    onResetValue: (){
      this.offset = 0;
      this.offsetChange();
    },
    builder: (context,mode) {
      Widget body = Container();
      switch (mode) {
        case RefreshStatus.refreshing:
        case RefreshStatus.completed:
          body = Image.asset("assets/images/ic-refreshing.gif",width: height,height: height);
          break;
        case RefreshStatus.idle:
        case RefreshStatus.canRefresh:
        case RefreshStatus.failed:
          body = Opacity(opacity: this.opacity,child: Image.asset("assets/images/ic-refreshidle.png",width: height,height: height));
          break;
        default:
      }
      return Container(
        height: height,
        child: Center(child: body),
      );
    },
   );
  }

  void offsetChange(){
    if (this.status == RefreshStatus.idle && offset <= height && offset >= 0) {
        this.opacity = offset.clamp(0, height)/height;
        this.setState(() {});
    }else{
        this.opacity = 1;
    }
  }
}
