import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/clinic/activate_clinic_page.dart';

class ClinicPage extends StatefulWidget {
  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  String hasClinic = 'false';

  @override
  void initState() {
    super.initState();

    hasClinic = Pointer.currentUser.hasClinic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: hasClinic == 'false'
          ? Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/has_no_clinic.png',
                  height: ScreenUtil().setHeight(280),
                ),
                
                Center(
                  child: Text(
                    'You has no clinic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              child: Text(
                'has clinic',
              ),
            ),
    );
  }
}
