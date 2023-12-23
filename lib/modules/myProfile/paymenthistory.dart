import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

class PaymentHistory extends StatefulWidget {
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('পেমেন্ট তালিকা'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Close',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // flexibleSpace: appBarStyle(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                mypaymentlist.isEmpty
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: mypaymentlist.length,
                        itemBuilder: (context, index) {
                          return expansionTile(mypaymentlist[index]);
                        },
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
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

  void _getPaymentList() async {
    try {
      String serviceURL = ConstanceData.ServerURL +
          "/api/payment/list/" +
          userdata!.userId.toString();
      var response = await http.get(Uri.parse(serviceURL));

      if (response.statusCode == 200) {
        // print(response.body);
        var body = json.decode(response.body);
        if (body["success"] == true) {
          // print("E PORJONTO");
          var datalist = body["payments"];
          setState(() {
            mypaymentlist = [];
            for (var i in datalist) {
              mypaymentlist.add(i);
            }
          });
          print(mypaymentlist.length);
          setState(() {
            isLoading = false;
          });
        } else {}
      } else {
        // print(response);
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

  Widget expansionTile(payment) {
    var datettt = DateFormat('EEE, d MMMM, yyyy, hh:mm a')
        .format(DateTime.parse(payment['created_at']).toLocal());
    print(payment['created_at']);

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ExpansionTile(
            title: Text('+ ৳' + payment['amount']),
            subtitle: Text(datettt.toString()),
            children: <Widget>[
              ListTile(
                  title: Text(
                'Date: ' +
                    datettt.toString() +
                    '\nAmount: ৳' +
                    payment['amount'] +
                    '\nPayment Method: ' +
                    payment['card_type'] +
                    '\nTransaction ID: ' +
                    payment['trx_id'] +
                    '\nCoin Added: ' +
                    payment['coin'],
                textAlign: TextAlign.justify,
              )),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
