import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference{
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier{
  ThemePreference themePreference = ThemePreference();
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  Brightness get theme =>  _darkTheme == true ? Brightness.dark : Brightness.light;

  set darkTheme(bool value) {
    _darkTheme = value;
    themePreference.setDarkTheme(value);
    notifyListeners();
  }
}
