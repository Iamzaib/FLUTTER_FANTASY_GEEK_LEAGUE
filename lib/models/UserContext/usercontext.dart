import 'package:tempalteflutter/models/userData.dart';

class joinusercontext {
  String? userid;
  String? contestid;
  String? teamid;
  String? transactionid;

  joinusercontext(
      {this.userid, this.contestid, this.teamid, this.transactionid});

  Map tomap() {
    Map m = {};
    m["user_id"] = userid;
    m["contest_id"] = contestid;
    m["team_id"] = teamid;
    m["transaction_id"] = transactionid;

    return m;
  }
}
