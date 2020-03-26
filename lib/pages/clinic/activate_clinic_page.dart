import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/utils/app_utils.dart';

import '../../utils/app_utils.dart';

class ActivateClinicPage extends StatefulWidget {
  @override
  _ActivateClinicPageState createState() => _ActivateClinicPageState();
}

class _ActivateClinicPageState extends State<ActivateClinicPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final cardKey = GlobalKey<FlipCardState>();
  bool useCurrentLocation = true;

  bool satarday = false;
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;

  String _satarday = '',
      _sunday = '',
      _monday = '',
      _tuesday = '',
      _wednesday = '',
      _thursday = '',
      _friday = '';

  String address = '';
  String fee = '';
  String phone;
  String locationLatLng = '';

  LatLng locationLatlng;
  var location = new Location();

  List<Map<String, String>> workDays = List();

  AnimationController transformAnimationController;
  Animation<double> transformAnimation;

  AnimationController slideAnimationController;
  Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();

    // Transform animation for first child
    transformAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    transformAnimation =
        Tween<double>(begin: 0.0, end: ScreenUtil().setHeight(math.pi / 2))
            .animate(
      CurvedAnimation(
        parent: transformAnimationController,
        curve: Curves.decelerate,
      ),
    )..addListener(
                () {
                  setState(
                    () {},
                  );
                },
              );

    // Slide animation for sceond child
    slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    slideAnimation =
        Tween<double>(begin: 0.0, end: ScreenUtil().setHeight(550)).animate(
      CurvedAnimation(
        parent: slideAnimationController,
        curve: Curves.decelerate,
      ),
    )..addListener(
            () {
              setState(
                () {},
              );
            },
          );
  }

  @override
  void dispose() {
    transformAnimationController?.dispose();
    slideAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF1F2F7),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: ScreenUtil().setHeight(-slideAnimation.value / 2),
              left: 0.0,
              right: 0.0,
              height: MediaQuery.of(context).size.height,
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-transformAnimation.value),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: .4,
                        child: Image.asset(
                          'assets/images/brush.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setHeight(20),
                        ),
                        child: Container(
                          height: ScreenUtil.screenHeight,
                          width: ScreenUtil.screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil().setHeight(25),
                              ),
                              Text(
                                'Few informations to activate your clinic',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              buildTextFormField('Fee', TextInputType.number),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              buildTextFormField(
                                  'Phone (Optional)', TextInputType.number),
                              SizedBox(
                                height: ScreenUtil().setHeight(25),
                              ),
                              FlipCard(
                                key: cardKey,
                                direction: FlipDirection.HORIZONTAL,
                                flipOnTouch: false,
                                front: Column(
                                  children: <Widget>[
                                    Text(
                                      'Use current location as the address of clinic?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      locationLatLng,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(15),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        RaisedButton(
                                          onPressed: () async {
                                            locationLatLng =
                                                'Getting device location...';
                                            setState(() {});
                                            bool isGranted = await AppUtils
                                                .askDeviceLocationPermission();
                                            if (isGranted) {
                                              await location.getLocation().then(
                                                (location) {
                                                  locationLatlng = LatLng(
                                                    location.latitude,
                                                    location.longitude,
                                                  );
                                                  locationLatLng =
                                                      '${location.latitude.toStringAsFixed(6)} : ${location.longitude.toStringAsFixed(6)}';
                                                  setState(() {});
                                                },
                                              );
                                            } else {
                                              AppUtils.showDialog(
                                                context: context,
                                                title: 'Alert',
                                                negativeText: 'OK',
                                                positiveText: null,
                                                onPositiveButtonPressed: null,
                                                contentText:
                                                    'Can not get your location without your permission',
                                              );
                                            }
                                          },
                                          child: Text('Yes'),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                        ),
                                        RaisedButton(
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            useCurrentLocation = false;
                                            cardKey.currentState.toggleCard();
                                          },
                                          child: Text('No'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                back: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Type clinic address',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        RaisedButton(
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            useCurrentLocation = true;
                                            cardKey.currentState.toggleCard();
                                          },
                                          child: Text('Use location'),
                                        ),
                                      ],
                                    ),
                                    buildTextFormField(
                                      'Address',
                                      TextInputType.multiline,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(
                                      () {
                                        transformAnimationController.forward();
                                        slideAnimationController.forward();
                                      },
                                    );
                                  },
                                  child: Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height -
                  slideAnimation.value * 1.17,
              left: 0.0,
              right: 0.0,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setHeight(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Select work times',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_upward),
                            onPressed: () {
                              setState(
                                () {
                                  transformAnimationController.reverse();
                                  slideAnimationController.reverse();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_satarday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Satarday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: satarday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                satarday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _satarday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_sunday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Sunday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: sunday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                sunday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _sunday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_monday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Monday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: monday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                monday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _monday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_tuesday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Tuesday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: tuesday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                tuesday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _tuesday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_wednesday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Wednesday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: wednesday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                wednesday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _wednesday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_thursday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Thursday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: thursday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                thursday = val;

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _thursday =
                                      'FROM: ${start.hour}:${start.minute}   TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              subtitle: Text(_friday),
                              activeColor: Colors.blue,
                              title: Text(
                                'Friday',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: friday,
                              dense: true,
                              checkColor: Colors.white,
                              onChanged: (bool val) {
                                friday = val;
<<<<<<< HEAD

=======
>>>>>>> f2b4e750555c24ffeb8088ba1fc7aa2ec0dc4dfa
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(18),
                          ),
                          RaisedButton(
                            onPressed: () {
                              DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 1,
                                initialStartTime: DateTime.now(),
                                initialEndTime: DateTime.now().add(
                                  Duration(days: 20),
                                ),
                                mode: DateTimeRangePickerMode.time,
                                onConfirm: (start, end) {
                                  _friday =
                                      'FROM: ${start.hour}:${start.minute}  TO: ${end.hour}:${end.minute}';
                                  setState(() {});
                                },
                              ).showPicker(context);
                            },
                            child: Text('Time'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(28),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(48),
                        child: ProgressButton(
                          color: Colors.blue,
                          progressIndicatorColor: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: Text(
                            "Finish",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: (AnimationController controller) async {
                            processData(controller, context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(150),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, keyboardType) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
      onChanged: (input) {
        label == 'Fee'
            ? fee = input
            : label == 'Phone' ? phone = input : address = input;
      },
      onSaved: (input) {
        label == 'Fee'
            ? fee = input
            : label == 'Phone' ? phone = input : address = input;
      },
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        hintStyle: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }

  void processData(AnimationController controller, BuildContext context) async {
<<<<<<< HEAD
=======
    
>>>>>>> f2b4e750555c24ffeb8088ba1fc7aa2ec0dc4dfa
    if (address.isEmpty && locationLatlng == null) {
      AppUtils.showToast(msg: 'Please determine the clinic location');
    } else if (locationLatLng == 'Getting device location...' &&
            address == null ||
        address.isEmpty) {
      AppUtils.showToast(
          msg:
              'Please wait while getting device location or type address manually');
    } else if (fee.isEmpty) {
      AppUtils.showToast(msg: 'Type the dialy fee');
    } else if (int.parse(fee) <= 0) {
      AppUtils.showToast(msg: 'Fee can not be less then or equal to zero');
    } else if (phone != null && phone.isNotEmpty && phone.length < 9) {
      AppUtils.showToast(msg: 'Invalid phone');
    } else if (satarday && _satarday.isEmpty) {
      AppUtils.showToast(msg: 'Satarday time ?');
    } else if (sunday && _sunday.isEmpty) {
      AppUtils.showToast(msg: 'Sunday time ?');
    } else if (monday && _monday.isEmpty) {
      AppUtils.showToast(msg: 'Monday time ?');
    } else if (tuesday && _tuesday.isEmpty) {
      AppUtils.showToast(msg: 'Tuesday time ?');
    } else if (wednesday && _wednesday.isEmpty) {
      AppUtils.showToast(msg: 'Wednesday time ?');
    } else if (thursday && _thursday.isEmpty) {
      AppUtils.showToast(msg: 'Thuresday time ?');
    } else if (friday && _friday.isEmpty) {
      AppUtils.showToast(msg: 'Friday time ?');
    } else {
      controller.forward();
      if (!await AppUtils.getConnectionState()) {
        AppUtils.showDialog(
          context: context,
          title: 'Alert',
          negativeText: 'OK',
          positiveText: null,
          onPositiveButtonPressed: null,
          contentText: 'No Internet Connection',
        );

        controller.reverse();
        return;
      }
<<<<<<< HEAD
      workDays.clear();
=======
>>>>>>> f2b4e750555c24ffeb8088ba1fc7aa2ec0dc4dfa

      if (friday) {
        workDays.add({'Friday': _friday});
      }
      if (thursday) {
        workDays.add({'Thursday': _thursday});
      }
      if (wednesday) {
        workDays.add({'Wednesday': _wednesday});
      }
      if (tuesday) {
        workDays.add({'Tuesday': _tuesday});
      }
      if (monday) {
        workDays.add({'Monday': _monday});
      }
      if (sunday) {
        workDays.add({'Sunday': _sunday});
      }
      if (satarday) {
        workDays.add({'Satarday': _satarday});
<<<<<<< HEAD
      } else if (workDays.length == 0) {
        AppUtils.showToast(msg: 'Specify Work days and times');
      }
      print(workDays);

      await Firestore.instance
          .collection('clinics')
          .document(Pointer.currentUser.id)
          .setData(
        {
          'doctorId': Pointer.currentUser.id,
          'fee': fee,
          'latlong': locationLatLng == 'Getting device location...'
              ? ''
              : locationLatLng,
          'address': address == null ? '' : address,
          'phone': phone,
          'wordDays': workDays,
        },
      );

      await Firestore.instance
          .collection('human doctors')
          .document(Pointer.currentUser.id)
          .updateData(
        {
          'hasClinic': 'true',
        },
      );
      controller.reverse();
=======
      }
      print(workDays);
>>>>>>> f2b4e750555c24ffeb8088ba1fc7aa2ec0dc4dfa
    }
  }
}
