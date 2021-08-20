import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/saveImageTodisk.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/auth/registerScreen.dart';
import 'package:path_provider/path_provider.dart';

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
  }

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

    final double widgetHeight = 0.08 * deviceSize.height;

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
                              height: widgetHeight,
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => RegisterScreen()));
                              },
                              radius: 20.0,
                              textColor: Colors.white,
                              color: APP_BAR_COLOR,
                              text: "Sign up Now"),
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
