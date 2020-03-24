import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/providers/theme_provider.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/widgets/my_code_pin.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @required
  final Widget backPage;
  @required
  final Widget nextPage;
  @required
  final String phoneNumber;

  const VerifyPhoneNumberPage(
      {Key key, this.backPage, this.nextPage, this.phoneNumber})
      : super(key: key);

  @override
  _VerifyPhoneNumberPageState createState() => _VerifyPhoneNumberPageState();
}

class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
  String phoneNumber, smsCode, verficationId;

  bool isStart = false;

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber(phoneNumber: Pointer.currentUser.phone);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return widget.backPage;
            },
          ),
        );

        return true;
      },
      child: Consumer<AppThemeProvider>(
        builder:
            (BuildContext context, AppThemeProvider appTheme, Widget child) {
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return widget.backPage;
                      },
                    ),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil.screenHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              '3',
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
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/verify.png',
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(280),
                          height: ScreenUtil().setHeight(240),
                        ),
                      ),
                      Text(
                        'Enter the code that sent to you to verify your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appTheme.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setHeight(8),
                            vertical: ScreenUtil().setHeight(8)),
                        child: MyPinCodeTextField(
                          length: 6,
                          obsecureText: false,
                          animationType: AnimationType.fade,
                          shape: PinCodeFieldShape.box,
                          animationDuration: Duration(milliseconds: 300),
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          borderWidth: 1.0,
                          affirmativeText: 'Past code',
                          textStyle: TextStyle(
                            color: Colors.black,
                          ),
                          animationCurve: Curves.easeInOut,
                          dialogTitle: 'Past Code',
                          backgroundColor: Colors.transparent,
                          selectedColor:
                              appTheme.isDark ? Colors.white : Colors.black,
                          inactiveColor: Colors.yellow,
                          textInputType: TextInputType.phone,
                          activeColor: Colors.blue,
                          onCompleted: (input) async {
                            if (input.isNotEmpty && input.length == 6) {
                              setState(
                                () {
                                  isStart = true;
                                },
                              );
                              String result = await signInWithPhoneNumber(
                                userInput: input,
                                verificationId: verficationId,
                              );

                              if (result == 'DONE') {
                                setState(
                                  () {
                                    isStart = false;
                                  },
                                );
                                Navigator.of(context).push(
                                  PageTransition(
                                    child: widget.nextPage,
                                    type: PageTransitionType.scale,
                                  ),
                                );
                              } else if (result ==
                                  'ERROR_INVALID_VERIFICATION_CODE') {
                                setState(
                                  () {
                                    isStart = false;
                                  },
                                );
                                AppUtils.showToast(
                                  msg: 'Code incorrect',
                                  timeInSeconds: 2,
                                );
                              } else {
                                AppUtils.showToast(
                                  msg: 'Error',
                                  timeInSeconds: 2,
                                );
                              }
                            }
                          },
                          onChanged: (value) {},
                        ),
                      ),
                      isStart
                          ? Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber({
    @required phoneNumber,
  }) {
    codeAutoRetrievalTimeout(String verId) {
      verficationId = verId;
    }

    final PhoneCodeSent whenCodeSentToUser =
        (String verId, [int forceCodeResend]) {
      verficationId = verId;
      print('codeSent');
    };

    whenVerificationFailedToSend(AuthException exceptio) {
      print('${exceptio.message}');
    }

    whenVerificationSent(AuthCredential phoneAuthCredential) {
      print('code sent');
    }

    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: whenCodeSentToUser,
      timeout: Duration(seconds: 5),
      verificationCompleted: whenVerificationSent,
      verificationFailed: whenVerificationFailedToSend,
    );
  }

  // method to handle errors in phone auth method
  static String handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        return 'Invalid Code';
      default:
        return error.message;
        break;
    }
  }

  Future<String> signInWithPhoneNumber({
    @required String verificationId,
    @required String userInput,
  }) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: userInput,
      );
      final AuthResult operationResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();

      assert(
        operationResult.user.uid == currentUser.uid,
      );
      setState(
        () {
          isStart = false;
        },
      );

      return 'DONE';
    } catch (e) {
      setState(
        () {
          isStart = false;
        },
      );
      return handleError(e);
    }
  }
}
