import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';

class ScreenBackground extends BoxDecoration {
  ScreenBackground({Color? backgroundColor})
    : super(
        color: backgroundColor ?? AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.radius2xLarge),
          topRight: Radius.circular(Dimens.radius2xLarge),
        ),
      );
}
