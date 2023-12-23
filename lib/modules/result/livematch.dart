import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/global.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Context/context.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/modules/result/livematchranking.dart';
import 'package:tempalteflutter/modules/result/resultContest.dart';
import 'package:tempalteflutter/validator/validator.dart';

import '../../bloc/MyTeam/Myteam.dart';
import '../../bloc/usercontest/usercontestrank.dart';
import '../../models/UserContext/usercontestranking.dart';
import '../contests/TeamDetails.dart';

class LiveContestScreen extends StatefulWidget {
  final String? titel;
  final String? country1Name;
  final String? country1Flag;
  final String? country2Name;
  final String? country2Flag;
  final String? time;
  final String? price;
  final context_list cl;
  final ContestsScreen cs;
  final String uid;

  const LiveContestScreen(
      {Key? key,
      this.titel,
      this.country1Name,
      this.country1Flag,
      this.country2Name,
      this.country2Flag,
      this.time,
      this.price,
      required this.cl,
      required this.cs,
      required this.uid})
      : super(key: key);
  @override
  _ResultContestScreenState createState() => _ResultContestScreenState();
}

class _ResultContestScreenState extends State<LiveContestScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final usercontestrankingbloc = UserContextRankingBloc();
  MyTeamBloc mtb = MyTeamBloc();

  @override
  void initState() {
    usercontestrankingbloc.contxtid = widget.cl.id;
    mtb.fixtureid = widget.cl.fixtureid;
    getdata();
    usercontestrankingbloc.lst = [];
    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  getdata() {
    mtb.eventmyteamsink.add(MyTeamAction.FetchTeam);
  }

  bool isplayerpoints = true;

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
      child: isplayerpoints == false
          ? Stack(
              children: <Widget>[
                SafeArea(
                  child: Scaffold(
                    backgroundColor:
                        AllCoustomTheme.getThemeData().backgroundColor,
                    appBar: AppBar(
                      elevation: 0,
                      title: Text(
                        "Joined Contests",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color:
                              AllCoustomTheme.getReBlackAndWhiteThemeColors(),
                        ),
                      ),
                      centerTitle: true,
                    ),
                    body: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            MatchHadder(
                              country1Flag: widget.country1Flag,
                              country2Flag: widget.country2Flag,
                              country1Name: widget.country1Name,
                              country2Name: widget.country2Name,
                              price: widget.price,
                              time: widget.time,
                              titel: widget.titel,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 8, right: 8, top: 4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "SCORECARD",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: HexColor(
                                            '#AAAFBC',
                                          ),
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Text(
                                        "${widget.cs.country1Name}   213-10",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "  (49.5)",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor(
                                            '#AAAFBC',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('|'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${widget.cs.country2Name}   224-8",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "  (50)",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor(
                                            '#AAAFBC',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: <Widget>[
                                  //     Text(
                                  //       'India won by 11 runs',
                                  //       style: TextStyle(
                                  //         fontFamily: 'Poppins',
                                  //         fontSize: 14,
                                  //         color: HexColor(
                                  //           '#AAAFBC',
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  Divider(
                                    color: HexColor(
                                      '#AAAFBC',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isplayerpoints = true;
                                          });
                                        },
                                        child: Text(
                                          "Player Points",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 20,
                                              color: isplayerpoints
                                                  ? primaryColorString
                                                  : HexColor(
                                                      '#AAAFBC',
                                                    )),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isplayerpoints = false;
                                          });
                                        },
                                        child: Text(
                                          "Contest",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 20,
                                              color: isplayerpoints
                                                  ? HexColor(
                                                      '#AAAFBC',
                                                    )
                                                  : primaryColorString),
                                        ),
                                      )
                                    ],
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             JoinContestPlayerPoint(),
                                  //       ),
                                  //     );
                                  //   },
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: <Widget>[
                                  //       Text(
                                  //         'View Player Status',
                                  //         style: TextStyle(
                                  //           fontFamily: 'Poppins',
                                  //           fontSize: 14,
                                  //           color: AllCoustomTheme.getThemeData()
                                  //               .primaryColor,
                                  //         ),
                                  //       ),
                                  //       Icon(
                                  //         Icons.arrow_forward_ios,
                                  //         size: 20,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Divider(
                                    color: HexColor(
                                      '#AAAFBC',
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ResultContestScreen(),
                                      //   ),
                                      // );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Prize Pool',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: HexColor(
                                                  '#AAAFBC',
                                                ),
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE14,
                                              ),
                                            ),
                                            Text(
                                              '৳${widget.cl.prizepool}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Spots',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: HexColor(
                                                  '#AAAFBC',
                                                ),
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE14,
                                              ),
                                            ),
                                            Text(
                                              '${widget.cl.entrycapacity}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: HexColor(
                                                  '#AAAFBC',
                                                ),
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Entry',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: HexColor(
                                                  '#AAAFBC',
                                                ),
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE14,
                                              ),
                                            ),
                                            Text(
                                              '৳${widget.cl.entryfee}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 24,
                                    color: Color(0xFFf5f5f5),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.trophy,
                                            color: HexColor(
                                              '#AAAFBC',
                                            ),
                                            size: 10,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '1 WINNER',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                              color: HexColor('#AAAFBC'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Container(
                                child: contestsListData(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Stack(
              children: <Widget>[
                SafeArea(
                  child: Scaffold(
                    backgroundColor:
                        AllCoustomTheme.getThemeData().backgroundColor,
                    appBar: AppBar(
                      elevation: 0,
                      title: Text(
                        "Joined Contests",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color:
                              AllCoustomTheme.getReBlackAndWhiteThemeColors(),
                        ),
                      ),
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                MatchHadder(
                                  country1Flag: widget.country1Flag,
                                  country2Flag: widget.country2Flag,
                                  country1Name: widget.country1Name,
                                  country2Name: widget.country2Name,
                                  price: widget.price,
                                  time: widget.time,
                                  titel: widget.titel,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 4),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "SCORECARD",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: HexColor(
                                                '#AAAFBC',
                                              ),
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Text(
                                            "${widget.cs.country1Name}   213-10",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "  (49.5)",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(
                                                '#AAAFBC',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('|'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${widget.cs.country2Name}   224-8",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "  (50)",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(
                                                '#AAAFBC',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: <Widget>[
                                      //     Text(
                                      //       'India won by 11 runs',
                                      //       style: TextStyle(
                                      //         fontFamily: 'Poppins',
                                      //         fontSize: 14,
                                      //         color: HexColor(
                                      //           '#AAAFBC',
                                      //         ),
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                      Divider(
                                        color: HexColor(
                                          '#AAAFBC',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isplayerpoints = true;
                                              });
                                            },
                                            child: Text(
                                              "Player Points",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 20,
                                                  color: isplayerpoints
                                                      ? primaryColorString
                                                      : HexColor(
                                                          '#AAAFBC',
                                                        )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isplayerpoints = false;
                                              });
                                            },
                                            child: Text(
                                              "Contest",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 20,
                                                  color: isplayerpoints
                                                      ? HexColor(
                                                          '#AAAFBC',
                                                        )
                                                      : primaryColorString),
                                            ),
                                          )
                                        ],
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             JoinContestPlayerPoint(),
                                      //       ),
                                      //     );
                                      //   },
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       Text(
                                      //         'View Player Status',
                                      //         style: TextStyle(
                                      //           fontFamily: 'Poppins',
                                      //           fontSize: 14,
                                      //           color: AllCoustomTheme.getThemeData()
                                      //               .primaryColor,
                                      //         ),
                                      //       ),
                                      //       Icon(
                                      //         Icons.arrow_forward_ios,
                                      //         size: 20,
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      Divider(
                                        color: HexColor(
                                          '#AAAFBC',
                                        ),
                                      ),
                                      LiveMatchPlayerRanking(
                                        ucontestid: widget.cl.id,
                                        uid: widget.uid.toString(),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

  ScrollController _scrollController = new ScrollController();

  Widget contestsListData() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: ContestTabHeader(controller),
          ),
        ];
      },
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 40,
                color: Color(0xFFf5f5f5),
                child: Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'team Locked!\nNow download all teams',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE12,
                          color: HexColor('#AAAFBC'),
                        ),
                      ),
                      Container(
                        height: 26,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AllCoustomTheme.getThemeData()
                                  .primaryColor
                                  .withOpacity(0.5),
                              offset: Offset(0, 1),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: AllCoustomTheme.getThemeData()
                                .primaryColor
                                .withOpacity(0.4),
                            borderRadius: new BorderRadius.circular(20),
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Center(
                                child: Text(
                                  'Download Team',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    fontSize: ConstanceData.SIZE_TITLE10,
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
              Expanded(
                  child: FutureBuilder<List<UserContextRanking>>(
                      future: usercontestrankingbloc
                          .getUserContextRanking(widget.cl.id!),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        'ALL TEAMS',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: HexColor('#AAAFBC'),
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        'POINTS',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: HexColor('#AAAFBC'),
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'RANK',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: HexColor('#AAAFBC'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return Container(
                                        color: AllCoustomTheme.getThemeData()
                                            .primaryColor
                                            .withOpacity(0.2),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        TeamDetails(
                                                      ucontestid: widget.cl.id,
                                                      ucr:
                                                          snapshot.data![index],
                                                    ),
                                                  )),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6, top: 4),
                                                child: ListTile(
                                                    leading: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 24,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Image.asset(
                                                              ConstanceData
                                                                  .userAvatar,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          usercontestrankingbloc
                                                                      .lst[
                                                                          index]
                                                                      .user!
                                                                      .name!
                                                                      .length >
                                                                  20
                                                              ? Text(
                                                                  usercontestrankingbloc
                                                                      .lst[
                                                                          index]
                                                                      .user!
                                                                      .name!
                                                                      .substring(
                                                                          0, 20)
                                                                      .toString(),
                                                                )
                                                              : Text(
                                                                  usercontestrankingbloc
                                                                      .lst[
                                                                          index]
                                                                      .user!
                                                                      .name!
                                                                      .toString(),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .score
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: HexColor(
                                                                  '#AAAFBC'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      '#${index + 1}',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            const Divider(
                                              height: 0,
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                              ),
                            ],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Text(
                            'No Data',
                            style: TextStyle(fontSize: 30),
                          );
                        }
                      }))),
              const SizedBox(
                height: 70,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: AllCoustomTheme.getTextThemeColors().withOpacity(0.1),
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'RANK',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ConstanceData.SIZE_TITLE12,
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                        Text(
                          'PRIZE',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ConstanceData.SIZE_TITLE12,
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.cl.pricelst!.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: ((context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '# ${index + 1}',
                              ),
                              Text(
                                '৳ ${widget.cl.pricelst![index]}.00',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                            ],
                          ))),
                ),
                Container(
                  padding: EdgeInsets.only(right: 8, left: 8, bottom: 4),
                  child: Text(
                    'Note: The actual prize money may be different than the prize money mentioned above if there is a tie for any of the winning position. Check FQAs for further details.as per government regulations, a tax of 31.2% will be deducted if an individual wins more than Rs. 10,000',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  ContestTabHeader(
    this.controller,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: new TabBar(
              unselectedLabelColor:
                  AllCoustomTheme.getTextThemeColors().withOpacity(0.6),
              indicatorColor: AllCoustomTheme.getThemeData().primaryColor,
              labelColor: AllCoustomTheme.getThemeData().primaryColor,
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ConstanceData.SIZE_TITLE14,
              ),
              tabs: [
                new Tab(text: 'Leaderboard'),
                new Tab(text: 'Prize Breakup'),
              ],
              controller: controller,
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42.0;

  @override
  double get minExtent => 42.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
