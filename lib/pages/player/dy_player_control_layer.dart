import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dy_player_gesture_layer.dart';
import 'dy_player_controller.dart';
import 'dy_player_state_notifier.dart';


class DYPlayerControlLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context);
    Provider.of<DYPlayerStateNotifier>(context);
    
    return DYPlayerGestureLayer(Stack(children: [
      AnimatedPositioned(
          duration: Duration(milliseconds: 350),
          top: !controller.showControl || controller.lock ? -100 : 0,
          left: 0,
          right: 0,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: safeArea(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    genButton("ic-back", 22, () {
                      controller.back();
                    }),
                    genButton("ic-more", 22, () {
                      controller.onMenu();
                    }),
                  ]),controller.fullScreen))),
      AnimatedPositioned(
          duration: Duration(milliseconds: 350),
          bottom: !controller.showControl || controller.lock ? -100 : 0,
          left: 0,
          right: 0,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: safeArea(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                genButton(
                    controller.notifier.playing
                        ? "ic-pause"
                        : "ic-play",
                    18,
                    controller.onPlay),
                genButton("ic-refresh", 18, controller.onRefresh),
                Expanded(child: Container()),
                Container(width: 16),
                genButton(controller.fullScreen ? "ic-exitfull" : "ic-full", 16, () {
                  controller.switchScreenOrientation(controller.fullScreen ? DeviceOrientation.portraitUp : DeviceOrientation.landscapeLeft);
                }),
              ]),controller.fullScreen))),
      Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: controller.showControl ? 1 : 0,
              child: Visibility(visible: controller.showControl,child: safeArea(genButton(controller.lock ? "ic-lock" : "ic-unlock",
                  22, controller.onLock),controller.fullScreen))),
          alignment: Alignment.centerLeft),
      Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: controller.notifier.buffering ? 1 : 0,
              child: Visibility(visible: controller.notifier.buffering,child: Container(
                  color: Colors.transparent,
                  height: 90,
                  width: 90,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(controller.notifier.value.netSpeed,
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ]),
                  alignment: Alignment.center))),
          alignment: Alignment.center),
        Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: controller.notifier.failed ? 1 : 0,
              child: Visibility(visible: controller.notifier.failed,child: InkWell(child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 35,
                width: 120,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("播放失败,点击重试",
                            style: TextStyle(color: Colors.white, fontSize: 12))
                ]),
                alignment: Alignment.center),onTap: (){
                  controller.onRefresh();
                }))),
          alignment: Alignment.center)
    ]));
  }

  Widget genButton(String name, double size, VoidCallback onPressed) {
    return CupertinoButton(
      minSize: 0,
      child: Image.asset("assets/images/$name.png", height: size, width: size),
      onPressed: onPressed,
    );
  }

  Widget safeArea(Widget widget,bool fullScreen){
    return SafeArea(left:fullScreen,right:fullScreen,top:fullScreen,bottom:fullScreen,child: widget);
  }
}