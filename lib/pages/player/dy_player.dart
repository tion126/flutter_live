import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dy_player_danmu_layer.dart';
import 'dy_player_control_layer.dart';
import 'dy_player_menu_layer.dart';
import 'dy_player_observer.dart';
import 'dy_player_controller.dart';
import 'dy_player_widget.dart';
import 'dy_player_state_notifier.dart';

typedef OnDYPlayerCreate = void Function(DYPlayerController controller);

class DYPlayer extends StatefulWidget {
  final OnDYPlayerCreate onCreate;
  DYPlayer(this.onCreate);

  @override
  State<StatefulWidget> createState() => DYPlayerState();
}

class DYPlayerState extends State<DYPlayer> {
  DYPlayerController? controller;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    DYPlayerController.init().then((value) {
      this.controller = value;
      widget.onCreate(this.controller!);
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.controller == null
        ? Container()
        : MultiProvider(
            providers: [
                ChangeNotifierProvider<DYPlayerController>.value(
                    value: this.controller!),
                ChangeNotifierProvider<DYPlayerStateNotifier>.value(
                    value: this.controller!.notifier),
              ],
            child: Stack(children: [
              DYPlayerObserver(),
              DYPlayerWidget(controller!.ftlPlayerController),
              DYPlayerDanmuLayer(),
              DYPlayerControlLayer(),
              DYPlayerMenuLayer()
            ]));
  }

  @override
  void dispose() {
    super.dispose();
    this.controller?.ftlPlayerController.dispose();
    this.controller?.dispose();
  }
}
