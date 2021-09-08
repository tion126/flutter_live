import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dy_player_control_layer.dart';
import 'dy_player_danmu_layer.dart';
import 'dy_player_menu_layer.dart';
import 'dy_player_controller.dart';
import 'dy_player_widget.dart';
import 'dy_player_state_notifier.dart';

class DYPlayerFullScreen extends StatefulWidget {
  final DYPlayerController controller;
  DYPlayerFullScreen(this.controller);

  @override
  State<StatefulWidget> createState() => DYPlayerFullScreenState();
}

class DYPlayerFullScreenState extends State<DYPlayerFullScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: MultiProvider(
                providers: [
                  ChangeNotifierProvider<DYPlayerController>.value(
                      value: widget.controller),
                  ChangeNotifierProvider<DYPlayerStateNotifier>.value(
                      value: widget.controller.notifier),
                ],
                child: Stack(children: [
                  SafeArea(
                      top: false,
                      bottom: false,
                      child: DYPlayerWidget(
                          widget.controller.ftlPlayerController)),
                  DYPlayerDanmuLayer(),
                  DYPlayerControlLayer(),
                  DYPlayerMenuLayer()
                ]))),
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        });
  }
}
