import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/models/user.dart';
import 'package:smart_clinic/pages/clinic/activate_clinic_page.dart';
import 'package:smart_clinic/pages/clinic/upload_case/bmi/bmi.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';

class ClinicPage extends StatefulWidget {
  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  @override
  void initState() {
    super.initState();

    getDoctorClinicState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Pointer.currentUser.hasClinic == 'false'
          ? Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/has_no_clinic.png',
                  height: ScreenUtil().setHeight(280),
                ),
                Center(
                  child: Text(
                    'You has no clinic\n Activate it to receive the appointments notifications \nUpload patients\' cases and more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(18),
                ),
                Center(
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                    child: Text(
                      'ACTIVATE   MY   CLINIC',
                      style: TextStyle(
                        fontFamily: 'Vonique',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageTransition(
                          child: ActivateClinicPage(),
                          type: PageTransitionType.upToDown,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BMIPage(),
                    ),
                  );
                },
                child: Text(
                  'Add New Case',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
    );
  }

  void getDoctorClinicState() async {
    var doc =
        await FirebaseUtils.getCurrentUserData(ssn: Pointer.currentUser.id);
    User currentUser = User.fromMap(doc.data);
    print(currentUser.toMap());
    Pointer.currentUser = currentUser;
    setState(() {});
  }
}
