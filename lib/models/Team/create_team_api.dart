class teamApi {
  String? name;
  String? type;
  List<int> key;
  List<int> team_members;

  teamApi({
    this.name,
    this.type,
    required this.key,
    required this.team_members,
  });

  Map tomap() {
    Map m = {};
    m["name"] = name;
    m["type"] = type;
    m["key_members"] = key;
    m["team_members"] = team_members;
    print(m);
    return m;
  }
}
