import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

abstract class AppFontTextStyles {
  static const fontFamily = 'Poppins';

  static TextStyle textStyleSmall() => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fontSizeTwelve,
    color: AppColors.textColor,
    overflow: TextOverflow.visible,
    letterSpacing: 0.07,
  );

  static TextStyle textStyleMedium() => TextStyle(
    fontFamily: AppFontTextStyles.fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fontSizeFourteen,
    color: AppColors.textColor,
    overflow: TextOverflow.visible,
    letterSpacing: 0.07,
  );

  static TextStyle textStyleBold() => TextStyle(
    fontFamily: AppFontTextStyles.fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fontSizeSixteen,
    color: AppColors.boldTextColor,
    overflow: TextOverflow.ellipsis,
    letterSpacing: 0.07,
  );

  static TextStyle buttonTextStyle() => TextStyle(
    fontFamily: AppFontTextStyles.fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fontSizeFourteen,
    color: AppColors.textColor,
    overflow: TextOverflow.ellipsis,
    letterSpacing: 0.07,
  );

  static TextStyle appbarTextStyle() => TextStyle(
    fontFamily: AppFontTextStyles.fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fontSizeSixteen,
    color: AppColors.textColor,
    overflow: TextOverflow.ellipsis,
    letterSpacing: 0.07,
  );
}
