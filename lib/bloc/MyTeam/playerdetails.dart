// ignore_for_file: unused_element, camel_case_types, close_sinks, unnecessary_statements

import 'dart:async';
import 'dart:convert';

import '../../constance/constance.dart';
import 'package:http/http.dart' as http;
import '../../models/Team/playerdetails.dart';

enum PlayerDetailsAction { Fetch, FetchAll, FetchTeam }

String baseurl = ConstanceData.ServerURL;

class PlayerDetailsBloc {
  final _playerdetailsstatestreamController =
      StreamController<List<PlayerDetails>>.broadcast();
  StreamSink<List<PlayerDetails>> get _playerdetailssink =>
      _playerdetailsstatestreamController.sink;
  Stream<List<PlayerDetails>> get playerdetailsstream =>
      _playerdetailsstatestreamController.stream;

  final _eventplayerdetailsstreamController =
      StreamController<PlayerDetailsAction>.broadcast();
  StreamSink<PlayerDetailsAction> get eventplayerdetailssink =>
      _eventplayerdetailsstreamController.sink;
  Stream<PlayerDetailsAction> get _eventplayerdetailsstream =>
      _eventplayerdetailsstreamController.stream;

  PlayerDetailsBloc() {
    _eventplayerdetailsstream.listen((event) async {
      if (event == PlayerDetailsAction.Fetch) {
        try {
          // var palyer = await getDetails();
          // _playerdetailssink.add(palyer);
        } on Exception catch (e) {
          _playerdetailssink.addError("Something went wrong");
        }
      }
    });
  }

  Future<PlayerDetails> getDetails(
      String usercontestid, String playerid) async {
    PlayerDetails? p;
    try {
      var response = await http.get(Uri.parse(
          '${ConstanceData.urlPlayerStats}usercontest_id=$usercontestid&player_id=$playerid'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        p = PlayerDetails.fromJson(jsonMap);
        return p;
      }
      return p!;
    } catch (e) {
      return p!;
    }
  }

  void dispose() {
    _eventplayerdetailsstreamController.close();
    _playerdetailsstatestreamController.close();
  }
}
