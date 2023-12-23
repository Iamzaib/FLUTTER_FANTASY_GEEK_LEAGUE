// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tempalteflutter/bloc/MyTeam/Myteam.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/Context/context.dart';
import 'package:tempalteflutter/models/Team/getteam.dart';
import 'package:tempalteflutter/models/UserContext/usercontestranking.dart';
import 'package:tempalteflutter/modules/contests/TeamDetails.dart';
import 'package:tempalteflutter/validator/validator.dart';

import '../../bloc/usercontest/usercontestrank.dart';
import 'contestsScreen.dart';

class InsideContest extends StatefulWidget {
  final ContestsScreen cs;
  final context_list cl;
  bool isjoin;
  final String? matchstatus;
  InsideContest({
    Key? key,
    required this.isjoin,
    required this.cs,
    required this.cl,
    required this.matchstatus,
  }) : super(key: key);
  @override
  _InsideContestState createState() => _InsideContestState();
}

class _InsideContestState extends State<InsideContest>
    with SingleTickerProviderStateMixin {
  bool iscontestsProsses = false;
  bool ismyteam = false;
  ScrollController _scrollController = new ScrollController();
  late TabController controller;
  final usercontestrankingbloc = UserContextRankingBloc();
  MyTeamBloc mtb = MyTeamBloc();

  @override
  void initState() {
    usercontestrankingbloc.contxtid = widget.cl.id;
    mtb.fixtureid = widget.cl.fixtureid;
    getdata();
    usercontestrankingbloc.lst = [];
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }

  getdata() {
    mtb.eventmyteamsink.add(MyTeamAction.FetchTeam);
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
              body: RefreshIndicator(
                onRefresh: () async {
                  usercontestrankingbloc.eventusercontextrankingsink
                      .add(UserContextRanking_Action.Fetch);
                },
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
                                          'Contests',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                ConstanceData.SIZE_TITLE22,
                                            fontWeight: FontWeight.bold,
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
                              MatchHadderr(
                                cs: widget.cs,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: ModalProgressHUD(
                            inAsyncCall: iscontestsProsses,
                            color: Colors.transparent,
                            progressIndicator: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                            child: Container(
                              child: contestsData(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contestsData() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
          child: Column(
            children: <Widget>[
              Row(
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
                        height: 4,
                      ),
                      Text(
                        '৳${widget.cl.prizepool}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
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
                      SizedBox(height: 4),
                      Text(
                        '${widget.cl.winner}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          'Entry',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AllCoustomTheme.getTextThemeColors(),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 30,
                        width: 90,
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            widget.isjoin ? "Joined" : '৳${widget.cl.entryfee}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              backgroundColor:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              LinearPercentIndicator(
                lineHeight: 6,
                percent: (int.parse(widget.cl.entrycount!) /
                        int.parse(widget.cl.entrycapacity!)) *
                    100,
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor:
                    AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
                progressColor: AllCoustomTheme.getThemeData().primaryColor,
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${widget.cl.entryleft} spot left',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[400]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Divider(
                color: AllCoustomTheme.getThemeData().primaryColor,
              ),
            ],
          ),
        ),
        Expanded(child: contestsListData())
      ],
    );
  }

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
          widget.matchstatus == "0" ? team() : dowunloadbar(),
          widget.matchstatus == "0" ? team() : myteam(),
          prizeBreackup(),
        ],
      ),
    );
  }

  Widget prizeBreackup() {
    return Padding(
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
                          '# $index',
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
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }

  Widget dowunloadbar() {
    return Column(
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
                        color: AllCoustomTheme.getThemeData().backgroundColor,
                        borderRadius: new BorderRadius.circular(4.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors()
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
                                    color:
                                        AllCoustomTheme.getTextThemeColors()),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.file_download,
                                color: AllCoustomTheme.getTextThemeColors(),
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
        Container(
          padding: EdgeInsets.only(left: 10, top: 4, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                'All Teams',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AllCoustomTheme.getTextThemeColors(),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
            child: FutureBuilder<List<UserContextRanking>>(
                future:
                    usercontestrankingbloc.getUserContextRanking(widget.cl.id!),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return usercontestrankingbloc.lst.length > 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 4),
                                child: Row(
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
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        usercontestrankingbloc.lst.length,
                                    itemBuilder: ((context, index) => InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        TeamDetails(
                                                  ucontestid: widget.cl.id,
                                                  ucr: snapshot.data![index],
                                                ),
                                              )),
                                          child: Container(
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor
                                                    .withOpacity(0.2),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6, top: 4),
                                                  child: ListTile(
                                                      leading: Container(
                                                        width: MediaQuery.of(
                                                                    context)
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
                                                              child:
                                                                  Image.asset(
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
                                                                            0,
                                                                            20)
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
                                                        width: MediaQuery.of(
                                                                    context)
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
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      )),
                                                ),
                                                const Divider(
                                                  height: 0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ))),
                              ),
                              const SizedBox(
                                height: 20,
                              )
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
                                    color: AllCoustomTheme.getTextThemeColors(),
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
                                      fontSize: ConstanceData.SIZE_TITLE14,
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
    );
  }

  Widget team() {
    return Center(
      child: Text(
        'Match has not started yet',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ConstanceData.SIZE_TITLE18,
          color: AllCoustomTheme.getTextThemeColors(),
        ),
      ),
    );
  }

  Widget myteam() {
    return Column(
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
                        color: AllCoustomTheme.getThemeData().backgroundColor,
                        borderRadius: new BorderRadius.circular(4.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors()
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
                                    color:
                                        AllCoustomTheme.getTextThemeColors()),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.file_download,
                                color: AllCoustomTheme.getTextThemeColors(),
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
        Container(
          padding: EdgeInsets.only(left: 10, top: 4, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                'All Teams',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AllCoustomTheme.getTextThemeColors(),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
            child: FutureBuilder<List<UserContextRanking>>(
                future:
                    usercontestrankingbloc.getUserContextRanking(widget.cl.id!),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                width: MediaQuery.of(context).size.width * 0.3,
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
                                ismyteam = false;
                                mtb.lstteam.forEach((element) {
                                  if (element.id ==
                                      snapshot.data![index].teamid) {
                                    ismyteam = true;
                                  }
                                });
                                return ismyteam
                                    ? Container(
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
                                      )
                                    : Text('');
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
                })))
      ],
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  ContestTabHeader(this.controller);

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
                Tab(text: 'Leaderboard'),
                Tab(text: 'MyTeam'),
                Tab(text: 'Prize Breakup'),
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

class MatchHadderr extends StatelessWidget {
  final ContestsScreen cs;

  const MatchHadderr({
    Key? key,
    required this.cs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 36,
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  child: Image.network('${cs.country1Flag}'),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    cs.country1Name!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontSize: ConstanceData.SIZE_TITLE12,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'vs',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ConstanceData.SIZE_TITLE12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    cs.country2Name!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontSize: ConstanceData.SIZE_TITLE12,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  child: Image.network('${cs.country2Flag}'),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Container(
                  child: Text(
                    cs.time!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: HexColor(
                        '#AAAFBC',
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
