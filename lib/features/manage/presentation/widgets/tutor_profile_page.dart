import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class TutorProfilePage extends StatelessWidget {
  final String tutorId;
  final String name;
  final String email;
  final String photoUrl;
  final Timestamp createdAt;

  const TutorProfilePage({
    super.key,
    required this.tutorId,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
  });

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date);
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Top Profile Section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Header with back and menu buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.percentWidth(0.04),
                        vertical: responsive.percentHeight(0.01),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: responsive.percentHeight(0.02)),

                    // Profile Image
                    Container(
                      width: responsive.percentWidth(0.35),
                      height: responsive.percentWidth(0.35),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade50,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl.isEmpty
                            ? Text(
                                getInitials(name),
                                style: TextStyle(
                                  fontSize: responsive.percentWidth(0.1),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              )
                            : null,
                      ),
                    ),

                    SizedBox(height: responsive.percentHeight(0.02)),

                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: responsive.percentWidth(0.065),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: responsive.percentHeight(0.005)),

                    // Role
                    Text(
                      'Professional Tutor',
                      style: TextStyle(
                        fontSize: responsive.percentWidth(0.04),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: responsive.percentHeight(0.03)),

                    // Info Cards Row
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.percentWidth(0.05),
                      ),
                      child: Row(
                        children: [
                          // Joined Date Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(responsive.percentWidth(0.04)),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.deepPurple,
                                    size: responsive.percentWidth(0.055),
                                  ),
                                  SizedBox(height: responsive.percentHeight(0.01)),
                                  Text(
                                    'Joined Date',
                                    style: TextStyle(
                                      fontSize: responsive.percentWidth(0.03),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: responsive.percentHeight(0.005)),
                                  Text(
                                    formatDate(createdAt),
                                    style: TextStyle(
                                      fontSize: responsive.percentWidth(0.035),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: responsive.percentWidth(0.03)),

                          // Phone Number Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(responsive.percentWidth(0.04)),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Colors.deepPurple,
                                    size: responsive.percentWidth(0.055),
                                  ),
                                  SizedBox(height: responsive.percentHeight(0.01)),
                                  Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontSize: responsive.percentWidth(0.03),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: responsive.percentHeight(0.005)),
                                  Text(
                                    '+44 20 7946 0958',
                                    style: TextStyle(
                                      fontSize: responsive.percentWidth(0.035),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: responsive.percentHeight(0.03)),
                  ],
                ),
              ),
            ),
          ),

          // Email Card
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.percentWidth(0.05),
                responsive.percentHeight(0.02),
                responsive.percentWidth(0.05),
                0,
              ),
              child: Container(
                padding: EdgeInsets.all(responsive.percentWidth(0.045)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(responsive.percentWidth(0.03)),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.deepPurple,
                        size: responsive.percentWidth(0.06),
                      ),
                    ),
                    SizedBox(width: responsive.percentWidth(0.04)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.032),
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: responsive.percentHeight(0.005)),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.038),
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Salary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.percentWidth(0.05),
                responsive.percentHeight(0.015),
                responsive.percentWidth(0.05),
                0,
              ),
              child: Container(
                padding: EdgeInsets.all(responsive.percentWidth(0.045)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade400,
                      Colors.deepPurple.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(responsive.percentWidth(0.03)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: responsive.percentWidth(0.06),
                      ),
                    ),
                    SizedBox(width: responsive.percentWidth(0.04)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Salary',
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.032),
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          SizedBox(height: responsive.percentHeight(0.005)),
                          Text(
                            '₹50,000',
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.055),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: responsive.percentWidth(0.06),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Certificates Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.percentWidth(0.05),
                responsive.percentHeight(0.015),
                responsive.percentWidth(0.05),
                0,
              ),
              child: Container(
                padding: EdgeInsets.all(responsive.percentWidth(0.045)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(responsive.percentWidth(0.03)),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        color: Colors.orange.shade700,
                        size: responsive.percentWidth(0.06),
                      ),
                    ),
                    SizedBox(width: responsive.percentWidth(0.04)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certificates & Documents',
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.038),
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: responsive.percentHeight(0.005)),
                          Text(
                            'View all certificates',
                            style: TextStyle(
                              fontSize: responsive.percentWidth(0.032),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade400,
                      size: responsive.percentWidth(0.045),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(responsive.percentWidth(0.05)),
              child: Row(
                children: [
                  // Message Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade400,
                            Colors.deepPurple.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/message',
                              arguments: {
                                'tutorId': tutorId,
                                'tutorName': name,
                                'tutorEmail': email,
                                'tutorPhoto': photoUrl,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.percentHeight(0.02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  color: Colors.white,
                                  size: responsive.percentWidth(0.055),
                                ),
                                SizedBox(width: responsive.percentWidth(0.02)),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    fontSize: responsive.percentWidth(0.04),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: responsive.percentWidth(0.03)),

                  // Call Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(responsive.percentWidth(0.04)),
                          child: Icon(
                            Icons.phone_outlined,
                            color: Colors.deepPurple,
                            size: responsive.percentWidth(0.06),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: responsive.percentWidth(0.03)),

                  // Email Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(responsive.percentWidth(0.04)),
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.deepPurple,
                            size: responsive.percentWidth(0.06),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Padding
          SliverToBoxAdapter(
            child: SizedBox(height: responsive.percentHeight(0.02)),
          ),
        ],
      ),
    );
  }
}