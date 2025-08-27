import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';

class ContainerDecoration extends BoxDecoration {
  final double? radius;
  final Color? backgroundColor;
  final Color borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadows;
  final Gradient? gradientColor;

  ContainerDecoration({
    this.radius,
    this.backgroundColor,
    this.borderColor = AppColors.focusedBorderColor,
    this.borderWidth,
    this.boxShadows,
    this.gradientColor,
  }) : super(
         borderRadius: BorderRadius.circular(radius ?? Dimens.radiusLarge),
         color: backgroundColor,
         gradient: gradientColor,
         border: Border.all(
           width: borderWidth ?? Dimens.borderWidthXSmall,
           color: borderColor,
         ),
         boxShadow: boxShadows
       );
}
