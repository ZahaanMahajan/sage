import 'package:flutter/material.dart';
import 'package:sage_app/core/extensions/string.dart';

abstract class Validators {
  Validators._();

  static FormFieldValidator<String>? getValidator(TextInputType? keyboardType) {
    return switch (keyboardType) {
      TextInputType.emailAddress => Validators.email,
      _ => null,
    };
  }

  static String? required(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'Field is required';
    }
    return null;
  }

  static String? requiredTyped<T>(T? input) {
    if (input == null) {
      return 'Field is required';
    }
    return null;
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return "Enter email address";
    }

    if (!email.isValidEmail()) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter Password";
    }
    if (password.length < 6) {
      return "Password should contain at-least 6 letters.";
    }
    return null;
  }
}
