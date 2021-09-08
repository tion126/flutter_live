import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/widget/bb_image.dart';
import 'package:flutter_live/widget/button.dart';

double appbarHeight = Platform.isIOS ? 44.0 : kToolbarHeight;
double bottomBarHeight = Platform.isIOS ? 49.0 : kBottomNavigationBarHeight;

// const SystemUiOverlayStyle BarDefaultStyle = SystemUiOverlayStyle(
//   systemNavigationBarColor: Colors.white,
//   systemNavigationBarDividerColor: null,
//   statusBarColor: Colors.transparent,
//   systemNavigationBarIconBrightness: Brightness.dark,
//   statusBarIconBrightness: Brightness.light,
//   statusBarBrightness: Brightness.dark,
// );

const SystemUiOverlayStyle BarDefaultStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const SystemUiOverlayStyle BarDefaultDarkStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: null,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);


class DefaultAppBar extends StatefulWidget with PreferredSizeWidget {
  final double? leadingWidth;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final String? title;
  final Widget? backButton;
  final Widget? titleWidget;
  final Color? titleColor;
  final Color? backgroundColor;
  final double? elevation;
  final Brightness? brightness;
  final List<Widget>? actions;
  final double? height;

  DefaultAppBar(
      {this.leadingWidth,
      this.bottom,
      this.showBackButton = true,
      this.titleWidget,
      this.titleColor,
      this.backgroundColor,
      this.elevation,
      this.brightness,
      this.actions,
      this.backButton,
      this.title,
      this.height});

  @override
  State<StatefulWidget> createState() => DefaultAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? appbarHeight);
}

class DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(widget.height ?? appbarHeight),
        child: AppBar(
          titleSpacing: 0,
          leadingWidth: widget.leadingWidth,
          centerTitle: true,
          bottom: widget.bottom,
          leading: widget.showBackButton
              ? widget.backButton ?? _backButton()
              : null,
          automaticallyImplyLeading: widget.showBackButton,
          title: widget.titleWidget ??
              Text(widget.title ?? "",
                  style: TextStyle(
                      fontSize: 18,
                      color: widget.titleColor ??
                          COLOR_EEEEEE,
                      fontWeight: MediumWeight)),
          iconTheme: IconThemeData(
              color: widget.titleColor ??
                          COLOR_2D3863),
          backgroundColor: widget.backgroundColor ?? Colors.white,
          elevation: widget.elevation ?? 0,
          brightness: widget.brightness ?? Brightness.light,
          actions: widget.actions ?? [],
        ));
  }


  Widget _backButton({Color color = Colors.black}){
    return Button(child: BBImage(url: "ic-back",imageType: ImageContentType.assets,height: 24,width: 24,color: color), onPressed: () => BBRouter.pop());
  }
}

