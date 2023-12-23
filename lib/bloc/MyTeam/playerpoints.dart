// ignore_for_file: unused_element, camel_case_types, close_sinks, unnecessary_statements

import 'dart:async';
import 'dart:convert';

import '../../constance/constance.dart';
import 'package:http/http.dart' as http;

import '../../models/Team/playerpoints.dart';

enum PlayerPointsAction { Fetch, FetchAll, FetchTeam }

String baseurl = ConstanceData.ServerURL;

class PlayerPointsBloc {
  final _playerpointsstatestreamController =
      StreamController<List<PlayerPoints>>.broadcast();
  StreamSink<List<PlayerPoints>> get _playerpointssink =>
      _playerpointsstatestreamController.sink;
  Stream<List<PlayerPoints>> get playerpointsstream =>
      _playerpointsstatestreamController.stream;

  final _eventplayerpointsstreamController =
      StreamController<PlayerPointsAction>.broadcast();
  StreamSink<PlayerPointsAction> get eventplayerpointssink =>
      _eventplayerpointsstreamController.sink;
  Stream<PlayerPointsAction> get _eventplayerpointsstream =>
      _eventplayerpointsstreamController.stream;

  PlayerPointsBloc() {
    _eventplayerpointsstream.listen((event) async {
      if (event == PlayerPointsAction.Fetch) {
        try {
          // var palyer = await getDetails();
          // _playerdetailssink.add(palyer);
        } on Exception catch (e) {
          _playerpointssink.addError("Something went wrong");
        }
      }
    });
  }

  Future<PlayerPoints> getDetails(String uid, String usercontestid) async {
    PlayerPoints? p;
    try {
      var response = await http.get(Uri.parse(
          '${ConstanceData.urlPlayerPoints}user_id=$uid&contest_id=$usercontestid'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        jsonMap = jsonMap["data"];
        p = PlayerPoints();
        p.contest = ContestPlayerPoints.fromJson(jsonMap["contest"]);
        p.id = jsonMap["id"];
        p.key_members = jsonMap["key_members"];
        p.ranking = jsonMap["ranking"];
        p.score = jsonMap["score"];
        p.user = UserPlayerPoints.fromJson(jsonMap["user"]);
        List<TeamStatsPlayerPoints> lsttspp = [];
        for (var i in jsonMap["team_stats"]) {
          lsttspp.add(TeamStatsPlayerPoints.fromJson(i));
        }
        p.team_stats = lsttspp;
        return p;
      }
      return p!;
    } catch (e) {
      return p!;
    }
  }

  void dispose() {
    _eventplayerpointsstreamController.close();
    _playerpointsstatestreamController.close();
  }
}
