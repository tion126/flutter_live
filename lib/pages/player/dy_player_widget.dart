
import 'package:flutter/material.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'package:provider/provider.dart';
import 'dy_player_controller.dart';


class DYPlayerWidget extends StatefulWidget {
  final FTLPlayerController? controller;
  DYPlayerWidget(this.controller);

  @override
  State<StatefulWidget> createState() => DYPlayerWidgetState();
}

class DYPlayerWidgetState extends State<DYPlayerWidget>{

  @override
  Widget build(BuildContext context) {
    DYPlayerController controller =
        Provider.of<DYPlayerController>(context);
    if (this.widget.controller == null) {
      return Container(color: Colors.black);
    }else if(controller.ratio == null || !controller.aotuRatio){
      return Container(color: Colors.black,child:Texture(textureId: this.widget.controller?.textureId ?? 0));
    }else{
      return  Container(color: Colors.black,child:Center(child: AspectRatio(aspectRatio: controller.ratio ?? 1,child:Texture(textureId: this.widget.controller?.textureId ?? 0))));
    }
  }
}
