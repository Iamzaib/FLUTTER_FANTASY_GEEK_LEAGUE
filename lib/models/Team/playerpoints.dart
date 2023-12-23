// ignore_for_file: non_constant_identifier_names

import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';

class PlayerPoints {
  int? id;
  UserPlayerPoints? user;
  List? key_members;
  String? score, ranking;
  List<TeamStatsPlayerPoints>? team_stats;
  ContestPlayerPoints? contest;
}

class UserPlayerPoints {
  int? id;
  String? name;
  String? image;

  UserPlayerPoints({required this.id, required this.image, required this.name});

  factory UserPlayerPoints.fromJson(Map<String, dynamic> mp) {
    return UserPlayerPoints(id: mp['id'], image: mp["image"], name: mp["name"]);
  }
}

class TeamStatsPlayerPoints {
  String? id, name, image, playerposition_id;
  int? score;

  TeamStatsPlayerPoints(
      {required this.id,
      required this.image,
      required this.name,
      required this.playerposition_id,
      required this.score});

  factory TeamStatsPlayerPoints.fromJson(Map<String, dynamic> mp) {
    return TeamStatsPlayerPoints(
        id: mp["id"],
        image: mp["image"],
        name: mp["name"],
        playerposition_id: mp["playerposition_id"],
        score: mp["score"]);
  }
}

class ContestPlayerPoints {
  int? id;
  String? match_id,
      name,
      totalPrize,
      entryFree,
      entryCapacity,
      entryCount,
      firstPrize,
      winnerCount;

  List? prizeList;

  ContestPlayerPoints(
      {required this.entryCapacity,
      required this.entryCount,
      required this.entryFree,
      required this.firstPrize,
      required this.id,
      required this.match_id,
      required this.name,
      required this.prizeList,
      required this.totalPrize,
      required this.winnerCount});

  factory ContestPlayerPoints.fromJson(Map<String, dynamic> mp) {
    return ContestPlayerPoints(
        entryCapacity: mp["entryCapacity"],
        entryCount: mp["entryCount"],
        entryFree: mp["entryFree"],
        firstPrize: mp["firstPrize"],
        id: mp["id"],
        match_id: mp["match_id"],
        name: mp["name"],
        prizeList: mp["prizeList"],
        totalPrize: mp["totalPrize"],
        winnerCount: mp["winnerCount"]);
  }
}
