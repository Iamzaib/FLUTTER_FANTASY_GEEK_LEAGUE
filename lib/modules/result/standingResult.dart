// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Context/context.dart';
import 'package:tempalteflutter/modules/contests/contestsScreen.dart';
import 'package:tempalteflutter/modules/contests/insideContest.dart';
import 'package:tempalteflutter/modules/result/livematch.dart';
import 'package:tempalteflutter/modules/result/resultContest.dart';
import 'package:tempalteflutter/validator/validator.dart';

import '../../bloc/usercontest/usercontestbyfixture.dart';
import '../../bloc/usercontest/usercontestrank.dart';
import '../../constance/sharedPreferences.dart';
import '../../models/Matches_Standing_Screen/mactheslist.dart';
import '../../models/UserContext/getusercontest.dart';
import '../../models/UserContext/usercontestranking.dart';
import '../../models/userData.dart';

class StandingResult extends StatefulWidget {
  final String? titel;
  final String? id;
  final String? country1Name;
  final String? country1Flag;
  final String? country2Name;
  final String? country2Flag;
  final String? time;
  final String? price;
  final List<Player>? lstteam1;
  final List<Player>? lstteam2;
  final String? matchstatus;

  const StandingResult(
      {Key? key,
      this.titel,
      this.country1Name,
      this.country1Flag,
      this.country2Name,
      this.country2Flag,
      this.time,
      this.price,
      this.lstteam1,
      this.lstteam2,
      this.id,
      this.matchstatus})
      : super(key: key);
  @override
  _StandingResultState createState() => _StandingResultState();
}

class _StandingResultState extends State<StandingResult>
    with SingleTickerProviderStateMixin {
  UserContextBloc usercontestbloc = UserContextBloc();
  final usercontestrankingbloc = UserContextRankingBloc();
  @override
  void initState() {
    usercontestbloc.fxtid = widget.id!;
    usercontestbloc.eventusercontextsink.add(UserContext_Action.Fetch);

    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  bool iscontest = true;
  context_list? cl;
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
        child: Scaffold(
            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
              title: Text(
                "Joined Contests",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                MatchHadder(
                  country1Flag: widget.country1Flag,
                  country2Flag: widget.country2Flag,
                  country1Name: widget.country1Name,
                  country2Name: widget.country2Name,
                  price: widget.price,
                  time: widget.time,
                  titel: widget.titel,
                ),
                ContestData()
              ]),
            )));
  }

  Widget ContestData() {
    return Container(
      child: StreamBuilder<List<UserContestData>>(
        stream: usercontestbloc.usercontextstream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return snapshot.data!.length == 0
                ? Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: Text(
                          'You have not joined a contest yet!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: AllCoustomTheme.getTextThemeColors(),
                            fontSize: ConstanceData.SIZE_TITLE14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Image.asset(
                      //   ConstanceData.g1,
                      //   fit: BoxFit.cover,
                      //   height: 200,
                      // ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      // Text(
                      //   'What are you waiting for',
                      //   style: TextStyle(
                      //     fontFamily: 'Poppins',
                      //     fontWeight: FontWeight.bold,
                      //     color: AllCoustomTheme.getTextThemeColors(),
                      //     fontSize: ConstanceData.SIZE_TITLE14,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      // Container(
                      //   height: 50,
                      //   padding:
                      //       EdgeInsets.only(left: 50, right: 50, bottom: 8),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Flexible(
                      //         child: Container(
                      //           decoration: new BoxDecoration(
                      //             color: AllCoustomTheme.getThemeData()
                      //                 .primaryColor,
                      //             borderRadius:
                      //                 new BorderRadius.circular(4.0),
                      //             boxShadow: <BoxShadow>[
                      //               BoxShadow(
                      //                   color:
                      //                       Colors.black.withOpacity(0.5),
                      //                   offset: Offset(0, 1),
                      //                   blurRadius: 5.0),
                      //             ],
                      //           ),
                      //           child: Material(
                      //             color: Colors.transparent,
                      //             child: InkWell(
                      //               borderRadius:
                      //                   new BorderRadius.circular(4.0),
                      //               onTap: () async {
                      //                 Navigator.pop(context);
                      //               },
                      //               child: Center(
                      //                 child: Text(
                      //                   'JOIN CONTEST',
                      //                   style: TextStyle(
                      //                     fontFamily: 'Poppins',
                      //                     fontWeight: FontWeight.bold,
                      //                     color: Colors.white,
                      //                     fontSize:
                      //                         ConstanceData.SIZE_TITLE12,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //     ),
                      //    ],
                      //    ),
                      //   ),
                    ],
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) => StickyHeader(
                        header: new Container(
                          color: AllCoustomTheme.getThemeData()
                              .scaffoldBackgroundColor,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 6, left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  'Contest Number $index',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].contest!.name
                                      .toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        content: InkWell(
                          onTap: () async {
                            context_list cl = context_list(
                                fixtureid: widget.id,
                                id: snapshot.data![index].contest!.id,
                                entrycapacity: snapshot
                                    .data![index].contest!.entrycapacity,
                                prizepool:
                                    snapshot.data![index].contest!.prizepool,
                                entryfee:
                                    snapshot.data![index].contest!.entryfee,
                                entryleft:
                                    snapshot.data![index].contest!.entryleft,
                                entrycount:
                                    snapshot.data![index].contest!.entrycount,
                                winner: snapshot.data![index].contest!.winner,
                                pricelst:
                                    snapshot.data![index].contest!.pricelst,
                                firstprice:
                                    snapshot.data![index].contest!.firstprice);
                            ContestsScreen s = ContestsScreen(
                              id: widget.id,
                              lstteam1player: widget.lstteam1,
                              lstteam2player: widget.lstteam2,
                              key: widget.key,
                              titel: widget.titel,
                              time: widget.time,
                              country1Flag: widget.country1Flag,
                              country2Flag: widget.country2Flag,
                              country1Name: widget.country1Name,
                              country2Name: widget.country2Name,
                              matchstatus: widget.matchstatus,
                            );
                            UserData? user =
                                await MySharedPreferences().getUserData();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LiveContestScreen(
                                    titel: widget.titel,
                                    country1Name: widget.country1Name,
                                    country1Flag: widget.country1Flag,
                                    country2Name: widget.country2Name,
                                    country2Flag: widget.country2Flag,
                                    time: widget.time,
                                    price: widget.price,
                                    cs: s,
                                    cl: cl,
                                    uid: user!.userId!.toString(),
                                  );
                                  // return InsideContest(
                                  //   cl: cl,
                                  //   cs: s,
                                  //   isjoin: true,
                                  //   matchstatus: widget.matchstatus,
                                  // );
                                },
                                fullscreenDialog: false,
                              ),
                            );
                          },
                          child: contestnt(
                              snapshot.data![index].contest!.pricelst,
                              snapshot.data![index].contest!.winner.toString(),
                              snapshot.data![index].id,
                              snapshot.data![index].contest!.prizepool,
                              "Joined",
                              snapshot.data![index].contest!.entryleft,
                              '${snapshot.data![index].contest!.entrycount} spot',
                              snapshot.data![index].contest!.winner,
                              (int.parse(snapshot
                                          .data![index].contest!.entrycount!) /
                                      int.parse(snapshot.data![index].contest!
                                          .entrycapacity!)) *
                                  100),
                        ))));
          } else {
            return Text("NO Data");
          }
        }),
      ),
    );
  }

  Widget contestnt(
    List? lst,
    String? winner,
    String? id,
    String? txt1,
    String? txt2,
    String? txt3,
    String? txt4,
    String? txt5,
    double? progress,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Prize Pool',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '৳${txt1!}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Winners',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      txt5!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AllCoustomTheme.getThemeData().primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 14, left: 14, top: 4, bottom: 4),
                        child: Text(
                          "Joined",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).canvasColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: progress!,
            linearStrokeCap: LinearStrokeCap.roundAll,
            backgroundColor:
                AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
            progressColor: AllCoustomTheme.getThemeData().primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  txt3! + 'spot left',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400],
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  txt4!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400],
                  ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                lst == null
                                    ? Text("")
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: lst.length,
                                        itemBuilder: ((context, index) =>
                                            Column(
                                              children: [
                                                ListTile(
                                                    leading: SizedBox(
                                                        height: 16,
                                                        child: Image.asset(
                                                            'assets/badge.png')),
                                                    title: Text(
                                                      'Rank ${index + 1}',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    trailing:
                                                        Text('${lst[index]}')),
                                                const Divider(
                                                  height: 0,
                                                )
                                              ],
                                            ))),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                              ],
                            );
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          ConstanceData.trophy,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Total Winners $winner",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          'assets/arrow_down.png',
                          height: 23,
                        ),
                      ],
                    ),
                  )
                  // Image.asset(
                  //   ConstanceData.guaranteed,
                  //   height: 16,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contest(context_list clst) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          ),
                          Text(
                            '৳${clst.prizepool.toString()}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: ConstanceData.SIZE_TITLE20,
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
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          ),
                          Text(
                            '${clst.entryleft}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: HexColor(
                                '#AAAFBC',
                              ),
                              fontSize: ConstanceData.SIZE_TITLE14,
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
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          ),
                          Text(
                            '৳${clst.entryfee}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 24,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            '${clst.winner} WINNER',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: ConstanceData.SIZE_TITLE12,
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
                child: contestsListData(clst.id!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ScrollController _scrollController = new ScrollController();
  TabController? controller;
  final PageController pageController = PageController(initialPage: 0);

  Widget contestsListData(String cntxtid) {
    usercontestrankingbloc.contxtid = cntxtid;

    usercontestrankingbloc.eventusercontextrankingsink
        .add(UserContextRanking_Action.Fetch);
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: ContestTabHeader(controller!),
          // ),
        ];
      },
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 50,
                color: AllCoustomTheme.getTextThemeColors().withOpacity(0.1),
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'view all teams \nafter the deadline',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE12,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                      Container(
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            width: 150,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AllCoustomTheme.getThemeData()
                                  .backgroundColor,
                              borderRadius: new BorderRadius.circular(4.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AllCoustomTheme
                                            .getBlackAndWhiteThemeColors()
                                        .withOpacity(0.3),
                                    offset: Offset(0, 1),
                                    blurRadius: 5.0),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Download Teams ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE10,
                                          color: AllCoustomTheme
                                              .getTextThemeColors()),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.file_download,
                                      color:
                                          AllCoustomTheme.getTextThemeColors(),
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Expanded(
                  child: StreamBuilder<List<UserContextRanking>>(
                      stream: usercontestrankingbloc.usercontextrankingstream,
                      builder: ((context, snapshot) {
                        if (usercontestrankingbloc.lst.length > 0) {
                          return usercontestrankingbloc.lst.length > 0
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14, top: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'ALL TEAMS',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: HexColor('#AAAFBC'),
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'POINTS',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: HexColor('#AAAFBC'),
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Text(
                                                'RANK',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: HexColor('#AAAFBC'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: usercontestrankingbloc
                                              .lstteam.length,
                                          itemBuilder: ((context, index) =>
                                              Container(
                                                color: AllCoustomTheme
                                                        .getThemeData()
                                                    .primaryColor
                                                    .withOpacity(0.2),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14,
                                                          right: 14,
                                                          top: 4),
                                                  child: Row(
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Image.asset(
                                                          ConstanceData
                                                              .userAvatar,
                                                        ),
                                                      ),
                                                      Text(
                                                        usercontestrankingbloc
                                                            .lstteam[index].name
                                                            .toString(),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          usercontestrankingbloc
                                                              .lst[index].score
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
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '#${index + 1}',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ))),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    children: <Widget>[
                                      Text(
                                        'No team has joined this contest yet',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset(ConstanceData.users),
                                      ),
                                      Container(
                                        child: Text(
                                          'Be the first one to join this contest & start winning!',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE14,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print('waiting.....');
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Text(
                            'No Data',
                            style: TextStyle(fontSize: 30),
                          );
                        }
                      })))
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: 8, left: 8, top: 4),
            child: Text(
              'Note: The actual prize money may be different than the prize money mentioned above if there is a tie for any of the winning position. Check FQAs for further details.as per government regulations, a tax of 31.2% will be deducted if an individual wins more than Rs. 10,000',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AllCoustomTheme.getTextThemeColors(),
                fontSize: ConstanceData.SIZE_TITLE14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget playerPoint() {
    return Column(children: [
      Container(
        height: 24,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Players",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ConstanceData.SIZE_TITLE12,
                  color: HexColor(
                    '#AAAFBC',
                  ),
                ),
              ),
              Text(
                'POINTS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ConstanceData.SIZE_TITLE12,
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
          child: ListView.builder(
              itemCount: widget.lstteam1!.length + widget.lstteam2!.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemBuilder: ((context, index) => index < widget.lstteam1!.length
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, right: 14),
                      child: Column(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    widget.lstteam1![index].img.toString()),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${widget.lstteam1![index].name}',
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
                                '${widget.lstteam1![index].rating}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider()
                      ]))
                  : Padding(
                      padding: const EdgeInsets.only(top: 10, right: 14),
                      child: Column(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30.0,
                                backgroundImage: NetworkImage(widget
                                    .lstteam2![index - widget.lstteam1!.length]
                                    .img
                                    .toString()),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${widget.lstteam2![index - widget.lstteam1!.length].name}',
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
                                '${widget.lstteam2![index - widget.lstteam1!.length].rating}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider()
                      ])))))
    ]);
  }

  int pageNumber = 0;
}
