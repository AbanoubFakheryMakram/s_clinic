import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('human doctors')
            .orderBy('name')
            .startAt(['ا']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
             
            return Card(
              child: Container(
                height: 48,
                child: Center(
                  child: Text(
                    snapshot.data.documents[0]['name'],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Loading',
              ),
            );
          }
        },
      ),
    );
  }
}
