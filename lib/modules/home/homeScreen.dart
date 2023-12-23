// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tempalteflutter/api/apiProvider.dart';
import 'package:tempalteflutter/bloc/Context/context.dart';
import 'package:tempalteflutter/bloc/Matches/matches.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Matches_Standing_Screen/mactheslist.dart';
import 'package:tempalteflutter/models/scheduleResponseData.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/drawer/drawer.dart';
import 'package:tempalteflutter/modules/notification/notificationScreen.dart';
import 'package:tempalteflutter/utils/avatarImage.dart';
import 'package:tempalteflutter/validator/validator.dart';

import '../../models/Context/context.dart';

class HomeScreen extends StatefulWidget {
  final void Function()? menuCallBack;

  HomeScreen({Key? key, this.menuCallBack}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     new GlobalKey<RefreshIndicatorState>();

  var sheduallist = <ShedualData>[];
  // var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoginProsses = false;
  late UserData userData;

  @override
  void initState() {
    matchbloc.eventmatchsink.add(MatchesAction.Fetch);
    getTeamData(false);
    super.initState();
  }

  Future<Null> getTeamData(bool pool) async {
    userData = (await MySharedPreferences().getUserData())!;
    if (!pool) {
      setState(() {
        isLoginProsses = true;
      });
    }

    var responseData = await ApiProvider().postScheduleList();

    if (responseData != null && responseData.shedualData != null) {
      sheduallist = responseData.shedualData!;
    }
    if (!mounted) return null;
    setState(() {
      isLoginProsses = false;
    });
    return null;
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getThemeData().primaryColor,
        ),
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
              title: Text(
                'Matches',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            drawer: AppDrawer(
              mySettingClick: () {},
              referralClick: () {},
            ),
            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
            body: RefreshIndicator(
              onRefresh: () async {
                matchbloc.eventmatchsink.add(MatchesAction.Fetch);
                await Future.delayed(Duration(seconds: 2));
              },
              child: ModalProgressHUD(
                inAsyncCall: isLoginProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
                  children: <Widget>[
                    CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: RefreshIndicator(
                              onRefresh: () async {
                                matchbloc.eventmatchsink
                                    .add(MatchesAction.Fetch);
                                await Future.delayed(Duration(seconds: 2));
                              },
                              child: listItems()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget drawerButton() {
    return InkWell(
      onTap: openDrawer,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:
                AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
            radius: 16,
            child: AvatarImage(
              imageUrl:
                  'https://www.menshairstylesnow.com/wp-content/uploads/2018/03/Hairstyles-for-Square-Faces-Slicked-Back-Undercut.jpg',
              isCircle: true,
              radius: 28,
              sizeValue: 28,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Icon(
            Icons.sort,
            size: 30,
          )
        ],
      ),
    );
  }

  Widget notificationButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Icon(
          Icons.notifications,
          color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
        ),
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
              'Upcoming Matches',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
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
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget listItems() {
    return StreamBuilder<List<matches_list>>(
        stream: matchbloc.matchstream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.45),
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                matchbloc.eventmatchsink.add(MatchesAction.Fetch);
                await Future.delayed(Duration(seconds: 2));
              },
              child: Container(
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) => MatchesList(
                          id: snapshot.data![index].id,
                          titel: snapshot.data![index].titel,
                          country1Name: snapshot.data![index].country1Name,
                          country2Name: snapshot.data![index].country2Name,
                          country1Flag: snapshot.data![index].country1Flag,
                          country2Flag: snapshot.data![index].country2Flag,
                          price: snapshot.data![index].price,
                          time:
                              '''${(snapshot.data![index].time).toString().split(':')[0]}:${(snapshot.data![index].time).toString().split(':')[1]} PM''',
                          lstteam1player: snapshot.data![index].lstteam1player,
                          lstteam2player: snapshot.data![index].lstteam2player,
                          matchstatus: snapshot.data![index].matchstatus,
                        ))),
              ),
            );
          } else {
            return Text(
              "No data",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            );
          }
        })

        // SizedBox(
        //   height: 70,
        // )

        );
  }

  void openDrawer() {
    widget.menuCallBack!();
  }
}

class MatchesList extends StatefulWidget {
  String? titel;
  String? country1Name;
  String? country1Flag;
  String? country2Name;
  String? country2Flag;
  String? matchstatus;
  String? time;
  String? price;
  String? id;
  final List<Player>? lstteam1player;
  final List<Player>? lstteam2player;
  MatchesList(
      {Key? key,
      this.id,
      this.titel,
      this.country1Name,
      this.country2Name,
      this.time,
      this.price,
      this.country1Flag,
      this.country2Flag,
      this.lstteam1player,
      this.lstteam2player,
      required this.matchstatus})
      : super(key: key);

  @override
  _MatchesListState createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList> {
  CountdownTimerController? countdown_controller;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
            "${widget.time.toString().split(' ')[0]} ${widget.time.toString().split(' ')[1]}")
        .toUtc();

    int endTime = dateTime.millisecondsSinceEpoch;
    countdown_controller =
        CountdownTimerController(endTime: endTime, onEnd: () {});
    return DateTime.now().isAfter(dateTime)
        ? Text("")
        : InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContestsScreen(
                  time: widget.time,
                  lstteam1player: widget.lstteam1player,
                  lstteam2player: widget.lstteam2player,
                  id: widget.id,
                  country1Flag: widget.country1Flag,
                  country2Flag: widget.country2Flag,
                  country1Name: widget.country1Name,
                  country2Name: widget.country2Name,
                  price: widget.price,
                  titel: widget.titel,
                  matchstatus: widget.matchstatus,
                ),
              ),
            ),
            // onLongPress: () {
            //   showModalBottomSheet<void>(
            //     context: context,
            //     builder: (
            //       BuildContext context,
            //     ) =>
            //         UnderGroundDrawer(
            //       country1Flag: widget.country1Flag!,
            //       country2Flag: widget.country2Flag!,
            //       country1Name: widget.country1Name!,
            //       country2Name: widget.country2Name!,
            //       price: widget.price!,
            //       time: widget.time!,
            //       titel: widget.titel!,
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
                              Expanded(child: SizedBox()),
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
                            CountdownTimer(
                              endWidget: Center(
                                child: Text(
                                  "Match Started",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE12,
                                color: Colors.red,
                              ),
                              widgetBuilder: ((context, time) {
                                int days = time?.days ?? 0;
                                days = days * 24;
                                int hours = time?.hours ?? 0;
                                int sum = days + hours;
                                if (time == null) {
                                  return Center(
                                    child: Text(
                                      "Match Started",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                                return Text(
                                  '$sum hour(s) ${time.min ?? 0} minute(s)',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: Colors.red,
                                  ),
                                );
                              }),
                              onEnd: () {},
                              endTime: endTime,
                            ),
                            // Container(
                            //   child: Text(
                            //     widget.time!,
                            //     style: TextStyle(
                            //       fontFamily: 'Poppins',
                            //       fontSize: ConstanceData.SIZE_TITLE12,
                            //       color: Colors.red,
                            //     ),
                            //   ),
                            // ),
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
                          //         Container(
                          //           decoration: BoxDecoration(
                          //             border: Border.all(color: Colors.green),
                          //             borderRadius: BorderRadius.circular(4),
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(right: 3, left: 3),
                          //             child: Text(
                          //               "Mega",
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 fontFamily: 'Poppins',
                          //                 fontSize: ConstanceData.SIZE_TITLE12,
                          //                 color: Colors.green,
                          //                 fontWeight: FontWeight.w400,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          SizedBox(width: 8),
                          FutureBuilder<List<context_list>>(
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
                          Expanded(child: SizedBox()),
                          // Image.asset(
                          //   ConstanceData.tv,
                          //   height: 18,
                          // ),
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

class UnderGroundDrawer extends StatefulWidget {
  final String? titel;
  final String? country1Name;
  final String? country1Flag;
  final String? country2Name;
  final String? country2Flag;
  final String? time;
  final String? price;

  const UnderGroundDrawer({
    Key? key,
    this.titel,
    this.country1Name,
    this.country1Flag,
    this.country2Name,
    this.country2Flag,
    this.time,
    this.price,
  }) : super(key: key);

  @override
  _UnderGroundDrawerState createState() => _UnderGroundDrawerState();
}

class _UnderGroundDrawerState extends State<UnderGroundDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: <Widget>[
          matchSchedulData(),
          Divider(
            height: 1,
          ),
          Expanded(
            child: matchInfoList(),
          ),
        ],
      ),
    );
  }

  Widget matchInfoList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        CountdownTimerController countdown_controller;
        int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
        countdown_controller =
            CountdownTimerController(endTime: endTime, onEnd: () {});
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Match',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        widget.country1Name! + " vs " + widget.country2Name!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Series',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        widget.titel!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Start Date',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CountdownTimer(
                      controller: countdown_controller,
                      onEnd: () {},
                      endTime: endTime,
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Start Time',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        '15:00:00',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Venue',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'India',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Umpires',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'Martine',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Referee',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'Charls piter',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Match Format',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'Match Formate',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Location',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'India',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider()
            ],
          ),
        );
      },
    );
  }

  Widget matchSchedulData() {
    CountdownTimerController countdown_controller;
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
    countdown_controller =
        CountdownTimerController(endTime: endTime, onEnd: () {});
    return Container(
      padding: EdgeInsets.all(10),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset(widget.country1Flag!),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 4),
            child: new Text(
              widget.country1Name!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AllCoustomTheme.getThemeData().primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            child: Text(
              'vs',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ConstanceData.SIZE_TITLE14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            child: new Text(
              widget.country2Name!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AllCoustomTheme.getThemeData().primaryColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 4),
            child: Container(
              child: Container(
                width: 50,
                height: 50,
                child: Image.asset(widget.country2Flag!),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          CountdownTimer(
            controller: countdown_controller,
            onEnd: () {},
            endTime: endTime,
          ),
          // Text(
          //   widget.time!,
          //   style: TextStyle(
          //     fontFamily: 'Poppins',
          //     color: HexColor(
          //       '#AAAFBC',
          //     ),
          //     fontWeight: FontWeight.w600,
          //     fontSize: 14,
          //   ),
          // ),
        ],
      ),
    );
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }
