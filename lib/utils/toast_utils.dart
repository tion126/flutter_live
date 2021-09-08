import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:oktoast/oktoast.dart';
import 'index.dart';

class Toast{

  static showMsg(String name) {
    if (Utils.isEmpty(name)) {
      return;
    }
    
    showToast(name,
        radius: 4,
        dismissOtherToast: true,
        duration: Duration(seconds: 2),
        textPadding: EdgeInsets.all(15),
        textStyle: TextStyle(fontSize: 14,color: Colors.white),backgroundColor: COLOR_30363d.withOpacity(0.6));
  }

  static showLoading({String? text,bool handleTouch = false,int duration = 10}) {
    showToastWidget(GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){

      },
      child:Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
      child:Center(child: Container( 
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),color: COLOR_30363d.withOpacity(0.6)),
          child: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          Utils.isEmpty(text) ? Container(height: 1,width: 1) : Padding(padding: EdgeInsets.only(top:10),child: Text(text!,style: TextStyle(fontSize: 13,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,))
        ]),padding: EdgeInsets.all(15)
      )))),duration:Duration(seconds: duration),dismissOtherToast: true,handleTouch:handleTouch);
  }
  static hide() {
    dismissAllToast();
  }

}