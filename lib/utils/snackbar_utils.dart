import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showSnackBar(
    BuildContext context, {
    required String text,
    Color color = Colors.lightBlue,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      duration: const Duration(
        seconds: 1,
      ),
    ));
  }
}
