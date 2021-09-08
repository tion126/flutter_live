import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live/router/bb_router.dart';
import 'package:localstorage/localstorage.dart';
export 'package:flutter_live/generated/json/base/json_convert_content.dart';

export 'package:flutter_live/configs/constant.dart';
export 'package:flutter_live/pages/live/live_page.dart';
export 'package:flutter_live/router/bb_router.dart';
export 'package:flutter_live/state/base_state_mixin.dart';
export 'package:flutter_live/utils/dio_utils.dart';
export 'package:flutter_live/utils/index.dart';
export 'package:flutter_live/widget/bb_image.dart';
export 'package:pull_to_refresh/pull_to_refresh.dart';

class Utils {
  static final LocalStorage storage = LocalStorage("flutter_live");

  static bool isEmpty(String? text) {
    return text == null || !(text is String) || text.isEmpty || text == "null";
  }

  static bool isNotEmpty(String? text) {
    return !Utils.isEmpty(text);
  }

  static Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static String ifNull(String? text, {String replace = ""}) {
    return Utils.isEmpty(text) ? replace : text ?? "";
  }

  static String phoneObscure(String text) {
    if (isEmpty(text)) {
      return "";
    } else if (text.length <= 4) {
      return text;
    } else {
      int start = (text.length - 4) ~/ 2;
      return text.replaceRange(start, start + 4, "****");
    }
  }

  static void unfoucus() {
    FocusScope.of(BBRouter.context).requestFocus(FocusNode());
  }

  static String genMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString().toUpperCase();
  }

  static String genMD5Insensitive(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }
}

