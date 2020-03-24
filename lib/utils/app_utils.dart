import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class AppUtils {
  PermissionStatus status;

  static Future<bool> getConnectionState() async {
    return await DataConnectionChecker().hasConnection;
  }

  static void showDialog({
    @required BuildContext context,
    @required String title,
    @required String negativeText,
    @required String positiveText,
    @required Function onPositiveButtonPressed,
    Function onNegativeButtonPressed,
    @required String contentText,
    bool dismissWhenClickOutsideDialog,
    DialogTransitionType type,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: dismissWhenClickOutsideDialog ?? true,
      animationType: type ?? DialogTransitionType.scale,
      duration: Duration(
        milliseconds: 400,
      ),
      builder: (context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          negativeText: negativeText,
          positiveText: (positiveText == '' || positiveText == null)
              ? null
              : positiveText,
          onNegativeClick: onPositiveButtonPressed,
          contentText: contentText,
          onPositiveClick: onNegativeButtonPressed ??
              () {
                Navigator.of(context).pop();
              },
        );
      },
    );
  }

  static hidwKeyboared(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static showToast({@required msg, int timeInSeconds, Color backgroundColor}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: timeInSeconds ?? 1,
      backgroundColor: backgroundColor ?? Color(0xff1E1E1E),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // true if granted : false if denied
  static Future<bool> checkPermissionState(PermissionGroup permissions) async {
    bool permissionState = false;
    await PermissionHandler().checkPermissionStatus(permissions).then(
      (state) {
        if (state == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );
    return permissionState;
  }

  static void exitFromApp() {
    exit(0);
  }

  // true if granted : false if denied
  static Future<bool> askPhotosPermission() async {
    bool permissionState = false;
    await PermissionHandler().requestPermissions([
      Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos,
    ]).then(
      (Map<PermissionGroup, PermissionStatus> map) {
        if (map[PermissionGroup.storage] == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );

    print('state of permission >>>> $permissionState');
    return permissionState;
  }

  static Future<bool> askDeviceLocationPermission() async {
    bool permissionState = false;
    await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]).then(
      (Map<PermissionGroup, PermissionStatus> map) {
        if (map[PermissionGroup.location] == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );

    print('state of permission >>>> $permissionState');
    return permissionState;
  }

  static Future<DateTime> showDatePicker(BuildContext context) async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950, 3, 5),
      lastDate: DateTime(DateTime.now().year + 20),
      borderRadius: 16,
    );

    return newDateTime;
  }

  static String getTimeAgo(String timestamp) {
    String timeAgo = TimeAgo.getTimeAgo(
      int.parse(timestamp),
    );
    return timeAgo;
  }

  static bool getNetworkState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
        return false;
      default:
        return false;
    }
  }
}
