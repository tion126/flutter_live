
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class MessageManager extends ChangeNotifier{

  factory MessageManager() => _getInstance();
  static MessageManager get share => _getInstance();
  static MessageManager? _share;
  MessageManager._internal();
  static MessageManager _getInstance() {
    if (_share == null) {
      _share = MessageManager._internal();
    }
    return _share!;
  }

  int? rid;
  List<MessageEntity> messages = [];

  Timer? timer;
  IOWebSocketChannel? channel;

  @override
  void addListener(void Function() listener) {
    if (!this.hasListeners) {
      this.start();
    }
    super.addListener(listener);
  }

  @override
  void removeListener(void Function() listener) {
    super.removeListener(listener);
    if (!this.hasListeners) {
      this.stop();
    }
  }

  void start(){

    if (this.rid == null) {
      return;
    }

    this.channel = IOWebSocketChannel.connect("wss://danmuproxy.douyu.com:8506");
    
    String roomID = this.rid.toString();
    String login =
        "type@=loginreq/room_id@=$roomID/dfl@=sn@A=105@Sss@A=1/username@=61609154/uid@=61609154/ver@=20190610/aver@=218101901/ct@=0/";
    this.channel!.sink.add(encode(login));
    String joingroup = "type@=joingroup/rid@=$roomID/gid@=-9999/";
    this.channel!.sink.add(encode(joingroup));
    String heartbeat = 'type@=mrkl/';
    this.channel!.sink.add(encode(heartbeat));

    this.channel!.stream.listen((msg) {
      Uint8List list = Uint8List.fromList(msg);
      decode(list);
    });

    this.timer = Timer.periodic(Duration(seconds: 45), (callback) {
      String heartbeat = 'type@=mrkl/';
      this.channel!.sink.add(encode(heartbeat));
    });
  }

  void stop(){
    this.rid = null;
    this.timer?.cancel();
    this.channel?.sink.close();
    this.messages = [];
  }

  Uint8List encode(String msg) {
    ByteData header = ByteData(12);
    //定义协议头
    header.setInt32(0, msg.length + 9, Endian.little);
    header.setInt32(4, msg.length + 9, Endian.little);
    header.setInt32(8, 689, Endian.little);
    List<int> data = header.buffer.asUint8List().toList();
    List<int> msgData = utf8.encode(msg);
    data.addAll(msgData);
    data.add(0);
    return Uint8List.fromList(data);
  }

  //对消息进行解码
  decode(Uint8List list) {
    //消息总长度
    int totalLength = list.length;
    // 当前消息长度
    int len = 0;
    int decodedMsgLen = 0;
    // 单条消息的 buffer
    Uint8List singleMsgBuffer;
    Uint8List lenStr;
    while (decodedMsgLen < totalLength) {
      lenStr = list.sublist(decodedMsgLen, decodedMsgLen + 4);
      len = lenStr.buffer.asByteData().getInt32(0, Endian.little) + 4;
      singleMsgBuffer = list.sublist(decodedMsgLen, decodedMsgLen + len);
      decodedMsgLen += len;
      String byteDatas =
          utf8.decode(singleMsgBuffer.sublist(12, singleMsgBuffer.length - 2));
      //type@=chatmsg/rid@=99999/ct@=2/uid@=151938256/nn@=99999丶让我中个奖吧/txt@=这应该也就18左右吧/cid@=0a99327c7fbb495bbfd1f10000000000/ic@=avanew@Sface@S201707@S21@S18@Sc8e935d61918b28151e86548b1fad59f/level@=9/sahf@=0/cst@=1591546069188/bnn@=大马猴/bl@=7/brid@=99999/hc@=7094bdb067efbb89706bf894ceb8e67c/el@=/lk@=/fl@=7/urlev@=16/dms@=3/pdg@=65/pdk@=18

      //目前只处理弹幕信息所以简单点

      if (byteDatas.contains("type@=chatmsg")) {
        //截取用户名
        var nickname = byteDatas
            .substring(byteDatas.indexOf("nn@="), byteDatas.indexOf("/txt"))
            .replaceAll("nn@=", "");
        //截取弹幕信息
        var content = byteDatas
            .substring(byteDatas.indexOf("txt@="), byteDatas.indexOf("/cid"))
            .replaceAll("txt@=", "");
        this.messages.add(MessageEntity(name: nickname,content: content));
        if (this.messages.length > 100) {
          this.messages.removeRange(0, this.messages.length - 100);
        }
        this.notifyListeners();
      }
    }
  }

}


class MessageEntity{
  String? name;
  String? content;
  MessageEntity({this.name,this.content});
}