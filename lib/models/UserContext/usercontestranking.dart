// ignore_for_file: non_constant_identifier_names

class UserContextRanking {
  String? usercontestid;
  ContestUser? user;
  String? teamid;

  String? score;
  String? ranking;

  UserContextRanking({
    this.usercontestid,
    this.teamid,
    this.user,
    this.score,
    this.ranking,
  });
}

class ContestUser {
  int? id;
  String? name;
  String? image;

  ContestUser({required this.id, required this.name, required this.image});

  factory ContestUser.fromMap(Map<String, dynamic> mp) {
    return ContestUser(id: mp["id"], name: mp["name"], image: mp["image"]);
  }
}

class TeamStats {
  String? id;
  PlayerStats? Stats;
  TeamStats({required this.id, required this.Stats});
}

class PlayerStats {
  int? duck,
      runs,
      six_x,
      four_x,
      runs_50,
      run_outs,
      runs_100,
      econ_rate,
      wickets_1,
      wickets_3,
      wickets_4,
      wickets_5,
      strike_rate,
      maiden_overs,
      catches_stumpings,
      is_in_starting_xi;
  PlayerStats(
      {required this.duck,
      required this.six_x,
      required this.four_x,
      required this.run_outs,
      required this.runs_50,
      required this.runs_100,
      required this.runs,
      required this.catches_stumpings,
      required this.econ_rate,
      required this.is_in_starting_xi,
      required this.maiden_overs,
      required this.strike_rate,
      required this.wickets_1,
      required this.wickets_3,
      required this.wickets_4,
      required this.wickets_5});

  factory PlayerStats.fromJson(Map<String, dynamic> mp) {
    return PlayerStats(
        duck: mp['duck'],
        six_x: mp['six_x'],
        four_x: mp['four_x'],
        run_outs: mp['run_outs'],
        runs_50: mp['runs_50'],
        runs_100: mp['runs_100'],
        runs: mp['runs'],
        catches_stumpings: mp['catches_stumpings'],
        econ_rate: mp['econ_rate'],
        is_in_starting_xi: mp['is_in_starting_xi'],
        maiden_overs: mp['maiden_overs'],
        strike_rate: mp['strike_rate'],
        wickets_1: mp['wickets_1'],
        wickets_3: mp['wickets_3'],
        wickets_4: mp['wickets_4'],
        wickets_5: mp['wickets_5']);
  }
}
