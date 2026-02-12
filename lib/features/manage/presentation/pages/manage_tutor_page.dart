import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/widgets/common/gradient_background_container.dart';
import '../../../../core/constants/colors.dart';
import '../../../../modules/dynamic_dropdown/widget/admin_panel_logo_widget.dart';
import '../cubits/tutors_cubit.dart';
import '../widgets/tutor_card.dart';

class ManageTutorPage extends StatelessWidget {
  const ManageTutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorsCubit(FirebaseFirestore.instance),
      child: Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        body: const ManageTutorPageView(),
      ),
    );
  }
}

class ManageTutorPageView extends StatelessWidget {
  const ManageTutorPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return GradientBackgroundContaier(
      child: Column(
        children: [
          HeaderSection(size: responsive),
          Expanded(
            child: BlocBuilder<TutorsCubit, List<DocumentSnapshot>>(
              builder: (context, tutors) {
                if (tutors.isEmpty) {
                  return TutorErrorState(responsive: responsive);
                }
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.deepPurple.shade50.withOpacity(0.3),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                  child: CustomScrollView(
                    slivers: [
            
                      // Section Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            responsive.percentWidth(0.05),
                            responsive.percentHeight(0.03),
                            responsive.percentWidth(0.05),
                            responsive.percentHeight(0.015),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'All Tutors',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.percentWidth(0.03),
                                  vertical: responsive.percentHeight(0.008),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.deepPurple.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.filter_list_rounded,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                    SizedBox(width: responsive.percentWidth(0.01)),
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            
                      // Tutors List
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.percentWidth(0.04),
                          vertical: responsive.percentHeight(0.01),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final tutor = tutors[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: responsive.percentHeight(0.015),
                                ),
                                child: TutorCard(
                                  name: tutor['name'],
                                  email: tutor['email'],
                                  photoUrl: tutor['photourl'] ?? '',
                                  createdAt: tutor['createdAt'] as Timestamp,
                                  onMessageTap: () {
                                    // Navigate to message screen
                                    Navigator.pushNamed(
                                      context,
                                      '/message',
                                      arguments: {
                                        'tutorId': tutor.id,
                                        'tutorName': tutor['name'],
                                        'tutorEmail': tutor['email'],
                                        'tutorPhoto': tutor['photourl'] ?? '',
                                      },
                                    );
                                  }, tutorId: tutor.id,
                                ),
                              );
                            },
                            childCount: tutors.length,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TutorErrorState extends StatelessWidget {
  const TutorErrorState({
    super.key,
    required this.responsive,
  });

  final ResponsiveConfig responsive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: responsive.percentHeight(0.02)),
          Text(
            'Loading tutors...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: responsive.percentHeight(0.03)),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
class HeaderSection extends StatelessWidget {   //HeaderSection
  const HeaderSection({super.key, required this.size});
  final ResponsiveConfig size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.percentWidth(0.05)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: PColors.white,
                  size: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AdminPanelSettingsLogoWidget(),
              ),
            ],
          ),
          SizedBox(height: size.percentHeight(0.03)),
          const Text(
            'Manage Tutors',
            style: TextStyle(
              color: PColors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          
        ],
      ),
    );
  }
}