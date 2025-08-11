import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../core/dimens.dart';
import '../app_loader.dart';
import '../svg_icon.dart';

class AppIconButton extends StatelessWidget {
  final String? svgImage;
  final Widget? iconWidget;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? disabledColor;
  final Color imageColor;
  final Color? backgroundColor;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool isEnabled;
  final Widget? loadingWidget;

  const AppIconButton({
    super.key,
    this.svgImage,
    this.iconWidget,
    this.imageWidth = Dimens.iconMedium,
    this.imageHeight = Dimens.iconMedium,
    this.onTap,
    this.isLoading = false,
    this.disabledColor = AppColors.secondaryGrey2,
    this.backgroundColor = AppColors.transparent,
    this.hasBorder = false,
    this.imageColor = AppColors.primaryOrange,
    this.borderColor = AppColors.primaryOrange,
    this.borderWidth = Dimens.borderWidthSmall,
    this.borderRadius = Dimens.radius3xLarge,
    this.isEnabled = true,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading || !isEnabled ? null : onTap,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor:
            isLoading ? AppColors.transparent : disabledColor,
        padding: const EdgeInsets.all(Dimens.padding2xSmall),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: borderColor,
              width: borderWidth,
              style: hasBorder || isLoading
                  ? BorderStyle.solid
                  : BorderStyle.none),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: isLoading
          ? SizedBox(
              width: Dimens.iconXSmall,
              height: Dimens.iconXSmall,
              child: loadingWidget ?? const AppLoader(),
            )
          : IgnorePointer(
            child: iconWidget ??
                _SvgIcon(
                  image: svgImage!,
                  color: imageColor,
                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                ),
          ),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  final String image;
  final Color color;
  final double? imageWidth;
  final double? imageHeight;

  const _SvgIcon({
    required this.image,
    required this.color,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppSvgIcon(
      image,
      color: color,
      height: imageHeight,
      width: imageWidth,
    );
  }
}
