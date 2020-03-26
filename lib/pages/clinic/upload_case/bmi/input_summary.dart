import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gender_card.dart';

class InputSummaryCard extends StatelessWidget {
  final GenderType gender;
  final int height;
  final int weight;

  const InputSummaryCard({Key key, this.gender, this.height, this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(16.0),
          left: ScreenUtil().setHeight(16.0),
          right: ScreenUtil().setHeight(16.0)),
      child: SizedBox(
        height: ScreenUtil().setHeight(32.0),
        child: Row(
          children: <Widget>[
            Expanded(child: _genderText()),
            _divider(),
            Expanded(child: _text("${weight}kg")),
            _divider(),
            Expanded(child: _text("${height}cm")),
          ],
        ),
      ),
    );
  }

  Widget _genderText() {
    String genderText = gender == GenderType.other
        ? '-'
        : (gender == GenderType.male ? 'Male' : 'Female');
    return _text(genderText);
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(143, 144, 156, 1.0),
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _divider() {
    return Container(
      width: 1.0,
      color: Color.fromRGBO(151, 151, 151, 0.1),
    );
  }
}
