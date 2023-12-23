// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:tempalteflutter/bloc/StandingScreen/complete_standard_screen.dart';
import 'package:tempalteflutter/bloc/StandingScreen/standingscreen.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/drawer/drawer.dart';
import 'package:tempalteflutter/modules/result/standingResult.dart';
import 'package:tempalteflutter/utils/avatarImage.dart';
import 'package:tempalteflutter/validator/validator.dart';

import '../../bloc/Context/context.dart';
import '../../bloc/StandingScreen/live_standing_screen.dart';
import '../../models/Context/context.dart';

class StandingScree extends StatefulWidget {
  final void Function()? menuCallBack;

  const StandingScree({Key? key, this.menuCallBack}) : super(key: key);
  @override
  _StandingScreeState createState() => _StandingScreeState();
}

class _StandingScreeState extends State<StandingScree>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKeyF =
      new GlobalKey<RefreshIndicatorState>();
  final standingscreenbloc = StandingScreenBloc();
  final livestandingscreenbloc = LiveStandingScreenBloc();
  final completestandingscreenbloc = CompleteStandingScreenBloc();
  @override
  void initState() {
    standingscreenbloc.eventstandingscreensink.add(StandingScreenAction.Fetch);
    livestandingscreenbloc.eventlivestandingscreensink
        .add(StandingScreenAction.LiveFetch);
    super.initState();
    updateData();
  }

  updateData() async {
    userData = (await MySharedPreferences().getUserData())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: <Widget>[
          Container(
            color: AllCoustomTheme.getThemeData().primaryColor,
          ),
          SafeArea(
            child: Scaffold(
              drawer: AppDrawer(
                mySettingClick: () {},
                referralClick: () {},
              ),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
                title: Text(
                  'Standings',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Text(
                        "Upcoming",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "Live",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "Completed",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                color: AllCoustomTheme.getThemeData().backgroundColor,
                child: TabBarView(
                  children: <Widget>[
                    Fixtures(
                      standingscreenbloc: standingscreenbloc,
                    ),
                    Live(
                      livestandingscreenbloc: livestandingscreenbloc,
                    ),
                    Results(
                      completeStandingScreenBloc: completestandingscreenbloc,
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

  UserData userData = new UserData();

  Widget drawerButton() {
    return InkWell(
      onTap: openDrawer,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:
                AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
            radius: 14,
            child: AvatarImage(
              imageUrl: ConstanceData.appIcon,
              isCircle: true,
              radius: 28,
              sizeValue: 28,
              isAssets: false,
            ),
          ),
          Icon(Icons.sort,
              color: AllCoustomTheme.getReBlackAndWhiteThemeColors())
        ],
      ),
    );
  }

  Widget sliverText() {
    return FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 8, top: 0),
      title: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Standings',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: AllCoustomTheme.getThemeData().backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDrawer() {
    widget.menuCallBack!();
  }
}

class Fixtures extends StatefulWidget {
  Fixtures({Key? key, required this.standingscreenbloc}) : super(key: key);
  StandingScreenBloc standingscreenbloc;
  @override
  _FixturesState createState() => _FixturesState();
}

class _FixturesState extends State<Fixtures> {
  @override
  void initState() {
    widget.standingscreenbloc.eventstandingscreensink
        .add(StandingScreenAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<matches_list>>(
          stream: widget.standingscreenbloc.standingscreenstream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.length == 0
                  ? Center(
                      child: Text(
                        'No Upcoming Fixture Yet',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 4),
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data![index].matchstatus != "0"
                            ? Text("")
                            : MatchesList(
                                id: snapshot.data![index].id,
                                titel: snapshot.data![index].titel,
                                country1Name:
                                    snapshot.data![index].country1Name,
                                country2Name:
                                    snapshot.data![index].country2Name,
                                country1Flag:
                                    snapshot.data![index].country1Flag,
                                country2Flag:
                                    snapshot.data![index].country2Flag,
                                price: snapshot.data![index].price,
                                lstteam1: snapshot.data![index].lstteam1player,
                                lstteam2: snapshot.data![index].lstteam2player,
                                time: snapshot.data![index].time,
                                matchstatus: snapshot.data![index].matchstatus);
                      },
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              return Center(
                  child: Text(
                'No Upcoming Fixture Yet',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ));
            }
          })),
    );
  }
}

class Live extends StatefulWidget {
  Live({Key? key, required this.livestandingscreenbloc}) : super(key: key);
  LiveStandingScreenBloc livestandingscreenbloc;
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  @override
  void initState() {
    widget.livestandingscreenbloc.eventlivestandingscreensink
        .add(StandingScreenAction.LiveFetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<matches_list>>(
          stream: widget.livestandingscreenbloc.livestandingscreenstream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: ((context, index) => MatchesList(
                            id: snapshot.data![index].id,
                            titel: snapshot.data![index].titel,
                            country1Name: snapshot.data![index].country1Name,
                            country2Name: snapshot.data![index].country2Name,
                            country1Flag: snapshot.data![index].country1Flag,
                            country2Flag: snapshot.data![index].country2Flag,
                            price: "৳2 Lakhs",
                            time: "Live",
                            lstteam1: snapshot.data![index].lstteam1player,
                            lstteam2: snapshot.data![index].lstteam2player,
                            matchstatus: snapshot.data![index].matchstatus,
                          )))
                  : Column(
                      children: [
                        Container(
                          color: AllCoustomTheme.getTextThemeColors(),
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/cup.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Text(
                          "You haven't joined any contests that are Live\nJoin contests for any of the upcoming matches",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ConstanceData.SIZE_TITLE14,
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(
                  child: Text(
                'No Data',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ));
            }
          }),
    );
  }
}

class Results extends StatefulWidget {
  CompleteStandingScreenBloc completeStandingScreenBloc;
  Results({required this.completeStandingScreenBloc});
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  void initState() {
    widget.completeStandingScreenBloc.eventcompletestandingscreensink
        .add(StandingScreenAction.CompleteFetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<matches_list>>(
              stream: widget
                  .completeStandingScreenBloc.completestandingscreenstream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: ((context, index) => MatchesList(
                                id: snapshot.data![index].id,
                                titel: snapshot.data![index].titel,
                                country1Name:
                                    snapshot.data![index].country1Name,
                                country2Name:
                                    snapshot.data![index].country2Name,
                                country1Flag:
                                    snapshot.data![index].country1Flag,
                                country2Flag:
                                    snapshot.data![index].country2Flag,
                                price: "1 contest joined",
                                time: 'Completed',
                                lstteam1: snapshot.data![index].lstteam1player,
                                lstteam2: snapshot.data![index].lstteam2player,
                                matchstatus: snapshot.data![index].matchstatus,
                              )))
                      : Center(
                          child: Text(
                          'No Data',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(
                      child: Text(
                    'No Data',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ));
                }
              }),
        )
      ],
    );
  }
}

class MatchesList extends StatefulWidget {
  final String? titel;
  final String? country1Name;
  final String? country1Flag;
  final String? country2Name;
  final String? country2Flag;
  final String? time;
  final String? price;
  final String? id;
  final List<Player>? lstteam1;
  final List<Player>? lstteam2;
  final String? matchstatus;

  const MatchesList({
    Key? key,
    this.id,
    this.titel,
    this.country1Name,
    this.country2Name,
    this.time,
    this.price,
    this.country1Flag,
    this.country2Flag,
    this.lstteam1,
    this.lstteam2,
    this.matchstatus,
  }) : super(key: key);

  @override
  _MatchesListState createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList> {
  CountdownTimerController? countdown_controller;
  @override
  Widget build(BuildContext context) {
    int endTime = 0;
    try {
      DateTime dateTime = DateTime.parse(
          "${widget.time.toString().split(' ')[0]} ${widget.time.toString().split(' ')[1]}");

      endTime = dateTime.millisecondsSinceEpoch;
      countdown_controller =
          CountdownTimerController(endTime: endTime, onEnd: () {});
    } catch (e) {}
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            print(widget.id);
            return StandingResult(
              id: widget.id,
              lstteam1: widget.lstteam1,
              lstteam2: widget.lstteam2,
              country1Flag: widget.country1Flag,
              country2Flag: widget.country2Flag,
              country1Name: widget.country1Name,
              country2Name: widget.country2Name,
              price: widget.price,
              time: widget.time,
              titel: widget.titel,
              matchstatus: widget.matchstatus,
            );
          }),
        );
      },
      // onLongPress: () {
      //   showModalBottomSheet<void>(
      //     context: context,
      //     builder: (
      //       BuildContext context,
      //     ) =>
      //         UnderGroundDrawer(
      //       country1Flag: widget.country1Flag,
      //       country2Flag: widget.country2Flag,
      //       country1Name: widget.country1Name,
      //       country2Name: widget.country2Name,
      //       price: widget.price,
      //       time: widget.time,
      //       titel: widget.titel,
      //     ),
      //   );
      // },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 15,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Text(
                          widget.titel!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ConstanceData.SIZE_TITLE12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          width: 10,
                        )),
                        Image.asset(
                          ConstanceData.lineups,
                          height: 14,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.notification_add_outlined,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.3,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.country1Name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        widget.country2Name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.network(widget.country1Flag!),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          widget.time == "Live"
                              ? Text(
                                  "Live",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: Colors.green,
                                  ),
                                )
                              : CountdownTimer(
                                  endWidget: Center(
                                    child: Text(
                                      widget.matchstatus == "2"
                                          ? "Match Completed"
                                          : "Match Started",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: Colors.green,
                                  ),
                                  widgetBuilder: ((context, time) {
                                    if (time == null) {
                                      return Center(
                                        child: Text(
                                          widget.matchstatus == "2"
                                              ? "Match Completed"
                                              : "Match Started",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            color: Colors.green,
                                          ),
                                        ),
                                      );
                                    }
                                    return Text(
                                      'days: ${time.days ?? 0} hours:${time.hours ?? 0} min:${time.min ?? 0} sec: ${time.sec ?? 0}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                        color: Colors.green,
                                      ),
                                    );
                                  }),
                                  onEnd: () {},
                                  endTime: endTime,
                                ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.network(widget.country2Flag!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AllCoustomTheme.isLight
                    ? HexColor("#f5f5f5")
                    : Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    widget.matchstatus != "0"
                        ? const Text("")
                        : FutureBuilder<List<context_list>>(
                            future: ContextBloc().getContext(widget.id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "Available Contest ${snapshot.data!.length.toString()}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                );
                              }
                              return Text("");
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  PersistentHeader(
    this.controller,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          color: AllCoustomTheme.getThemeData().backgroundColor,
          child: new TabBar(
            unselectedLabelColor: AllCoustomTheme.getTextThemeColors(),
            indicatorColor: AllCoustomTheme.getThemeData().primaryColor,
            labelColor: AllCoustomTheme.getThemeData().primaryColor,
            tabs: [
              new Tab(text: 'Fixtures'),
              new Tab(text: 'Live'),
              new Tab(text: 'Results'),
            ],
            controller: controller,
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  @override
  double get maxExtent => 41.0;

  @override
  double get minExtent => 41.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
