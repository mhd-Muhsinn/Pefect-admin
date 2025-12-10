import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:shimmer/shimmer.dart';

class MessageBoxShimmer extends StatelessWidget {
  final bool isSender;

  const MessageBoxShimmer({super.key, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: PColors.shimmerbasecolor,
        highlightColor: PColors.shimmerhighlightcolor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          constraints: BoxConstraints(
            maxWidth: size.percentWidth(0.35),
            minWidth: size.percentWidth(0.2)
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isSender
                  ? const Radius.circular(18)
                  : const Radius.circular(4),
              bottomRight: isSender
                  ? const Radius.circular(4)
                  : const Radius.circular(18),
            ),
          ),
          child: Container(
            height: 14,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
