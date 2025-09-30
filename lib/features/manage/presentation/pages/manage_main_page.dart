import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/manage_button.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EDIT  &  MANAGE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.edit, color: PColors.iconPrimary),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.percentWidth(0.05)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRowsection(context),
              SizedBox(height: size.percentHeight(0.03)),
              _buildColumnsSections(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnsSections(BuildContext context) {
    return Column(children: [
      ManageButton(
        label: "MANAGE TRAINERS",
        onTap: () {
          Navigator.pushNamed(context, '/tutorall');
        },
      ),
      ManageButton(
        label: "ALL COURSES",
        onTap: () {
          Navigator.pushNamed(context, '/allcourses');
        },
      ),
      ManageButton(
        label: "CREATE NEW COURSE",
        icon: Icons.add,
        onTap: () {
          Navigator.pushNamed(context, '/addcoursePage');
        },
      ),
      ManageButton(
        label: "ALL MEETINGS",
        onTap: () {},
      ),
    ]);
  }

  Widget _buildRowsection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ManageButton(
          label: "New TRAINERS",
          icon: Icons.group,
          isSmall: true,
          onTap: () {
            Navigator.pushNamed(context, '/trainersrequests');
          },
        ),
        ManageButton(
          label: "MANAGE USERS",
          icon: Icons.group,
          isSmall: true,
          onTap: () {},
        ),
        ManageButton(
          label: "CREATE MEET",
          icon: Icons.add,
          isSmall: true,
          onTap: () {},
        ),
      ],
    );
  }
}
