import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/clinic/clinic_page.dart';
import 'package:smart_clinic/pages/home.dart';
import 'dart:math';
import 'package:smart_clinic/utils/app_utils.dart';

class Diagnosis extends StatefulWidget {
  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  String diagnosis;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(18),
            vertical: ScreenUtil().setHeight(20),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setHeight(28),
              ),
              Text(
                'Finally type your diagnosis here',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (String input) {
                  diagnosis = input;
                },
                onSaved: (input) {
                  diagnosis = input;
                },
                decoration: InputDecoration(hintText: 'my diagnosis'),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(58),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(18),
                ),
                height: ScreenUtil().setHeight(44),
                child: ProgressButton(
                  color: Colors.blue,
                  onPressed: (AnimationController controller) async {
                    if (diagnosis == null || diagnosis.isEmpty) {
                      AppUtils.showToast(msg: 'Please type your diagnosis !');
                    } else {
                      controller.forward();
                      if (!await AppUtils.getConnectionState()) {
                        AppUtils.showDialog(
                          context: context,
                          title: 'Alert!',
                          negativeText: 'OK',
                          positiveText: null,
                          onPositiveButtonPressed: null,
                          contentText: 'No Internet Connection',
                        );

                        controller.reverse();
                        return;
                      }

                      // patient and diagnosis info
                      Pointer.currentPost.diagnosis = diagnosis;

                      // post info
                      Pointer.currentPost.date =
                          '${DateTime.now().millisecondsSinceEpoch}';
                      Pointer.currentPost.likes = [];
                      Pointer.currentPost.comments = [];
                      Pointer.currentPost.post_id = getRandomID();

                      // doctor info
                      Pointer.currentPost.doctor_id = Pointer.currentUser.id;
                      Pointer.currentPost.doctor_spec =
                          Pointer.currentUser.specialist;
                      Pointer.currentPost.doctor_image =
                          Pointer.currentUser.image;
                      Pointer.currentPost.doctor_gender =
                          Pointer.currentUser.gender;
                      Pointer.currentPost.doctor_name =
                          Pointer.currentUser.name;

                      publishPost(controller);
                    }
                  },
                  child: Text(
                    'Publish',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getRandomID() {
    Random random = Random();
    var number = random.nextInt(1000000) + 999999;
    return '${number}${DateTime.now().millisecondsSinceEpoch}'; // a random number with time now in timestamp format
  }

  void publishPost(AnimationController controller) async {
    await Firestore.instance
        .collection('cases')
        .document(Pointer.currentPost.post_id)
        .setData(
          Pointer.currentPost.postsToMap(),
        );

    controller.reverse();
    AppUtils.showToast(msg: 'Published');
    SharedPreferences.getInstance().then(
      (pref) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePage(
              userSSN: pref.getString('userSSN'),
            ),
          ),
        );
      },
    );
  }
}
