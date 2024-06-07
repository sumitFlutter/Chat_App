import 'package:shared_preferences/shared_preferences.dart';

class ShareHelper{
  void saveTheme({required bool pTheme}) async {
    SharedPreferences s1 = await SharedPreferences.getInstance();
    s1.setBool("theme", pTheme);
  }

  Future<bool?> applyTheme() async {
    SharedPreferences s1 = await SharedPreferences.getInstance();
    s1.getBool("theme");
    return s1.getBool("theme");
  }
}