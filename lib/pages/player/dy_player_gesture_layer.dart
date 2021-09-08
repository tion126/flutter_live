import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dy_player_controller.dart';

class DYPlayerGestureLayer extends StatefulWidget {
  final Widget child;
  DYPlayerGestureLayer(this.child);

  @override
  State<StatefulWidget> createState() => DYPlayerGestureLayerState();
}

class DYPlayerGestureLayerState extends State<DYPlayerGestureLayer> {
  @override
  Widget build(BuildContext context) {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Stack(children: [
        widget.child,
        if (controller.showBrightness) brightnessWidget(),
        if (controller.showVolume) volumeWidget()
      ]),
      onTap: controller.onTap,
      onVerticalDragUpdate: this.onDrag,
      onVerticalDragEnd: this.onDrag,
      onVerticalDragStart: this.onDrag,
      onDoubleTap: this.onDoubleTap,
    );
  }

  void onDoubleTap() {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);
    if (controller.lock) {
      return;
    }
    controller.switchScreenOrientation(controller.fullScreen ? DeviceOrientation.portraitUp : DeviceOrientation.landscapeLeft);
  }

  void onDrag(e) {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);
    if (RenderObject.debugActiveLayout != null) {
      return;
    }
    var size = context.findRenderObject()?.paintBounds.size;
    if (size != null) {
      controller.onDragGesture(size, e);
    }
  }

  Widget volumeWidget() {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);

    return Align(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            height: 90,
            width: 90,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(controller.volumeIcon, color: Colors.white, size: 50),
              Text(controller.volumeText,
                  style: TextStyle(color: Colors.white, fontSize: 12))
            ]),
            alignment: Alignment.center));
  }

  Widget brightnessWidget() {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);

    return Align(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            height: 90,
            width: 90,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(controller.brightnessIcon,
                  color: Colors.white, size: 50),
              Text(controller.brightnessText,
                  style: TextStyle(color: Colors.white, fontSize: 12))
            ]),
            alignment: Alignment.center));
  }
}
