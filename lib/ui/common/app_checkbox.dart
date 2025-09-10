import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';
import 'app_inkwell.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String itemText;
  final TextStyle? itemTextStyle;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color activeColor;
  final Color fillColor;
  final Color checkColor;
  final double spacing;

  const AppCheckbox({
    super.key,
    required this.value,
    this.itemText = '',
    this.onChanged,
    this.borderRadius = Dimens.radius4xSmall,
    this.borderWidth = Dimens.borderWidthMedium,
    this.activeColor = AppColors.primaryOrange,
    this.checkColor = AppColors.white,
    this.fillColor = AppColors.white,
    this.borderColor,
    this.itemTextStyle,
    this.spacing = Dimens.space2xSmall,
  });

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            value: value,
            checkColor: checkColor,
            side: WidgetStateBorderSide.resolveWith(
              (_) => BorderSide(color: borderColor ?? AppColors.borderColor, width: borderWidth),
            ),
            fillColor: WidgetStateColor.resolveWith(
              (_) => value ? activeColor : fillColor,
            ),
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: Dimens.visualDensitySmall,
            ),
          ),
          if (itemText.isNotBlank) ...[
            Gap(spacing),
            Flexible(
              child: Text(
                itemText,
                overflow: TextOverflow.visible,
                style:
                    itemTextStyle ??
                    AppFontTextStyles.textStyleMedium().copyWith(
                      fontSize: Dimens.fontSizeTwelve,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
