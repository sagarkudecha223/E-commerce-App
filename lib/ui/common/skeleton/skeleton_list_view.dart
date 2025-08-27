import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/dimens.dart';
import '../../../core/styles.dart';
import '../../decoration/container_decoration.dart';
import 'skeleton_wrapper.dart';

class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonWrapper(
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder:
            (_, index) => Container(
              height: Dimens.containerXSmall,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
              padding: EdgeInsets.all(Dimens.space2xSmall),
              decoration: ContainerDecoration(),
              child: Row(
                children: [
                  Bone.square(
                    size: Dimens.container2xSmall,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.radiusLarge),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.spaceSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Item number $index as title',
                            style: AppFontTextStyles.textStyleBold().copyWith(
                              fontSize: Dimens.fontSizeEighteen,
                            ),
                          ),
                          const Text(
                            'Subtitle here,Subtitle here,Subtitle here',
                          ),
                          Row(
                            children: [
                              Text(
                                'Price',
                                style: AppFontTextStyles.textStyleBold()
                                    .copyWith(
                                      fontSize: Dimens.fontSizeEighteen,
                                    ),
                              ),
                              const Spacer(),
                              Bone.square(
                                size: Dimens.iconLarge,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.radiusSmall),
                                ),
                              ),
                              const Gap(Dimens.space2xSmall),
                              Bone.square(
                                size: Dimens.iconLarge,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.radiusSmall),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
