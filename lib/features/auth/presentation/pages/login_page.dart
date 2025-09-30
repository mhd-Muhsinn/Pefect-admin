import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/image_strings.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';
import 'package:perfect_super_admin/core/constants/text_strings.dart';
import 'package:perfect_super_admin/core/utils/form_validator.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/core/widgets/common/custom_button.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/features/auth/presentation/widgets/login_form.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';

import '../widgets/reset_password_dialog.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            CircularProgressIndicator(
              color: PColors.primary,
            );
            Navigator.pushNamedAndRemoveUntil(
                context, '/mainpage', (route) => false);
          }
          if (state is AuthenticatedErrors) {
            showCustomSnackbar(
                context: context, message: state.message, size: size,backgroundColor: PColors.error);
          }
        },
        child: Scaffold(
          backgroundColor: PColors.backgrndPrimary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildLoginIllustraion(),
                Padding(
                  padding: EdgeInsets.all(size.spacingSmall),
                  child: _Login(
                    context,
                    size,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildLoginIllustraion() {
    return Container(
      color: PColors.containerBackground,
      child: Image.asset(PImages.loginIllustraion),
    );
  }

  Widget _Login(
    BuildContext context,
    ResponsiveConfig size,
  ) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            PTexts.loginSubtitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.spacingLarge),
          CustomTextFormField(
            controller: emailController,
            hintText: "Enter Your email",
            prefixIcon: Icons.email,
            validator: (value) {
              return Validator.validateEmail(value);
            },
          ),
          SizedBox(height: size.spacingSmall),
          CustomTextFormField(
            controller: passwordController,
            hintText: "Password",
            prefixIcon: Icons.lock,
            obscureText: true,
            validator: (value) {
              return Validator.validatePassword(value);
            },
          ),
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => buildForgotPasswordDialog(context));
            },
            child: const Text("Forgot Password?"),
          ),
          SizedBox(height: size.spacingMedium),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () {
                if (Validator.checkFormValid(_formkey)) {
                  context.read<AuthBloc>().add(LoginEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()));
                }
              },
              text: 'Login',color: PColors.containerBackground,
            ),
          ),
        ],
      ),
    );
  }
}
