
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/image_strings.dart';

class UserAvatar extends StatelessWidget {
  final String photoUrl;
  final String name;
  final double radius;

  const UserAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.radius,

  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: PColors.primary,
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Image.asset(AppImages.userPlaceholder, fit: BoxFit.cover),
                errorWidget: (_, __, ___) =>
                    Image.asset(AppImages.userPlaceholder, fit: BoxFit.cover),
              )
            : Center(
                child: Text(
                  _getInitials(name),
                  style:
                      TextStyle(
                        fontSize: radius * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                ),
              ),
      ),
    );
  }
}
