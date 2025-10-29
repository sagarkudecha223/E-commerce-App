import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/dimens.dart';
import '../../core/images.dart';
import 'anim/hero.dart';
import 'app_loader.dart';
import 'svg_icon.dart';

class CacheNetworkImageView extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final String heroTag;

  const CacheNetworkImageView({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return HeroAnim(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusLarge),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
          progressIndicatorBuilder:
              (context, url, progress) => Center(child: AppLoader()),
          errorWidget:
              (context, url, error) =>
                  AppSvgIcon(Images.snacks, height: Dimens.iconMedium),
        ),
      ),
    );
  }
}
