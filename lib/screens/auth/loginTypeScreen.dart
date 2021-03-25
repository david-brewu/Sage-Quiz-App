import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/gettingStartedScreen.dart';
import 'package:gamie/screens/auth/login.dart';

class LoginTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceSize.height,
          color: MAIN_BACK_COLOR,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: CustomBackground()),
              Positioned.fill(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 60),
                          Text(APP_NAME, style: TITLE),
                          Text(
                            APP_SLOGAN,
                            style: SMALL_DISABLED_TEXT,
                          ),
                          SizedBox(height: 70),
                          Container(
                            width: deviceSize.width,
                            child: Image.asset(GIRL_WITH_LAPTOP_IMG,
                                fit: BoxFit.cover),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            width: deviceSize.width,
                            height: 50,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => LoginScreen()));
                              },
                              child: Text("Login now",
                                  style: NORMAL_BLACK_BUTTON_TEXT),
                              color: ASH_BUTTON_COLOR,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: deviceSize.width,
                            height: 50,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        GettingStartedScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Getting Started",
                                      style: MEDIUM_WHITE_BUTTON_TEXT),
                                ],
                              ),
                              color: FACEBOOK_BLUE_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
