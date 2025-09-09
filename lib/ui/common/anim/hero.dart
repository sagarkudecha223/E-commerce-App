import 'package:flutter/material.dart';

class HeroAnim extends StatelessWidget {
  final Object tag;
  final Widget child;
  final Color color;

  const HeroAnim(
      {super.key,
      required this.tag,
      required this.child,
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Hero(tag: tag, child: Material(color: color, child: child));
  }
}
