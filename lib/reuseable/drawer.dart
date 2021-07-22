import 'dart:convert';

import 'package:gamie/payments/main_payments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/profilePageWidgets/personalInfo.dart';
import 'package:gamie/screens/user/user_course_management.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/screens/Knowledge/pascoPage.dart';
import 'package:gamie/screens/user/settingScreen.dart';
import 'package:provider/provider.dart';
import '../screens/auth/gettingStartedScreen.dart';
import '../Providers/authUserProvider.dart';

String mydocID;

class CustomDrawer extends StatelessWidget {
  //CustomDrawer(this.name, this.phone, this.address, this.photo, this.email);
  @override
  Widget build(BuildContext context) {
    // String id;

    // Map<String, dynamic> data;
    final user = Provider.of<UserAuthProvider>(context);
    return SafeArea(
      child: Theme(
        data: ThemeData(primaryColor: APP_BAR_COLOR),
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              UserAccountsDrawerHeader(
                  currentAccountPicture: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: user.authUser.photoURL != null
                          ? CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  user.authUser.photoURL))
                          : Image.asset(
                              USER_PROFILE_PIC,
                              fit: BoxFit.cover,
                            )),
                  accountName: Text(
                    "${user != null ? user.authUser.displayName ?? '' : ""}",
                    style: MEDIUM_WHITE_BUTTON_TEXT,
                  ),
                  accountEmail: Text(
                    "${user != null ? user.authUser.email : ""}",
                    style: SMALL_DISABLED_TEXT,
                  )),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        getUser(FirebaseAuth.instance.currentUser);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    UserCourses()));
                      },
                      leading: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Manage Courses",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        getUser(FirebaseAuth.instance.currentUser);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Map<String, dynamic> data =
                            jsonDecode(prefs.getString(PREFS_PERSONAL_INFO));
                        mydocID = data['userid'];
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PersonalInfo(
                                  formKey: GlobalKey<FormState>(),
                                  docID: mydocID,
                                )));
                      },
                      leading: Icon(
                        FontAwesome5.edit,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Profile",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PascoPage()));
                      },
                      leading: Icon(
                        FontAwesome.book,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Past Questions",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      //linked all payments to only one payment screen
                      onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (BuildContext context) => Payments())),
                      leading: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Payments",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () {
                        // Navigator.pop(context);
                        //Navigator.of(context).push(CupertinoPageRoute(
                        //  builder: (context) => InviteScreen()));
                        final RenderBox box = context.findRenderObject();
                        Share.share('text',
                            subject: 'Check Out this Cool App',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                      leading: Icon(
                        Icons.local_laundry_service,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Invite Friend",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Settings",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () async {
                        //removes drawer first then
                        Navigator.pop(context);
                        //show dialog
                        _showAlertDialog(context);
                      },
                      leading: Icon(
                        AntDesign.logout,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Log Out",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text('Are you sure you want to log out?'),
      title: Text('Log Out'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            // await GoogleSignIn().signOut();
            //Provider.of<UserAuthProvider>(context).reset();
            //go to getting started
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                    builder: (context) => GettingStartedScreen()),
                (route) => false);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
