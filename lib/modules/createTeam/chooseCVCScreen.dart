// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tempalteflutter/bloc/teamSelectionBloc.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import 'package:tempalteflutter/models/Team/create_team_api.dart';
import 'package:tempalteflutter/models/scheduleResponseData.dart';
import 'package:tempalteflutter/models/squadsResponseData.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/modules/createTeam/playerProfile.dart';
import 'package:tempalteflutter/modules/createTeam/teamPreview.dart';
import 'package:tempalteflutter/models/teamResponseData.dart' as team;
import 'package:tempalteflutter/modules/home/homeScreen.dart';
import 'package:tempalteflutter/modules/home/tabScreen.dart';
import '../../api/joincontest.dart';
import '../../bloc/Context/context.dart';
import '../../constance/sharedPreferences.dart';
import '../../models/UserContext/usercontext.dart';
import '../../models/userData.dart';
import '../../utils/loadindDialogs.dart';
import 'createTeamScreen.dart';
import 'package:http/http.dart' as http;

class ChooseCVCScreen extends StatefulWidget {
  final bool? isUpdateTeam;
  final CreateTeamType? createTeamtype;
  final String? time;
  matches_list mlst;
  final String fixtureid;
  final String? usercontextid;
  final String? contextid;
  final String? titel;
  final String? country1Name;
  final String? country1Flag;
  final String? country2Name;
  final String? country2Flag;
  final String? ttime;
  final String? price;
  final String? id;
  final String? matchstatus;
  final List<Player>? lstteam1player;
  final List<Player>? lstteam2player;
  ChooseCVCScreen(
      {Key? key,
      required this.mlst,
      this.usercontextid,
      this.isUpdateTeam = false,
      this.createTeamtype = CreateTeamType.createTeam,
      this.time,
      this.country1Name,
      this.country1Flag,
      this.country2Name,
      this.country2Flag,
      this.ttime,
      this.price,
      this.id,
      this.matchstatus,
      this.lstteam1player,
      this.lstteam2player,
      this.contextid,
      required this.fixtureid,
      this.titel})
      : super(key: key);

  @override
  _ChooseCVCScreenState createState() => _ChooseCVCScreenState();
}

class _ChooseCVCScreenState extends State<ChooseCVCScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isLoginProsses = false;
  List<team.TeamData> createdTeamList = <team.TeamData>[];
  var selectedPlayerList = <Players>[];
  TextEditingController teamname = TextEditingController();
  var wkList = <Players>[];
  var batList = <Players>[];
  var arList = <Players>[];
  var bowlList = <Players>[];
  var allPlayesList = <Players>[];
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
              key: _scaffoldKey,
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                          widget.time!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
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
                              Container(
                                child: Center(
                                  child: Text(
                                    'Choose Captain and Vice Captain',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: Center(
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0),
                                                    border: new Border.all(
                                                      width: 1.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2, top: 2),
                                                    child: Center(
                                                      child: Text(
                                                        'C',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 4),
                                              child: Center(
                                                child: Text(
                                                  ' gets 2x points',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: Center(
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0),
                                                    border: new Border.all(
                                                      width: 1.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 4, top: 1),
                                                    child: Center(
                                                      child: Text(
                                                        'vc',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 4),
                                              child: Center(
                                                child: Text(
                                                  ' gets 1.5x points',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: ConstanceData
                                                        .SIZE_TITLE14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ModalProgressHUD(
                            color: Colors.transparent,
                            inAsyncCall: isLoginProsses,
                            progressIndicator: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                            child: BlocBuilder(
                              bloc: teamSelectionBloc,
                              builder: (context, TeamSelectionBlocState state) {
                                selectedPlayerList = [];
                                state.allPlayerList!.forEach((player) {
                                  if (player.isSelcted!) {
                                    selectedPlayerList.add(player);
                                  }
                                });
                                wkList = <Players>[];
                                batList = <Players>[];
                                arList = <Players>[];
                                bowlList = <Players>[];
                                allPlayesList = <Players>[];
                                selectedPlayerList.forEach((player) {
                                  if (player.playingRole!.toLowerCase() ==
                                      teamSelectionBloc
                                          .getTypeText(TabTextType.wk)
                                          .toLowerCase()) {
                                    wkList.add(player);
                                  }
                                  if (player.playingRole!.toLowerCase() ==
                                      teamSelectionBloc
                                          .getTypeText(TabTextType.bat)
                                          .toLowerCase()) {
                                    batList.add(player);
                                  }
                                  if (player.playingRole!.toLowerCase() ==
                                      teamSelectionBloc
                                          .getTypeText(TabTextType.ar)
                                          .toLowerCase()) {
                                    arList.add(player);
                                  }
                                  if (player.playingRole!.toLowerCase() ==
                                      teamSelectionBloc
                                          .getTypeText(TabTextType.bowl)
                                          .toLowerCase()) {
                                    bowlList.add(player);
                                  }
                                });

                                wkList.sort((a, b) => b.fantasyPlayerRating!
                                    .compareTo(a.fantasyPlayerRating!));
                                batList.sort((a, b) => b.fantasyPlayerRating!
                                    .compareTo(a.fantasyPlayerRating!));
                                arList.sort((a, b) => b.fantasyPlayerRating!
                                    .compareTo(a.fantasyPlayerRating!));
                                bowlList.sort((a, b) => b.fantasyPlayerRating!
                                    .compareTo(a.fantasyPlayerRating!));

                                allPlayesList.addAll(wkList);
                                allPlayesList.addAll(batList);
                                allPlayesList.addAll(arList);
                                allPlayesList.addAll(bowlList);

                                return ListView.builder(
                                  padding: EdgeInsets.only(bottom: 100),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: allPlayesList.length,
                                  itemBuilder: (context, index) =>
                                      PlayerslistUI(
                                    player: allPlayesList[index],
                                    isGrayBar: index != 0
                                        ? allPlayesList[index].playingRole !=
                                            allPlayesList[index - 1].playingRole
                                        : true,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(4.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor
                                          .withOpacity(0.5),
                                      offset: Offset(0, 1),
                                      blurRadius: 5.0),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeamPreviewScreen(),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      'PREVIEW',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme.getThemeData()
                                            .primaryColor,
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: BlocBuilder(
                              bloc: teamSelectionBloc,
                              builder: (context, TeamSelectionBlocState state) {
                                final isDisabled = teamSelectionBloc
                                    .validSaveTeamRequirement();
                                return Opacity(
                                  opacity: isDisabled ? 1.0 : 0.2,
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: Offset(0, 1),
                                            blurRadius: 5.0),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            new BorderRadius.circular(4.0),
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  ((context) => AlertDialog(
                                                        content: TextFormField(
                                                          controller: teamname,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Enter Team Name"),
                                                        ),
                                                        icon: Text(
                                                          'Details',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        actions: [
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("No")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (teamname
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  LoadingDialog(
                                                                      context);
                                                                  Players c = allPlayesList
                                                                      .where((element) =>
                                                                          element
                                                                              .isC ==
                                                                          true)
                                                                      .first;
                                                                  Players vc = allPlayesList
                                                                      .where((element) =>
                                                                          element
                                                                              .isVC ==
                                                                          true)
                                                                      .first;
                                                                  List<int>
                                                                      lstint =
                                                                      [];
                                                                  for (Players p
                                                                      in selectedPlayerList) {
                                                                    lstint.add(
                                                                        p.id!);
                                                                  }

                                                                  teamApi ta = teamApi(
                                                                      team_members:
                                                                          lstint,
                                                                      key: [
                                                                        c.pid!,
                                                                        vc.pid!
                                                                      ]);
                                                                  ta.name =
                                                                      teamname
                                                                          .text;
                                                                  ta.type = 2
                                                                      .toString();

                                                                  if (isDisabled) {
                                                                    bool
                                                                        isstatus =
                                                                        false;
                                                                    UserData?
                                                                        user =
                                                                        await MySharedPreferences()
                                                                            .getUserData();

                                                                    var response =
                                                                        await http
                                                                            .post(
                                                                                Uri.parse(
                                                                                    '${ConstanceData.createTeam}'),
                                                                                headers: {
                                                                                  "Content-type": "application/json"
                                                                                },
                                                                                body: json.encode({
                                                                                  "name": teamname.text,
                                                                                  "type": 1.toString(),
                                                                                  "fixture_id": widget.fixtureid,
                                                                                  "key_members": [
                                                                                    c.id,
                                                                                    vc.id
                                                                                  ],
                                                                                  "user_id": user!.userId,
                                                                                  "team_members": lstint
                                                                                }))
                                                                            .then((response) async {
                                                                      if (response
                                                                              .statusCode ==
                                                                          201) {
                                                                        var data =
                                                                            json.decode(response.body);
                                                                        SharedPreferences
                                                                            prefs =
                                                                            await SharedPreferences.getInstance();

                                                                        prefs.setInt(
                                                                            'TeamKey',
                                                                            data["id"]);
                                                                        isstatus =
                                                                            true;
                                                                        if (widget.usercontextid ==
                                                                            null) {
                                                                        } else {
                                                                          joinusercontext
                                                                              jc =
                                                                              joinusercontext();
                                                                          UserData?
                                                                              user =
                                                                              await MySharedPreferences().getUserData();

                                                                          jc.userid =
                                                                              user!.userId;
                                                                          jc.contestid =
                                                                              widget.usercontextid;
                                                                          jc.teamid =
                                                                              data["id"].toString();
                                                                          jc.transactionid =
                                                                              "1";
                                                                          joincontest
                                                                              jcapi =
                                                                              joincontest();

                                                                          var result =
                                                                              await jcapi.post(jc.tomap());
                                                                          if (result ==
                                                                              "okay") {
                                                                            Navigator.pop(context);
                                                                            showInSnackBar("Joined Successfully",
                                                                                isGreeen: true);

                                                                            ContextBloc
                                                                                contextbloc =
                                                                                ContextBloc();
                                                                            contextbloc.id =
                                                                                widget.contextid!;

                                                                            contextbloc.eventcontextsink.add(Context_Action.Fetch);
                                                                          } else {
                                                                            Navigator.pop(context);
                                                                            showInSnackBar(result);
                                                                          }
                                                                        }
                                                                      }
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) =>
                                                                                TabScreen())));
                                                                    if (isstatus) {
                                                                    } else {
                                                                      print(
                                                                          "Something went wrong");
                                                                    }
                                                                    // if (data == "okay") {
                                                                    //   showInSnackBar(
                                                                    //       'Contest Created Successfully..');
                                                                    // } else {
                                                                    //   showInSnackBar("Something went wrong..");
                                                                    // }

                                                                    // Navigator.push(
                                                                    //   context,
                                                                    //   MaterialPageRoute(
                                                                    //     builder:
                                                                    //         (context) =>
                                                                    //             MyTeamsScreen(
                                                                    //       wkList:
                                                                    //           wkList,
                                                                    //       allPlayesList:
                                                                    //           allPlayesList,
                                                                    //       batList:
                                                                    //           batList,
                                                                    //       bowlList:
                                                                    //           bowlList,
                                                                    //       arList:
                                                                    //           arList,
                                                                    //       captain:
                                                                    //           c,
                                                                    //       vcaptain:
                                                                    //           vc,
                                                                    //       mlst: widget
                                                                    //           .mlst,
                                                                    //       fixtureid:
                                                                    //           widget
                                                                    //               .fixtureid,
                                                                    //     ),
                                                                    //   ),
                                                                    // );
                                                                  }
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showInSnackBar(
                                                                      "Team Name Must Be Entered...",
                                                                      isGreeen:
                                                                          false);
                                                                }
                                                              },
                                                              child:
                                                                  Text("Yes")),
                                                        ],
                                                      )));
                                        },
                                        child: Center(
                                          child: Text(
                                            'SAVE TEAM',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value, {bool isGreeen = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: isGreeen ? Colors.green : Colors.red,
      ),
    );
  }
}

class PlayerslistUI extends StatelessWidget {
  final Players? player;
  final ShedualData? shedualData;
  final bool? isGrayBar;

  const PlayerslistUI(
      {Key? key, this.player, this.isGrayBar = false, this.shedualData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          isGrayBar!
              ? Container(
                  padding: EdgeInsets.all(4),
                  color: AllCoustomTheme.getThemeData()
                      .dividerColor
                      .withOpacity(0.1),
                  child: Center(
                    child: Text(
                      teamSelectionBloc.getFullNameType(player!.playingRole!),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        fontSize: ConstanceData.SIZE_TITLE12,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Container(
            height: 60,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: new BorderRadius.circular(0.0),
                onTap: () async {},
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerProfileScreen(
                        shedualData: shedualData,
                        player: player,
                        isChoose: false,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerProfileScreen(
                                      shedualData: shedualData,
                                      player: player!,
                                      isChoose: false,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:
                                        NetworkImage(player!.img.toString()),
                                    backgroundColor: Colors.transparent,
                                  )),
                              // Container(
                              //   width: 50,
                              //   height: 50,
                              //   child: AvatarImage(
                              //     isCircle: true,
                              //     isAssets: true,
                              //     imageUrl: 'assets/cname/${player!.pid}.png',
                              //     radius: 50,
                              //     sizeValue: 50,
                              //   ),
                              // ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${player!.title}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme
                                            .getBlackAndWhiteThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${player!.teamName} - ${player!.playingRole!.toUpperCase()}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            child: Center(
                              child: Text(
                                '${player!.point}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AllCoustomTheme.getTextThemeColors(),
                                  fontSize: ConstanceData.SIZE_TITLE12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            width: 0.4,
                            child: Container(
                              color: AllCoustomTheme.getTextThemeColors()
                                  .withOpacity(0.5),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, left: 8),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: new BorderRadius.circular(32.0),
                                  onTap: () {
                                    teamSelectionBloc.setCaptain(player!.pid!);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: player!.isC!
                                          ? AllCoustomTheme.getThemeData()
                                              .primaryColor
                                          : Colors.transparent,
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: player!.isC!
                                            ? AllCoustomTheme.getThemeData()
                                                .primaryColor
                                            : AllCoustomTheme
                                                .getTextThemeColors(),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      child: Center(
                                        child: Text(
                                          'C',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: player!.isC!
                                                ? Colors.white
                                                : AllCoustomTheme
                                                    .getTextThemeColors(),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: new BorderRadius.circular(32.0),
                                  onTap: () {
                                    teamSelectionBloc
                                        .setViceCaptain(player!.pid!);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: player!.isVC!
                                          ? AllCoustomTheme.getThemeData()
                                              .primaryColor
                                          : Colors.transparent,
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: player!.isVC!
                                            ? AllCoustomTheme.getThemeData()
                                                .primaryColor
                                            : AllCoustomTheme
                                                .getTextThemeColors(),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(bottom: 4, top: 1),
                                      child: Center(
                                        child: Text(
                                          'vc',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: player!.isVC!
                                                ? Colors.white
                                                : AllCoustomTheme
                                                    .getTextThemeColors(),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE18,
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
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
