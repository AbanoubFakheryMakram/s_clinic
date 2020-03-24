import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appTheme, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.language,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Language',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Englsh',
                  textAlign: TextAlign.left,
                ),
              ),
              ListTile(
                onTap: () {
                  print(appTheme.isDark);
                  if (appTheme.isDark) {
                    appTheme.setAppTheme('light');
                  } else {
                    appTheme.setAppTheme('dark');
                  }
                },
                leading: Icon(
                  Icons.color_lens,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Theme',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: appTheme.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  appTheme.isDark ? 'Dark' : 'Light',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
