// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempalteflutter/api/apiProvider.dart';
import 'package:tempalteflutter/api/logout.dart';
import 'package:tempalteflutter/constance/constance.dart';
import 'package:tempalteflutter/constance/global.dart';
import 'package:tempalteflutter/constance/sharedPreferences.dart';
import 'package:tempalteflutter/constance/themes.dart';
import 'package:tempalteflutter/models/userData.dart';
import 'package:tempalteflutter/modules/home/homeScreen.dart';
import 'package:tempalteflutter/modules/myProfile/paymenthistory.dart';
import 'package:tempalteflutter/modules/myProfile/transectionHistoryScreen.dart';
import 'package:tempalteflutter/modules/myProfile/updateProfileScreen.dart';
import 'package:tempalteflutter/modules/pymentOptions/pymentOptionsScreen.dart';
import 'package:tempalteflutter/modules/pymentOptions/withdrawScreen.dart';
import 'package:tempalteflutter/utils/avatarImage.dart';

var responseData;

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  double _appBarHeight = 100.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  var name = '';
  var bkash = '';
  var imageUrl = '';
  ScrollController _scrollController = new ScrollController();

  var data;

  @override
  void initState() {
    getUserData();
    super.initState();

    var profileData = ApiProvider().getProfile();
    if (profileData != null && profileData.data != null) {
      final txt = profileData.data!.name!.trim().split(' ');
      name = txt[0][0].toUpperCase() + txt[0].substring(1, txt[0].length);
      imageUrl = profileData.data!.image!;
      MySharedPreferences().setUserDataString(profileData.data!);
    }
    setState(() {
      name = userdata!.name.toString();
      bkash = userdata!.bkashNumber.toString();
    });
  }

  void getUserData() async {
    var responseData = ApiProvider().getProfile();
    data = userdata!; // responseData.data;
    setState(() {});
  }

  refresh() async {
    print('RELOAD');
    userdata = await MySharedPreferences().getUserData();
    setState(() {
      name = userdata!.name.toString();
      bkash = userdata!.bkashNumber.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 3
      child: Stack(
        children: [
          Container(
            color: AllCoustomTheme.getThemeData().primaryColor,
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              appBar: AppBar(
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 44,
                        width: 44,
                        child: AvatarImage(
                          sizeValue: 44,
                          radius: 44,
                          isCircle: true,
                          imageUrl:
                              "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1534&q=80",
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        userdata!.name.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AllCoustomTheme.getThemeData().backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Text(
                        "আমার তথ্য",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "ম্যাচসমূহ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Tab(
                    //   icon: Text(
                    //     "ওয়ালেট",
                    //     style: TextStyle(
                    //       fontFamily: 'Poppins',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: FloatingActionButton.extended(
                  foregroundColor:
                      AllCoustomTheme.getThemeData().backgroundColor,
                  backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateProfileScreen(userdata!, refresh),
                      ),
                    );
                    getUserData();
                  },
                  label: Text('আপডেট'),
                  icon: Icon(Icons.edit),
                ),
              ),
              body: Container(
                color: AllCoustomTheme.getThemeData().backgroundColor,
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(0),
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'নাম',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        userdata!.name.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'ইমেইল',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        userdata!.email.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'মোবাইল নম্বর',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        userdata!.mobileNumber.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'ঠিকানা',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        userdata!.address.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'বিকাশ নম্বর',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        bkash,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                color: AllCoustomTheme.getThemeData()
                                    .primaryColor
                                    .withOpacity(0.2),
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "ব্যালেন্স",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE16,
                                          fontWeight: FontWeight.bold,
                                          color: AllCoustomTheme.getThemeData()
                                              .primaryColor,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: ConstanceData.SIZE_TITLE22,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'মোট কয়েন',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PymentScreen(
                                              isOnlyAddMoney: true,
                                              isTruePayment: () {},
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
                                        decoration: new BoxDecoration(
                                          color: AllCoustomTheme.getThemeData()
                                              .backgroundColor,
                                          borderRadius:
                                              new BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1,
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 1),
                                                blurRadius: 5.0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'কয়েন কিনুন',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.green,
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        userdata!.totalCoin.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      child: Text(
                                        'মোট জিতেছেন (৳)',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                          color: AllCoustomTheme
                                              .getTextThemeColors(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WithdrawScreen(),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
                                        decoration: new BoxDecoration(
                                          color: AllCoustomTheme.getThemeData()
                                              .backgroundColor,
                                          borderRadius:
                                              new BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1,
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 1),
                                                blurRadius: 5.0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'কয়েন রিডিম'.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.green,
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WithdrawScreen(),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
                                        decoration: new BoxDecoration(
                                          color: AllCoustomTheme.getThemeData()
                                              .backgroundColor,
                                          borderRadius:
                                              new BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1,
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 1),
                                                blurRadius: 5.0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'টাকা তুলুন'.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.green,
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        '৳ ' +
                                            userdata!.winningBalance.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          // TransectionHistoryScreen(),
                                          PaymentHistory(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor
                                          .withOpacity(0.3),
                                      padding:
                                          EdgeInsets.only(left: 16, right: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "পেমেন্ট তালিকা",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE16,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                        .getThemeData()
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right,
                                            size: ConstanceData.SIZE_TITLE22,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor,
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
                              // logoutButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    PlayingHistory(),
                    // Wallet(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget logoutButton() {
    return Container(
      height: 30,
      child: InkWell(
        onTap: () {
          LogOut().logout(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.powerOff,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                      fontSize: ConstanceData.SIZE_TITLE14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliverText() {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 8, top: 0),
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            width: 44,
            child: AvatarImage(
              sizeValue: 44,
              radius: 44,
              isCircle: true,
              imageUrl:
                  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1534&q=80",
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Enric',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AllCoustomTheme.getThemeData().backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountInfoScreen extends StatefulWidget {
  final Function? update;

  const AccountInfoScreen({Key? key, this.update}) : super(key: key);
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool isLoginProsses = false;
  UserData data = UserData();
  var name = '';
  var bkash = '';

  @override
  void initState() {
    super.initState();
    getUserData();
    name = userdata!.name.toString();
    bkash = userdata!.bkashNumber.toString();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });
    var responseData = ApiProvider().getProfile();
    data = userdata!;
    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            child: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              color: Colors.transparent,
              progressIndicator: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                physics: BouncingScrollPhysics(),
                child: data.name != ''
                    ? Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Enric",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "enric@gmail.com",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Mobile No',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "+91 1234567890",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      DateFormat('dd MMM, yyyy').format(
                                          DateFormat('dd/MM/yyyy')
                                              .parse(data.dob!)),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      data.gender![0].toUpperCase() +
                                          data.gender!.substring(1),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Country',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'US',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'State',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      data.state!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'City',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      data.city!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: ConstanceData.SIZE_TITLE16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            logoutButton(),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: -10, right: 30),
            child: FloatingActionButton(
              foregroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
              onPressed: () async {
                if (data.name != '') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(
                        data,
                        refresh,
                      ),
                    ),
                  );
                  getUserData();
                  widget.update!();
                }
              },
              tooltip: 'পোফাইল আপডেট করুন',
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  refresh() async {
    print('RELOAD');
    userdata = await MySharedPreferences().getUserData();
    setState(() {
      name = userdata!.name.toString();
      bkash = userdata!.bkashNumber.toString();
    });
  }

  Widget logoutButton() {
    return Container(
      height: 30,
      child: InkWell(
        onTap: () {
          LogOut().logout(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.powerOff,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                      fontSize: ConstanceData.SIZE_TITLE14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayingHistory extends StatefulWidget {
  @override
  _PlayingHistoryState createState() => _PlayingHistoryState();
}

class _PlayingHistoryState extends State<PlayingHistory> {
  bool isLoginProsses = false;
  UserData data = UserData();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });
    var responseData = ApiProvider().getProfile();
    if (responseData != null && responseData.data != null) {
      data = userdata!;
    }
    if (!mounted) return;
    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Center(
        child: ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'কন্টেস্ট',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '40',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'ম্যাচ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'সিরিজ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '4',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'জয়',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '5',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoginProsses = false;
  UserData data = UserData();
  bool emialApproved = false;
  bool pancardApproved = false;
  bool bankApproved = false;
  bool allApproved = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });

    var responseData = ApiProvider().getProfile();

    if (responseData != null && responseData.data != null) {
      data = userdata!; //responseData.data!;
    }

    var email = userdata!.email.toString().isNotEmpty
        ? true
        : await ApiProvider().getEmailResponce();

    // if ('Your E-mail and Mobile Number are Verified.' == email.message ) {
    //   emialApproved = true;
    // }
    if (userdata!.email.toString().isNotEmpty) {
      emialApproved = true;
    }

    var pancard = await ApiProvider().getPanCardResponce();

    if (pancard.success == '1') {
      if (pancard.pancardDetail != null) {
        if (pancard.pancardDetail!.length > 0) {
          if (pancard.pancardDetail![0].pancardNo != '') {
            if ('Your Pan Card Verification Has been Approved' ==
                pancard.message) {
              pancardApproved = true;
            }
          }
        }
      }
    }

    var bankData = await ApiProvider().bankListApprovedResponseData();
    if (bankData.success == 1) {
      if (bankData.accountDetail != null) {
        if (bankData.accountDetail!.length > 0) {
          bankApproved = true;
        }
      }
    }

    if (emialApproved && pancardApproved && bankApproved) {
      allApproved = true;
    }

    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Center(
        child: ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: data.name != ''
              ? Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          right: 16, left: 16, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'আমার কয়েন',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: ConstanceData.SIZE_TITLE16,
                              color: AllCoustomTheme.getTextThemeColors(),
                            ),
                          ),
                          Text(
                            userdata!.totalCoin.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: ConstanceData.SIZE_TITLE16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(
                          right: 16, left: 16, top: 4, bottom: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Winning',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WithdrawScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              decoration: new BoxDecoration(
                                color: AllCoustomTheme.getThemeData()
                                    .backgroundColor,
                                borderRadius: new BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 1),
                                      blurRadius: 5.0),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'withdraw'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.green,
                                    fontSize: ConstanceData.SIZE_TITLE14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              '৳ 100',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    !allApproved
                        ? Container(
                            padding: EdgeInsets.only(top: 4),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Verify your account to be eligible to withdraw.      ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE12,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(
                          right: 16, left: 16, top: 8, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Bonus',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '৳' + data.cashBonus!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransectionHistoryScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            color: AllCoustomTheme.getThemeData()
                                .primaryColor
                                .withOpacity(0.2),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "My Transactions",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: ConstanceData.SIZE_TITLE16,
                                      fontWeight: FontWeight.bold,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: ConstanceData.SIZE_TITLE22,
                                  color: AllCoustomTheme.getThemeData()
                                      .primaryColor,
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
                  ],
                )
              : SizedBox(),
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
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AllCoustomTheme.getThemeData().primaryColor,
            ),
            tabs: [
              new Tab(text: 'Account Info'),
              new Tab(text: 'Playing History'),
              new Tab(text: 'Wallet'),
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
