import 'package:flutter/material.dart';
import 'package:flutter_live/pages/live/message_manager.dart';
import 'package:flutter_live/utils/index.dart';

class MessageList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MessageListState();
}

class MessageListState extends State<MessageList> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  ScrollController scrollController = ScrollController();

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
    this.scrollController.jumpTo(
            scrollController.position.maxScrollExtent);
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(controller: this.scrollController,padding: EdgeInsets.zero,itemCount: MessageManager.share.messages.length,itemBuilder: (ctx,index){
      var model = MessageManager.share.messages[index];
      return Container(padding: EdgeInsets.only(left: 16,right: 16,top: 5,bottom: 5),child: Text.rich(TextSpan(text: model.name,style: TextStyle(color: COLOR_333333,fontSize: 14,fontWeight: MediumWeight),children: [
        TextSpan(text: " : ",style: TextStyle(color: COLOR_333333,fontSize: 14,fontWeight: RegularWeight)),
        TextSpan(text: model.content,style: TextStyle(color: COLOR_333333,fontSize: 14,fontWeight: RegularWeight))
      ])));
    });
  }
}