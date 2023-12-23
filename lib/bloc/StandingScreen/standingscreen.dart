// ignore_for_file: unused_element, camel_case_tclose_sinks, close_sinks

import 'dart:async';
import 'dart:convert';

import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';

import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

import '../../constance/sharedPreferences.dart';
import '../../models/userData.dart';

enum StandingScreenAction { Fetch, LiveFetch, CompleteFetch }

String baseurl = ConstanceData.ServerURL;

class StandingScreenBloc {
  final _standingscreenstatestreamController =
      StreamController<List<matches_list>>.broadcast();
  StreamSink<List<matches_list>> get _standingscreensink =>
      _standingscreenstatestreamController.sink;
  Stream<List<matches_list>> get standingscreenstream =>
      _standingscreenstatestreamController.stream;

  final _eventstandingscreenstreamController =
      StreamController<StandingScreenAction>.broadcast();
  StreamSink<StandingScreenAction> get eventstandingscreensink =>
      _eventstandingscreenstreamController.sink;
  Stream<StandingScreenAction> get _eventstandingscreenstream =>
      _eventstandingscreenstreamController.stream;

  StandingScreenBloc() {
    _eventstandingscreenstream.listen((event) async {
      if (event == StandingScreenAction.Fetch) {
        try {
          var macthes = await getUpcomingStandingScreen();
          _standingscreensink.add(macthes);
        } on Exception catch (e) {
          _standingscreensink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<matches_list>> getUpcomingStandingScreen() async {
    List<matches_list> lst = [];
    try {
      var response =
          await http.get(Uri.parse('${ConstanceData.getUpcomingFixtures}'));
      UserData? user = await MySharedPreferences().getUserData();
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        print(jsonMap['data']);
        for (var i in jsonMap["data"]) {
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

        return lst;
      }
    } catch (e) {
      return lst;
    }
    return lst;
  }
}
