import 'package:flutter/material.dart';
import 'package:flutter_live/configs/configs.dart';
import 'package:flutter_live/configs/theme_config.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/state/global_providers.dart';
import 'package:flutter_live/widget/refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
  await Configs.initialization();
  runApp(BBApp());
}

class BBApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BBAppState();
  }
}

class BBAppState extends State<BBApp> {
  BBRouterDelegate bbRouterDelegate = BBRouterDelegate();
  BBRouterInformationParser bbRouterInformationParser =
      BBRouterInformationParser();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: Consumer<BBRouter>(builder: (context, router, child) {
          return OKToast(
              child: RefreshConfiguration(
                  shouldFooterFollowWhenNotFull: (e)=>true,
                  headerBuilder: () => RefreshHeader(),
                  footerBuilder: () => RefreshFooter(),
                  child: MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      theme: ThemeConfig.themeData,
                      localizationsDelegates: [
                        GlobalCupertinoLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      supportedLocales: const <Locale>[
                        Locale('zh', 'CN'),
                        Locale('en', 'US')
                      ],
                      routerDelegate: bbRouterDelegate,
                      routeInformationParser: bbRouterInformationParser)));
        }));
  }
}
