import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/form_validator.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';

Widget buildForgotPasswordDialog(BuildContext context) {
  final dialogFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: PColors.backgrndPrimary,
    title: Text("Forgot Password", style: TextStyle(color: PColors.textPrimary)),
    content: Form(
      key: dialogFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter your email and and click send to get password reset email..",
              style: TextStyle(color: PColors.textPrimary)),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
            validator: (Value) {
              return Validator.validateEmail(Value);
            },
          )
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Cancel", style: TextStyle(color: PColors.error)),
      ),
      TextButton(
        onPressed: () {
          if (dialogFormKey.currentState!.validate()) {
            context
                .read<AuthBloc>()
                .add(ForgotPasswordEvent(email: emailController.text.trim()));
            Navigator.pop(context);
          }
        },
        child: Text("send", style: TextStyle(color: PColors.success)),
      ),
    ],
  );
}
