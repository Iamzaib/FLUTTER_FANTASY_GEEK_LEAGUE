import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/global.dart';
// import 'package:tempalteflutter/payments/refundpolicy.dart';
// import 'package:tempalteflutter/payments/terms.dart';
import 'package:flutter/material.dart';
import 'package:aamarpay/aamarpay.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/modules/home/tabScreen.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class AamarPay extends StatefulWidget {
  final String totalcointobuy;
  final String totalamount;

  const AamarPay(this.totalcointobuy, this.totalamount, {Key? key})
      : super(key: key);

  @override
  _AamarPayState createState() => _AamarPayState();
}

class _AamarPayState extends State<AamarPay> {
  bool isLoading = false;
  String transactionid = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      transactionid = "FG" + generateRandomString(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('কয়েন কিনুন'),
        // flexibleSpace: appBarStyle(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "প্যাকেজঃ " + widget.totalcointobuy + ' কয়েন',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text(
                //   '৳' + banglaNumber(widget.packagedata['strike_price']),
                //   style: const TextStyle(
                //       fontSize: 30,
                //       height: 1,
                //       decoration: TextDecoration.lineThrough,
                //       color: Colors.black54),
                // ),
                Text(
                  '৳' + widget.totalamount,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const TermsAndConditions(),
                    //   ),
                    // ),
                  },
                  child: const Text(
                    'Terms & Conditions',
                    style: TextStyle(fontFamily: 'Arial', fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const RefundPolicy(),
                    //   ),
                    // ),
                  },
                  child: const Text(
                    'Refund Policy',
                    style: TextStyle(fontFamily: 'Arial', fontSize: 12),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Aamarpay(
                // This will return a payment url based on failUrl,cancelUrl,successUrl
                returnUrl: (String url) {
                  print(url);
                },
                // This will return the payment loading status
                isLoading: (bool loading) {
                  // print('Load hocche');
                  setState(() {
                    isLoading = loading;
                  });
                },
                // This will return the payment status
                paymentStatus: (String status) {
                  if (status == 'success') {
                    print('SUCCESS hoise vai...');
                    _checkPackageValidity();
                    // showSimpleSnackBar(context, 'লেনদেন সফল!');
                    showSuccessAlertDialog(context,
                        'লেনদেন সফল হয়েছে ও কয়েন সংখ্যা বৃদ্ধি করা হয়েছে!');
                    // OneSignal.shared
                    //     .sendTags({'user_type': 'Premium'}).then((response) {
                    //   print("Successfully sent tags with response: $response");
                    // }).catchError((error) {
                    //   print("Encountered an error sending tags: $error");
                    // });
                    // Future.delayed(
                    //     const Duration(seconds: 1)); // THIS LITLE LINE!!!
                    // Navigator.of(context).pop();
                  } else if (status == 'cancel') {
                    print('Cancel kora hoise...');
                    Fluttertoast.showToast(msg: "লেনদেন বাতিল করা হয়েছে!");
                    // Navigator.of(context).pop();
                  } else if (status == 'fail') {
                    Fluttertoast.showToast(msg: "লেনদেন ব্যর্থ হয়েছে!");
                    // Navigator.of(context).pop();
                  }
                },
                // This will return the payment event with a message
                status: (EventState event, String message) {
                  if (event == EventState.error) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  if (event.index == 0) {
                    _postTempPaymentData();
                    // print('Data posted');
                  }
                },
                // When you use your own url, you must have the keywords:cancel,confirm,fail otherwise the callback function will not work properly
                cancelUrl: ConstanceData.ServerURL + "/api/payment/cancel",
                successUrl: ConstanceData.ServerURL + "/api/payment/confirm",
                failUrl: ConstanceData.ServerURL + "/api/payment/fail",
                // cancelUrl:
                //     "https://api.fantasygeek.xyz/api/payment/cancel", // temporary
                // successUrl:
                //     "https://api.fantasygeek.xyz/api/payment/confirm", // temporary
                // failUrl:
                //     "https://api.fantasygeek.xyz/api/payment/fail", // temporary
                customerEmail:
                    userdata!.email.toString(), // .replaceAll("+88", "")

                customerMobile: userdata!.mobileNumber.toString(),
                customerName: userdata!.name,
                // That is the test signature key. But when you go to the production you must use your own signature key
                signature: "6c032e9baa85e13f74806b789b305991",
                // That is the test storeID. But when you go to the production you must use your own storeID
                storeID: "innovabd",
                transactionAmount: "1", // dynamic hobe
                //The transactionID must be unique for every payment
                transactionID: transactionid,
                description: userdata!.name! +
                    " - " +
                    widget.totalamount +
                    ' কয়েন'
                        " - ৳ " +
                    widget.totalamount,
                // optA: userdata!.mobileNumber
                //     .toString()
                //     .toString(), // user phone number in Aoo, UserID in Web, optA er kaaj nai App e...
                // optB: '1', // widget.totalamount,
                // When the application goes to the producation the isSandbox must be false
                isSandBox: false,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        color: Colors.orange,
                        height: 50,
                        child: const Center(
                          child: Text(
                            "পরিশোধ করুন",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 300,
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  _postTempPaymentData() async {
    var data = {
      'user_id': userdata!.userId.toString(),
      'amount': 1, // widget.totalamount
      'coin': widget.totalcointobuy,
      'trx_id': transactionid,
    };
    // print(data);
    try {
      http.Response response = await http.post(
        Uri.parse(ConstanceData.ServerURL + '/api/payment/temp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (body["success"] == true) {
          print('data dhukse...');
        }
      } else {
        print(response.body);
      }
    } catch (_) {
      print(_);
    }
  }

  _checkPackageValidity() async {
    String serviceURL = ConstanceData.ServerURL +
        '/api/users/check/' +
        userdata!.userId.toString();
    try {
      var response = await http.get(Uri.parse(serviceURL));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (body['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
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
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => new TabScreen()));
          // print(userData);
          // print(usertoken);
          // print(userdata!.toJson());
        } else {
          Fluttertoast.showToast(msg: body['message']);
        }
      } else {
        // print(response.body);
      }
    } catch (_) {
      // print(_);
    }
    // try {
    //   String _softToken = "Rifat.Admin.2022";
    //   String serviceURL = ServerURL +
    //       "/api/checkpackagevalidity/" +
    //       _softToken +
    //       "/" +
    //       userdata.phoneNumber
    //           .toString();
    //   var response = await http.get(Uri.parse(serviceURL));
    //   if (response.statusCode == 200) {
    //     var body = json.decode(response.body);
    //     if (body["success"] == true) {
    //       // print(DateTime.parse(body["package_expiry_date"]));
    //       // print(DateTime.now());
    //       if (DateTime.parse(body["package_expiry_date"])
    //               .compareTo(DateTime.now()) >
    //           0) {
    //         var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    //         var inputDate = inputFormat.parse(body["package_expiry_date"]);

    //         /// outputFormat - convert into format you want to show.
    //         var outputFormat = DateFormat('MMMM dd, yyyy');
    //         var outputDate = outputFormat.format(inputDate);
    //         setState(() {
    //           paymentvalidity = true;
    //           paymentexpirydate = outputDate;
    //         });
    //         // print("Package Valid");
    //         // print(paymentexpirydate);
    //       } else {
    //         setState(() {
    //           // print("Package Invalid");
    //           paymentvalidity = false;
    //         });
    //       }
    //     }
    //   } else {
    //     // print(response.body);
    //   }
    // } catch (_) {
    //   // print(_);
    // }
  }

  showSuccessAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("সফল লেনদেন"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
