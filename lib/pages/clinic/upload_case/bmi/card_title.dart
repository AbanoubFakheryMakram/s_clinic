import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  CardTitle({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(8),
            bottom: ScreenUtil().setHeight(8),
            left: ScreenUtil().setHeight(11),
            right: ScreenUtil().setHeight(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: _titleStyle,
              ),
              Text(
                subtitle ?? "",
                style: _subtitleStyle,
              )
            ],
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  TextStyle _titleStyle = TextStyle(
      fontSize: 16.0,
      color: Color.fromRGBO(14, 24, 35, 1.0),
      fontFamily: 'Baloo');

  TextStyle _subtitleStyle = TextStyle(
    fontSize: 11.0,
    color: Color.fromRGBO(143, 144, 156, 1.0),
  );
}
