import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/user.dart';
import 'package:smart_clinic/pages/auth/login.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';

class UpdateUserPassword extends StatefulWidget {
  final User currentUser;

  const UpdateUserPassword({
    Key key,
    this.currentUser,
  }) : super(key: key);

  @override
  _UpdateUserPasswordState createState() => _UpdateUserPasswordState();
}

class _UpdateUserPasswordState extends State<UpdateUserPassword> {
  final _formKey = GlobalKey<FormState>();
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Update password',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
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
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  widget.currentUser.image != null &&
                          widget.currentUser.image != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            width: ScreenUtil().setWidth(160),
                            fit: BoxFit.cover,
                            height: ScreenUtil().setHeight(160),
                            imageUrl: widget.currentUser.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      : Image.asset(
                          widget.currentUser.gender == 'Male'
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          width: ScreenUtil().setWidth(160),
                          fit: BoxFit.cover,
                          height: ScreenUtil().setHeight(160),
                        ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  MyFadeAnimation(
                    delayinseconds: 1,
                    child: Text(
                      widget.currentUser.name,
                      style: TextStyle(fontSize: 20, fontFamily: 'Vonique'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      ScreenUtil().setWidth(18),
                    ),
                    child: MyFadeAnimation(
                      delayinseconds: 2,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (input) {
                            newPassword = input;
                          },
                          onSaved: (input) {
                            newPassword = input;
                          },
                          validator: (userInput) {
                            if (userInput.isEmpty) {
                              return 'enter your new password';
                            } else if (userInput.length < 8) {
                              return 'password must not be less than 8 digits';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'new password',
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(25),
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
                            "Update",
                            style: TextStyle(
                              color: Colors.black,
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
                              bool updated = await FirebaseUtils.updateData(
                                dataInMap: {
                                  'password': newPassword,
                                },
                                ssn: widget.currentUser.id,
                              );
                              if (updated) {
                                AppUtils.showToast(
                                    msg: 'Password updated successfully');
                                controller.reverse();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return LoginPage();
                                    },
                                  ),
                                );
                              } else {
                                controller.reverse();
                                AppUtils.showToast(
                                    msg: 'Can not updat password');
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
      ),
    );
  }
}
