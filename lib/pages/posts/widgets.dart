import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_clinic/pages/posts/functionality.dart';

class PostWidgets {
  static Widget buildDoctorProfileImage({
    @required imageURL,
    @required String gender,
  }) {
    return imageURL != null && imageURL.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              width: ScreenUtil().setWidth(40),
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(40),
              imageUrl: imageURL,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )
        : gender == 'Male'
            ? Image.asset(
                'assets/images/male.png',
                fit: BoxFit.cover,
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setHeight(40),
              )
            : Image.asset(
                'assets/images/female.png',
                fit: BoxFit.cover,
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setHeight(40),
              );
  }

  static Widget countCommentsAndLikes({
    @required List likes,
    @required List comments,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              '${likes.length ?? 0} Likes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '${comments.length ?? 0} Comments',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildCommentLikeButtons({
    @required List comments,
    @required List likes,
    @required BuildContext context,
    @required bool like,
    @required String postID,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlineButton(
            color: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            hoverColor: Theme.of(context).accentColor,
            splashColor: Theme.of(context).accentColor,
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              PostFunctionality.likeAndUnlikePost(
                likes: likes,
                postID: postID,
              );
            },
            child: Text(
              like ? 'Unlike' : 'Like',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: OutlineButton(
            color: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            hoverColor: Theme.of(context).accentColor,
            splashColor: Theme.of(context).accentColor,
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              PostFunctionality.showPostComments(
                comments: comments,
                context: context,
                postId: postID,
              );
            },
            child: Text(
              'Comment',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
