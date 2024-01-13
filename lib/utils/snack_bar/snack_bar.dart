import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void snack_bar(
    String msg, String title, BuildContext context, ContentType con) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // clipBehavior: Clip.antiAlias,
      duration: const Duration(seconds: 4),

      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: msg,
        message: title,
        contentType: con,
      ),
    ),
  );
}
