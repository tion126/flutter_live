
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:flutter_live/utils/dio_utils.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/widget/appbar.dart';
import 'package:package_info/package_info.dart';

enum ENV { DEBUG, RELEASE }

const ENV env = bool.hasEnvironment("release") ? ENV.RELEASE : ENV.DEBUG;

class Configs {

  static String main = "";

  static get isDebug {
    return env == ENV.DEBUG;
  }

  static get isRelease {
    return env == ENV.RELEASE;
  }

  static initialization() async {

    WidgetsFlutterBinding.ensureInitialized();
    
    Configs.configOverlays();

    BBRouter.pagesInit();

    //log
    if (Configs.isDebug) {
      DioUtils.share.interceptors.add(LogInterceptor(responseBody: true));
    }

    PackageInfo info = await PackageInfo.fromPlatform();
    DioUtils.version = info.version;
    DioUtils.buildNumber = info.buildNumber;

    await Utils.storage.ready;

    //网络状态变化
    // NetworkStatus.config();
  }

  static configOverlays() {
    ///状态栏 横竖屏
    SystemChrome.setSystemUIOverlayStyle(BarDefaultStyle);
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
  }
}