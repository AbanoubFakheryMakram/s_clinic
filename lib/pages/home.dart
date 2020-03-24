import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic/models/pointer.dart';
import 'package:smart_clinic/models/user.dart';
import 'package:smart_clinic/pages/auth/login.dart';
import 'package:smart_clinic/pages/posts/posts_screen.dart';
import 'package:smart_clinic/pages/posts/search_action.dart';
import 'package:smart_clinic/pages/settings/main_settings_page.dart';
import 'package:smart_clinic/utils/app_utils.dart';
import 'package:smart_clinic/utils/firebase_methods.dart';

import 'clinic/clinic_page.dart';

class HomePage extends StatefulWidget {
  final String userSSN;

  HomePage({
    Key key,
    @required this.userSSN,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool networkIsActive;

  bool isCollapsed = false;

  final Duration _animationDuration = const Duration(milliseconds: 550);

  @override
  void initState() {
    super.initState();
    subscripToConnection();
  }

  void loadUserData() async {
    DocumentSnapshot snapshot = await FirebaseUtils.getCurrentUserData(
      ssn: widget.userSSN,
    );

    User currentUser = User.fromMap(snapshot.data);
    Pointer.currentUser = currentUser;
  }

  subscripToConnection() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(
          () {
            networkIsActive = AppUtils.getNetworkState(result);
            if (networkIsActive) {
              loadUserData();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppUtils.exitFromApp();
        return true;
      },
      child: DefaultTabController(
        length: 4,
        child: Stack(
          children: <Widget>[
            mainSideMenu(),
            mainHomeView(),
          ],
        ),
      ),
    );
  }

  Widget mainHomeView() {
    return AnimatedPositioned(
      duration: _animationDuration,
      top: isCollapsed ? 0.08 * ScreenUtil.screenHeight : 0,
      bottom: isCollapsed ? 0.08 * ScreenUtil.screenWidth : 0,
      left: isCollapsed ? 0.3 * ScreenUtil.screenWidth : 0,
      right: isCollapsed ? -0.5 * ScreenUtil.screenWidth : 0,
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        animationDuration: _animationDuration,
        elevation: 8,
        child: Scaffold(
          appBar: networkIsActive
              ? AppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: SearchAction(),
                        );
                      },
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Theme.of(context).accentColor,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    unselectedLabelColor: Colors.blueGrey,
                    tabs: [
                      Tab(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Center(
                            child: Text(
                              'Posts',
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Center(
                            child: Text(
                              'Clinic',
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Center(
                            child: Text(
                              'Notifications',
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Center(
                            child: Text(
                              'Profile',
                            ),
                          ),
                        ),
                      ),
                    ],
                    labelColor: Colors.black,
                  ),
                  elevation: 0,
                  title: Text(
                    'Smart Clinic',
                    style: TextStyle(
                      fontFamily: 'Radiant',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          isCollapsed = !isCollapsed;
                        },
                      );
                    },
                  ),
                )
              : null,
          body: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(8.0),
              left: ScreenUtil().setHeight(8.0),
              right: ScreenUtil().setHeight(8.0),
            ),
            child: Container(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              child: networkIsActive == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : !networkIsActive
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/no_internet_connection.jpg',
                                fit: BoxFit.cover,
                                width: ScreenUtil.screenWidth,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(18),
                              ),
                              Text(
                                'No   internet   connection',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Vonique',
                                ),
                              ),
                            ],
                          ),
                        )
                      : TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            PostsPage(),
                            ClinicPage(),
                            Container(
                              color: Colors.indigo,
                            ),
                            Container(
                              color: Colors.yellow,
                            )
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainSideMenu() {
    return Material(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(.2),
            ),
            duration: _animationDuration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Pointer.currentUser.image != null &&
                          Pointer.currentUser.image.isNotEmpty
                      ? CachedNetworkImageProvider(
                          Pointer.currentUser.image,
                        )
                      : Pointer.currentUser.gender == 'Male'
                          ? AssetImage(
                              'assets/images/male.png',
                            )
                          : AssetImage(
                              'assets/images/female.png',
                            ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(18.0),
                    vertical: ScreenUtil().setHeight(3.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${Pointer.currentUser.name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${Pointer.currentUser.specialist}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              setState(
                () {
                  isCollapsed = !isCollapsed;
                },
              );
            },
            leading: Icon(
              Icons.message,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Messages',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(
                () {
                  isCollapsed = !isCollapsed;
                },
              );
            },
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Utility Bills',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(
                () {
                  isCollapsed = !isCollapsed;
                },
              );
            },
            leading: Icon(
              Icons.transfer_within_a_station,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Funds Transfer',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(
                () {
                  isCollapsed = !isCollapsed;
                },
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return SettingsPage();
                  },
                ),
              );
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Divider(
            height: ScreenUtil().setHeight(22),
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            onTap: () async {
              await SharedPreferences.getInstance().then(
                (pref) {
                  pref.clear();
                },
              );

              Navigator.of(context).push(
                PageTransition(
                  child: LoginPage(),
                  type: PageTransitionType.upToDown,
                ),
              );
            },
            leading: Icon(
              Icons.branding_watermark,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
