import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/user.dart';
import 'package:smart_clinic/pages/auth/forgot_password.dart';
import 'package:smart_clinic/pages/auth/signup_basic_info.dart';
import 'package:smart_clinic/pages/home.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';
import 'package:smart_clinic/utils/patterns.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userAccount = '';
  String userPassword = '';

  final _formKey = GlobalKey<FormState>();

  var globalKey = RectGetter.createGlobalKey();
  Rect rect;
  Animation animation;
  double width = double.infinity;
  GlobalKey buttonKey = GlobalKey();

  bool hidePassword = true;
  bool isNewUser = true;

  // The ripple animation time (1 second)
  Duration animationDuration = Duration(milliseconds: 500);
  Duration delayTime = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    FirebaseUtils.getCurrentUser().then(
      (user) {
        if (user == null) {
          isNewUser = true;
        } else {
          isNewUser = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  MyFadeAnimation(
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(130),
                      height: ScreenUtil().setHeight(90),
                    ),
                    delayinseconds: 1,
                  ),
                  MyFadeAnimation(
                    delayinseconds: 1,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Smart Clinic',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'Radiant',
                            ),
                          ),
                          TextSpan(
                            text: '  (Doctors)',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  MyFadeAnimation(
                    delayinseconds: 1.5,
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setHeight(13),
                      ),
                      elevation: 6,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                          child: Column(
                            children: <Widget>[
                              buildTextFormField(
                                isSSN: true,
                                label: 'SSN',
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              buildTextFormField(
                                isSSN: false,
                                label: 'password',
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ForgotPaswordPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  MyFadeAnimation(
                    delayinseconds: 2,
                    child: Padding(
                      padding: EdgeInsets.all(
                        ScreenUtil().setHeight(18),
                      ),
                      child: Container(
                        key: buttonKey,
                        height: ScreenUtil().setHeight(48),
                        width: width,
                        child: RectGetter(
                          key: globalKey,
                          child: ProgressButton(
                            progressIndicatorColor: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: (AnimationController controller) {
                              animatedButton(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  MyFadeAnimation(
                    delayinseconds: 2.5,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: CreateAccountBasicInfo(),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                      },
                      child: Text(
                        'CREATE NEW ACCOUNT',
                        style: TextStyle(
                          fontSize: 15,
                          wordSpacing: 1.8,
                          fontFamily: 'Vonique',
                          color: Colors.black,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _ripple(),
      ],
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }

    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff03A9F4),
        ),
      ),
    );
  }

  void animatedButton(AnimationController controller) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      controller.forward();
      if (!await AppUtils.getConnectionState()) {
        controller.reverse();
        AppUtils.showDialog(
          context: context,
          title: 'ALERT!',
          negativeText: 'OK',
          positiveText: '',
          onPositiveButtonPressed: null,
          contentText: 'No internet connection',
        );
        return;
      }

      bool isExist = await FirebaseUtils.doesSSNExist(ssn: userAccount);

      // this aacount is exist
      if (isExist) {
        DocumentSnapshot snapshot =
            await FirebaseUtils.getCurrentUserData(ssn: userAccount);

        // get a snapshot of user data
        User user = User.fromMap(snapshot.data);

        // check for input password
        // case true login user
        if (user.password == userPassword) {
          setState(
            () {
              controller.reverse();
            },
          );
          _onTap();
        } else {
          // wrong password
          setState(
            () {
              controller.reverse();
              AppUtils.showToast(
                msg: 'Wrong password',
                timeInSeconds: 2,
              );
            },
          );
        }
      } else {
        setState(
          () {
            controller.reverse();
            AppUtils.showToast(
              msg: 'This account not exist',
              timeInSeconds: 2,
            );
          },
        );
      }
    }
  }

  Widget buildTextFormField({
    @required bool isSSN,
    @required String label,
  }) {
    return TextFormField(
      keyboardType: isSSN ? TextInputType.number : TextInputType.text,
      onChanged: (userInput) {
        isSSN ? userAccount = userInput : userPassword = userInput;
      },
      onSaved: (userInput) {
        isSSN ? userAccount = userInput : userPassword = userInput;
      },
      obscureText: isSSN ? false : hidePassword,
      validator: (userInput) {
        if (userInput.isEmpty) {
          return "Please fill this field";
        } else if (isSSN) {
          bool hasMatch = MyPatterns.checkEgyptionIdPattern(userInput);
          if (hasMatch) {
            return null;
          } else {
            return "invalid SSN";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: isSSN
            ? null
            : IconButton(
                icon: hidePassword
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () {
                  setState(
                    () {
                      hidePassword = !hidePassword;
                    },
                  );
                },
              ),
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  void _onTap() {
    setState(
      () => rect = RectGetter.getRectFromKey(globalKey),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(
          () => rect =
              rect.inflate(1.3 * MediaQuery.of(context).size.longestSide),
        );

        Future.delayed(animationDuration + delayTime, goToNextPage);
      },
    );
  }

  void goToNextPage() async {
    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setString(
          'userSSN',
          userAccount,
        );
      },
    );
    Navigator.of(context)
        .pushReplacement(
          PageTransition(
            child: HomePage(
              userSSN: userAccount,
            ),
            type: PageTransitionType.fade,
          ),
        )
        .then(
          (_) => setState(() => rect = null),
        );
  }
}
