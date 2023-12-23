// ignore_for_file: close_sinks

import 'dart:async';
import 'dart:convert';

import 'package:tempalteflutter/bloc/StandingScreen/standingscreen.dart';
import 'package:tempalteflutter/constance/constance.dart';

import '../../constance/sharedPreferences.dart';
import '../../models/Matches_Standing_Screen/mactheslist.dart';
import '../../models/userData.dart';

import 'package:http/http.dart' as http;

class LiveStandingScreenBloc {
  final _livestandingscreenstatestreamController =
      StreamController<List<matches_list>>.broadcast();
  StreamSink<List<matches_list>> get _livestandingscreensink =>
      _livestandingscreenstatestreamController.sink;
  Stream<List<matches_list>> get livestandingscreenstream =>
      _livestandingscreenstatestreamController.stream;

  final _eventlivestandingscreenstreamController =
      StreamController<StandingScreenAction>.broadcast();
  StreamSink<StandingScreenAction> get eventlivestandingscreensink =>
      _eventlivestandingscreenstreamController.sink;
  Stream<StandingScreenAction> get _eventlivestandingscreenstream =>
      _eventlivestandingscreenstreamController.stream;

  LiveStandingScreenBloc() {
    _eventlivestandingscreenstream.listen((event) async {
      if (event == StandingScreenAction.LiveFetch) {
        try {
          var macthes = await getLiveStandingScreen();
          _livestandingscreensink.add(macthes);
        } on Exception catch (e) {
          _livestandingscreensink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<matches_list>> getLiveStandingScreen() async {
    List<matches_list> lst = [];
    UserData? userData = await MySharedPreferences().getUserData();
    print(userData!.userId.toString());
    try {
      var response = await http.get(Uri.parse(
          '${ConstanceData.getStandingScreens}${userData.userId.toString()}/fixtures/running'));
      UserData? user = await MySharedPreferences().getUserData();
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        for (var i in jsonMap) {
          matches_list m = matches_list(
              lstteam1player: [], lstteam2player: [], matchstatus: i["status"]);
          m.id = i["id"].toString();
          m.country1Name = i["team1"]["name"];
          m.country2Name = i["team2"]["name"];
          m.country1Flag = i["team1"]["image"];
          m.country2Flag = i["team2"]["image"];
          m.time = i["starting_time"];
          m.titel = i["name"];
          m.price = "৳2 Lakhs";
          for (var v in i['team1']['team_members']) {
            Player p = Player(
                img: v['image'],
                id: v['id'].toString(),
                name: v['name'],
                pid: v['pid'],
                rating: v['rating'] ?? 0.toString(),
                playerposition_id: v['playerposition_id']);
            m.lstteam1player!.add(p);
          }
          for (var v in i['team2']['team_members']) {
            Player p = Player(
                img: v['image'],
                id: v['id'].toString(),
                name: v['name'],
                pid: v['pid'],
                rating: v['rating'] ?? 0.toString(),
                playerposition_id: v['playerposition_id']);
            m.lstteam2player!.add(p);
          }
          var response = await http.get(Uri.parse(
              '${ConstanceData.ServerURL}/api/user/${user!.userId}/fixture/${m.id}/usercontests'));
          if (response.statusCode == 200) {
            List templst = jsonDecode(response.body)["data"];
            if (templst.isNotEmpty) {
              lst.add(m);
            }
          }
        }
      }
    } catch (e) {}
    return lst;
  }
}
