// ignore_for_file: unused_element, camel_case_types, close_sinks

import 'dart:async';
import 'dart:convert';
import 'package:tempalteflutter/bloc/MyTeam/Myteam.dart';
import 'package:tempalteflutter/models/Context/context.dart';
import 'package:tempalteflutter/models/UserContext/getusercontest.dart';
import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

import '../../constance/sharedPreferences.dart';
import '../../models/userData.dart';

enum UserContext_Action { Fetch, FetchTeam }

String baseurl = ConstanceData.ServerURL;

class UserContextBloc {
  String? fxtid, userid;
  MyTeamBloc? mtb;
  List<UserContestData> lstucd = [];
  final _usercontextstatestreamController =
      StreamController<List<UserContestData>>.broadcast();
  StreamSink<List<UserContestData>> get _usercontextsink =>
      _usercontextstatestreamController.sink;
  Stream<List<UserContestData>> get usercontextstream =>
      _usercontextstatestreamController.stream;

  final _eventusercontextstreamController =
      StreamController<UserContext_Action>.broadcast();
  StreamSink<UserContext_Action> get eventusercontextsink =>
      _eventusercontextstreamController.sink;
  Stream<UserContext_Action> get _eventusercontextstream =>
      _eventusercontextstreamController.stream;

  UserContextBloc() {
    this.fxtid;
    this.userid;
    this.lstucd;
    _eventusercontextstream.listen((event) async {
      if (event == UserContext_Action.Fetch) {
        try {
          UserData? user = await MySharedPreferences().getUserData();
          this.userid = user!.userId;
          print(userid);
          print('fxtid $fxtid');
          var macthes = await getUserContext(this.fxtid!, this.userid!);
          _usercontextsink.add(macthes);
        } on Exception catch (e) {
          _usercontextsink.addError("Something went wrong");
        }
      }
      if (event == UserContext_Action.FetchTeam) {
        try {
          UserData? user = await MySharedPreferences().getUserData();
          this.userid = user!.userId;
          var macthes = await getTeam(this.fxtid!, this.userid!, this.mtb!);
          _usercontextsink.add(macthes);
        } on Exception catch (e) {
          _usercontextsink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<UserContestData>> getUserContext(
      String fxtid, String userid) async {
    List<UserContestData> lst = [];
    lstucd = [];
    try {
      print(userid);
      var response = await http.get(Uri.parse(
          '${ConstanceData.getUserContestbyFixtureId}$userid/fixture/$fxtid/usercontests'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        for (var v in jsonMap['data']) {
          UserContestData ucd = UserContestData();
          ucd.id = v['id'].toString();

          ucd.contestid = v['contest_id'];
          ucd.userid = v['user_id'];
          ucd.teamid = v['team_id'];
          print(v['contest']);

          context_list c = context_list();
          c.id = v['contest']['id'].toString();

          c.fixtureid = v['contest']['fixture_id'];
          c.name = v['contest']["name"];
          c.prizepool = v['contest']["totalPrize"];
          c.firstprice = v['contest']["firstPrize"];
          c.entryfee = v['contest']["entryFee"];
          c.entrycount = v['contest']["entryCount"];
          c.entryleft = (int.parse(v['contest']["entryCapacity"]) -
                  int.parse(v['contest']["entryCount"]))
              .toString();
          if (v['contest']["prizeList"] is String) {
            c.pricelst = json.decode(v['contest']["prizeList"]);
          } else {
            c.pricelst = v['contest']["prizeList"];
          }

          c.winner = v['contest']["winnerCount"];
          c.entrycapacity = v['contest']["entryCapacity"];
          ucd.contest = c;
          lstucd.add(ucd);
          lst.add(ucd);
        }
      }
      print(lst.length);
      return lst;
    } catch (e) {
      print(e);
      return lst;
    }
  }

  Future<List<UserContestData>> getTeam(
      String fxtid, String userid, MyTeamBloc mtb) async {
    List<UserContestData> lst = [];
    mtb.lstteam = [];
    try {
      print(userid);
      var response = await http.get(Uri.parse(
          '${ConstanceData.getUserContestbyFixtureId}$userid/fixture/$fxtid/usercontests'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        for (var v in jsonMap['data']) {
          UserContestData ucd = UserContestData();
          ucd.id = v['id'].toString();

          ucd.contestid = v['contest_id'];
          ucd.userid = v['user_id'];
          ucd.teamid = v['team_id'];
          print(v['contest']);

          context_list c = context_list();
          c.id = v['contest']['id'].toString();
          c.fixtureid = v['contest']['fixture_id'];
          c.name = v['contest']["name"];
          c.prizepool = v['contest']["totalPrize"];
          c.firstprice = v['contest']["firstPrize"];
          c.entryfee = v['contest']["entryFee"];
          c.entrycount = v['contest']["entryCount"];
          c.entryleft = (int.parse(v['contest']["entryCapacity"]) -
                  int.parse(v['contest']["entryCount"]))
              .toString();
          if (v['contest']["prizeList"] is String) {
            c.pricelst = json.decode(v['contest']["prizeList"]);
          } else {
            c.pricelst = v['contest']["prizeList"];
          }

          c.winner = v['contest']["winnerCount"];
          c.entrycapacity = v['contest']["entryCapacity"];
          ucd.contest = c;

          mtb.id.add(int.parse(ucd.teamid.toString()));

          lst.add(ucd);
        }
      }
      // mtb.eventmyteamsink.add(MyTeamAction.FetchAll);
      print(lst.length);
      return lst;
    } catch (e) {
      return lst;
    }
  }

  void dispose() {
    _usercontextstatestreamController.close();
    _eventusercontextstreamController.close();
  }
}
