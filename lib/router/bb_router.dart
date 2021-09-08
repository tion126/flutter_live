import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live/pages/home/home_page.dart';
import 'package:provider/provider.dart';

typedef TabChangeHandler = void Function(int index);


class BBRouter with ChangeNotifier{

  static TabChangeHandler? tabChange;

  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext get context => key.currentState!.overlay!.context;
  
  static BBRouter get share => Provider.of<BBRouter>(context,listen: false);

  static List<Page> pages = [];

  static Map<UniqueKey,Completer<dynamic>> completers = {};

  static Future<T> push<T>(Widget child){
    var completer = Completer<T>();
    var ukey = UniqueKey();
    var page = CupertinoPage(child: child,key: ukey,name: child.runtimeType.toString()); 
    BBRouter.pages.add(page);
    BBRouter.share.notifyListeners();
    BBRouter.completers[ukey] = completer;
    return completer.future;
  }

  static Future<T> pushReplacement<T>(Widget child){
    BBRouter.pages.removeLast();
    BBRouter.clearCompleters();
    return BBRouter.push(child);  
  }

  static void pop([dynamic result]) {
    Navigator.of(context).maybePop(result);
  }

  static void delayPop([result]) async{
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.of(context).maybePop(result);
  }

  static void popToRoot(){
    Navigator.of(context).popUntil((route) => route.isFirst);
    BBRouter.clearCompleters();
    BBRouter.share.notifyListeners();
  }

  static void pagesInit(){
    pages = [CupertinoPage(child: HomePage())];
  }

  static void onPopPage(Page page,dynamic result){

    var key = page.key;
    BBRouter.completers[key]?.complete.call(result);
    BBRouter.pages.remove(page);
    BBRouter.clearCompleters();
    BBRouter.share.notifyListeners();
  }

  static void clearCompleters(){
    var exitedKeys = BBRouter.pages.map<LocalKey?>((e) => e.key);
    BBRouter.completers.removeWhere((key, value) => !exitedKeys.contains(key));
  }

}


class BBRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {

  @override
  Widget build(BuildContext context) {
    return Navigator(
          pages: List.of(BBRouter.pages),
          key: BBRouter.key,
          onPopPage: onPopPage,
        );
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) 
      return false;
    BBRouter.onPopPage(route.settings as Page,result);
    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => BBRouter.key;

  @override
  String get currentConfiguration => BBRouter.pages.last.name ?? "";

  @override
   Future<void> setNewRoutePath(String configuration) async {
     return;
  }
}

class BBRouterInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation.location!;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) => RouteInformation(location: configuration);
}


class FadeTransitionPage extends CupertinoPage {
  final Widget child;

  FadeTransitionPage({required this.child, LocalKey? key,String? name}) : super(key: key,name: name,child: child);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}