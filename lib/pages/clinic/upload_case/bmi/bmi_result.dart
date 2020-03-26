import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/animation/domino_reveal.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/clinic/upload_case/symptoms.dart';
import 'calculator.dart' as calculator;
import 'gender_card.dart';

class BMIResultPage extends StatefulWidget {
  final int height;
  final int weight;
  final GenderType gender;

  const BMIResultPage({Key key, this.height, this.weight, this.gender})
      : super(key: key);

  @override
  _BMIResultPageState createState() => _BMIResultPageState();
}

class _BMIResultPageState extends State<BMIResultPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ResultCard(
              bmi: getBMI(),
              minWeight:
                  calculator.calculateMinNormalWeight(height: widget.height),
              maxWeight:
                  calculator.calculateMaxNormalWeight(height: widget.height),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  double getBMI() {
    Pointer.currentPost.patient_height = '${widget.height}';
    Pointer.currentPost.patient_weight = '${widget.weight}';
    Pointer.currentPost.patient_gender =
        widget.gender == GenderType.male ? 'Male' : 'Female';
    Pointer.currentPost.patient_height = '${widget.height}';

    double bmi =
        calculator.calculateBMI(height: widget.height, weight: widget.weight);

    Pointer.currentPost.patient_bmi = '$bmi';

    return bmi;
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DominoReveal(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 52.0,
                  width: 80.0,
                  child: RaisedButton(
                    child: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(15),
                ),
                Container(
                  height: 52.0,
                  width: 80.0,
                  child: RaisedButton(
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Symptoms(),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final double bmi;
  final double minWeight;
  final double maxWeight;

  ResultCard({Key key, this.bmi, this.minWeight, this.maxWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 8.0,
          margin:
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Container(
              width: double.infinity,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    top: ScreenUtil().setHeight(10),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Text(
                    'Body mass index (BMI) is a measure of body fat based on height and weight that applies to adult men and women',
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '🔥',
                  style: TextStyle(fontSize: 80.0),
                ),
                Text(
                  bmi.toStringAsFixed(1),
                  style:
                      TextStyle(fontSize: 140.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'BMI = ${bmi.toStringAsFixed(2)} kg/m²',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 5, right: 5),
                  child: Text(
                    'The normal healthy range is between 18.5 to 24.9 kg/m2 for people who are in 18 years old to 60 years old',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
            ),
          ),
        ),
        Card(
          elevation: 4.0,
          margin:
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 5),
          child: Container(
            height: ScreenUtil().setHeight(50),
            width: double.infinity,
            child: Center(
              child: Text(
                'Your are ${getUserState(bmi)}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getUserState(bmi) {
    if (bmi >= 18.5 && bmi <= 24.9) {
      return 'in normal range ☺️\nKeep on this';
    } else if (bmi < 18.5) {
      return 'underweight 😋\nYou need to eat little more';
    } else if (bmi > 24.9 && bmi <= 29.1) {
      return 'overweight 😕\nYou need to take care about your weight';
    } else if (bmi > 24.9 && bmi > 29.1) {
      return 'so fat 😱\nYou need to diet and do sports';
    }
    return 'normal'; // default
  }
}
