import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class TutorCard extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final Timestamp createdAt;

  const TutorCard({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
  });

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return 'Joined on ${DateFormat.yMMMMd().format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.percentHeight(0.01),
        horizontal: responsive.percentWidth(0.04),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.percentWidth(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: responsive.percentWidth(0.03),
            spreadRadius: responsive.percentWidth(0.01),
            offset: Offset(0, responsive.percentHeight(0.005)),
          ),
        ],
      ),
      padding: EdgeInsets.all(responsive.percentWidth(0.04)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Photo
          CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
            radius: responsive.percentWidth(0.08),
          ),
          
          SizedBox(width: responsive.percentWidth(0.04)),
          
          // Right side - Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Join Date
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.percentWidth(0.045),
                  ),
                ),
                SizedBox(height: responsive.percentHeight(0.005)),
                Text(
                  formatDate(createdAt),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: responsive.percentWidth(0.03),
                  ),
                ),
                
                SizedBox(height: responsive.percentHeight(0.015)),
                
                // Email
                Text(
                  email,
                  style: TextStyle(
                    fontSize: responsive.percentWidth(0.035),
                    color: Colors.black87,
                  ),
                ),
                
                SizedBox(height: responsive.percentHeight(0.015)),
                
                // Action Icons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.phone, size: responsive.percentWidth(0.06)),
                      color: Colors.deepPurple,
                      onPressed: () {},
                    ),
                    SizedBox(width: responsive.percentWidth(0.02)),
                    IconButton(
                      icon: Icon(Icons.email, size: responsive.percentWidth(0.06)),
                      color: Colors.deepPurple,
                      onPressed: () {},
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.more_vert, size: responsive.percentWidth(0.06)),
                      color: Colors.black54,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}