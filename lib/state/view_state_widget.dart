import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/appbar.dart';
import 'package:flutter_live/widget/button.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,child: LayoutBuilder(builder: (ctx, cons) {
      var maxH = cons.maxHeight;
      var screenH = MediaQuery.of(context).size.height;
      bool showAppBar = maxH == screenH && BBRouter.pages.length > 1;
      return Container(color: Colors.white,child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (showAppBar) DefaultAppBar(),
                Expanded(
                    child: Center(
                            child: Image.asset("assets/images/ic-page-loading.gif",height: 200,width: 200)))
              ]));
    }));
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String title;
  final Widget image;
  final String buttonTitle;
  final VoidCallback onPressed;

  ViewStateWidget(
      {Key? key,
      required this.onPressed,
      required this.image,
      required this.title,
      required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,child: LayoutBuilder(builder: (ctx, cons) {
      var maxH = cons.maxHeight;
      var screenH = MediaQuery.of(context).size.height;
      bool showAppBar = maxH == screenH && BBRouter.pages.length > 1;
      return Container(
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (showAppBar) DefaultAppBar(),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    this.image,
                    SizedBox(height: 12),
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            color: COLOR_333333,
                            fontWeight: RegularWeight)),
                    ViewStateButton(
                      onPressed,
                      buttonTitle,
                    ),
                  ],
                ))
              ]));
    }));
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final String? title;
  final Widget? image;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    Key? key,
    required this.onPressed,
    this.image,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage = BBImage(url:"ic-page-error",imageType: ImageContentType.assets,height:200,width:200);
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? "页面错误",
      buttonTitle: "重试",
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String? title;
  final Widget? image;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget(
      {Key? key, this.image, this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage = BBImage(url:"ic-page-error",imageType: ImageContentType.assets,height:200,width:200);
    return ViewStateWidget(
        onPressed: this.onPressed,
        image: image ?? defaultImage,
        title: title ?? "暂无数据",
        buttonTitle: "刷新");
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  ViewStateButton(this.onPressed, this.title);

  @override
  Widget build(BuildContext context) {
    return Button(
      margin: EdgeInsets.only(top: 30),
      borderRadius: 4,
      width: 100,
      height: 30,
      borderWidth: 1,
      borderColor: COLOR_666666,
      child: Text(
        title,
        style: TextStyle(wordSpacing: 5, fontSize: 14, color: COLOR_666666),
      ),
      onPressed: onPressed,
    );
  }
}
