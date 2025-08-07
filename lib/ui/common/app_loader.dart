import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/enum.dart';
import '../../core/enum_extensions.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.strokeWidth, this.backgroundColor});

  final double? strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme =
        AppColors.isLightTheme ? AppLoaderTheme.dark : AppLoaderTheme.dark;
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? Dimens.borderWidthXMedium,
        valueColor: AlwaysStoppedAnimation<Color>(
          backgroundColor ?? theme.valueColor,
        ),
        backgroundColor: theme.backgroundColor.withOpacity(0.2),
      ),
    );
  }
}
