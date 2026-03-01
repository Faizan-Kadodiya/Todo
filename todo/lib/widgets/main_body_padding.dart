//flutter
import 'package:flutter/material.dart';

class MainBodyPadding extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Widget? child;
  const MainBodyPadding({
    super.key,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 20,
        right: right ?? 20,
        top: top ?? 20,
        bottom: bottom ?? 20,
      ),
      child: child,
    );
  }
}
