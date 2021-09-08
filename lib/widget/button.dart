import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final bool enable;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? disableBackgroundColor;
  final List<Color>? gradientColors;
  final List<Color>? disableGradientColors;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final List<BoxShadow>? shadow;
  final List<BoxShadow>? disableShadow;
  final Alignment align;

  Button(
      {Key? key,
      required this.child,
      this.onPressed,
      this.height,
      this.width,
      this.backgroundColor,
      this.disableBackgroundColor,
      this.gradientColors,
      this.disableGradientColors,
      this.enable = true,
      this.borderWidth = 0.0,
      this.borderColor = Colors.transparent,
      this.borderRadius = 0,
      this.padding,
      this.margin,
      this.gradientBegin = Alignment.centerLeft,
      this.gradientEnd = Alignment.centerRight,
      this.shadow,
      this.disableShadow,
      this.align = Alignment.center})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colors = widget.backgroundColor == null
        ? widget.gradientColors ?? [Colors.transparent, Colors.transparent]
        : [widget.backgroundColor!, widget.backgroundColor!];
    var disableColors = widget.disableBackgroundColor == null
        ? widget.disableGradientColors ??
            colors 
        : [widget.disableBackgroundColor!, widget.disableBackgroundColor!];

    return CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: widget.enable ? widget.onPressed : null,
        child: Container(
            height: widget.height,
            width: widget.width,
            padding: widget.padding ?? EdgeInsets.zero,
            margin: widget.margin ?? EdgeInsets.zero,
            decoration: BoxDecoration(
                boxShadow: widget.enable || widget.disableShadow == null
                    ? widget.shadow
                    : widget.disableShadow,
                border: Border.all(
                    color: widget.borderColor, width: widget.borderWidth),
                gradient: LinearGradient(
                    begin: widget.gradientBegin,
                    end: widget.gradientEnd,
                    colors: widget.enable ? colors : disableColors),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius))),
            child: Align(child: widget.child,alignment: widget.align)));
  }
}
