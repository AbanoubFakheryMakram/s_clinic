import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic/animation/fade_animation.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/pages/posts/functionality.dart';
import 'package:smart_clinic/pages/posts/widgets.dart';
import 'package:smart_clinic/providers/theme_provider.dart';
import 'package:smart_clinic/utils/app_utils.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  String imageURL = '';
  String name = '';
  String specialization = '';
  String gender = '';
  String postID;

  double duration = 0;

  bool like = false;
  List<String> likes = <String>[];
  List<String> comments = <String>[];

  StringBuffer currentSymptoms = StringBuffer();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appTheme, Widget child) {
        return Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          child: StreamBuilder(
            stream: Firestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot currentPost =
                        snapshot.data.documents[index];
                    imageURL = currentPost.data['doctor_image'];
                    name = currentPost.data['doctor_name'];
                    gender = currentPost.data['doctor_gender'];
                    specialization = currentPost.data['doctor_specialization'];
                    postID = currentPost.data['post_id'];
                    likes = List.from(currentPost.data['likes']);
                    comments = List.from(currentPost.data['comments']);

                    like = false;

                    if (likes.isNotEmpty) {
                      if (likes.contains(Pointer.currentUser.id)) {
                        like = true;
                      }
                    }

                    return Consumer<AppThemeProvider>(
                      builder: (BuildContext context, AppThemeProvider appTheme,
                          Widget child) {
                        return MyFadeAnimation(
                          delayinseconds: duration,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(8),
                              right: ScreenUtil().setWidth(8),
                              top: ScreenUtil().setWidth(18),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: !appTheme.isDark
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        offset: Offset(1, 4),
                                        blurRadius: 5,
                                      ),
                                    ]
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: ScreenUtil.screenWidth,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(8),
                                left: ScreenUtil().setWidth(8),
                                right: ScreenUtil().setWidth(8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(8.0),
                                  vertical: ScreenUtil().setHeight(8.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            PostWidgets.buildDoctorProfileImage(
                                              imageURL: imageURL,
                                              gender: gender,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(11),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Dr: $name',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '${AppUtils.getTimeAgo(currentPost.data['date'])}',
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
                                          specialization,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: ScreenUtil().setHeight(25),
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Symptoms: ',
                                          style: TextStyle(
                                            fontFamily: 'Baloo',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                PostFunctionality.getSymptoms(
                                              currentPost,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: ScreenUtil().setHeight(25),
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Diagnosis: ',
                                          style: TextStyle(
                                            fontFamily: 'Baloo',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(8),
                                            right: ScreenUtil().setWidth(8),
                                          ),
                                          child: Text(
                                            '${currentPost.data['Diagnosis']}',
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: ScreenUtil().setHeight(25),
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'pharmaceutical: ',
                                          style: TextStyle(
                                            fontFamily: 'Baloo',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: PostFunctionality
                                                .getpharmaceutical(currentPost),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(
                                        10,
                                      ),
                                    ),
                                    PostWidgets.buildCommentLikeButtons(
                                      comments: comments,
                                      context: context,
                                      likes: likes,
                                      postID: postID,
                                      like: like,
                                      currentPost: currentPost,
                                    ),
                                    PostWidgets.countCommentsAndLikes(
                                      comments: comments,
                                      likes: likes,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }
}
