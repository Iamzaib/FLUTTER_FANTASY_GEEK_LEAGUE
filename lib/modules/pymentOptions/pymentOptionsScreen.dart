// ignore_for_file: unused_field, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tempalteflutter/api/apiProvider.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/scheduleResponseData.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/modules/pymentOptions/aamarpay.dart';

class PymentScreen extends StatefulWidget {
  final String? paymetMoney;
  final entryFees;
  final ShedualData? shedualData;
  final bool? isOnlyAddMoney;
  final VoidCallback? isTruePayment;

  const PymentScreen(
      {Key? key,
      this.paymetMoney,
      this.shedualData,
      this.isOnlyAddMoney = false,
      this.entryFees,
      this.isTruePayment})
      : super(key: key);
  @override
  _PymentScreenState createState() => _PymentScreenState();
}

class _PymentScreenState extends State<PymentScreen> {
  var paymet = '';
  var isProsses = false;
  var totalCointoBuy = 0;
  var paymentController = new TextEditingController();
  UserData userData = new UserData();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var cashBonus = '';
  late Razorpay _razorpay;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.paymetMoney != null) {
      paymet = '${double.tryParse(widget.paymetMoney!)!.toInt()}';
    }
    paymentController.text = paymet;
    getUserData();
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    );
    print(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!);
  }

  @override
  void dispose() {
    super.dispose();
    paymentController.dispose();
    _razorpay.clear();
  }

  static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';

  void getUserData() async {
    setState(() {
      isProsses = true;
    });
    var responseData = await ApiProvider().drawerInfoList();
    if (responseData != null) {
      userData = responseData.data!;
    }
    if (!widget.isOnlyAddMoney!) {
      if ((double.tryParse(widget.entryFees)! * 0.20) <
          double.tryParse(userData.cashBonus!)!) {
        cashBonus = '${double.tryParse(widget.entryFees)! * 0.20}';
      } else {
        cashBonus = '${double.tryParse(userData.cashBonus!)}';
      }
    }
    setState(() {
      isProsses = false;
    });
  }

  void openPaymentOption() async {
    var options = {
      'key': 'rzp_test_ZAO3p5KJhdTKpQ',
      'amount': 10000,
      'name': 'Add Amount',
      'description': 'Test',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      },
      "colors": "#008080",
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AllCoustomTheme.getThemeData().primaryColor,
            AllCoustomTheme.getThemeData().primaryColor,
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          color: AllCoustomTheme.getThemeData().primaryColor,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: AppBar().preferredSize.height,
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: AppBar().preferredSize.height,
                                          height: AppBar().preferredSize.height,
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          widget.isOnlyAddMoney!
                                              ? 'কয়েন কিনুন'
                                              : 'কয়েন কিনুন',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .backgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: AppBar().preferredSize.height,
                                    ),
                                  ],
                                ),
                              ),
                              widget.shedualData != null
                                  ? MatchHadder()
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: userData != null
                              ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 16,
                                                top: 16),
                                            child:
                                                // Row(
                                                //   children: <Widget>[
                                                // Text(
                                                //   'Current Balance',
                                                //   style: TextStyle(
                                                //     fontFamily: 'Poppins',
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                // Expanded(
                                                //   child: SizedBox(),
                                                // ),
                                                // userData != null
                                                //     ? Text(
                                                //         '৳720',
                                                //         style: TextStyle(
                                                //           fontFamily: 'Poppins',
                                                //           color: AllCoustomTheme
                                                //                   .getThemeData()
                                                //               .primaryColor,
                                                //           fontSize:
                                                //               ConstanceData
                                                //                   .SIZE_TITLE18,
                                                //         ),
                                                //       )
                                                //     : Container(
                                                //         width: 12,
                                                //         height: 12,
                                                //         child:
                                                //             CircularProgressIndicator(
                                                //           strokeWidth: 2.0,
                                                //           valueColor:
                                                //               AlwaysStoppedAnimation<
                                                //                   Color>(
                                                //             AllCoustomTheme
                                                //                 .getBlackAndWhiteThemeColors(),
                                                //           ),
                                                //         ),
                                                //       ),
                                                //   ],
                                                // ),
                                                Text(
                                              '১ টাকা = ১০ কয়েন, নিচের অপশনগুলো থেকে যতগুলো কয়েন কিনতে চান, তা সিলেক্ট করুন।',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 16, left: 16),
                                        child: Text(
                                          'মোট টাকা',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(4.0),
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              readOnly: true,
                                              enabled: false,
                                              controller: paymentController,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE16,
                                                color: AllCoustomTheme
                                                    .getBlackAndWhiteThemeColors(),
                                              ),
                                              autofocus: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: new InputDecoration(
                                                prefix: Text(
                                                  '৳',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE16,
                                                  ),
                                                ),
                                                border: InputBorder.none,
                                                labelStyle: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE16,
                                                ),
                                              ),
                                              inputFormatters: [
                                                // WhitelistingTextInputFormatter.digitsOnly,
                                              ],
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return 'যেকোন একটি অপশন সিলেক্ট করুন';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '100';
                                                      totalCointoBuy = 1000;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '১০০০ কয়েন',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '৳১০০ (০% ডিসকাউন্ট)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '190';
                                                      totalCointoBuy = 2000;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '২০০০ কয়েন',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '৳১৯০ (৫% ডিসকাউন্ট)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '460';
                                                      totalCointoBuy = 5000;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '৫০০০ কয়েন',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '৳৪৬০ (৮% ডিসকাউন্ট)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '900';
                                                      totalCointoBuy = 10000;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '১০০০০ কয়েন',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '৳৯০০ (১০% ডিসকাউন্ট)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '2200';
                                                      totalCointoBuy = 25000;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '২৫০০০ কয়েন',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '৳২২০০ (১২% ডিসকাউন্ট)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        height: 60,
                                        padding: EdgeInsets.only(
                                            left: 50, right: 50, bottom: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          4.0),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 3.0),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                    onTap: () {
                                                      // openPaymentOption();
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());

                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) => AamarPay(
                                                                totalCointoBuy
                                                                    .toString(),
                                                                paymentController
                                                                    .text),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        'কয়েন কিনুন'
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // void showInSnackBar(String value) {
  //   _scaffoldKey.currentState!.showSnackBar(
  //     new SnackBar(
  //       content: new Text(
  //         value,
  //         style: TextStyle(
  //           fontFamily: 'Poppins',
  //           fontSize: ConstanceData.SIZE_TITLE14,
  //           color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
  //         ),
  //       ),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  // void showInSnackBars(String value) {
  //   _scaffoldKey.currentState!.showSnackBar(
  //     new SnackBar(
  //       content: new Text(
  //         value,
  //         style: TextStyle(
  //           fontFamily: 'Poppins',
  //           fontSize: ConstanceData.SIZE_TITLE14,
  //           color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
  //         ),
  //       ),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  // }
}
