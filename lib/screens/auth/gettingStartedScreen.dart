import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/saveImageTodisk.dart';
import 'package:gamie/models/google_auth.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/auth/registerScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../Providers/authUserProvider.dart';
import 'package:toast/toast.dart';
import '../homeScreen.dart';
import '../../config/config.dart';

class GettingStartedScreen extends StatefulWidget {
  static final String routeName = "getting_started_screen";

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  bool authState;

  @override
  void initState() {
    super.initState();
    // BackgroundPreps();
  }

  // ignore: non_constant_identifier_names
  void backgroundPrseps() async {
    setProfileAvatar();
  }

  void setProfileAvatar() async {
    String avatarLink =
        (await getApplicationDocumentsDirectory()).path + USER_AVATAR_FILENAME;
    bool avatarExists = File(avatarLink).existsSync();
    if (!avatarExists) {
      try {
        saveImageToDisk(DEFAULT_USER_AVATAR, avatarLink);
        return;
      } catch (error) {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    //tweaked widgetHeight value
    final double widgetHeight = 0.08 * deviceSize.height;
    final auth = Provider.of<UserAuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceSize.height,
          color: MAIN_BACK_COLOR,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: CustomBackground()),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 8),
                      child: Text(
                        'Get Started now',
                        style: NORMAL_HEADER,
                      ),
                    ),
                    SizedBox(
                      height: widgetHeight / 2,
                    ),
                    Container(
                      height: 200,
                      child:
                          Image.asset(GETTING_STARTED_IMG, fit: BoxFit.cover),
                    ),
                    SizedBox(
                      height: widgetHeight,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomRoundedButton(
                            onTap: () async {
                              signInWithGoogle().then((value) {
                                if (value.user != null) {
                                  auth.setAuthUser = value.user;
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      HomeScreen.routeName, (route) => false);
                                } else {
                                  Toast.show('Error Signing in!', context,
                                      duration: Toast.LENGTH_LONG);
                                }
                              }).catchError((err) {
                                Toast.show('Error Signing in!', context,
                                    duration: Toast.LENGTH_LONG);
                              });
                            },
                            radius: 20.0,
                            height: widgetHeight,
                            image: GOOGLE_IMG,
                            color: ASH_BUTTON_COLOR,
                            text: "Continue with Google",
                          ),
                          SizedBox(height: 40),
                          CustomRoundedButton(
                              height: widgetHeight,
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => RegisterScreen()));
                              },
                              radius: 20.0,
                              textColor: Colors.white,
                              color: APP_BAR_COLOR,
                              text: "Sign up with Email"),
                          Padding(
                            padding: const EdgeInsets.only(top: 58.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Existing User?",
                                  style: SMALL_DISABLED_TEXT,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Text(
                                    "Login now",
                                    style: SMALL_WITH_BLACK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
