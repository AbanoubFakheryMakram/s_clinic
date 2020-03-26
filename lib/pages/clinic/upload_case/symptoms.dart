import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/clinic/upload_case/pharmaceutical.dart';
import 'package:smart_clinic/utils/app_utils.dart';

import '../../../repo/symptoms_repo.dart';

class Symptoms extends StatefulWidget {
  @override
  _SymptomsState createState() => _SymptomsState();
}
//  الاعرض

class _SymptomsState extends State<Symptoms> {
  List<String> tags = [];
  List<String> options = SymptomsRepo.heartSymptoms;

  @override
  Widget build(BuildContext context) {
// ChipsChoice<T>.multiple
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select the Symptoms',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Center(child: Text('${tags.length}')),
            SizedBox(
              width: ScreenUtil().setWidth(8),
            ),
            IconButton(
              icon: Icon(Icons.forward),
              onPressed: () {
                if (tags.isEmpty) {
                  AppUtils.showToast(
                    msg: 'Select Symptoms !',
                  );
                } else {
                  Pointer.currentPost.symptoms = tags;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Pharmaceutical(),
                    ),
                  );
                }
                ;
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: buildSymptomsItem(options),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildSymptomsItem(List options) {
    List<Widget> chips = List();
    for (int i = 0; i < options.length; i++) {
      chips.add(
        CheckboxListTile(
          dense: true,
          title: Text(
            options[i],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          value: tags.contains(options[i]),
          onChanged: (bool selected) {
            if (selected) {
              tags.add(options[i]);
            } else {
              tags.remove(options[i]);
            }
            setState(() {});
          },
        ),
      );
    }

    return chips;
  }
}
