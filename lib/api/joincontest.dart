// ignore_for_file: camel_case_types, unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constance/constance.dart';

class joincontest {
  String baseurl = ConstanceData.ServerURL;
  Future post(Map data) async {
    var response =
        await http.post(Uri.parse('${ConstanceData.joinContest}'), body: data);
    print(response.statusCode);
    if (response.statusCode == 201) {
      var result = json.decode(response.body);
      return "okay";
    } else {
      return "Something went wrong";
    }
  }
}
