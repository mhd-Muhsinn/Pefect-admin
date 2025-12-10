import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/tutor_cubit/tutor_request_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_request_card.dart';


class TutorRequestsStreamWrapper extends StatelessWidget {
  const TutorRequestsStreamWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>TutorRequestCubit(),
    child: TutorRequestsStream());
  }
}
class TutorRequestsStream extends StatelessWidget {
  const TutorRequestsStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tutor_requests')
          .where('status', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No tutor requests"));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;

            final rawCertificates = data['certificates'] ?? [];
            final certificates = rawCertificates is List
                ? rawCertificates.whereType<Map<String, dynamic>>().toList()
                : [];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: TutorRequestCard(
                key: ValueKey(docId),
                name: data['name'] ?? 'No Name',
                email: data['email'] ?? 'No Email',
                age: (data['age'] ?? '').toString(),
                photoUrl: data['photo']?['url'] ??
                    'https://via.placeholder.com/150',
                qualification: data['qualification'] ?? '',
                certificates: certificates as  List<Map<String, dynamic>>,
                selectedCourses:
                    List<Map<String,dynamic>>.from(data['selectedCourses'] ?? []),
                onAccept: () {
                  context.read<TutorRequestCubit>().acceptRequest(docId);
                  Navigator.pop(context);
                },
                onReject: () {
                  context.read<TutorRequestCubit>().rejectRequest(docId);
                  Navigator.pop(context);
                }
              ),
            );
          },
        );
      },
    );
  }

 
}
