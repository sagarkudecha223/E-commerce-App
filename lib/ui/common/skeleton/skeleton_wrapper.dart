import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/colors.dart';

class AppSkeletonWrapper extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color highlightColor;
  final Color containersColor;
  final Duration? duration;
  final PaintingEffect? effect;
  final bool? ignoreContainers;
  final bool enabled;
  final double? textBoneBorderRadius;

  const AppSkeletonWrapper({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor = AppColors.white,
    this.containersColor = AppColors.secondaryGrey2,
    this.duration,
    this.effect,
    this.ignoreContainers,
    this.enabled = true,
    this.textBoneBorderRadius,
  });

  @override
  Widget build(BuildContext context) => Skeletonizer(
    containersColor: containersColor,
    effect:
        effect ??
        ShimmerEffect(
          baseColor: baseColor ?? AppColors.skeletonBaseColor.withOpacity(0.3),
          duration: duration ?? Duration(milliseconds: 1500),
          highlightColor: highlightColor,
        ),
    ignoreContainers: ignoreContainers,
    enabled: enabled,
    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
      textBoneBorderRadius ?? 0.5,
    ),
    child: child,
  );
}
