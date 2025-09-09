import 'package:flutter/material.dart';

import '../../core/colors.dart';

class AppInkWell extends StatelessWidget {
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final Widget child;
  final Color highlightColor;
  final Color splashColor;
  final bool enableSplash;

  const AppInkWell({
    required this.child,
    this.onTap,
    this.onTapDown,
    this.highlightColor = AppColors.transparent,
    this.splashColor = AppColors.secondaryOrange,
    this.enableSplash = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onTapDown: onTapDown,
      splashColor: enableSplash ? splashColor : AppColors.transparent,
      highlightColor: enableSplash ? highlightColor : AppColors.transparent,
      child: child,
    );
  }
}
