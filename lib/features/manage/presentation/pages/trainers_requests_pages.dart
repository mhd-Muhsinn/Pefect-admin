import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

import 'package:perfect_super_admin/features/manage/presentation/widgets/tutor_requests_stream.dart';

class TutorRequestsPage extends StatelessWidget {
  const TutorRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Requests'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: PColors.backgrndPrimary,
      body:  TutorRequestsStreamWrapper(),
    );
  }
}

