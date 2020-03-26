import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/models/case.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/posts/functionality.dart';
import 'package:smart_clinic/pages/posts/widgets.dart';
import 'package:smart_clinic/utils/app_utils.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool like = false;
  List<String> likes = <String>[];
  List<String> comments = <String>[];

  StringBuffer currentSymptoms = StringBuffer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('cases')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot currentCase = snapshot.data.documents[index];
                  Case _case = Case.fromDoc(currentCase.data);
                  like = false;

                  likes = _case.likes;
                  if (likes.isNotEmpty) {
                    if (likes.contains(Pointer.currentUser.id)) {
                      like = true;
                    }
                  }
                  return buildCase(_case);
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buildCase(Case _case) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
        vertical: ScreenUtil().setHeight(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
        vertical: ScreenUtil().setHeight(10),
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(3, 3),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  PostWidgets.buildDoctorProfileImage(
                    imageURL: _case.doctor_image,
                    gender: _case.doctor_gender,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr: ${_case.doctor_name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${AppUtils.getTimeAgo(_case.date)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${_case.doctor_spec}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Text(
            'A ${_case.patient_gender} with height = ${_case.patient_height} cm and weight = ${_case.patient_weight} kg',
          ),
          Text(
            'The BMI was: ${_case.patient_bmi} kg/m²',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(8),
          ),
          Text(
            'Has the following symptoms',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: PostFunctionality.buildItemsList(_case.symptoms),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(8),
          ),
          Text(
            'My diagonsis was',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(_case.diagnosis),
          SizedBox(
            height: ScreenUtil().setHeight(8),
          ),
          Text(
            'And i wrote these pharmaceutical',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: PostFunctionality.buildItemsList(_case.pharmaceutical),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(
              10,
            ),
          ),
          PostWidgets.buildCommentLikeButtons(
            comments: _case.comments,
            context: context,
            likes: _case.likes,
            postID: _case.post_id,
            like: like,
          ),
          PostWidgets.countCommentsAndLikes(
            comments: _case.comments,
            likes: _case.likes,
          ),
        ],
      ),
    );
  }
}
