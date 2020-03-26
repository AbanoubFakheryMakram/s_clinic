import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/pages/auth/login.dart';
import 'package:smart_clinic/pages/home.dart';

import 'my_test_file.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SharedPreferences.getInstance().then(
    (pref) {
      runApp(
        MyApp(
          pref.getString('userSSN') ?? '',
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final String userSSN;

  MyApp(this.userSSN);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Clinic',
      home: Builder(
        builder: (context) {
          ScreenUtil.init(
            context,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            allowFontScaling: true,
          );
          return Scaffold(
            body: userSSN == '' ? LoginPage() : HomePage(userSSN: userSSN),
          );
        },
      ),
    );
  }
}
