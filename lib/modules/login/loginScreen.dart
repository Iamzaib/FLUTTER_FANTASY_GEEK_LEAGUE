import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/global.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/login/sliderView.dart';
import 'package:tempalteflutter/modules/phoneauth/PhoneValidationScreen.dart';
import 'package:tempalteflutter/validator/validator.dart';

var loginUserData = UserData();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoginType = '';
  var email = '';
  var name = '';
  var id = '';
  var imageUrl = '';

  var isLoginProsses = false;

  @override
  void initState() {
    super.initState();
    print('login screen');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().backgroundColor,
                AllCoustomTheme.getThemeData().backgroundColor,
              ],
            ),
          ),
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: AllCoustomTheme.getThemeData().primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                Image.asset(
                                  "assets/stump.png",
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'FantasyGeek',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: SliderView(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        // FacebookGoogleView(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            // padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: new BoxDecoration(
                              color: HexColor('#4267B2'),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: new BorderRadius.circular(20.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PhoneValidationScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'লগ ইন করুন',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE16,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .backgroundColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Terms of Service | ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
