import 'package:tempalteflutter/models/Context/context.dart';

class UserContestData {
  String? id;
  String? userid;
  String? contestid;
  String? teamid;
  context_list? contest;

  UserContestData(
      {this.teamid, this.id, this.userid, this.contestid, this.contest});
}
