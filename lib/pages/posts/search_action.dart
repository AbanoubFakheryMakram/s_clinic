import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchAction extends SearchDelegate<String> {
  SearchAction()
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldLabel: 'Search here...',
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          //color: appTheme.isDark ? Colors.white : Colors.black,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        // color: appTheme.isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        close(
          context,
          null,
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(
      query,
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == null || query.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(
            ScreenUtil().setHeight(8.0),
          ),
          child: Text(
            'Search for doctor by name, specialization or degree',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return StreamBuilder(
      stream: Firestore.instance.collection('human doctors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: ((_, index) {
              if (snapshot.data.documents[index]['name'].contains('$query') ||
                  snapshot.data.documents[index]['specialist']
                      .contains('$query') ||
                  snapshot.data.documents[index]['degree'].contains('$query')) {
                DocumentSnapshot currentDoctor = snapshot.data.documents[index];
                return index % 2 == 0
                    ? SlideInLeft(
                        child: Padding(
                          padding: EdgeInsets.all(
                            ScreenUtil().setHeight(8.0),
                          ),
                          child: ListTile(
                            onTap: () {},
                            title: Row(
                              children: <Widget>[
                                Text(
                                  '${currentDoctor['name']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${currentDoctor['specialist']} doctor',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text('${currentDoctor['degree']}'),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  currentDoctor.data['image'] != null &&
                                          currentDoctor.data['image'].isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          currentDoctor.data['image'],
                                        )
                                      : currentDoctor.data['gender'] == 'Male'
                                          ? AssetImage(
                                              'assets/images/male.png',
                                            )
                                          : AssetImage(
                                              'assets/images/female.png',
                                            ),
                            ),
                            trailing: Icon(
                              Icons.album,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      )
                    : SlideInRight(
                        child: Padding(
                          padding: EdgeInsets.all(
                            ScreenUtil().setHeight(8.0),
                          ),
                          child: ListTile(
                            onTap: () {},
                            title: Row(
                              children: <Widget>[
                                Text(
                                  '${currentDoctor['name']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${currentDoctor['specialist']} doctor',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text('${currentDoctor['degree']}'),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  currentDoctor.data['image'] != null &&
                                          currentDoctor.data['image'].isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          currentDoctor.data['image'],
                                        )
                                      : currentDoctor.data['gender'] == 'Male'
                                          ? AssetImage(
                                              'assets/images/male.png',
                                            )
                                          : AssetImage(
                                              'assets/images/female.png',
                                            ),
                            ),
                            trailing: Icon(
                              Icons.album,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      );
              } else {
                return SizedBox.shrink();
              }
            }),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        }
      },
    );
  }
}
