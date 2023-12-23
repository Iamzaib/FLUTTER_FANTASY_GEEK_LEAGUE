import 'package:tempalteflutter/bloc/Matches/matches.dart';

class ConstanceData {
  static const ServerURL = 'https://api.fantasygeek.xyz';
  // static const ServerURL = 'http://192.168.0.108:8000';
  static const getContest = '$ServerURL/api/contests?fixture_id';
  static const getMatches = '$ServerURL/api/fixtures';
  static const getSingleTeam = '$ServerURL/api/teams/';
  static const getStandingScreens = '$ServerURL/api/users/';
  static const getUpcomingFixtures = '$ServerURL/api/fixtures/upcoming';
  static const getUserContestbyFixtureId = '$ServerURL/api/user/';
  static const getUserContest =
      '$ServerURL/api/usercontests/ranking?contest_id=';
  static const getAllTeam = '$ServerURL/api/userfixtureteams?';
  static const joinContest = '$ServerURL/api/usercontests';
  static const createContest = '$ServerURL/api/contests';
  static const createTeam = '$ServerURL/api/teams';
  static const UserImageUrl =
      'http://starsportsfantasy.com/Fantasy/image/user/';
  static const urlPlayerStats = "$ServerURL/api/usercontests/scorecard?";
  static const urlPlayerPoints = "$ServerURL/api/usercontests?";

  static const PASSWORD_MIN_LENGTH = 6;
  static const TermsofService = 'https://innovabd.tech/';
  static const PrivacyPolicy = 'https://innovabd.tech/';
  static const Ligality = 'https://starsportsfantasy.com/Fantasy/ligality';
  static const HowItWork = '';
  static const PointSystem = '';

  static const NoInternet = 'No internet connection\nPlease!. try again later.';

  static const SIZE_TITLE10 = 10.0;
  static const SIZE_TITLE12 = 12.0;
  static const SIZE_TITLE14 = 14.0;
  static const SIZE_TITLE16 = 16.0;
  static const SIZE_TITLE18 = 18.0;
  static const SIZE_TITLE20 = 20.0;
  static const SIZE_TITLE22 = 22.0;

  static const Usertoken = 'Usertoken';
  static const UserData = 'UserData';
  static const Is_login = 'Is_login';
  static const phoneNumber = '';

  static final appIcon =
      'https://www.menshairstylesnow.com/wp-content/uploads/2018/03/Hairstyles-for-Square-Faces-Slicked-Back-Undercut.jpg';
  static final cricketGround = 'assets/cricketGround.png';
  static final cupImage = 'assets/cup.png';
  static final playerImage = 'assets/playerImage.png';
  static final ruppeIcon = 'assets/ruppeIcon.png';
  static final userAvatar = 'assets/userAvatar.png';
  static final pts = 'assets/pts.png';
  static final greencup = 'assets/greencup.png';
  static final users = 'assets/users.png';
  static final arrowE = 'assets/arrowE.png';
  static final arrowG = 'assets/arrowG.png';
  static final arrowL = 'assets/arrowL.png';
  static final notificationCup = 'assets/notificationCup.png';
  static final lineups = 'assets/lineups.png';
  static final tv = 'assets/tv.png';
  static final wallet = 'assets/wallet.png';
  static final g1 = 'assets/g1.png';
  static final dhoni = 'assets/cname/123.png';
  static final virat = 'assets/cname/119.png';
  static final prize = 'assets/prize.png';
  static final guaranteed = 'assets/guaranteed.png';
  static final trophy = 'assets/trophy.png';

  static final palyerProfilePic = "assets/playerProfilePic.jpg";
  static final cricketPlayer = "assets/cricketPlayer.jpg";
  static final footballPlayer = "assets/footballPlayer.jpg";
  static final kabadiplayer = "assets/kabadiplayer.jpg";
}

final matchbloc = MatchesBloc();
