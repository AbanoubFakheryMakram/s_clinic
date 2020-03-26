import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/animation/fade_transition.dart';
import 'package:smart_clinic/pages/clinic/upload_case/bmi/pacman_slider.dart';
import 'package:smart_clinic/pages/clinic/upload_case/bmi/transition_dots.dart';
import 'package:smart_clinic/pages/clinic/upload_case/bmi/weight_card.dart';

import 'bmi_result.dart';
import 'gender_card.dart';
import 'height_card.dart';
import 'input_summary.dart';

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> with TickerProviderStateMixin {
  // animation controller
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animationController.addStatusListener((status) {
      //add a listener
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) =>
            _animationController.reset()); //reset controller when coming back
      }
    });
  }

  _goToResultPage() async {
    return Navigator.of(context).push(
      FadeRoute(
        //use the FadeRoute
        builder: (context) => BMIResultPage(
          weight: weight,
          height: height,
          gender: gender,
        ),
      ),
    );
  }

  // initial data
  GenderType gender = GenderType.male;
  int height = 170;
  int weight = 60;

  @override
  Widget build(BuildContext context) {
    initScreenSize();
    return Stack(
      children: <Widget>[
        Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputSummaryCard(
                  gender: gender,
                  weight: weight,
                  height: height,
                ),
                Expanded(child: _buildCards()),
                _buildBottom(),
              ],
            ),
          ),
        ),
        TransitionDot(animation: _animationController),
      ],
    );
  }

  initScreenSize() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context,
        width: screenWidth, height: screenHeight, allowFontScaling: true);
  }

  Widget _buildCards() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8),
          left: ScreenUtil().setHeight(14),
          right: ScreenUtil().setHeight(14)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GenderCard(
                    initialGender: GenderType.male,
                    onChange: (type) => setState(() => gender = type),
                  ),
                ),
                Expanded(
                    child: WeightCard(
                  initialWeight: 60,
                  onChage: (val) => setState(() => weight = val),
                ))
              ],
            ),
          ),
          Expanded(
            child: HeightCard(
              height: 170,
              onChanged: (val) => setState(() => height = val),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setHeight(16.0),
        right: ScreenUtil().setHeight(16.0),
        bottom: ScreenUtil().setHeight(22.0),
        top: ScreenUtil().setHeight(14.0),
      ),
      child: PacmanSlider(
        onSubmit: onPacmanSubmit,
        animationController: _animationController,
      ),
    );
  }

  void onPacmanSubmit() {
    // start the animation whenever the user submitting the slider
    _animationController.forward();
  }
}
