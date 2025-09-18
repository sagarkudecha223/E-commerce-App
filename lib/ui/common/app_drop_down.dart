import 'dart:math';

import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';

class AppDropDown<T> extends StatefulWidget {
  const AppDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.itemLabel,
    this.horizontalPadding,
    this.menuColor,
    this.trailingIcon,
    this.enabled = true,
    this.hasBorder = true,
    this.borderWidth = Dimens.borderWidthSmall,
    this.borderRadius = Dimens.radiusMedium,
    this.menuBorderRadius = Dimens.radiusLarge,
    this.labelText,
    this.errorText,
    this.filled = false,
    this.onFocusEvent,
    this.autoFocus = false,
    this.enableSearch = true,
    this.focusNode,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.textAlign = TextAlign.start,
    this.leadingIcon,
    this.borderColor,
    this.textStyle,
    this.height = Dimens.tabBarHeight,
    this.isMandatory = false,
  });

  final double? horizontalPadding;
  final Color? menuColor;
  final Color? borderColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Function(T?) onChanged;
  final List<T> items;
  final bool enabled;
  final bool hasBorder;
  final double borderWidth;
  final double borderRadius;
  final double menuBorderRadius;
  final String? errorText;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final bool filled;
  final bool enableSearch;
  final Function? onFocusEvent;
  final bool autoFocus;
  final FocusNode? focusNode;
  final String Function(T) itemLabel;
  final dynamic initialValue;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final double height;
  final bool isMandatory;

  @override
  State<AppDropDown<T>> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  OutlineInputBorder _textFieldBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    borderSide: BorderSide(
      color:
          widget.errorText != null && widget.errorText!.isNotBlank
              ? AppColors.red
              : widget.borderColor ?? AppColors.borderColor,
      width: widget.hasBorder ? widget.borderWidth : 0.0,
    ),
  );

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _textEditingController.text = widget.initialValue.toString();
    }
  }

  @override
  void didUpdateWidget(covariant AppDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        if (widget.initialValue == null) {
          _textEditingController.text = '';
        } else {
          _textEditingController.text = widget.initialValue;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      enabled: widget.enabled,
      controller: _textEditingController,
      menuHeight: Dimens.containerSmall,
      errorText:
          widget.errorText != null && widget.errorText.isNotBlank
              ? widget.errorText
              : null,
      label:
          widget.labelText != null && widget.labelText!.isNotBlank
              ? _LabelText(
                labelText: widget.labelText!,
                isMandatory: widget.isMandatory,
                isError:
                    widget.errorText != null && widget.errorText!.isNotBlank,
              )
              : null,
      selectedTrailingIcon:
          widget.trailingIcon != null
              ? Transform.rotate(angle: pi, child: widget.trailingIcon)
              : null,
      trailingIcon: widget.trailingIcon,
      textStyle: AppFontTextStyles.textStyleMedium(),
      hintText: widget.hintText,
      helperText: widget.helperText,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        constraints: BoxConstraints(maxHeight: widget.height),
        errorStyle: AppFontTextStyles.textStyleSmall().copyWith(
          color: AppColors.red,
          fontSize: Dimens.fontSizeTwelve,
        ),
        filled: widget.filled,
        fillColor:
            widget.enabled
                ? AppColors.primaryOrange.withOpacity(0.07)
                : AppColors.secondaryGrey1.withOpacity(0.05),
        enabledBorder: _textFieldBorder(),
        focusedBorder: _textFieldBorder(),
        errorBorder: _textFieldBorder(),
        disabledBorder: _textFieldBorder(),
        focusedErrorBorder: _textFieldBorder(),
      ),
      onSelected: (value) => widget.onChanged(value),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          widget.menuColor ?? AppColors.backgroundColor,
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.secondaryGrey2),
        ),
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(widget.menuBorderRadius),
          ),
        ),
      ),
      dropdownMenuEntries:
          widget.items
              .map(
                (item) => DropdownMenuEntry(
                  value: item,
                  label: widget.itemLabel(item),
                  labelWidget: Text(
                    widget.itemLabel(item),
                    style:
                        widget.textStyle ?? AppFontTextStyles.textStyleMedium(),
                  ),
                ),
              )
              .toList(),
      leadingIcon: widget.leadingIcon,
      expandedInsets: EdgeInsets.all(widget.horizontalPadding ?? 0),
      textAlign: widget.textAlign,
    );
  }
}

class _LabelText extends StatelessWidget {
  final String labelText;
  final bool isError;
  final bool isMandatory;

  const _LabelText({
    required this.labelText,
    required this.isError,
    required this.isMandatory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: AppFontTextStyles.textStyleMedium().copyWith(
            color: isError ? AppColors.red : AppColors.borderColor,
          ),
        ),
        if (isMandatory)
          Text(
            ' *',
            style: AppFontTextStyles.buttonTextStyle().copyWith(
              color: AppColors.red,
            ),
          ),
      ],
    );
  }
}
