import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/tutors_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_card.dart';



class TutorsGridView extends StatelessWidget {
  const TutorsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorsCubit(FirebaseFirestore.instance),
      child: Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        appBar: AppBar(title: const Text('Tutors'),backgroundColor: Colors.transparent,),
        body: const TutorsGridContent(),
      ),
    );
  }
}

class TutorsGridContent extends StatelessWidget {
  const TutorsGridContent({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return BlocBuilder<TutorsCubit, List<DocumentSnapshot>>(
      builder: (context, tutors) {
        if (tutors.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(responsive.percentWidth(0.03)),
          child: ListView.builder(
            itemCount: tutors.length,
        
            itemBuilder: (BuildContext context, index) {
              final tutor = tutors[index];
              return TutorCard(
                name: tutor['name'],
                email: tutor['email'],
                photoUrl: tutor['photourl'] ?? '',
                createdAt: tutor['createdAt'] as Timestamp,
              );
            },
          ),
        );
      },
    );
  }
}