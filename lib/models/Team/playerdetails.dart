// ignore_for_file: non_constant_identifier_names, camel_case_types

class PlayerDetails {
  String? name, image, rating, playerposition_id, bowlingstyle, battingstyle;
  bool? is_captain, is_vicecaptain;
  int? score;
  Player_Stats? player_stats;
  Player_Stats? stat_points;

  PlayerDetails(
      {required this.battingstyle,
      required this.image,
      required this.bowlingstyle,
      required this.is_captain,
      required this.is_vicecaptain,
      required this.name,
      required this.player_stats,
      required this.playerposition_id,
      required this.rating,
      required this.score,
      required this.stat_points});

  factory PlayerDetails.fromJson(Map<String, dynamic> mp) {
    return PlayerDetails(
        battingstyle: mp["battingstyle"],
        bowlingstyle: mp["bowlingstyle"],
        image: mp['image'],
        is_captain: mp["is_captain"],
        is_vicecaptain: mp["is_vicecaptain"],
        name: mp["name"],
        player_stats: Player_Stats.fromJson(mp["player_stats"]),
        playerposition_id: mp["playerposition_id"],
        rating: mp["rating"],
        score: mp["score"],
        stat_points: Player_Stats.fromJson(mp["stat_points"]));
  }
}

class Player_Stats {
  String econ_rate;
  int? duck,
      runs,
      six_x,
      four_x,
      runs_50,
      run_outs,
      runs_100,
      wickets_1,
      wickets_3,
      wickets_4,
      wickets_5,
      strike_rate,
      maiden_overs,
      catches_stumpings,
      is_in_starting_xi;

  Player_Stats(
      {required this.catches_stumpings,
      required this.duck,
      required this.econ_rate,
      required this.four_x,
      required this.is_in_starting_xi,
      required this.maiden_overs,
      required this.run_outs,
      required this.runs,
      required this.runs_100,
      required this.runs_50,
      required this.six_x,
      required this.strike_rate,
      required this.wickets_1,
      required this.wickets_3,
      required this.wickets_4,
      required this.wickets_5});

  factory Player_Stats.fromJson(Map<String, dynamic> mp) {
    return Player_Stats(
        catches_stumpings: mp["catches_stumpings"],
        duck: mp["duck"],
        econ_rate: mp["econ_rate"].toString(),
        four_x: mp["four_x"],
        is_in_starting_xi: mp["is_in_starting_xi"],
        maiden_overs: mp["maiden_overs"],
        run_outs: mp["run_outs"],
        runs: mp["runs"],
        runs_100: mp["runs_100"],
        runs_50: mp["runs_50"],
        six_x: mp["six_x"],
        strike_rate: mp["strike_rate"],
        wickets_1: mp["wickets_1"],
        wickets_3: mp["wickets_3"],
        wickets_4: mp["wickets_4"],
        wickets_5: mp["wickets_5"]);
  }
}
