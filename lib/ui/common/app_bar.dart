import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/images.dart';
import '../../core/styles.dart';
import 'buttons/icon_button.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const CommonAppBar({super.key, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: AppColors.primaryYellow,
      leading:
      Navigator.of(context).canPop()
          ? AppIconButton(svgImage: Images.backArrow,
          onTap: () => navigatorKey.currentContext?.pop())
          : null,
      title: Text(title ?? '', style: AppFontTextStyles.appbarTextStyle()),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Dimens.appBarHeight);
}
