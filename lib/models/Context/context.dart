// ignore_for_file: non_constant_identifier_names

class context_list {
  String? prizepool;
  String? winner;
  String? entryfee;
  String? entryleft;
  String? entrycount;
  String? firstprice;
  String? entrycapacity;
  List? pricelst;
  String? name;
  String? id;
  String? fixtureid;
  context_list(
      {this.fixtureid,
      this.prizepool,
      this.winner,
      this.entryfee,
      this.entryleft,
      this.entrycount,
      this.firstprice,
      this.pricelst,
      this.name,
      this.id,
      this.entrycapacity});

  Map tomap() {
    Map m = {};
    m["name"] = name;
    m["fixture_id"] = id;
    m["entry_fee"] = entryfee;
    m["winner_count"] = winner;
    m["winner_amount"] = firstprice;
    m["award_amount"] = firstprice;

    m["prize_list"] = pricelst.toString();

    m["total_award_amount"] = prizepool;
    m["entry_capacity"] = entrycapacity;
    print(m);
    return m;
  }
}
