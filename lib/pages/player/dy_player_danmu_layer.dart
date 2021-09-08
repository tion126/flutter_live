import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_live/pages/live/message_manager.dart';
import 'package:flutter_live/utils/index.dart';


class DYPlayerDanmuLayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DYPlayerDanmuLayerState();
}

class DYPlayerDanmuLayerState extends State<DYPlayerDanmuLayer> {

  BarrageWallController barrageWallController = BarrageWallController();
  @override
  void initState() {
    super.initState();
    MessageManager.share.addListener(this.refresh);
  }

  @override
  void dispose() {
    super.dispose();
    MessageManager.share.removeListener(this.refresh);
  }

  void refresh(){
    var content = MessageManager.share.messages.last.content;
    if (Utils.isNotEmpty(content)) {
      this.barrageWallController.send([Bullet(child: Text(content!,style: TextStyle(color: COLOR_EEEEEE)))]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:BarrageWall(
              speed: 4, 
              child: Container(),
              controller: barrageWallController,
            ));
  }
}
