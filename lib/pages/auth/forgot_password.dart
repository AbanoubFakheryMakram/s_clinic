import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/user.dart';
import 'package:smart_clinic/pages/auth/update_user_password.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';
import 'package:smart_clinic/utils/patterns.dart';

class ForgotPaswordPage extends StatefulWidget {
  @override
  _ForgotPaswordPageState createState() => _ForgotPaswordPageState();
}

class _ForgotPaswordPageState extends State<ForgotPaswordPage>
    with SingleTickerProviderStateMixin {
  
  Animation animation;
  final _formKey = GlobalKey<FormState>();
  String userSSN = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff003E46),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              AppUtils.hidwKeyboared(context);
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          height: ScreenUtil.screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff003E46),
                Color(0xff03A9F4),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                MyFadeAnimation(
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                    width: ScreenUtil().setWidth(170),
                    height: ScreenUtil().setHeight(150),
                  ),
                  delayinseconds: 1,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                MyFadeAnimation(
                  delayinseconds: 1.5,
                  child: Text(
                    'Type your ssn number',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    ScreenUtil().setHeight(20),
                  ),
                  child: MyFadeAnimation(
                    delayinseconds: 2,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (input) {
                          userSSN = input;
                        },
                        onSaved: (input) {
                          userSSN = input;
                        },
                        validator: (userInput) {
                          bool hasMatch =
                              MyPatterns.checkEgyptionIdPattern(userInput);
                          if (userInput.isEmpty) {
                            return 'enter your ssn';
                          } else if (hasMatch) {
                            return null;
                          } else {
                            return "invalid SSN";
                          }
                        },
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'SSN',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                MyFadeAnimation(
                  delayinseconds: 2.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setHeight(20),
                        vertical: ScreenUtil().setHeight(10)),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(48),
                      child: ProgressButton(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        strokeWidth: 2,
                        child: Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: (AnimationController controller) async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            controller.forward();
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
                              return;
                            }
                            controller.forward();
                            bool ssnIsExist = await FirebaseUtils.doesSSNExist(
                              ssn: userSSN,
                            );
                            if (ssnIsExist) {
                              // retrive user data
                              DocumentSnapshot snapshot =
                                  await FirebaseUtils.getCurrentUserData(
                                      ssn: userSSN);
                              User currentUser = User.fromMap(snapshot.data);
                              controller.reverse();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return UpdateUserPassword(
                                  currentUser: currentUser,
                                );
                              }));
                            } else {
                              controller.reverse();
                              AppUtils.showToast(msg: 'This SSN is not exist');
                            }
                          }
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
  }
}
