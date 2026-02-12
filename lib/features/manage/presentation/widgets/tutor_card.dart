import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/widgets/common/user_avatar_widget.dart';
import 'tutor_profile_page.dart';

class TutorCard extends StatelessWidget {
  final String tutorId;
  final String name;
  final String email;
  final String photoUrl;
  final Timestamp createdAt;
  final VoidCallback onMessageTap;

  const TutorCard({
    super.key,
    required this.tutorId,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.onMessageTap,
  });

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat.yMMMMd().format(date);
  }

  String getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.isEmpty) return '?';
    if (names.length == 1) return names[0][0].toUpperCase();
    return (names[0][0] + names[names.length - 1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PColors.primary.withOpacity(0.19),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TutorProfilePage(
                  tutorId: tutorId,
                  name: name,
                  email: email,
                  photoUrl: photoUrl,
                  createdAt: createdAt,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(responsive.percentWidth(0.04)),
            child: Row(
              children: [
                // Profile Image with Gradient Border and Badge
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [PColors.gradient1, PColors.gradient2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: UserAvatar(photoUrl: photoUrl, name: name, radius: responsive.percentWidth(0.11))
                      ),
                    ),
                  ],
                ),

                SizedBox(width: responsive.percentWidth(0.04)),

                // Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: responsive.percentWidth(0.048),
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: responsive.percentHeight(0.006)),

                      // Email with icon
                      Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.all(responsive.percentWidth(0.012)),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              size: responsive.percentWidth(0.038),
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: responsive.percentWidth(0.02)),
                          Expanded(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: responsive.percentWidth(0.034),
                                color: Colors.grey.shade700,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: responsive.percentHeight(0.01)),

                      // Salary and Join Date Row
                      Row(
                        children: [
                          // Salary Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.percentWidth(0.025),
                              vertical: responsive.percentHeight(0.006),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade50,
                                  Colors.deepPurple.shade100.withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.deepPurple.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size: responsive.percentWidth(0.035),
                                  color: Colors.deepPurple.shade700,
                                ),
                                Text(
                                  '50K/mo',
                                  style: TextStyle(
                                    fontSize: responsive.percentWidth(0.03),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.deepPurple.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: responsive.percentWidth(0.02)),

                          // Join Date
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: responsive.percentWidth(0.03)),

                // Message Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade600,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onMessageTap,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: EdgeInsets.all(responsive.percentWidth(0.035)),
                        child: Icon(
                          Icons.message_rounded,
                          size: responsive.percentWidth(0.055),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
