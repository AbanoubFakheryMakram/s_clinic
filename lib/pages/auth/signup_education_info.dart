import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/auth/signup_image_page.dart';
import 'package:smart_clinic/pages/auth/signup_verify_phone_number.dart';
import 'package:smart_clinic/providers/theme_provider.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/const.dart';
import 'package:smart_clinic/widgets/my_dropDownButton.dart';

class CreateAccountEducationInfo extends StatefulWidget {
  @override
  _CreateAccountEducationInfoState createState() =>
      _CreateAccountEducationInfoState();
}

class _CreateAccountEducationInfoState extends State<CreateAccountEducationInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  String graduationYear = '';
  String specialist = '';
  String degree = '';
  String userQualificationAndCertifications = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      upperBound: 23,
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appTheme, Widget child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appTheme.isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                AppUtils.hidwKeyboared(context);
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              child: Padding(
                padding: EdgeInsets.all(
                  ScreenUtil().setHeight(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Educational Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                appTheme.isDark ? Colors.white : Colors.black,
                            fontFamily: 'Baloo',
                            fontSize: _controller.value,
                          ),
                        ),
                        Container(
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                '2',
                                style: TextStyle(
                                  color: appTheme.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Radiant',
                                ),
                              ),
                              Text(
                                '/4',
                                style: TextStyle(
                                  color: appTheme.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(28),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 2,
                      child: MyDropDownFormField(
                        titleText: 'Specialization',
                        hintText: 'Please choose one',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                appTheme.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        itemStyle: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                        value: specialist,
                        onSaved: (value) {
                          setState(
                            () {
                              specialist = value;
                            },
                          );
                        },
                        onChanged: (value) {
                          setState(
                            () {
                              specialist = value;
                            },
                          );
                        },
                        dataSource: Const.specializations,
                        textField: 'display',
                        valueField: 'value',
                        titleStyle: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 2.5,
                      child: MyDropDownFormField(
                        titleStyle: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                appTheme.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        titleText: 'Degree',
                        hintText: 'Please choose one',
                        itemStyle: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                        value: degree,
                        onSaved: (value) {
                          setState(
                            () {
                              degree = value;
                            },
                          );
                        },
                        onChanged: (value) {
                          setState(
                            () {
                              degree = value;
                            },
                          );
                        },
                        dataSource: Const.degress,
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Graduation Year',
                            style: TextStyle(
                              color:
                                  appTheme.isDark ? Colors.white : Colors.black,
                              fontSize: 17,
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              getUserGraduationYear();
                            },
                            child: Text(
                              'Select',
                              style: TextStyle(
                                color: appTheme.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 3,
                      child: Text(
                        '$graduationYear',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 3.5,
                      child: Text(
                        'Qualifications and certifications (optional)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    MyFadeAnimation(
                      delayinseconds: 3.5,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                        onChanged: (input) {
                          userQualificationAndCertifications = input;
                        },
                        decoration: InputDecoration(
                          labelText: 'Your qualifications and certifications',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setHeight(10),
                        vertical: ScreenUtil().setHeight(30),
                      ),
                      child: MyFadeAnimation(
                        delayinseconds: 4,
                        child: Container(
                          height: ScreenUtil().setHeight(48),
                          child: ProgressButton(
                            progressIndicatorColor: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: (AnimationController controller) async {
                              processData(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void processData(AnimationController controller) async {
    if (specialist.isEmpty) {
      AppUtils.showToast(msg: 'Select your specialization');
    } else if (degree.isEmpty) {
      AppUtils.showToast(msg: 'Select your degree');
    } else if (graduationYear.isEmpty) {
      AppUtils.showToast(msg: 'Select your graduation year');
    } else {
      controller.forward();

      Pointer.currentUser.specialist = specialist;
      Pointer.currentUser.degree = degree;
      Pointer.currentUser.graduationYear = graduationYear;
      Pointer.currentUser.qualifications =
          userQualificationAndCertifications ?? '';

      await Future.delayed(
        Duration(
          milliseconds: 1000,
        ),
      );

      controller.reverse();

      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.downToUp,
          child: VerifyPhoneNumberPage(
            backPage: CreateAccountEducationInfo(),
            nextPage: CreateAccountImagePage(),
            phoneNumber: Pointer.currentUser.phone,
          ),
        ),
      );
    }
  }

  void getUserGraduationYear() async {
    DateTime newDateTime = await AppUtils.showDatePicker(context);
    setState(
      () {
        graduationYear =
            '${newDateTime.day} / ${newDateTime.month} / ${newDateTime.year}';
      },
    );
  }
}
