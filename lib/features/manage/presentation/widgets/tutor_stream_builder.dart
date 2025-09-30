import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_card.dart';

class TutorsStreamBuilder extends StatelessWidget {
  final Stream<QuerySnapshot> tutorsStream;

  const TutorsStreamBuilder({
    super.key,
    required this.tutorsStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: tutorsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tutors = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tutors.length,

          itemBuilder: (context, index) {
            final tutor = tutors[index];
            return TutorCard(
              name: tutor['name'],
              email: tutor['email'],
              photoUrl: tutor['photourl'] ?? '',
              createdAt: tutor['createdAt'] as Timestamp,
            );
          },
        );
      },
    );
  }
}