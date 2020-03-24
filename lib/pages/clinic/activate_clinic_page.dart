import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:smart_clinic/utils/app_utils.dart';

class ActivateClinicPage extends StatefulWidget {
  @override
  _ActivateClinicPageState createState() => _ActivateClinicPageState();
}

class _ActivateClinicPageState extends State<ActivateClinicPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final cardKey = GlobalKey<FlipCardState>();
  bool useCurrentLocation = true;
  bool clinicIsActivated = false;

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
  String locationLatLng = '';

  LatLng locationLatlng;
  var location = new Location();

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
                                                .askDevicePermission();
                                            if (isGranted) {
                                              location.getLocation().then(
                                                (location) {
                                                  locationLatlng = LatLng(
                                                    location.latitude,
                                                    location.longitude,
                                                  );
                                                  locationLatLng =
                                                      '${location.latitude.toStringAsFixed(4)} : ${location.longitude.toStringAsFixed(4)}';
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
                      buildDay('Satarday', satarday, _satarday),
                      buildDay('Sunday', sunday, _sunday),
                      buildDay('Monday', monday, _monday),
                      buildDay('Tuesday', tuesday, _tuesday),
                      buildDay('Wednesday', wednesday, _wednesday),
                      buildDay('Thursday', thursday, _thursday),
                      buildDay('Friday', friday, _friday),
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
                            //  processData(controller);
                          },
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
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
        label == 'Fee' ? fee = input : address = input;
      },
      onSaved: (input) {
        label == 'Fee' ? fee = input : address = input;
      },
      validator: (input) {
        if (input.isEmpty) {
          return 'Fill this field';
        } else if (int.parse(fee) <= 0) {
          return 'Fee can not be less than or equal to zero';
        } else {
          return null;
        }
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

  Widget buildDay(String day, bool dayIsCheck, String result) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CheckboxListTile(
            subtitle: Text(result),
            title: Text('$day'),
            value: dayIsCheck,
            onChanged: (val) {
              setState(
                () {
                  dayIsCheck = val;
                },
              );
            },
          ),
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
                result =
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
    );
  }
}
