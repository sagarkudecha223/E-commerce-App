import 'package:flutter/material.dart';
import 'skeleton_item_view.dart';
import 'skeleton_wrapper.dart';

class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonWrapper(
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (_, index) => const SkeletonItemView(),
      ),
    );
  }
}
