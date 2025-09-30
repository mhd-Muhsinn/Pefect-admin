import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/modules/custom_text_field/cubit/obscure_text_cubit.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? prefixText;
  final int? maxLength;
  final String? initialValue;
  final void Function(String?)? onchanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.onchanged,
    this.initialValue,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.prefixText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    if (obscureText) {
      return BlocProvider(
        create: (_) => ObscureTextCubit(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, isObscure) {
            return _buildTextFormField(context, isObscure);
          },
        ),
      );
    } else {
      return _buildTextFormField(context, false);
    }
  }

  Widget _buildTextFormField(BuildContext context, bool isObscure) {
    return TextFormField(
      onChanged: onchanged,
      initialValue: initialValue,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText && isObscure,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
     minLines: keyboardType == TextInputType.multiline ? 1 : 1, // 👈
     maxLines: keyboardType == TextInputType.multiline ? null : 1, // 👈
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixIcon: Icon(prefixIcon, color: PColors.containerBackground),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: PColors.containerBackground,
                ),
                onPressed: () {
                  context.read<ObscureTextCubit>().toggle();
                },
              )
            : suffixIcon,
        labelText: hintText,
        labelStyle: TextStyle(
            color: Colors.grey[800], fontWeight: FontWeight.w400), //change itt
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: PColors.containerBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: PColors.containerBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: PColors.containerBackground),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),

        filled: true,
        fillColor: Colors.white,
        counterText: '', // Hides the character counter
      ),
    );
  }
}
