import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:smart_clinic/models/pointer.dart';

class PostFunctionality {
  static List<Widget> getSymptoms(DocumentSnapshot currentPost) {
    List symptoms = List.from(currentPost.data['Symptoms']);
    List<Widget> widgets = [];
    for (int i = 0; i < symptoms.length; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(8),
            right: ScreenUtil().setWidth(8),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Text(
                '.  ${symptoms[i]}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  static List<Widget> getpharmaceutical(DocumentSnapshot currentPost) {
    List pharmaceutical = List.from(currentPost.data['pharmaceutical']);
    List<Widget> widgets = [];
    for (int i = 0; i < pharmaceutical.length; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(8),
            right: ScreenUtil().setWidth(8),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Text(
                '.  ${pharmaceutical[i]}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  static void showPostComments({
    @required postId,
    @required BuildContext context,
    @required List comments,
  }) async {
    await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          snapSpec: SnapSpec(
            snap: true,
            snappings: [.4, .7, 0.94],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return Container(
              height: ScreenUtil.screenHeight,
              width: ScreenUtil.screenWidth,
              child: Material(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.all(
                      ScreenUtil().setHeight(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${comments.length ?? 0}',
                                style: TextStyle(fontFamily: 'Baloo'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static likeAndUnlikePost({
    @required List likes,
    @required String postID,
  }) async {
    var firestore = Firestore.instance.collection('posts').document(postID);
    if (likes.contains(Pointer.currentUser.id)) {
      await firestore.updateData(
        {
          'likes': FieldValue.arrayRemove([Pointer.currentUser.id]),
        },
      );
    } else {
      await firestore.updateData(
        {
          'likes': FieldValue.arrayUnion([Pointer.currentUser.id]),
        },
      );
    }
  }
}
