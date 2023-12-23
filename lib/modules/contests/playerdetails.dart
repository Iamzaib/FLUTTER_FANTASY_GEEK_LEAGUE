// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tempalteflutter/bloc/MyTeam/playerdetails.dart';
import '../../constance/themes.dart';
import '../../models/Team/playerdetails.dart';
import '../../models/UserContext/usercontestranking.dart';

class PlayerDetailsScreen extends StatefulWidget {
  PlayerDetailsScreen({Key? key, required this.id, required this.ucr})
      : super(key: key);
  String id;
  String ucr;
  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  PlayerDetailsBloc pdb = PlayerDetailsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
        title: Text(
          'Player Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<PlayerDetails>(
          future: pdb.getDetails(widget.ucr.toString(), widget.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.black)),
                      child: Wrap(direction: Axis.horizontal, children: [
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(99)),
                                    child: Image(
                                        image: NetworkImage(
                                            snapshot.data!.image.toString())),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: snapshot.data!.is_captain == true
                                        ? role("C")
                                        : snapshot.data!.is_vicecaptain == true
                                            ? role("VC")
                                            : Text(""))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Container(
                              width: 120,
                              child: Text(snapshot.data!.name.toString(),
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 18)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            snapshot.data!.playerposition_id.toString() == "1"
                                ? Text("BATSMAN",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    ))
                                : snapshot.data!.playerposition_id.toString() ==
                                        "2"
                                    ? Text("BOWLER",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AllCoustomTheme.getThemeData()
                                              .primaryColor,
                                        ))
                                    : snapshot.data!.playerposition_id
                                                .toString() ==
                                            "3"
                                        ? Text("KEEPER",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  AllCoustomTheme.getThemeData()
                                                      .primaryColor,
                                            ))
                                        : Text(
                                            "ALL ROUNDER",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  AllCoustomTheme.getThemeData()
                                                      .primaryColor,
                                            ),
                                          ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                            ),
                            Text(
                              "Total Points",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              snapshot.data!.score.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    DataTable(
                      columns: [
                        DataColumn(
                            label: Text('Events',
                                style: TextStyle(
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Score',
                                style: TextStyle(
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Earned Points',
                                style: TextStyle(
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Playing_xi'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.is_in_starting_xi
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.is_in_starting_xi
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(
                                  Container(width: 55, child: Text('Runs'))),
                              DataCell(Text(snapshot.data!.player_stats!.runs
                                  .toString())),
                              DataCell(Text(
                                  snapshot.data!.stat_points!.runs.toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(
                                  Container(width: 55, child: Text('4\'s'))),
                              DataCell(Text(snapshot.data!.player_stats!.four_x
                                  .toString())),
                              DataCell(Text(snapshot.data!.stat_points!.four_x
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(
                                  Container(width: 55, child: Text('6\'s'))),
                              DataCell(Text(snapshot.data!.player_stats!.six_x
                                  .toString())),
                              DataCell(Text(snapshot.data!.stat_points!.six_x
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Strike Rate'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.strike_rate
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.strike_rate
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Wickets_1'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.wickets_1
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.wickets_1
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Wickets_3'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.wickets_3
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.wickets_3
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Wickets_4'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.wickets_4
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.wickets_4
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Wickets_5'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.wickets_5
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.wickets_5
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Maiden Overs'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.maiden_overs
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.maiden_overs
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Econ. Rate'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.econ_rate
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.econ_rate
                                  .toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Run Outs'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.run_outs
                                  .toString())),
                              DataCell(Text(
                                  snapshot.data!.stat_points!.runs.toString())),
                            ]),
                        DataRow(
                            color: MaterialStateProperty.all(Colors.grey[300]),
                            cells: [
                              DataCell(Container(
                                  width: 55, child: Text('Catches_Stumping'))),
                              DataCell(Text(snapshot
                                  .data!.player_stats!.catches_stumpings
                                  .toString())),
                              DataCell(Text(snapshot
                                  .data!.stat_points!.catches_stumpings
                                  .toString())),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            } else {
              return Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              );
            }
          }),
    );
  }

  Container role(String role) {
    return Container(
        decoration: BoxDecoration(
            color: AllCoustomTheme.getThemeData().primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ));
  }
}
