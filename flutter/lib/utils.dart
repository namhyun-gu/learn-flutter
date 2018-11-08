import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final String _prefUserId = "pref_user_id";

  static Future<String> getUserIdFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefUserId);
  }
}
