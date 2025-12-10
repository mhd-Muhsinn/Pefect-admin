import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/tutor_cubit/tutor_request_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/tutor_cubit/tutor_request_state.dart';

import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_requests_stream.dart';

// lib/features/manage/presentation/pages/tutor_requests_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_request_card.dart';

class TutorRequestsPage extends StatelessWidget {
  const TutorRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TutorRequestCubit();
        cubit.startListening();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tutor Requests'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: PColors.backgrndPrimary,
        body: BlocBuilder<TutorRequestCubit, TutorRequestState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.requests.isEmpty) {
              return const Center(child: Text("No tutor requests"));
            }

            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final data = state.requests[index];
                final docId = data["id"];

                final certificates = (data['certificates'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                final courses = (data['selectedCourses'] as List?)?.cast<Map<String, dynamic>>() ?? [];

                return TutorRequestCard(
                  key: ValueKey(docId),
                  name: data['name'] ?? 'No Name',
                  email: data['email'] ?? 'No Email',
                  age: (data['age'] ?? '').toString(),
                  photoUrl: data['photo']?['url'] ?? 'https://via.placeholder.com/150',
                  qualification: data['qualification'] ?? '',
                  certificates: certificates,
                  selectedCourses: courses,
                  onAccept: () => context.read<TutorRequestCubit>().acceptRequest(docId),
                  onReject: () => context.read<TutorRequestCubit>().rejectRequest(docId),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


