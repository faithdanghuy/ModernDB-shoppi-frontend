import 'dart:async';

import 'package:flutter/material.dart';

class WidgetAnimationClick extends StatefulWidget {
  const WidgetAnimationClick({super.key, required this.child, this.onTap});
  final Widget child;
  final Function()? onTap;

  @override
  State<WidgetAnimationClick> createState() => _WidgetAnimationClickState();
}

class _WidgetAnimationClickState extends State<WidgetAnimationClick>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  late Animation<double> animation;
  late Animation<double> animationOpacity;
  late Animation<double> animationColor;
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 50,
      ),
      // lowerBound: 0.0,
      // upperBound: 0.05,
    );

    animation = Tween<double>(begin: 0, end: 0.1).animate(_controller)
      ..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (_controller.status == AnimationStatus.dismissed) {
          debugPrint("AnimationStatus.dismissed - $count");
          widget.onTap?.call();
          // timer?.cancel();
          // timer = Timer(
          //   const Duration(milliseconds: 200),
          //   () {
          //     count = 0;
          //   },
          // );
        }
        setState(() {});
      });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - animation.value;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.onTap != null) {
          // debugPrint("widget.onTap - call - $count");
          // if (count == 0) {
          // debugPrint("_controller: ${_controller.status}");
          _controller.forward();
          // count += 1;
          // }
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
