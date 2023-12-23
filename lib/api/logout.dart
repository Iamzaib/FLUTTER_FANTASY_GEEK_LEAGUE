import 'package:flutter/material.dart';
import 'package:tempalteflutter/constance/global.dart' as globals;
import 'package:tempalteflutter/constance/routes.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/login/loginScreen.dart';
import 'package:tempalteflutter/modules/splash/SplashScreen.dart';
import 'package:tempalteflutter/utils/dialogs.dart';

class LogOut {
  void logout(BuildContext context) async {
    try {
      globals.usertoken = '';
      await MySharedPreferences().clearSharedPreferences();
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     Routes.SPLASH, (Route<dynamic> route) => false);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => SplashScreen()),
      //     (Route<dynamic> route) => true);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new SplashScreen()));
    } on Exception {
      Dialogs.showDialogWithOneButton(
        context,
        "Error",
        "please! try again.",
        onButtonPress: () {},
      );
    }
  }

  Future backSplashScreen(BuildContext context) async {
    try {
      globals.usertoken = '';
      loginUserData = UserData();
      await MySharedPreferences().clearSharedPreferences();
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.LOGIN, (Route<dynamic> route) => false);
    } on Exception {
      Dialogs.showDialogWithOneButton(
        context,
        "Error",
        "please! try again.",
        onButtonPress: () {},
      );
    }
  }
}
