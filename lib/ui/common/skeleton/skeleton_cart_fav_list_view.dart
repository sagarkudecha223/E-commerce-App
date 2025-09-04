import 'package:flutter/material.dart';

import '../../../core/dimens.dart';
import 'skeleton_cart_and_fav_view.dart';
import 'skeleton_wrapper.dart';

class SkeletonCartFavListView extends StatelessWidget {
  const SkeletonCartFavListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonWrapper(
      child: GridView.builder(
        padding: const EdgeInsets.all(Dimens.spaceXSmall),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: Dimens.containerXMedium,
          mainAxisExtent: 280,
          crossAxisSpacing: Dimens.spaceXSmall,
          mainAxisSpacing: Dimens.spaceXSmall,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => const SkeletonCartAndFavItemView(),
        shrinkWrap: true,
      ),
    );
  }
}
