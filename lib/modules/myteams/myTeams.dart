// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tempalteflutter/api/apiProvider.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import 'package:tempalteflutter/models/scheduleResponseData.dart';
import 'package:tempalteflutter/models/squadsResponseData.dart';
import 'package:tempalteflutter/models/teamResponseData.dart' as teamData;
import 'package:tempalteflutter/models/teamResponseData.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/modules/createTeam/createTeamScreen.dart';
import 'package:tempalteflutter/modules/createTeam/teamPreview.dart';

import 'package:tempalteflutter/utils/avatarImage.dart';

class MyTeamsScreen extends StatefulWidget {
  List<Players> wkList;
  List<Players> batList;
  List<Players> arList;
  List<Players> bowlList;
  List<Players> allPlayesList;
  matches_list mlst;
  Players captain;
  Players vcaptain;
  String? fixtureid;
  MyTeamsScreen(
      {required this.wkList,
      required this.batList,
      required this.bowlList,
      required this.arList,
      required this.allPlayesList,
      required this.captain,
      required this.mlst,
      required this.fixtureid,
      required this.vcaptain});
  @override
  _MyTeamsScreenState createState() => _MyTeamsScreenState();
}

class _MyTeamsScreenState extends State<MyTeamsScreen> {
  List<teamData.TeamData> teamList = <teamData.TeamData>[];
  bool isProsses = false;

  @override
  void initState() {
    getTeamList();
    super.initState();
  }

  Future getTeamList() async {
    setState(() {
      teamList.clear();
      isProsses = true;
    });
    var bat = '';
    var bowl = '';
    var ar = '';

    widget.batList.forEach((item) {
      bat += '${item.title},';
    });
    widget.bowlList.forEach((item) {
      bowl += '${item.title},';
    });
    widget.arList.forEach((item) {
      ar += '${item.title},';
    });
    print(bat);
    var team = GetTeamResponseData.fromJson({
      "team_data": {
        "team_id": "293",
        "team_name": "Oliver Smith(T2)",
        "captun": widget.captain.title,
        "wise_captun": widget.vcaptain.title,
        "wicket_keeper": widget.wkList[0].title,
        "bowler": bowl,
        "bastman": bat,
        "all_rounder": ar,
        "user_id": "5",
        "created_time": DateTime.now().toString(),
        "updated_time": "0000-00-00 00:00:00",
        "is_delete": "0",
        "match_key": "38529",
        "competition_id": "111320"
      }
    });
    teamList = team.teamData!;
    print(teamList);

    setState(() {
      isProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AllCoustomTheme.getThemeData().primaryColor,
            AllCoustomTheme.getThemeData().primaryColor,
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Scaffold(
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          color: AllCoustomTheme.getThemeData().primaryColor,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: AppBar().preferredSize.height,
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: AppBar().preferredSize.height,
                                          height: AppBar().preferredSize.height,
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'My Teams',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: AppBar().preferredSize.height,
                                    )
                                  ],
                                ),
                              ),
                              MatchHadder(
                                titel: widget.mlst.titel.toString(),
                                country1Name: widget.mlst.country1Name,
                                country2Name: widget.mlst.country2Name,
                                country1Flag: widget.mlst.country1Flag,
                                country2Flag: widget.mlst.country2Flag,
                                price: "৳2 Lakhs",
                                time: widget.mlst.time,
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: contestsListData(),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: Container(
                        height: 60,
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 20),
                        child: Opacity(
                          opacity: teamList == null ? 0.2 : 1.0,
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              borderRadius: new BorderRadius.circular(4.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0, 1),
                                    blurRadius: 5.0),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: new BorderRadius.circular(4.0),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateTeamScreen(
                                        playerlst: widget.mlst,
                                        fixtureid: widget.fixtureid,
                                        isupdate: false,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  setState(() {
                                    getTeamList();
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'CREATE TEAM',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contestsListData() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 80),
      itemCount: teamList.length,
      itemBuilder: (context, index) {
        return CreatedTeamListView(
          index: index,
          team: teamList[index],
          copyCallBack: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTeamScreen(
                  createdTeamData: teamList[index],
                  createTeamtype: CreateTeamType.copyTeam,
                  fixtureid: widget.fixtureid,
                  isupdate: false,
                ),
                fullscreenDialog: true,
              ),
            );
            setState(() {
              getTeamList();
            });
          },
          editCallBack: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTeamScreen(
                  createdTeamData: teamList[index],
                  createTeamtype: CreateTeamType.editTeam,
                  fixtureid: widget.fixtureid,
                  isupdate: false,
                ),
                fullscreenDialog: true,
              ),
            );
            setState(() {
              getTeamList();
            });
          },
          shareCallBack: () {},
          allViewClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamPreviewScreen(
                  createdTeamData: teamList[index],
                  createTeamPreviewType: CreateTeamPreviewType.created,
                  editCallback: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTeamScreen(
                          createdTeamData: teamList[index],
                          createTeamtype: CreateTeamType.editTeam,
                          fixtureid: widget.fixtureid,
                          isupdate: false,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    setState(() {
                      getTeamList();
                    });
                  },
                  shreCallback: () {},
                ),
                fullscreenDialog: true,
              ),
            );
          },
          mlst: widget.mlst,
        );
      },
    );
  }
}

class CreatedTeamListView extends StatefulWidget {
  final VoidCallback? copyCallBack;
  final VoidCallback? editCallBack;
  final VoidCallback? shareCallBack;
  final VoidCallback? allViewClick;

  final teamData.TeamData? team;
  final int? index;
  matches_list mlst;
  final ShedualData? shedualData;
  CreatedTeamListView({
    Key? key,
    required this.mlst,
    this.team,
    this.index,
    this.shedualData,
    this.copyCallBack,
    this.editCallBack,
    this.shareCallBack,
    this.allViewClick,
  }) : super(key: key);
  @override
  _CreatedTeamListViewState createState() => _CreatedTeamListViewState();
}

class _CreatedTeamListViewState extends State<CreatedTeamListView> {
  var wkcount = 0;
  var batcount = 0;
  var allcount = 0;
  var bowlcount = 0;
  var teamA = 0;
  var teamB = 0;

  List<Players> players = <Players>[];
  Players captun = new Players();
  Players wcaptun = new Players();

  @override
  void initState() {
    batcount = widget.team!.bastman!.split(',').length;
    allcount = widget.team!.allRounder!.split(',').length;
    bowlcount = widget.team!.bowler!.split(',').length;

    super.initState();
    getTeamDeatil();
  }

  Future getTeamDeatil() async {
    SquadsResponseData data = await ApiProvider().getTeamDataa(widget.mlst);
    if (data.success == 1 && data.playerList!.length > 0) {
      players = data.playerList!;

      players.forEach((p) {
        if (p.title == widget.team!.captun) {
          captun = p;
          captun.isC = true;
        }
        if (p.title == widget.team!.wiseCaptun) {
          wcaptun = p;
          wcaptun.isVC = true;
        }
        if (isMach(p.title!)) {
          if (widget.mlst.country1Name!.toLowerCase() ==
              p.teamName!.toLowerCase()) {
            teamA += 1;
          }
          if (widget.mlst.country2Name!.toLowerCase() ==
              p.teamName!.toLowerCase()) {
            teamB += 1;
          }
        }
      });
    }
    setState(() {});
  }

  bool isMach(String name) {
    bool isMach = false;
    var allplayername = <String>[];
    allplayername.addAll(widget.team!.bastman!.split(','));
    allplayername.addAll(widget.team!.allRounder!.split(','));
    allplayername.addAll(widget.team!.bowler!.split(','));
    allplayername.add(widget.team!.wicketKeeper!);
    allplayername.forEach((pName) {
      if (pName == name) {
        isMach = true;
        return;
      }
    });
    return isMach;
  }

  @override
  Widget build(BuildContext context) {
    return widget.index == 0 && players.length == 0
        ? Container(
            height: 2,
            child: LinearProgressIndicator(),
          )
        : players.length > 0
            ? InkWell(
                onTap: () {
                  widget.allViewClick!();
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: <Widget>[
                          headers1(),
                          headers2(),
                          headers3(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ),
              )
            : SizedBox();
  }

  Widget headers1() {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              'My Team (T1)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ConstanceData.SIZE_TITLE16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              widget.editCallBack!();
            },
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              widget.copyCallBack!();
            },
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.content_copy,
                  size: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headers2() {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 16, top: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  widget.mlst.country1Name.toString() == "Bangladesh"
                      ? "Ban"
                      : widget.mlst.country1Name.toString() == "South Africa"
                          ? "SA"
                          : widget.mlst.country1Name.toString() == "Pakistan"
                              ? "Pak"
                              : widget.mlst.country1Name.toString() == "India"
                                  ? "Ind"
                                  : widget.mlst.country1Name.toString() ==
                                          "Zimbabwe"
                                      ? "Zim"
                                      : widget.mlst.country1Name.toString() ==
                                              "West Indies"
                                          ? "WI"
                                          : widget.mlst.country1Name
                                                      .toString() ==
                                                  "England"
                                              ? "Eng"
                                              : widget.mlst.country1Name
                                                          .toString() ==
                                                      "Austrailia"
                                                  ? "Aus"
                                                  : widget.mlst.country1Name
                                                      .toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ConstanceData.SIZE_TITLE14,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '$teamA',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ConstanceData.SIZE_TITLE18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: <Widget>[
                Text(
                  widget.mlst.country2Name.toString() == "Bangladesh"
                      ? "Ban"
                      : widget.mlst.country2Name.toString() == "South Africa"
                          ? "SA"
                          : widget.mlst.country2Name.toString() == "Pakistan"
                              ? "Pak"
                              : widget.mlst.country2Name.toString() == "India"
                                  ? "Ind"
                                  : widget.mlst.country2Name.toString() ==
                                          "Zimbabwe"
                                      ? "Zim"
                                      : widget.mlst.country2Name.toString() ==
                                              "West Indies"
                                          ? "WI"
                                          : widget.mlst.country2Name
                                                      .toString() ==
                                                  "England"
                                              ? "Eng"
                                              : widget.mlst.country2Name
                                                          .toString() ==
                                                      "Austrailia"
                                                  ? "Aus"
                                                  : widget.mlst.country2Name
                                                      .toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ConstanceData.SIZE_TITLE14,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '$teamB',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ConstanceData.SIZE_TITLE18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              child: getPlayerView(captun),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              padding: EdgeInsets.only(right: 32),
              child: getPlayerView(wcaptun),
            ),
          ),
        ],
      ),
    );
  }

  Widget headers3() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Wk  ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE14),
                ),
                Text('1'),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'BAT  ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE14),
                ),
                Text('$batcount'),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'All  ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE14),
                ),
                Text('$allcount'),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'BOWL  ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE14),
                ),
                Text('$bowlcount'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPlayerView(Players player) {
    final firstname = player.firstName;
    final lastName = player.lastName;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width > 360 ? 8 : 4),
              right: (MediaQuery.of(context).size.width > 360 ? 8 : 4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  height: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(player.img.toString()),
                    backgroundColor: Colors.transparent,
                  )),
              Container(
                padding: EdgeInsets.only(left: 6, top: 2, bottom: 2, right: 6),
                decoration: new BoxDecoration(
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  borderRadius: new BorderRadius.circular(4.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 1),
                        blurRadius: 5.0),
                  ],
                ),
                child: Center(
                  child: Text(
                    (firstname!.length > 1
                            ? player.firstName![0].toUpperCase() + '. '
                            : '') +
                        lastName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width > 360
                          ? ConstanceData.SIZE_TITLE10
                          : 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(32.0),
                  border: new Border.all(
                    width: 1.0,
                    color: AllCoustomTheme.getThemeData().primaryColor,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Center(
                    child: Text(
                      'C',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AllCoustomTheme.getThemeData().primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: ConstanceData.SIZE_TITLE10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
