import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/auth/signup_education_info.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';
import 'package:smart_clinic/utils/patterns.dart';

class CreateAccountBasicInfo extends StatefulWidget {
  @override
  _CreateAccountBasicInfoState createState() => _CreateAccountBasicInfoState();
}

class _CreateAccountBasicInfoState extends State<CreateAccountBasicInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;
  String countryCode = '+20';
  String phoneNumber;
  String ssn = '';

  String msg = 'Checking if this SSN is exist or not.';
  bool isDark = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      upperBound: 23,
    )..addListener(
        () {
          setState(() {});
        },
      );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String userEmail = '';
  String userPassword = '';
  String username = '';
  String userBirthDate = '';
  String userGender = 'Male';

  bool hidePassword = true;
  bool isMale = true;
  bool isStarted = false;
  bool isFemail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            AppUtils.hidwKeyboared(context);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setHeight(20),
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
                      'Basic Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Baloo',
                        fontSize: _controller.value,
                      ),
                    ),
                    Container(
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            '1',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Radiant',
                            ),
                          ),
                          Text(
                            '/4',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      MyFadeAnimation(
                        delayinseconds: 2,
                        child: buildTextFormField(
                          label: 'name',
                          isPhone: false,
                          isPassword: false,
                          isSSN: false,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      MyFadeAnimation(
                        delayinseconds: 2.5,
                        child: buildTextFormField(
                          label: 'SSN',
                          isPhone: false,
                          isSSN: true,
                          isPassword: false,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      MyFadeAnimation(
                        delayinseconds: 3,
                        child: buildTextFormField(
                          label: 'password',
                          isPhone: false,
                          isSSN: false,
                          isPassword: true,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      MyFadeAnimation(
                        delayinseconds: 3.5,
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: CountryCodePicker(
                                onChanged: (countrySelected) {
                                  countryCode = countrySelected.dialCode;
                                },
                                initialSelection: 'EG',
                                favorite: ['+20', 'EG'],
                                showCountryOnly: false,
                                onInit: (countryCode) {
                                  this.countryCode = countryCode.dialCode;
                                },
                                textStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: buildTextFormField(
                                isPassword: false,
                                isSSN: false,
                                isPhone: true,
                                label: 'phone number',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      MyFadeAnimation(
                        delayinseconds: 4,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Select your birth date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              RaisedButton(
                                child: Text(
                                  'Select',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  AppUtils.hidwKeyboared(context);
                                  getUserBirthDate();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$userBirthDate',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              MyFadeAnimation(
                                delayinseconds: 4.5,
                                child: Text(
                                  'Select Your gender',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              MyFadeAnimation(
                                delayinseconds: 5,
                                child: Text(
                                  '$userGender',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      MyFadeAnimation(
                        delayinseconds: 5.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: buildGenderCard(
                                isSelected: isMale,
                                onTap: () {
                                  setState(
                                    () {
                                      isMale = true;
                                      isFemail = false;
                                      userGender = 'Male';
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.mars,
                                    ),
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildGenderCard(
                                isSelected: isFemail,
                                onTap: () {
                                  setState(
                                    () {
                                      isMale = false;
                                      isFemail = true;
                                      userGender = 'Female';
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.venus,
                                    ),
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(10),
                    vertical: ScreenUtil().setHeight(30),
                  ),
                  child: MyFadeAnimation(
                    delayinseconds: 6,
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
                        onPressed: (
                          AnimationController controller,
                        ) async {
                          processData(controller);
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: isStarted
                      ? TyperAnimatedTextKit(
                          isRepeatingAnimation: true,
                          displayFullTextOnTap: false,
                          text: [
                            msg,
                          ],
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void processData(controller) async {
    if (_formKey.currentState.validate()) {
      if (userBirthDate.isEmpty) {
        AppUtils.showToast(msg: 'Select your birth date');
        return;
      }

      _formKey.currentState.save();
      controller.forward();

      setState(() {
        isStarted = true;
      });

      if (!await AppUtils.getConnectionState()) {
        AppUtils.showDialog(
          context: context,
          title: 'ALERT!',
          negativeText: 'OK',
          positiveText: '',
          onPositiveButtonPressed: null,
          contentText: 'No internet connection',
        );
        controller.reverse();
        setState(
          () {
            isStarted = false;
          },
        );
        return;
      }

      bool isSSNExist = await FirebaseUtils.doesSSNExist(ssn: ssn);

      if (isSSNExist) {
        AppUtils.showToast(msg: "This SSN is already exist");
        setState(
          () {
            isStarted = false;
            controller.reverse();
          },
        );
      } else {
        setState(
          () {
            msg = 'Checking if this phone number is exist or not.';
          },
        );
        bool isPhoneNumberExist = await FirebaseUtils.doesPhoneExist(
            phone: '$countryCode$phoneNumber');

        if (isPhoneNumberExist) {
          AppUtils.showToast(msg: "This phone number is already exist");
          setState(
            () {
              isStarted = false;
              controller.reverse();
            },
          );

          return;
        }

        setState(
          () {
            msg = '';
          },
        );

        Pointer.currentUser.name = username;
        Pointer.currentUser.id = ssn;
        Pointer.currentUser.password = userPassword;
        Pointer.currentUser.phone = countryCode + phoneNumber;
        Pointer.currentUser.birthDate = userBirthDate;
        Pointer.currentUser.gender = userGender;

        controller.reverse();
        setState(
          () {
            isStarted = false;
          },
        );

        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.downToUp,
            child: CreateAccountEducationInfo(),
          ),
        );
      }
    }
  }

  void getUserBirthDate() async {
    DateTime newDateTime = await AppUtils.showDatePicker(context);
    setState(
      () {
        userBirthDate =
            '${newDateTime.day} / ${newDateTime.month} / ${newDateTime.year}';
      },
    );
  }

  Widget buildTextFormField({
    String label,
    bool isPassword,
    bool isPhone,
    bool isSSN,
  }) {
    return TextFormField(
      style: TextStyle(
        color: Colors.black,
      ),
      onChanged: (input) {
        isPassword
            ? userPassword = input
            : isPhone
                ? phoneNumber = input
                : isSSN ? ssn = input : username = input;
      },
      onSaved: (input) {
        isPassword
            ? userPassword = input
            : isPhone
                ? phoneNumber = input
                : isSSN ? ssn = input : username = input;
      },
      validator: (userInput) {
        if (userInput.isEmpty) {
          return 'fill this field';
        } else if (isPassword) {
          if (userInput.length < 8) {
            return 'password must be more than 8 characters';
          }
        } else if (!isSSN && !isPassword) {
          if (userInput.length < 2) {
            return 'is not a valid name';
          }
        } else if (isPhone) {
          bool hasMatch = MyPatterns.checkPhonePattern(userInput);
          if (!hasMatch) {
            return 'invalid phone number';
          }
        } else if (isSSN) {
          bool hasMatch = MyPatterns.checkEgyptionIdPattern(userInput);
          if (hasMatch) {
            return '';
          } else {
            return 'Invalid SSN';
          }
        }
        return null;
      },
      textInputAction: TextInputAction.go,
      textAlign: !isPhone ? TextAlign.center : TextAlign.left,
      obscureText: isPassword ? hidePassword : false,
      keyboardType: isPhone
          ? TextInputType.phone
          : isSSN ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                color: isDark ? Colors.white : Colors.black,
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(
                    () {
                      hidePassword = !hidePassword;
                    },
                  );
                },
              )
            : null,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        alignLabelWithHint: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildGenderCard({
    Widget child,
    bool isSelected,
    Function onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(
            5,
          ),
        ),
        duration: Duration(
          milliseconds: 500,
        ),
        height: ScreenUtil().setHeight(70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.grey : Colors.black12,
        ),
        child: child,
      ),
    );
  }
}
