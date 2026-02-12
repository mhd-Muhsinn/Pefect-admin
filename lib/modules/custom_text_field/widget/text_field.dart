import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/modules/custom_text_field/cubit/obscure_text_cubit.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  /// NOW OPTIONAL
  final IconData? prefixIcon;

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
    this.prefixIcon, // now optional
    this.suffixIcon,
    this.onchanged,
    this.initialValue,
    this.obscureText = false,
    this.validator,
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
            return _buildTextField(context, isObscure);
          },
        ),
      );
    } else {
      return _buildTextField(context, false);
    }
  }

  Widget _buildTextField(BuildContext context, bool isObscure) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onchanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText && isObscure,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      minLines: keyboardType == TextInputType.multiline ? 1 : 1,
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
      style: const TextStyle(fontSize: 15),

      decoration: InputDecoration(
        prefixText: prefixText,

        /// IMPORTANT: Only show prefixIcon when provided
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: PColors.containerBackground)
            : null,

        /// Obscure button OR custom suffix
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: PColors.containerBackground,
                ),
                onPressed: () => context.read<ObscureTextCubit>().toggle(),
              )
            : suffixIcon,

        labelText: hintText,
        labelStyle: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.w400,
        ),

        filled: true,
        fillColor: Colors.white,

        counterText: '',

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
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
