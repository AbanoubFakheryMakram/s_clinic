import 'package:flutter/material.dart';

class Const {
  static  ThemeData lightTheme = ThemeData(    
    backgroundColor: Colors.white,
    accentColor:  Colors.blue,
    cursorColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );

 static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Color(0xff1E1E1E),
    accentColor: Color(0xff5CC991),
    scaffoldBackgroundColor: Color(0xff1E1E1E),
    cursorColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );

  static List<Map<String, String>> specializations = [
    {
      "display": "Heart",
      "value": "Heart",
    },
    {
      "display": "Dentist",
      "value": "Dentist",
    },
    {
      "display": "Bones",
      "value": "Bones",
    },
    {
      "display": "Chest",
      "value": "Chest",
    },
    {
      "display": "Urologist",
      "value": "Urologist",
    },
    {
      "display": "Internist",
      "value": "Internist",
    },
    {
      "display": "Neurologists",
      "value": "Neurologists",
    },
    {
      "display": "Blood vessels",
      "value": "Blood vessels",
    },
    {
      "display": "Ear, Nose and Throat",
      "value": "Ear, Nose and Throat",
    },
  ];

  static List<Map<String, String>> degress = [
    {
      "display": "Doctor",
      "value": "Doctor",
    },
    {
      "display": "Professor Dr",
      "value": "Professor Dr",
    },
    {
      "display": "M.A.",
      "value": "M.A.",
    },
    {
      "display": "Ph.D.",
      "value": "Ph.D.",
    },
    {
      "display": "Doctor assistant",
      "value": "Doctor assistant",
    },
    {
      "display": "Specialist",
      "value": "Specialist",
    },
    {
      "display": "Head of the Department",
      "value": "Head of the Department",
    },
    {
      "display": "Assistant Professor",
      "value": "Assistant Professor",
    },
  ];
}
