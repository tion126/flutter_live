import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';

class DYPlayerStateNotifier extends ValueNotifier<DYPlayerStateValue> {
  DYPlayerStateNotifier(value) : super(value);

  Future<void> callHandler(MethodCall call) {
    switch (call.method) {
      case "onPlayEvent":
        var evtId = call.arguments["playEvent"];
        if (evtId == PLAY_EVT_PLAY_BEGIN || evtId == PLAY_EVT_RCV_FIRST_I_FRAME) {
          this.value = this.value.copyWith(state:DYPlayerState.Playing,eventParam: call.arguments);
        }else if (evtId == PLAY_EVT_PLAY_END) {
            this.value = this.value.copyWith(state:DYPlayerState.Stopped,eventParam: call.arguments);
        } else if (evtId == PLAY_ERR_NET_DISCONNECT) {
            this.value = this.value.copyWith(state:DYPlayerState.Failed,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_PLAY_LOADING){
            // 当缓冲是空的时候
            this.value = this.value.copyWith(state:DYPlayerState.Buffering,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_STREAM_SWITCH_SUCC) {
            
        } else if (evtId == PLAY_ERR_STREAM_SWITCH_FAIL) {
            this.value = this.value.copyWith(state:DYPlayerState.Failed,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_PLAY_PROGRESS) {
            if (this.value.state == DYPlayerState.Stopped){
            }
        }

        break;
      case "onNetStatus":
        double netSpeed = (double.tryParse("${call.arguments[NET_STATUS_NET_SPEED]}") ?? 0) /8;
        double height = double.tryParse("${call.arguments[NET_STATUS_VIDEO_HEIGHT]}") ?? 0 ;
        double width = double.tryParse("${call.arguments[NET_STATUS_VIDEO_WIDTH]}") ?? 0 ;

        var netText;
        if (netSpeed > 1024) {
          netText = "${(netSpeed/1024).toStringAsFixed(1)} mb/s";
        }else if(netSpeed <= 1024 && netSpeed > 0){
          netText = "${netSpeed.toStringAsFixed(0)} kb/s";
        }else{
          netText = "";
        }
        this.value = this.value.copyWith(
          height : height,
          width: width,
          netSpeed:netText,
          netParam: call.arguments);
        break;
      default:
    }
    return Future.value();
  }

  bool get playing{
    return this.value.state == DYPlayerState.Buffering || this.value.state == DYPlayerState.Playing;
  }

  bool get buffering{
    return this.value.state == DYPlayerState.Buffering;
  }

  bool get failed{
    return this.value.state == DYPlayerState.Failed;
  }

  set state(DYPlayerState state){
    this.value = this.value.copyWith(state:state);
  }

}

enum DYPlayerState {
  Failed, // 播放失败
  Buffering, // 缓冲中
  Playing, // 播放中
  Stopped, // 停止播放
  Pause // 暂停播放
} 

class DYPlayerStateValue {
  DYPlayerState state;
  String         netSpeed;
  double         height;
  double         width;
  Map?            eventParam;
  Map?            netParam;
  DYPlayerStateValue({this.state = DYPlayerState.Buffering,this.netSpeed = "",this.netParam,this.eventParam,this.height = 0,this.width = 0});
  DYPlayerStateValue copyWith({DYPlayerState? state ,String? netSpeed,Map? netParam,Map? eventParam,double? height,double? width}){
      return DYPlayerStateValue(
        state : state ?? this.state,
        netSpeed : netSpeed ?? this.netSpeed,
        eventParam : eventParam ?? this.eventParam,
        netParam : netParam ?? this.netParam,
        height : height ?? this.height,
        width : width ?? this.width
      );
  }
}
