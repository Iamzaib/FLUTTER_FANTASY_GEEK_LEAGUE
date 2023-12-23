// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tempalteflutter/models/Team/playerpoints.dart';
import '../../bloc/MyTeam/playerpoints.dart';
import '../../constance/constance.dart';
import '../../constance/themes.dart';
import '../contests/playerdetails.dart';

class LiveMatchPlayerRanking extends StatelessWidget {
  LiveMatchPlayerRanking(
      {Key? key, required this.ucontestid, required this.uid})
      : super(key: key);
  String uid;
  String? ucontestid;
  PlayerPointsBloc ppb = PlayerPointsBloc();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, top: 10),
      child: FutureBuilder<PlayerPoints>(
          future: ppb.getDetails(uid.toString(), ucontestid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.team_stats == null
                  ? Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.team_stats!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PlayerDetailsScreen(
                                      id: snapshot.data!.team_stats![index].id
                                          .toString(),
                                      ucr: snapshot.data!.id.toString())))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(99))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(99)),
                                          child: Image.network(
                                            snapshot
                                                .data!.team_stats![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          child: Container(
                                        height: 20,
                                        width: 20,
                                        child: snapshot.data!.team_stats![index]
                                                    .id ==
                                                snapshot.data!.key_members![0]
                                                    .toString()
                                            ? role("C")
                                            : snapshot.data!.team_stats![index]
                                                        .id ==
                                                    snapshot
                                                        .data!.key_members![1]
                                                        .toString()
                                                ? role("VC")
                                                : Text(""),
                                      ))
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.team_stats![index].name
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.team_stats![index].score
                                          .toString(),
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      });
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
        child: Center(
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
