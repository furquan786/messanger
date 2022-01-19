import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sharedprefference {
  static String userloggedinkey = 'Userloggedin';
  static String usernamekey = 'Username';
  static String usermailkey = 'Usermail';

  static Future<bool> savedloggedinuser(bool isuserloggedin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(userloggedinkey, isuserloggedin);
  }

  static Future<bool> savedusername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usernamekey, username);
  }

  static Future<dynamic> savedusermail(String usermail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usermailkey, usermail);
  }

  static Future<bool?> getloggedinuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
      userloggedinkey,
    );
  }

  static Future<String?> getusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernamekey);
  }

  static Future<String?> getusermail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usermailkey);
  }
}
