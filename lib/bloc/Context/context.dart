// ignore_for_file: unused_element, camel_case_types, close_sinks, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:tempalteflutter/bloc/usercontest/usercontestbyfixture.dart';
import 'package:tempalteflutter/models/Context/context.dart';
import 'package:tempalteflutter/models/UserContext/getusercontest.dart';
import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

import '../../constance/sharedPreferences.dart';
import '../../models/userData.dart';

enum Context_Action { Fetch }

String baseurl = ConstanceData.ServerURL;

class ContextBloc {
  List<context_list> lst = [];
  late String id;
  final _contextstatestreamController =
      StreamController<List<context_list>>.broadcast();
  StreamSink<List<context_list>> get _contextsink =>
      _contextstatestreamController.sink;
  Stream<List<context_list>> get contextstream =>
      _contextstatestreamController.stream;

  final _eventcontextstreamController =
      StreamController<Context_Action>.broadcast();
  StreamSink<Context_Action> get eventcontextsink =>
      _eventcontextstreamController.sink;
  Stream<Context_Action> get _eventcontextstream =>
      _eventcontextstreamController.stream;

  ContextBloc() {
    _eventcontextstream.listen((event) async {
      if (event == Context_Action.Fetch) {
        try {
          var macthes = await getContext(id);
          _contextsink.add(macthes);
        } on Exception catch (e) {
          _contextsink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<context_list>> getContext(String id) async {
    lst = [];
    UserData? user = await MySharedPreferences().getUserData();
    UserContextBloc ucb = UserContextBloc();
    List<UserContestData> templstucd =
        await ucb.getUserContext(id, user!.userId.toString());
    try {
      var response =
          await http.get(Uri.parse('${ConstanceData.getContest}=$id'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        print(jsonMap);
        for (var i in jsonMap["data"]) {
          context_list c = context_list();
          c.id = i['id'].toString();
          c.name = i["name"];
          c.prizepool = i["totalPrize"];
          c.firstprice = i["firstPrize"];
          c.entryfee = i["entryFee"];
          c.entrycount = i["entryCount"];
          c.entryleft =
              (int.parse(i["entryCapacity"]) - int.parse(i["entryCount"]))
                  .toString();
          if (i["prizeList"] is String) {
            c.pricelst = json.decode(i["prizeList"]);
          } else {
            c.pricelst = i["prizeList"];
          }

          c.winner = i["winnerCount"];
          c.entrycapacity = i["entryCapacity"];
          if (templstucd.length > 0) {
            UserContestData ucd = UserContestData();
            for (UserContestData i in templstucd) {
              if (i.contest!.id == c.id) {
                ucd = i;
              }
            }

            if (ucd.contest == null) {
              lst.add(c);
            }
          } else {
            lst.add(c);
          }
        }
      }
      print(lst.length);
    } catch (e) {
      print(e);
    }
    return lst;
  }

  void dispose() {
    _contextstatestreamController.close();
    _eventcontextstreamController.close();
  }
}
