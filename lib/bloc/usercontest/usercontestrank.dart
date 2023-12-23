// ignore_for_file: unused_element, camel_case_types, close_sinks, unnecessary_statements

import 'dart:async';
import 'dart:convert';
import '../../constance/constance.dart';
import 'package:http/http.dart' as http;
import '../../models/Matches_Standing_Screen/mactheslist.dart';
import '../../models/Team/getteam.dart';
import '../../models/UserContext/usercontestranking.dart';

enum UserContextRanking_Action { Fetch }

String baseurl = ConstanceData.ServerURL;

class UserContextRankingBloc {
  String? contxtid;
  List<UserContextRanking> lst = [];
  List<MyTeam> lstteam = [];
  final _usercontextrankingstatestreamController =
      StreamController<List<UserContextRanking>>.broadcast();
  StreamSink<List<UserContextRanking>> get _usercontextrankingsink =>
      _usercontextrankingstatestreamController.sink;
  Stream<List<UserContextRanking>> get usercontextrankingstream =>
      _usercontextrankingstatestreamController.stream;

  final _eventusercontextrankingstreamController =
      StreamController<UserContextRanking_Action>.broadcast();
  StreamSink<UserContextRanking_Action> get eventusercontextrankingsink =>
      _eventusercontextrankingstreamController.sink;
  Stream<UserContextRanking_Action> get _eventusercontextrankingstream =>
      _eventusercontextrankingstreamController.stream;

  UserContextRankingBloc() {
    _eventusercontextrankingstream.listen((event) async {
      if (event == UserContextRanking_Action.Fetch) {
        try {
          print(this.contxtid);
          var macthes = await getUserContextRanking(this.contxtid!);
          _usercontextrankingsink.add(macthes);
        } on Exception catch (e) {
          _usercontextrankingsink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<UserContextRanking>> getUserContextRanking(
      String contxtid) async {
    List<int> lstteamid = [];
    try {
      var response =
          await http.get(Uri.parse('${ConstanceData.getUserContest}$contxtid'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        lst = [];
        lstteam = [];
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        for (var v in jsonMap['data']) {
          UserContextRanking ucd = UserContextRanking();

          ucd.usercontestid = v["usercontest_id"].toString();
          ucd.user = ContestUser.fromMap(v["user"]);
          ucd.score = v['score'];
          ucd.teamid = v["team_id"];
          ucd.ranking = v['ranking'];

          lst.add(ucd);
        }
        // for (int i in lstteamid) {
        //   lstteam = await getMatchesByID(i);
        // }
      }
      // List<MyTeam> templst = [];
      // List<String> templstid = [];
      // for (int i = 0; i < lstteam.length; i++) {
      //   if (!templstid.contains(lstteam[i].id)) {
      //     templst.add(lstteam[i]);
      //     templstid.add(lstteam[i].id!);
      //   }
      // }
      // lstteam = templst;
      lst.sort((b, a) => int.parse(a.score.toString())
          .compareTo(int.parse(b.score.toString())));
      // print(lstteam);
      // List<UserContextRanking> templst = [];

      // for (int i = 0; i < lst.length; i++) {
      //   for(int j=0;j<i;j++){
      //     if(lst[i].)
      //   }
      // }
      return lst;
    } catch (e) {
      print(e);
      return lst;
    }
  }

  void dispose() {
    _usercontextrankingsink.close();
    _eventusercontextrankingstreamController.close();
  }

  Future<List<MyTeam>> getMatchesByID(int? teamkey) async {
    try {
      var response = await http.get(Uri.parse(baseurl + '/api/teams/$teamkey'));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        MyTeam mt = MyTeam();
        mt.name = jsonMap['name'];
        mt.id = jsonMap['id'].toString();
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
    } catch (e) {
      return lstteam;
    }
  }
}
