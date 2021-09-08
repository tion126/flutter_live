
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live/configs/constant.dart';
import 'package:flutter_live/utils/index.dart';

class ImageUtils {
  static String asset(String url, {String ext = "png"}) {
    return Utils.isEmpty(ext)
        ? "assets/images/" + url
        : "assets/images/" + url + "." + ext;
  }

  static Widget placeholder() {
    return CupertinoActivityIndicator(radius: 10);
  }

  static Widget error() {
    return Icon(Icons.error_outline_sharp,color: COLOR_EEEEEE,size: 20);
  }

  static Widget custom({double height = 108,double width =  108,BoxFit fit = BoxFit.contain}){
    return Container(child: Image.asset(ImageUtils.asset("ic-placeholder"), fit: fit),height: height,width: width);
  }
}

enum ImageContentType {
  net, //网络
  assets, //资源目录
}

class BBImage extends StatefulWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageContentType imageType;
  final double radius;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final Widget? error;
  final Widget? placeHolder;
  final Key?    key;
  final Color?  color;

  BBImage(
      {required this.url,
      this.key,
      this.width,
      this.height,
      this.imageType: ImageContentType.net,
      this.fit: BoxFit.fill,
      this.radius = 0,
      this.topLeftRadius = 0,
      this.topRightRadius = 0,
      this.bottomLeftRadius = 0,
      this.bottomRightRadius = 0,
      this.error,
      this.placeHolder,
      this.color
      });

  @override
  State<StatefulWidget> createState() {
    return BBImageState();
  }
}

class BBImageState extends State<BBImage> {
  @override
  Widget build(BuildContext context) {
    var useRadius = widget.radius > 0;

    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                useRadius ? widget.radius : widget.topLeftRadius),
            topRight: Radius.circular(
                useRadius ? widget.radius : widget.topRightRadius),
            bottomLeft: Radius.circular(
                useRadius ? widget.radius : widget.bottomLeftRadius),
            bottomRight: Radius.circular(
                useRadius ? widget.radius : widget.bottomRightRadius)),
        child: widget.imageType == ImageContentType.assets
                ? Image.asset(imageUrl,
                    width: widget.width, height: widget.height, fit: widget.fit,color: widget.color)
                : CachedNetworkImage(
                    key : widget.key,
                    imageUrl: imageUrl,
                    color: widget.color,
                    width: widget.width,
                    height: widget.height,
                    placeholder: (_, __) =>
                        widget.placeHolder ??
                        ImageUtils.placeholder(),
                    errorWidget: (_, __, ___) =>
                        widget.error ??
                        ImageUtils.error(),
                    fit: widget.fit,
                  ));
  }

  String get imageUrl {
    switch (widget.imageType) {
      case ImageContentType.assets:
        return ImageUtils.asset(widget.url ?? "");
      case ImageContentType.net:
        return widget.url ?? "";
      default:
        return widget.url ?? "";
    }
  }
}
