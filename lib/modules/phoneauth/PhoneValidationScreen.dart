// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/bloc/phoneEnteryBloc.dart';
import 'package:tempalteflutter/bloc/phoneVerificationBloc.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/modules/login/continuebutton.dart';
import 'package:tempalteflutter/constance/global.dart' as globals;
import 'package:tempalteflutter/modules/login/otpValidationScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

var selectedCountryCode = '88';

class PhoneValidationScreen extends StatefulWidget {
  @override
  _PhoneValidationScreenState createState() => _PhoneValidationScreenState();
}

class _PhoneValidationScreenState extends State<PhoneValidationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  final phoneEntryBloc = PhoneEntryBloc(PhoneEntryBlocState.initial());

  String countryCode = "88";

  var phonNumberContorller = new TextEditingController();
  var phoneFocusNode = FocusNode();
  var phonNumber = '';

  var isLoginProsses = false;
  bool ismove = false;

  @override
  void initState() {
    globals.phoneVerificationBloc =
        PhoneVerificationBloc(PhoneVerificationBlocState.initial());
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    phonNumberContorller.dispose();
    super.dispose();
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                ),
              ),
              title: Text(
                'Fantasy Geek 11',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AllCoustomTheme.getThemeData().primaryColor,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: ListView(
                  children: [
                    _row1(),
                    _phonNumber(),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      color:
                                          AllCoustomTheme.getTextThemeColors(),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    ),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () async {
                                        const url =
                                            ConstanceData.TermsofService;
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                  ),
                                  TextSpan(
                                    text: '\n & ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      color:
                                          AllCoustomTheme.getTextThemeColors(),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    ),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () async {
                                        const url = ConstanceData.PrivacyPolicy;
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                  ),
                                  TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      color:
                                          AllCoustomTheme.getTextThemeColors(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14),
                      child: ContinueButton(
                        name: "Next",
                        callBack: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            isLoginProsses = true;
                          });
                          print(phonNumber);
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          _tryLogin(phonNumber);
                          // await Future.delayed(const Duration(seconds: 1));
                          // Fluttertoast.showToast(
                          //     msg: "Your phone verification successful.");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => OtpValidationScreen(),
                          //   ),
                          // );
                          setState(() {
                            isLoginProsses = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _tryLogin(var phonenumber) async {
    // TOKEN DELETE KORAR JONNO
    // TOKEN DELETE KORAR JONNO
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.remove(ConstanceData.Usertoken);
    // await preferences.remove(ConstanceData.UserData);
    if (phonenumber.length != 11) {
      Fluttertoast.showToast(msg: "১১ ডিজিটের ফোন নাম্বার প্রদান করুন!");
    } else {
      // print('e porjonto');
      String baseurl = ConstanceData.ServerURL;
      var data = {
        'mobile': phonenumber,
        // no OTP will lead the Laravel Login method to provide an OTP
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
        print(response.statusCode);
        if (response.statusCode == 200) {
          var body = json.decode(response.body);
          print(body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpValidationScreen(phonenumber),
            ),
          );
          Fluttertoast.showToast(msg: body);
        } else {
          // print(response.body);
        }
      } catch (_) {
        print(_);
        if (_.toString().split(' ').contains('SocketException:')) {
          if (_.toString().split(' ').contains('110,')) {
            print('server error');
            Fluttertoast.showToast(msg: 'সার্ভার এরর!');
          } else if (_.toString().split(' ').contains('101),')) {
            print('no internet');
            Fluttertoast.showToast(msg: 'ইন্টারনেট কানেকশন চেক করুন!');
          } else {
            print('connection error');
            Fluttertoast.showToast(msg: 'কানেকশন এরর!');
          }
        } else {
          print('other error');
          Fluttertoast.showToast(msg: 'দুঃখিত! আবার চেষ্টা করুন।');
        }
      }
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => OtpValidationScreen(),
    //   ),
    // );
  }

  Widget _help() {
    return Container(
      padding: EdgeInsets.only(top: 28, right: 10),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.questionCircle,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            'Help',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: ConstanceData.SIZE_TITLE10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row1() {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'আপনার ১১ ডিজিটের মোবাইল নম্বরটি লিখুন',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _phonNumber() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 80,
            height: 60,
            child: CountryCodePicker(
              onChanged: (e) {
                print(e.toLongString());
                print(e.name);
                print(e.code);
                print(e.dialCode);
                setState(() {
                  countryCode = e.dialCode!;
                });
              },
              initialSelection: 'Bangladesh',
              showFlagMain: true,
              showFlag: true,
              favorite: ['+88', 'Bangladesh'],
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: BlocBuilder(
                bloc: phoneEntryBloc,
                builder: (BuildContext context, PhoneEntryBlocState state) =>
                    Theme(
                  data: AllCoustomTheme.buildLightTheme().copyWith(
                      backgroundColor: Colors.transparent,
                      scaffoldBackgroundColor: Colors.transparent),
                  child: TextField(
                    controller: phonNumberContorller,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ConstanceData.SIZE_TITLE16,
                      color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                    ),
                    autofocus: true,
                    focusNode: phoneFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: 'মোবাইল নম্বর',
                      errorText: state.isPhoneError
                          ? '১১ ডিজিটের নাম্বারটি লিখুন'
                          : null,
                      prefix: Text("+$countryCode"),
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    maxLength: 11,
                    onChanged: (txt) {
                      phoneEntryBloc.onPhoneChanges(txt);
                      if (txt.length > 4) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                      setState(() {
                        phonNumber = txt;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
