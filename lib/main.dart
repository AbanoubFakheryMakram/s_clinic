import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/pages/auth/login.dart';
import 'package:smart_clinic/pages/home.dart';
import 'package:smart_clinic/providers/theme_provider.dart';
import 'package:smart_clinic/utils/const.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppThemeProvider(),
        ),
      ],
      child: Consumer<AppThemeProvider>(
        builder:
            (BuildContext context, AppThemeProvider appTheme, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Clinic',
            theme: appTheme.isDark ? Const.darkTheme : Const.lightTheme,
            home: Builder(
              builder: (context) {
                ScreenUtil.init(
                  context,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  allowFontScaling: true,
                );
                return Scaffold(
                  body:
                      userSSN == '' ? LoginPage() : HomePage(userSSN: userSSN),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
