import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/auth/login.dart';
import 'package:smart_clinic/pages/home.dart';
import 'package:smart_clinic/providers/theme_provider.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';
import 'package:smart_clinic/utils/image_processing.dart';

class CreateAccountImagePage extends StatefulWidget {
  @override
  _CreateAccountImagePageState createState() => _CreateAccountImagePageState();
}

class _CreateAccountImagePageState extends State<CreateAccountImagePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  File imageFile;
  bool isStarted = false;

  String imageURL = '';
  String waitMessage = 'Please wait a few seconds while creating your account';

  var globalKey = RectGetter.createGlobalKey();
  Rect rect;
  // The ripple animation time (1 second)
  Duration animationDuration = Duration(milliseconds: 500);
  Duration delayTime = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600),
      upperBound: 140,
      lowerBound: 0,
    )..addListener(
        () {
          setState(() {});
        },
      );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appTheme, Widget child) {
        return Stack(
          children: <Widget>[
            WillPopScope(
              onWillPop: () async {
                cancelCreatingAccountProcess();
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: appTheme.isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () async {
                      AppUtils.hidwKeyboared(context);
                      cancelCreatingAccountProcess();
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
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  '4',
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
                          Text(
                            'Would you like to upload an image for your profile ? (Optional)',
                            style: TextStyle(
                              color:
                                  appTheme.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(18),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                bool granted =
                                    await AppUtils.askPhotosPermission();
                                if (granted == true) {
                                  imageFile = await ImageProcessing.getImage(
                                    ImageSource.gallery,
                                  );
                                  setState(() {});
                                } else {
                                  AppUtils.showToast(
                                    msg:
                                        'Can not access your gallery without your permission',
                                    timeInSeconds: 2,
                                  );
                                }
                              },
                              child: Container(
                                width: animationController.value,
                                height: animationController.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: imageFile == null
                                        ? AssetImage(
                                            Pointer.currentUser.gender == 'Male'
                                                ? 'assets/images/male.png'
                                                : 'assets/images/female.png',
                                          )
                                        : FileImage(imageFile, scale: .5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                          MyFadeAnimation(
                            delayinseconds: 2.2,
                            child: Padding(
                              padding: EdgeInsets.all(
                                ScreenUtil().setHeight(30),
                              ),
                              child: RectGetter(
                                key: globalKey,
                                child: ProgressButton(
                                  color: Colors.white,
                                  progressIndicatorColor: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Text(
                                    "Finish",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onPressed:
                                      (AnimationController controller) async {
                                    controller.forward();
                                    if (await AppUtils.getConnectionState()) {
                                      saveUserData(controller);
                                    } else {
                                      AppUtils.showDialog(
                                        context: context,
                                        title: 'ALERT!',
                                        negativeText: 'OK',
                                        positiveText: '',
                                        onPositiveButtonPressed: null,
                                        contentText: 'No internet connection',
                                      );
                                      controller.reverse();
                                    }
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
                                      'please wait while creating your account',
                                    ],
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: appTheme.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _ripple(),
          ],
        );
      },
    );
  }

  void cancelCreatingAccountProcess() async {
    if (await FirebaseUtils.getCurrentUser() != null) {
      // user account is successfully created
      // ask him / her if want to cancel creating account progress
      AppUtils.showDialog(
        context: context,
        title: 'Alert',
        negativeText: 'Cancel',
        positiveText: 'Sumbit',
        onPositiveButtonPressed: () async {
          // 1- delete user account
          FirebaseUtils.deleteUserAccount().then(
            (_) {
              // 2- clear saved data
              Pointer.currentUser = null;
              // 3- back to login screen
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                PageTransition(
                  child: LoginPage(),
                  type: PageTransitionType.size,
                ),
              );
            },
          );
        },
        dismissWhenClickOutsideDialog: true,
        contentText: 'Want to cancel creating account process ?!',
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return LoginPage();
          },
        ),
      );
    }
  }

  void saveUserData(AnimationController controller) async {
    // start for saveing data
    setState(
      () {
        isStarted = true;
      },
    );
    if (imageFile != null) {
      print('upkoading user image');
      StorageReference storage = FirebaseStorage.instance
          .ref()
          .child('human doctors profile image')
          .child('img${Pointer.currentUser.id}.png');

      await FirebaseUtils.uploadDoctorProfileImageToFirebaseStorage(
        storage,
        imageFile,
      );

      imageURL = await FirebaseUtils.downloadImageURL(storage);
      Pointer.currentUser.image = imageURL;
    }

    await FirebaseUtils.saveData(
      dataInMap: Pointer.currentUser.toMap(),
      ssn: Pointer.currentUser.id,
    );

    controller.reverse();

    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setString(
          'userSSN',
          Pointer.currentUser.id,
        );
      },
    );

    _onTap();
  }

  void _onTap() {
    setState(
      () => rect = RectGetter.getRectFromKey(globalKey),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(
          () => rect = rect.inflate(
            1.3 * MediaQuery.of(context).size.longestSide,
          ),
        );

        Future.delayed(
          animationDuration + delayTime,
          goToNextPage,
        );
      },
    );
  }

  void goToNextPage() async {
    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setString(
          'userSSN',
          Pointer.currentUser.id,
        );
      },
    );
    Navigator.of(context)
        .pushReplacement(
          PageTransition(
            child: HomePage(
              userSSN: Pointer.currentUser.id,
            ),
            type: PageTransitionType.scale,
          ),
        )
        .then(
          (_) => setState(
            () => rect = null,
          ),
        );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }

    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: ScreenUtil.screenWidth - rect.right,
      top: rect.top,
      bottom: ScreenUtil.screenHeight - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff03A9F4),
        ),
      ),
    );
  }
}
