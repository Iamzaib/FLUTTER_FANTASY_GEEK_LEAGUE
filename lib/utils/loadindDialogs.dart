// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/routes.dart';
import 'package:tempalteflutter/constance/themes.dart';

void LoadingDialog(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 12,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  width: 15,
                ),
                Text('Loading...')
              ],
            ),
          ),
        );
      });
}
