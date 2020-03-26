import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/utils/app_utils.dart';

import 'diagonsis.dart';

class Pharmaceutical extends StatefulWidget {
  @override
  _PharmaceuticalState createState() => _PharmaceuticalState();
}

class _PharmaceuticalState extends State<Pharmaceutical> {
  List<String> tags = List();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pharmaceutical'),
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
                    msg: 'Select pharmaceutical !',
                  );
                } else {
                  Pointer.currentPost.pharmaceutical = tags;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Diagnosis(),
                    ),
                  );
                }
                ;
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(14),
            vertical: ScreenUtil().setHeight(18),
          ),
          child: Column(
            children: <Widget>[
              Text(
                'What are the Pharmaceutical used ?',
              ),
              SizedBox(
                height: ScreenUtil().setHeight(18),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(18),
                ),
                width: double.infinity,
                height: ScreenUtil().setHeight(40),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: 'medicament name',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(18),
              ),
              Expanded(
                child: ListView(
                  children: buildSymptomsItem(
                    [
                      'item1',
                      'item2',
                      'item3',
                      'item4',
                      'item5',
                      'item6',
                      'item7',
                      'item8',
                      'item9',
                      'item10',
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildSymptomsItem(List pharmaceutical) {
    List<Widget> chips = List();
    for (int i = 0; i < pharmaceutical.length; i++) {
      chips.add(
        CheckboxListTile(
          dense: true,
          title: Text(
            pharmaceutical[i],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          value: tags.contains(pharmaceutical[i]),
          onChanged: (bool selected) {
            if (selected) {
              tags.add(pharmaceutical[i]);
            } else {
              tags.remove(pharmaceutical[i]);
            }
            setState(() {});
          },
        ),
      );
    }

    return chips;
  }
}

/*
*
* */
