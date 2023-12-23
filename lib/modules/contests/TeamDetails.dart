import 'package:flutter/material.dart';
import 'package:tempalteflutter/bloc/MyTeam/Myteam.dart';
import 'package:tempalteflutter/bloc/MyTeam/playerpoints.dart';
import 'package:tempalteflutter/models/Team/getteam.dart';
import 'package:tempalteflutter/models/Team/playerpoints.dart';
import 'package:tempalteflutter/models/UserContext/usercontestranking.dart';
import 'package:tempalteflutter/modules/contests/playerdetails.dart';

import '../../constance/themes.dart';

class TeamDetails extends StatefulWidget {
  TeamDetails({Key? key, required this.ucr, this.ucontestid}) : super(key: key);
  UserContextRanking ucr;
  String? ucontestid;
  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  // MyTeamBloc mtb = MyTeamBloc();
  PlayerPointsBloc ppb = PlayerPointsBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
        title: Text(
          'Team Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<PlayerPoints>(
          future: ppb.getDetails(
              widget.ucr.user!.id.toString(), widget.ucontestid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white60,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Player Names",
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 18)),
                                Text("Player Points",
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 18)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    snapshot.data!.team_stats == null
                        ? Center(
                            child: Text("No Data"),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.team_stats!.length,
                            itemBuilder: ((context, index) => Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  PlayerDetailsScreen(
                                                      id: snapshot.data!
                                                          .team_stats![index].id
                                                          .toString(),
                                                      ucr: widget
                                                          .ucr.usercontestid
                                                          .toString())))),
                                      child: ListTile(
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(99))),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(99)),
                                              child: Image.network(
                                                snapshot.data!
                                                    .team_stats![index].image
                                                    .toString(),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          title: Text(snapshot
                                              .data!.team_stats![index].name
                                              .toString()),
                                          trailing: Text(snapshot
                                              .data!.team_stats![index].score
                                              .toString())),
                                    ),
                                    Divider()
                                  ],
                                ))),
                    SizedBox(
                      height: 50,
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
}
