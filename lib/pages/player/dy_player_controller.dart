import 'dart:async';
import 'package:brightness_volume/brightness_volume.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:ftl_player/ftl_orientation.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'dy_player_fullscreen.dart';
import 'dy_player_state_notifier.dart';

mixin DYPlayerEventHandler{
  void playerStateChange(DYPlayerState state){}
  void screenOrientationChange(DeviceOrientation orientation){}
  void didTapBack(){}
  void needRefresh(){}
}

class DYPlayerController extends ChangeNotifier {
  late FTLPlayerController ftlPlayerController;
  late DYPlayerStateNotifier notifier;

  static Future<DYPlayerController> init() async {
    DYPlayerController controller = DYPlayerController();
    controller.ftlPlayerController = await FTLPlayer.init(configs: TXLivePlayConfig(enableHWAcceleration: true));
    controller.hideTimerStart();
    controller.notifier = DYPlayerStateNotifier(DYPlayerStateValue());
    controller.ftlPlayerController.channel
        .setMethodCallHandler(controller.notifier.callHandler);
    controller.notifier.addListener(controller.stateListener);
    ftlOrientation.addListener(controller.onDeviceOrientationEvent);

    return controller;
  }

  @override
  void dispose() {
    super.dispose();
    this.ftlPlayerController.channel
        .setMethodCallHandler(null);
    this.notifier.removeListener(this.stateListener);
    ftlOrientation.removeListener(this.onDeviceOrientationEvent);
    this.timer?.cancel();
    BVUtils.keepOn(false);
  }

  /*封装事件回调 */
  DYPlayerEventHandler? eventHandler;

  /*锁定屏幕 */
  bool lock = false;

  /*当前方向 */
  DeviceOrientation playerOrientation = DeviceOrientation.portraitUp;

  /*是否全屏 */
  bool get fullScreen{
    return playerOrientation == DeviceOrientation.landscapeLeft || playerOrientation == DeviceOrientation.landscapeRight;
  }

  /* 当前的状态 */
  DYPlayerState state = DYPlayerState.Buffering;

  /*控制层是否显示 */
  bool showControl = false;

  /*调节音量中 */
  bool showVolume = false;

  /*调节亮度中 */
  bool showBrightness = false;

  /*显示控制菜单 */
  bool showMenu   = false;

  /*音量描述 */
  String volumeText = "";

  /*音量icon */
  IconData? volumeIcon;

  /*亮度描述 */
  String brightnessText = "";

  /*亮度icon */
  IconData? brightnessIcon;

  /*音量数值 */
  double volume = 0.0;

  /*亮度数值 */
  double brightness = 0.0;

  /*是否开启硬解 */
  bool enableHWAcceleration = false;

  /*隐藏控制层 */
  Timer? timer;

  /*比例 */
  double? ratio;
  
  /*全屏是否自动适配比例 */
  bool aotuRatio = true;

  void stateListener() {

    if (this.notifier.value.state != this.state) {
      this.state = this.notifier.value.state;
      //常亮
      BVUtils.keepOn(this.notifier.value.state == DYPlayerState.Buffering || this.notifier.value.state == DYPlayerState.Playing);
      
      this.eventHandler?.playerStateChange(this.state);

      switch (this.notifier.value.state) {
        case DYPlayerState.Failed:
          break;
        case DYPlayerState.Buffering:
          break;
        case DYPlayerState.Playing:
          break;
        case DYPlayerState.Stopped:
          break;
        case DYPlayerState.Pause:
          break;
        default:
      }
    }
    // print(this.notifier.value.eventParam);
    this.state = this.notifier.value.state;

    if (this.notifier.value.width > 0 && this.notifier.value.height > 0) {

      var newRatio = this.notifier.value.width / this.notifier.value.height;
      if (newRatio != this.ratio) {
        this.ratio = newRatio;
        this.notifyListeners();
      }else{
        this.ratio = newRatio;
      }
    }
  }

  //开始
  Future<void> start(String url) {
    return this.ftlPlayerController.start(url);
  }

  //暂停
  Future<void> pause() {
    return this.ftlPlayerController.pause();
  }

  //停止
  Future<void> stop() {
    return this.ftlPlayerController.stop();
  }

  //恢复
  Future<void> resume() {
    return this.ftlPlayerController.resume();
  }


  void onTap() {
    this.showControl = !this.showControl;
    if (this.showControl) {
      this.hideTimerStart();
    }
    this.notifyListeners();
  }

  void onRefresh(){
    this.eventHandler?.needRefresh();
  }

  void onLock() {
    this.lock = !this.lock;
    if (!this.lock) {
      this.showControl = true;
    }
    this.notifyListeners();
  }

  void onPlay() {
    if (this.notifier.playing) {
      this.ftlPlayerController.pause().then((value) {
        this.notifier.state = DYPlayerState.Pause;
      });
    } else {
      this.ftlPlayerController.resume().then((value) {
        this.notifier.state = DYPlayerState.Playing;
      });
    }
  }

  //**纵向手势 */
  void onDragGesture(Size size, detail) async {

    if (detail is DragStartDetails) {
      await syncDeviceData();
      return;
    }

    if (detail is DragEndDetails) {
      this.showVolume = false;
      this.showBrightness = false;
      notifyListeners();
      return;
    }

    if (detail.localPosition.dx > size.width / 2) {
      this.showVolume = true;
      this.showBrightness = false;
      double v = (this.volume - detail.delta.dy * 0.01)
          .clamp(0.0, 1.0);
      this.setVolume(v);
      var icons = [Icons.volume_down_sharp, Icons.volume_up_sharp];
      this.volumeIcon = icons[(v * 2.0).floor()];
      this.volumeText = "${(v * 100).toStringAsFixed(0)}%";
      this.notifyListeners();
    } else {
      this.showVolume = false;
      this.showBrightness = true;
      double b =
          (this.brightness - detail.delta.dy * 0.01).clamp(0.0, 1.0);
      this.setBrightness(b);
      var icons = [
        Icons.brightness_low_sharp,
        Icons.brightness_medium_sharp,
        Icons.brightness_high_sharp
      ];
      this.brightnessIcon = icons[(b * 3.0).floor()];
      this.brightnessText = "${(b * 100).toStringAsFixed(0)}%";
      print(this.brightnessText);
      this.notifyListeners();
    }
  }

  syncDeviceData() async{
    
    this.brightness = await BVUtils.brightness;
    this.volume = await BVUtils.volume;
    this.enableHWAcceleration = await this.ftlPlayerController.enableHWAcceleration() ?? false;
  }

  void setVolume(double v) {
    this.volume = v;
    BVUtils.setVolume(v);
    notifyListeners();
  }

  void setBrightness(double b){
    this.brightness = b;
    BVUtils.setBrightness(b);
    notifyListeners();
  }

  void setEnableHWAcceleration(bool e){
    this.enableHWAcceleration = e;
    this.ftlPlayerController.setEnableHWAcceleration(e);
    this.notifier.state = DYPlayerState.Buffering;
    notifyListeners();
  }

  void setAutoRatio(bool e){
    this.aotuRatio = e;
    notifyListeners();
  }

  void hideTimerStart() {
    if (this.timer != null) {
      this.timer!.cancel();
      this.timer = null;
    }

    this.timer = Timer(Duration(seconds: 5), () {
      this.showControl = false;
      this.notifyListeners();
      this.timer = null;
    });
  }

  void onDeviceOrientationEvent(){
      this.switchScreenOrientation(ftlOrientation.value);
  }

  void switchScreenOrientation(DeviceOrientation orientation) { 
    
    if (this.playerOrientation == orientation || this.lock || orientation == DeviceOrientation.portraitDown) {
      return;
    }

    if ((this.playerOrientation == DeviceOrientation.portraitUp || this.playerOrientation == DeviceOrientation.portraitDown) && (orientation == DeviceOrientation.landscapeLeft || orientation == DeviceOrientation.landscapeRight)) {
      BBRouter.push(DYPlayerFullScreen(this));
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    if ((this.playerOrientation == DeviceOrientation.landscapeLeft || this.playerOrientation == DeviceOrientation.landscapeRight) && (orientation == DeviceOrientation.portraitUp || orientation == DeviceOrientation.portraitDown)) {
      BBRouter.pop();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
    }

    this.playerOrientation = orientation;
    SystemChrome.setPreferredOrientations([orientation]);
    this.eventHandler?.screenOrientationChange(orientation);
    this.notifyListeners();
  }

  void back(){
    if (this.fullScreen) {
      this.switchScreenOrientation(DeviceOrientation.portraitUp);
      return;
    }
    this.eventHandler?.didTapBack();
  }

  void onMenu() async{
    this.showMenu = !this.showMenu;
    if (this.showMenu) {
      await this.syncDeviceData();
    }
    this.notifyListeners();
  }

}