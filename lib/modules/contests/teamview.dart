import 'package:flutter/material.dart';
import 'package:tempalteflutter/bloc/MyTeam/Myteam.dart';
import 'package:tempalteflutter/models/Team/getteam.dart';
import 'package:tempalteflutter/models/UserContext/usercontestranking.dart';
import 'package:tempalteflutter/modules/contests/playerdetails.dart';

import '../../constance/themes.dart';

class TeamView extends StatefulWidget {
  TeamView({Key? key, required this.mt}) : super(key: key);
  MyTeam mt;
  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Team Name:",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 18)),
                        Text("   ${widget.mt.name}",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 18))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.mt.team_members!.length,
                  itemBuilder: ((context, index) => Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(99))),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(99)),
                                child: Image.network(
                                  widget.mt.team_members![index].img.toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            title: Text(
                                widget.mt.team_members![index].name.toString()),
                            trailing: widget.mt.team_members![index]
                                        .playerposition_id
                                        .toString() ==
                                    "1"
                                ? Text("Bat")
                                : widget.mt.team_members![index]
                                            .playerposition_id
                                            .toString() ==
                                        "2"
                                    ? Text("Bowler")
                                    : widget.mt.team_members![index]
                                                .playerposition_id
                                                .toString() ==
                                            "3"
                                        ? Text("WK")
                                        : Text("AR"),
                          ),
                          Divider()
                        ],
                      ))),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
