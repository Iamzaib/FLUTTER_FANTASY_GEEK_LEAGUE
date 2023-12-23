class matches_list {
  String? id;
  String? titel;
  String? country1Name;
  String? country1Flag;
  String? country2Name;
  String? country2Flag;
  String? time;
  String? price;
  List<Player>? lstteam1player;
  List<Player>? lstteam2player;
  String? matchstatus;

  matches_list(
      {this.id,
      this.titel,
      this.country1Name,
      this.country2Name,
      this.time,
      this.price,
      this.country1Flag,
      this.country2Flag,
      this.lstteam1player,
      this.lstteam2player,
      this.matchstatus});
}

class Player {
  String? id;
  String? pid;
  String? name;
  String? rating;
  String? img;
  String? playerposition_id;

  Player({
    this.id,
    this.pid,
    this.name,
    this.rating,
    this.img,
    this.playerposition_id,
  });

  factory Player.fromjson(Map<String, dynamic> json) {
    return Player(
        id: json['id'],
        pid: json['pid'],
        name: json['name'],
        rating: json['rating'],
        img: json['image'],
        playerposition_id: json['playerposition_id']);
  }
}
