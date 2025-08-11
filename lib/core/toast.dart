import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showToast(Widget child, BuildContext context) {
  showToastWidget(
    child,
    context: context,
    duration: const Duration(milliseconds: 1000),
    animDuration: const Duration(milliseconds: 100),
    animation: StyledToastAnimation.none,
    reverseAnimation: StyledToastAnimation.none,
    position: StyledToastPosition.center,
  );
}
