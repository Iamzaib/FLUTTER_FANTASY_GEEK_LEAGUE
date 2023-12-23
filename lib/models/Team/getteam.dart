import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';

class MyTeam {
  String? name;
  String? id;
  List<int>? key;
  List<Player>? team_members;

  MyTeam({this.name, this.key, this.team_members, this.id});

  Map tomap() {
    Map m = {};
    m["name"] = name;
    m["key_members"] = key;
    m["team_members"] = team_members;
    m["id"] = id;
    print(m);
    return m;
  }
}
