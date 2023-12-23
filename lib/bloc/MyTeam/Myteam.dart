// ignore_for_file: unused_element, camel_case_types, close_sinks, unnecessary_statements

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import 'package:tempalteflutter/models/Team/getteam.dart';
import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

import '../../constance/sharedPreferences.dart';
import '../../models/userData.dart';

enum MyTeamAction { Fetch, FetchAll, FetchTeam }

String baseurl = ConstanceData.ServerURL;

class MyTeamBloc {
  List<int> id = [];
  String? fixtureid;
  List<MyTeam> lstteam = [];
  int? teamkey;
  final _myteamstatestreamController =
      StreamController<List<MyTeam>>.broadcast();
  StreamSink<List<MyTeam>> get _myteamsink => _myteamstatestreamController.sink;
  Stream<List<MyTeam>> get myteamstream => _myteamstatestreamController.stream;

  final _eventmyteamstreamController =
      StreamController<MyTeamAction>.broadcast();
  StreamSink<MyTeamAction> get eventmyteamsink =>
      _eventmyteamstreamController.sink;
  Stream<MyTeamAction> get _eventmyteamstream =>
      _eventmyteamstreamController.stream;

  MyTeamBloc() {
    this.fixtureid;
    _eventmyteamstream.listen((event) async {
      if (event == MyTeamAction.Fetch) {
        try {
          var team = await getMatches(teamkey);
          _myteamsink.add(team);
        } on Exception catch (e) {
          _myteamsink.addError("Something went wrong");
        }
      } else if (event == MyTeamAction.FetchAll) {
        for (var i in id) {
          try {
            var team = await getMatchesByID(i);
            print(team);
            _myteamsink.add(team);
          } on Exception catch (e) {
            _myteamsink.addError("Something went wrong");
          }
        }
      } else if (event == MyTeamAction.FetchTeam) {
        try {
          var team = await getAllTeam(fixtureid!);
          _myteamsink.add(team);
        } on Exception catch (e) {
          _myteamsink.addError("Something went wrong");
        }
      }
    });
  }
  Future<List<MyTeam>> getMatches(int? teamkey) async {
    List<MyTeam> lst = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response =
          await http.get(Uri.parse('${ConstanceData.getSingleTeam}$teamkey'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        MyTeam mt = MyTeam();
        mt.name = jsonMap['name'];
        List<int> lstkey = [];
        for (var i in jsonMap['key_members']) {
          print(i);
          lstkey.add(int.parse(i.toString()));
        }
        mt.key = lstkey;

        List<Player> lstp = [];
        for (var v in jsonMap["team_members"]) {
          Player p = Player();
          p.id = v['id'].toString();
          p.name = v['name'];
          p.pid = v['pid'];

          p.rating = v['rating'] ?? '';

          p.playerposition_id = v['playerposition_id'];
          p.img = v['image'];

          lstp.add(p);
        }

        mt.team_members = lstp;
        lst.add(mt);
      }
    } catch (e) {}
    return lst;
  }

  Future<List<MyTeam>> getMatchesByID(int? teamkey) async {
    print(teamkey);
    try {
      var response =
          await http.get(Uri.parse('${ConstanceData.getSingleTeam}$teamkey'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        MyTeam mt = MyTeam();
        mt.name = jsonMap['name'];
        List<int> lstkey = [];
        for (var i in jsonMap['key_members']) {
          lstkey.add(int.parse(i.toString()));
        }
        mt.key = lstkey;

        List<Player> lstp = [];
        for (var v in jsonMap["team_members"]) {
          Player p = Player();
          p.id = v['id'].toString();
          p.name = v['name'];
          p.pid = v['pid'];

          p.rating = v['rating'] ?? '';

          p.playerposition_id = v['playerposition_id'];
          p.img = v['image'];

          lstp.add(p);
        }

        mt.team_members = lstp;
        lstteam.add(mt);
      }
      return lstteam;
    } catch (e) {}
    return lstteam;
  }

  Future<List<MyTeam>> getAllTeam(String fixtureid) async {
    List<MyTeam> lst = [];
    try {
      UserData? user = await MySharedPreferences().getUserData();
      print(user!.userId);
      print('fxtid $fixtureid');
      var response = await http.get(Uri.parse(
          '${ConstanceData.getAllTeam}user_id=${user.userId}&fixture_id=$fixtureid'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        jsonMap = jsonMap['data'];

        for (var i in jsonMap) {
          MyTeam mt = MyTeam();
          mt.name = i['name'];
          mt.id = i["id"].toString();

          List<int> lstkey = [];
          for (var j in i['key_members']) {
            print(i);
            lstkey.add(int.parse(j.toString()));
          }
          mt.key = lstkey;

          List<Player> lstp = [];
          for (var v in i["team_members"]) {
            Player p = Player();
            p.id = v['id'].toString();
            p.name = v['name'];
            p.pid = v['pid'];

            p.rating = v['rating'] ?? '';

            p.playerposition_id = v['playerposition_id'];
            p.img = v['image'];

            lstp.add(p);
          }

          mt.team_members = lstp;
          lst.add(mt);
        }
        lstteam = lst;
      }
    } catch (e) {
      print(e);
    }
    return lst;
  }

  void dispose() {
    _eventmyteamstreamController.close();
    _myteamstatestreamController.close();
  }
}
