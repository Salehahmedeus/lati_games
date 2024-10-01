import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkmodeProvider with ChangeNotifier {
  bool isDark = false;
  switchmode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = !isDark;
    prefs.setBool("isDark", isDark);
    notifyListeners();
  }

  getMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    notifyListeners();
  }
}
