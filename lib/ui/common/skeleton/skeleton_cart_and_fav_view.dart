import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/dimens.dart';
import '../../../core/styles.dart';
import '../../decoration/container_decoration.dart';

class SkeletonCartAndFavItemView extends StatelessWidget {
  const SkeletonCartAndFavItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimens.containerSmall,
            child: Stack(
              children: [
                Bone.square(
                  size: double.infinity,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.radiusLarge),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimens.spaceXSmall),
                  child: Row(
                    children: [
                      Bone.square(
                        size: Dimens.iconLarge,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.radiusSmall),
                        ),
                      ),
                      const Gap(Dimens.space3xSmall),
                      Bone.square(
                        size: Dimens.iconLarge,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.radiusSmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.space3xSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item number index as title',
                  style: AppFontTextStyles.textStyleBold().copyWith(
                    fontSize: Dimens.fontSizeEighteen,
                  ),
                ),
                Text(
                  'Subtitle here,Subtitle here,Subtitle here ...Subtitle here ...',
                  style: AppFontTextStyles.textStyleSmall().copyWith(overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
