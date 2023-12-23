import 'package:http/http.dart' as http;
import '../constance/constance.dart';

class CreateContextAPI {
  //https://api.fantasygeek.xyz/api/contests
  String baseurl = ConstanceData.ServerURL;
  Future<String> post(Map data) async {
    bool isstatus = false;
    var response = await http
        .post(Uri.parse('${ConstanceData.createContest}'), body: data)
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 201) {
        isstatus = true;
      }
    });
    if (isstatus) {
      return "okay";
    } else {
      return "Something went wrong";
    }
  }
}
