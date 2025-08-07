import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';

class AppToast extends StatelessWidget {
  final String message;

  const AppToast({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.spaceLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: AppColors.shadowColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.spaceLarge,
            vertical: Dimens.spaceXMedium,
          ),
          child: Text(
            message,
            style: AppFontTextStyles.textStyleMedium().copyWith(
              fontSize: Dimens.fontSizeSixteen,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
