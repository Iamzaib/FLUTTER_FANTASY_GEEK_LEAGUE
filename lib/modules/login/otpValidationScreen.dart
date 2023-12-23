import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/global.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/home/tabScreen.dart';
import 'package:tempalteflutter/modules/login/continuebutton.dart';
import 'package:tempalteflutter/modules/login/otpProgressView.dart';
import 'package:tempalteflutter/modules/login/otpTimer.dart';
import 'package:tempalteflutter/modules/register/registerScreen.dart';
import 'package:http/http.dart' as http;

class OtpValidationScreen extends StatefulWidget {
  final String phonenumber;
  OtpValidationScreen(this.phonenumber);
  @override
  _OtpValidationScreenState createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidationScreen>
    with TickerProviderStateMixin {
  var isLoginProsses = false;
  late AnimationController _animationController;
  var otpText = '';
  var istimeFinish = false;
  var otpTimerView = false;
  var otpController = new TextEditingController();

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getThemeData().backgroundColor,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'OTP ভেরিফিকেশন',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          color: AllCoustomTheme.getThemeData()
                                              .primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              OtpProgressView(),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 60,
                                child: Container(
                                  width: 150,
                                  decoration: new BoxDecoration(
                                    color: AllCoustomTheme.getThemeData()
                                        .backgroundColor,
                                    border: new Border.all(
                                      width: 1.0,
                                      color:
                                          AllCoustomTheme.getTextThemeColors()
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                  child: TextField(
                                    cursorColor: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      letterSpacing: 10.0,
                                      fontSize: ConstanceData.SIZE_TITLE18,
                                      color: AllCoustomTheme
                                          .getBlackAndWhiteThemeColors(),
                                    ),
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        counterStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.transparent)),
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    onChanged: (txt) {
                                      otpText = txt;
                                      if (!istimeFinish) {
                                        if (txt.length == 4) {
                                          _animationController.forward();
                                        } else {
                                          _animationController.reverse();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              otpTimerView
                                  ? OtpTimerView(timeCallBack: (isfinish) {
                                      if (isfinish) {
                                        if (!mounted) return;
                                        setState(() {
                                          istimeFinish = true;
                                          _animationController.forward();
                                        });
                                      }
                                    })
                                  : OtpTimerView(timeCallBack: (isfinish) {
                                      if (isfinish) {
                                        if (!mounted) return;
                                        setState(() {
                                          istimeFinish = true;
                                          _animationController.forward();
                                        });
                                      }
                                    }),
                              Flexible(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              new SizeTransition(
                                sizeFactor: new CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.fastOutSlowIn),
                                axis: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14, left: 14, bottom: 14),
                                  child: ContinueButton(
                                    name: 'এগিয়ে যান',
                                    callBack: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      setState(() {
                                        isLoginProsses = true;
                                      });
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      _verifyOTP(otpText);
                                      // Fluttertoast.showToast(
                                      //     msg:
                                      //         "Your phone verification successful.");
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         RegisterScreen(),
                                      //   ),
                                      // );

                                      // setState(() {
                                      //   isLoginProsses = false;
                                      // });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _verifyOTP(var otp) async {
    if (otp.length != 4) {
      Fluttertoast.showToast(msg: "৪ ডিজিটের OTP দিন");
    } else {
      // print('e porjonto');
      String baseurl = ConstanceData.ServerURL;
      var data = {
        'mobile': widget.phonenumber,
        'otp': otp,
      };
      try {
        http.Response response = await http.post(
          Uri.parse(baseurl + '/api/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(data),
        );
        // print(response.statusCode);
        if (response.statusCode == 200) {
          var body = json.decode(response.body);
          setState(() {
            isLoginProsses = false;
          });

          if (body['success'] == true) {
            setState(() {
              userData = body['user'];
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(ConstanceData.Usertoken, userData['token']);
            await prefs.setString(
                ConstanceData.UserData,
                jsonEncode({
                  'user_id': body['user']['id'].toString(),
                  'email': body['user']['email'],
                  'name': body['user']['name'],
                  'mobile_number': body['user']['mobile'],
                  'bkash_number': body['user']['bkash'],
                  'address': body['user']['address'],
                  'image': body['user']['image'],
                  'total_coin': body['user']['total_coin'],
                  'winning_balance': body['user']['winning_balance'],
                  'created_time': body['user']['created_at'],
                  'updated_time': body['user']['updated_at'],
                }));
            usertoken = (await MySharedPreferences().getUsertokenString())!;
            userdata = await MySharedPreferences().getUserData();
            Fluttertoast.showToast(msg: body['message']);
            if (userdata!.name!.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabScreen(),
                ),
              );
            }

            print(userData);
            print(usertoken);
            print(userdata!.toJson());
          } else {
            Fluttertoast.showToast(msg: body['message']);
          }
        } else {
          print(response.body);
        }
      } catch (_) {
        print(_);
      }
      // Fluttertoast.showToast(msg: "Your phone verification successful.");
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => OtpValidationScreen(),
    //   ),
    // );
  }
}
