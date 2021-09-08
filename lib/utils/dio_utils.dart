import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_live/configs/configs.dart';
import 'package:flutter_live/utils/index.dart';
import 'package:flutter_live/utils/toast_utils.dart';
import 'base_response.dart';

enum HostType {
  None,
  Main,
}

class DioUtils {
  static String version = "";
  static String buildNumber = "";
  static Dio share = Dio();

  static Future<BaseResponse> get<T>(
    String url, {
    int timeout = 10000,
    Map<String,dynamic>? params,
    HostType host = HostType.Main,
    Map<String, dynamic>? header
  }) {
    return send<T>(url, "GET", timeout: timeout, params: params, host: host,header: header);
  }

  static Future<BaseResponse> post<T>(
    String url, {
    int timeout = 10000,
    Map<String,dynamic>? params,
    HostType host = HostType.Main,
    Map<String, dynamic>? header
  }) {
    return send<T>(url, "POST", timeout: timeout, params: params, host: host,header: header);
  }

  static Future<BaseResponse> upload<T>(
    String url, {
    int timeout = 20000,
    Map<String,dynamic>? params,
    HostType host = HostType.Main,
    Map<String, dynamic>? header,
    Map? files,
  }) {
    return send<T>(url, "POST",
        timeout: timeout, params: params ?? {}, host: host, files: files,header: header);
  }

  static Future<BaseResponse> send<T>(
    String url,
    String method, {
    int timeout = 10000,
    Map<String,dynamic>? params,
    HostType host = HostType.Main,
    Map? files,
    Map<String, dynamic>? header
  }) async {

    var h = header ?? {};
    h["user-agent"] = 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1';

    var options = Options(
      headers: h,
      method: method,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    String fullUrl;
    switch (host) {
      case HostType.None:
        fullUrl = url;
        break;
      case HostType.Main:
        fullUrl = Configs.main + url;
        break;
      default:
        fullUrl = Configs.main + url;
        break;
    }

    if (params is Map) {
      params!.removeWhere((key, value) => value == null);
      params = Map<String, dynamic>.from(params);
    } else {
      params = Map<String, dynamic>.from({});
    }

    Response response;
    CancelToken cancelToken = CancelToken();
    var cancelTimer = Timer(Duration(milliseconds: timeout), () {
      cancelToken.cancel();
    });
    try {
      switch (method) {
        case "GET":
          response = await DioUtils.share.request(fullUrl,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case "POST":
          if (files != null) {
            FormData formData = FormData.fromMap({...params, ...files});
            response = await DioUtils.share.request(fullUrl,
                data: formData,
                options: options,
                cancelToken: cancelToken,
                onSendProgress: (e, ee) {});
          } else if (params.isNotEmpty) {
            response = await DioUtils.share.request(fullUrl,
                data: json.encode(params),
                options: options,
                cancelToken: cancelToken);
          } else {
            response = await DioUtils.share
                .request(fullUrl, options: options, cancelToken: cancelToken);
          }
          break;
        default:
          throw BaseResponse(msg: "");
      }
      cancelTimer.cancel();
    } catch (err) {
      cancelTimer.cancel();
      var msg = _errorMsg(err);
      Toast.showMsg(msg);
      throw BaseResponse(msg: msg);
    }

    var data = response.data;
    var result;
    
    if (data is Map && T.toString() != "dynamic") {
      result = BaseResponse(
        msg: data["msg"], code: data["code"], data: JsonConvert.fromJsonAsT<T>(data["data"]));
    }else{
      result = BaseResponse(
        msg: "", code: 0, data: data);
    }
    
    if (result.code == 0) {
      return result;
    }

    Toast.hide();

    //错误提示处理
    if (Utils.isEmpty(result.msg)) {
      throw BaseResponse(msg: "未知错误", code: result.code);
    }

    throw result;
  }

  ///
  /// 异常信息
  ///
  static String _errorMsg(err) {
    if (err is DioError) {
      switch (err.type) {
        case DioErrorType.connectTimeout:
          return "连接超时";
        case DioErrorType.response:
          return "响应失败:${err.message}";
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          return "请求超时";
        case DioErrorType.receiveTimeout:
          return "响应超时";
        case DioErrorType.other:
          if (err.error != null && err.error is SocketException) {
            return "检查网络后重试";
          }
          String msg = err.message;
          return msg.isEmpty ? "未知错误" : msg;
      }
    }
    return "未知错误";
  }
}
