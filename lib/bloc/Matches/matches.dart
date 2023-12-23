// ignore_for_file: unused_element, camel_case_types, close_sinks

import 'dart:async';
import 'dart:convert';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

enum MatchesAction { Fetch }

String baseurl = ConstanceData.ServerURL;

class MatchesBloc {
  final _matchesstatestreamController =
      StreamController<List<matches_list>>.broadcast();
  StreamSink<List<matches_list>> get _matchsink =>
      _matchesstatestreamController.sink;
  Stream<List<matches_list>> get matchstream =>
      _matchesstatestreamController.stream;

  final _eventmatchestreamController =
      StreamController<MatchesAction>.broadcast();
  StreamSink<MatchesAction> get eventmatchsink =>
      _eventmatchestreamController.sink;
  Stream<MatchesAction> get _eventmatchstream =>
      _eventmatchestreamController.stream;

  MatchesBloc() {
    _eventmatchstream.listen((event) async {
      if (event == MatchesAction.Fetch) {
        try {
          var macthes = await getMatches();
          _matchsink.add(macthes);
        } on Exception catch (e) {
          _matchsink.addError("Something went wrong");
        }
      }
    });
  }
  Future<List<matches_list>> getMatches() async {
    List<matches_list> lst = [];
    try {
      var response = await http.get(Uri.parse('${ConstanceData.getMatches}'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        for (var i in jsonMap["data"]) {
          matches_list m = matches_list(
              lstteam1player: [], lstteam2player: [], matchstatus: i["status"]);

          m.country1Name = i["team1"]["name"];
          m.country2Name = i["team2"]["name"];
          m.country1Flag = i["team1"]["image"];
          m.country2Flag = i["team2"]["image"];
          m.time = i["starting_time"];
          m.titel = i["name"];

          m.id = i["id"].toString();

          m.price = "৳2 Lakhs";

          for (var v in i["team1"]["team_members"]) {
            Player p = Player();
            p.id = v['id'].toString();
            p.name = v['name'];
            p.pid = v['pid'];

            p.rating = v['rating'] ?? '';
            print('rating${p.rating}');
            p.playerposition_id = v['playerposition_id'];
            p.img = v['image'];
            m.lstteam1player!.add(p);
          }
          for (var v in i['team2']['team_members']) {
            print('enter');
            Player p = Player();
            p.id = v['id'].toString();
            p.name = v['name'];
            p.pid = v['pid'];
            print('done');
            p.rating = v['rating'] ?? '';
            p.img = v['image'];
            p.playerposition_id = v['playerposition_id'];

            m.lstteam2player!.add(p);
          }
          m.price = "৳2 Lakhs";
          lst.add(m);
        }
      }
    } catch (e) {}
    return lst;
  }

  void dispose() {
    _eventmatchestreamController.close();
    _matchesstatestreamController.close();
  }
}
