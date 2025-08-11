import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';

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
              ? Icon(Icons.arrow_back_ios_new_rounded)
              : null,
      title: Text(title ?? '', style: AppFontTextStyles.appbarTextStyle()),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Dimens.appBarHeight);
}
