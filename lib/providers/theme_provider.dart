import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/utils/const.dart';

class AppThemeProvider extends ChangeNotifier {
  AppThemeProvider() {
    checkTheme();
  }

  ThemeData theme = Const.lightTheme;
  bool isDark = true;

  checkTheme() {
    SharedPreferences.getInstance().then(
      (pref) {
        String appTheme = pref.getString('theme') ?? 'dark';
        if (appTheme == 'light') {
          theme = Const.lightTheme;
          isDark = false;
        } else {
          theme = Const.darkTheme;
          isDark = true;
        }
      },
    );

    notifyListeners();
  }

  bool getThemeMode() => isDark;

  setAppTheme(String mode) async {
    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setString('theme', '$mode');
        if (mode == 'light') {
          theme = Const.lightTheme;
          isDark = false;
        } else {
          theme = Const.darkTheme;
          isDark = true;
        }

        notifyListeners();
      },
    );
  }
}
