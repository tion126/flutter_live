
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dy_player_controller.dart';


class DYPlayerObserver extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DYPlayerObserverState();
}

class DYPlayerObserverState extends State<DYPlayerObserver> with WidgetsBindingObserver{
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    DYPlayerController controller =
        Provider.of<DYPlayerController>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        if (!controller.notifier.playing) {
          controller.onPlay();
        }
        break;
      case AppLifecycleState.paused:
        if (controller.notifier.playing) {
          controller.onPlay();
        }
        break;
      case AppLifecycleState.inactive:

        break;
      case AppLifecycleState.detached:

        break;
    }
  }
}