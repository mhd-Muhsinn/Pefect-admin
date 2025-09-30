// form_validator.dart
import 'package:flutter/material.dart';

class Validator {
  
   
    static bool checkFormValid(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }
  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return 'Enter your name';
    if (trimmed.length < 3 || trimmed.length > 20) {
      return 'Name should be between 3–20 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your age';
    final age = int.tryParse(value);
    if (age == null || age < 18 || age > 100) {
      return 'Please enter a valid age (18–100)';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter the $fieldName';
    }
    return null;

}
}
