import 'package:shared_preferences/shared_preferences.dart';

class FirstLaunchSharedPreference {
  static setLaunch(bool decision) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('firstLaunch', decision);
  }

  static firsGoogleSignIn(bool decision) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('firstGoogle', decision);
  }

  static Future<bool> getLaunch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool first_launch = preferences.getBool('firstLaunch');
    print(first_launch);
    return first_launch;
  }

  static Future<bool> firstGoogle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool firstGoogle = preferences.getBool('firstGoogle');
    print(firstGoogle);
    return firstGoogle;
  }

  static setNotiStatus(bool decision) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('notification', decision);
  }

  static Future<bool> getNotiStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool notiStatus = preferences.getBool('notification');
    return notiStatus;
  }
}
