import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:bloc_base_architecture/extension/context_extensions.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/images.dart';
import '../../core/styles.dart';
import 'app_loader.dart';
import 'svg_icon.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final TextInputAction? textInputAction;
  final double height;
  final Color? backgroundColor;
  final bool enabled;
  final bool obscureText;
  final bool hasBorder;
  final bool isMandatory;
  final bool alignToTopText;
  final Color? borderColor;
  final Color cursorColor;
  final double borderWidth;
  final double borderRadius;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Function(String)? textChanged;
  final Function(String)? onSubmitted;
  final Function? onSuffixIconTap;
  final Function? onFocusEvent;
  final bool autoFocus;
  final FocusNode? focusNode;
  final bool enableSuggestions;
  final bool isLoading;
  final int maxLines;
  final int? maxLength;
  final TextStyle? hintTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function()? onTapOutside;
  final bool filled;
  final String? errorText;
  final String? labelText;
  final String? prefixText;
  final double? suffixIconHeight;
  final TextFieldSuffixIconType? suffixIconType;

  const AppTextField({
    super.key,
    this.textEditingController,
    this.hintText,
    this.textInputAction = TextInputAction.done,
    this.height = Dimens.textFieldHeightMedium,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textChanged,
    this.onSubmitted,
    this.enabled = true,
    this.alignToTopText = false,
    this.obscureText = false,
    this.isMandatory = false,
    this.hasBorder = false,
    this.borderColor,
    this.cursorColor = AppColors.primaryOrange,
    this.borderWidth = Dimens.borderWidthSmall,
    this.borderRadius = Dimens.radiusSmall,
    this.backgroundColor,
    this.onSuffixIconTap,
    this.onFocusEvent,
    this.autoFocus = false,
    this.focusNode,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = true,
    this.isLoading = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.filled = false,
    this.hintTextStyle,
    this.errorText,
    this.prefixText = '',
    this.labelText,
    this.suffixIconHeight,
    this.suffixIconType,
  });

  @override
  State<AppTextField> createState() => _VineCareTextFieldState();
}

class _VineCareTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  late bool _obscureText;
  late TextFieldSuffixIconType? _suffixIconType;

  String get inputText => _textEditingController.text;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _suffixIconType = widget.suffixIconType;
    _textEditingController =
        widget.textEditingController ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusEvent);
    if (widget.autoFocus) _focusNode.requestFocus();
  }

  void _onFocusEvent() {
    setState(() {});
    if (widget.onFocusEvent != null) {
      widget.onFocusEvent!();
    }
  }

  OutlineInputBorder _textFieldBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    borderSide: BorderSide(
      color:
          widget.errorText != null && widget.errorText!.isNotBlank
              ? AppColors.red
              : widget.borderColor ?? AppColors.borderColor,
      width: widget.hasBorder ? widget.borderWidth : 1.0,
    ),
  );

  OutlineInputBorder _focusedBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    borderSide: BorderSide(
      color: AppColors.focusedBorderColor,
      width: widget.hasBorder ? widget.borderWidth : 1.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          inputFormatters: widget.inputFormatters,
          controller: _textEditingController,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.textColor,
          cursorErrorColor: AppColors.textColor,
          style: AppFontTextStyles.textStyleMedium(),
          enabled: widget.enabled,
          textCapitalization: widget.textCapitalization,
          textAlign: TextAlign.left,
          autocorrect: widget.enableSuggestions,
          enableSuggestions: widget.enableSuggestions,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          textAlignVertical: TextAlignVertical.center,
          maxLength: widget.maxLength,
          onSubmitted: widget.onSubmitted,
          keyboardAppearance: Brightness.dark,
          onTapOutside:
              (event) => widget.onTapOutside ?? context.hideKeyboard(),
          decoration: InputDecoration(
            label:
                widget.labelText != null && widget.labelText!.isNotBlank
                    ? _LabelText(
                      labelText: widget.labelText!,
                      isError:
                          widget.errorText != null &&
                          widget.errorText!.isNotBlank,
                      isFocused: _focusNode.hasFocus,
                    )
                    : null,
            isDense: true,
            counterText: '',
            fillColor:
                widget.enabled
                    ? widget.backgroundColor
                    : AppColors.primaryOrange.withOpacity(0.05),
            filled: widget.filled,
            focusedBorder: _focusedBorder(),
            border: _textFieldBorder(),
            enabledBorder: _textFieldBorder(),
            errorBorder: _textFieldBorder(),
            focusedErrorBorder: _textFieldBorder(),
            disabledBorder: _textFieldBorder(),
            hintText: widget.hintText,
            hintStyle:
                widget.hintTextStyle ??
                AppFontTextStyles.textStyleMedium().copyWith(
                  color: AppColors.secondaryGrey2,
                ),
            suffixIcon:
                widget.suffixIconType != null &&
                        _textEditingController.text.isNotEmpty
                    ? _SuffixIcon(
                      isLoading: widget.isLoading,
                      type: _suffixIconType!,
                      onTap: _onSuffixIconTap,
                      height: widget.suffixIconHeight,
                    )
                    : null,
          ),
          onChanged: (query) {
            if (widget.textChanged != null) {
              widget.textChanged!(query);
            }
            setState(() {});
          },
          focusNode: _focusNode,
        ),
      ],
    );
  }

  void _onSuffixIconTap() {
    switch (_suffixIconType) {
      case TextFieldSuffixIconType.cancel:
        _clearTextField();
        break;
      case TextFieldSuffixIconType.showObscureText:
        setState(() {
          _obscureText = false;
          _suffixIconType = TextFieldSuffixIconType.hideObscureText;
        });
        break;
      case TextFieldSuffixIconType.hideObscureText:
        setState(() {
          _obscureText = true;
          _suffixIconType = TextFieldSuffixIconType.showObscureText;
        });
        break;
      default:
        break;
    }
    if (widget.onSuffixIconTap != null) {
      widget.onSuffixIconTap!();
    }
  }

  void _clearTextField() {
    // refers to this: https://github.com/flutter/flutter/issues/17647
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.clear();
      if (widget.textChanged != null) widget.textChanged!('');
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.textEditingController == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }
}

class _LabelText extends StatelessWidget {
  final String labelText;
  final bool isError;
  final bool isFocused;

  const _LabelText({
    required this.labelText,
    required this.isError,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText,
      style: AppFontTextStyles.textStyleMedium().copyWith(
        color:
            isError
                ? AppColors.red
                : isFocused
                ? AppColors.focusedBorderColor
                : AppColors.secondaryGrey2,
      ),
    );
  }
}

class _SuffixIcon extends StatelessWidget {
  final bool isLoading;
  final TextFieldSuffixIconType type;
  final Function? onTap;
  final double? height;

  const _SuffixIcon({
    required this.onTap,
    required this.type,
    this.isLoading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
          padding: const EdgeInsets.all(Dimens.paddingXMedium),
          alignment: Alignment.center,
          width: Dimens.iconXSmall,
          height: Dimens.iconXSmall,
          child: const AppLoader(),
        )
        : IconButton(
          iconSize: Dimens.iconSmall,
          icon: AppSvgIcon(
            type.imageIcon,
            height: height,
            color: AppColors.secondaryGrey2,
          ),
          onPressed: onTap as void Function()?,
        );
  }
}

enum TextFieldSuffixIconType { cancel, showObscureText, hideObscureText }

extension ImageIcon on TextFieldSuffixIconType {
  static String _imageIcon(TextFieldSuffixIconType val) {
    switch (val) {
      case TextFieldSuffixIconType.cancel:
        return Images.cancel;
      case TextFieldSuffixIconType.showObscureText:
        return Images.showObscureText;
      case TextFieldSuffixIconType.hideObscureText:
        return Images.hideObscureText;
    }
  }

  String get imageIcon => _imageIcon(this);
}
