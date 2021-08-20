import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/models/user_model.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/registerScreen.dart';
import 'package:gamie/services/cloud_firestore_services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/authUserProvider.dart';
import 'package:the_validator/the_validator.dart';
import '../homeScreen.dart';
import 'reset_password_screens/emailEntry.dart';

Widget getUser(User user) {
  return StreamBuilder(
      stream: CloudFirestoreServices.userStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print('snap has error');
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> data = snapshot.data.docs;

          if (data.length == 0) print('no data');
          return saveDoc(UserDataModel.fromMap(data[0], 0), prefs);
        } else
          return SizedBox.shrink();
      });
}

Widget saveDoc(UserDataModel model, SharedPreferences prefs) {
  Map<String, dynamic> userData = {};

  userData['userid'] = model.id;
  userData['full_name'] = model.fullName;
  userData['photURL'] = model.photoURL;
  userData['email_address'] = model.email;
  userData['phone_number'] = model.phoneNumber;
  userData['school'] = model.school;

  prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(userData));
  print('finished');

  return HomeScreen();
}

class LoginScreen extends StatefulWidget {
  static String routeName = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = "";
  var pass = "";
  var errorMessage = "";
  var isBusy = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  _loginNow() async {
    var validEmail = Validator.isEmail(email);
    var validPassword = Validator.isPassword(pass, minLength: 6);
    if (validEmail && !validPassword) {
      setState(() {
        errorMessage = 'Password must be 6 characters or more';
      });
    } else if (validPassword && !validEmail) {
      setState(() {
        errorMessage = 'Please input a valid email address';
      });
    } else if (!validEmail && !validPassword) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (email.isEmpty && !validPassword) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (!validEmail && email.isEmpty) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (email.isEmpty && pass.isEmpty) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    }
    setState(() {
      isBusy = true;
    });

    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((resp) async {
      setState(() {
        isBusy = false;
      });
      if (resp.user != null) {
        Provider.of<UserAuthProvider>(context, listen: false).setAuthUser =
            resp.user;

        if (_auth.currentUser.emailVerified) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyClass.routeName, (route) => false);
        } else {
          resp.user.sendEmailVerification();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Confirm Email"),
                content: new Text(
                    'Verification email has been sent to your email address. Kindly verify your email and login again'),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  new FlatButton(
                    child: new Text("Dismiss"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        setState(() {
          errorMessage = 'user doesn\'t exist!';
        });
      }
    }).catchError((e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error"),
            content: new Text(e.message == 'Given String is empty or null'
                ? 'email or password cannot be empty'
                : e.message),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print(e.message);
    });
  }

// this comment wasn't necessary
  // ignore: unused_element
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Want to exit?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: NORMAL_HEADER,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "Yes",
                  style: NORMAL_HEADER,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double widgetWidth = deviceSize.width * 0.9;
    //changed widgetHeight value
    final double widgetHeight =
        0.07 * deviceSize.height; // Change width of evrytng from here

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceSize.height,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: CustomBackground()),
              Positioned.fill(
                child: Container(
                
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            maintainSize: false,
                            maintainAnimation: false,
                            maintainState: false,
                            visible: isBusy,
                            child: SizedBox(
                              height: deviceSize.height,
                              width: deviceSize.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingBouncingGrid.square(
                                    size: deviceSize.width / 4,
                                    borderSize: deviceSize.width / 8,
                                  ),
                                  Text(
                                    "Try to login\nPlease hold a sec",
                                    style: NORMAL_HEADER,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login Now",
                            style: NORMAL_HEADER,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Login to continue using our app",
                            style: SMALL_DISABLED_TEXT,
                          ),
                          SizedBox(
                            height: widgetHeight,
                          ),

                          SizedBox(
                            height: 40,
                          ),

                          Align(
                              alignment: Alignment.center,
                              child: Text("Login with email and password",
                                  style: SMALL_DISABLED_TEXT)),
                          SizedBox(
                            height: 30,
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: widgetHeight,
                              width: widgetWidth,
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  onChanged: (val) {
                                    setState(() {
                                      errorMessage = "";
                                      email = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Enter your email address",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: widgetHeight,
                              width: widgetWidth,
                              child: TextFormField(
                                obscureText: true,
                                obscuringCharacter: "*",
                                textAlign: TextAlign.center,
                                onChanged: (val) {
                                  setState(() {
                                    errorMessage = "";
                                    pass = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Enter you password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              EmailEntry())),
                                  child: Text("Forgot Password?",
                                      style: SMALL_BLUE_TEXT_STYLE),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !isBusy,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    errorMessage,
                                    style: ERROR_MSG_TEXTSTYLE,
                                  )),
                            ),
                          ), //ERROR MESSAGE
                          RoundedButtonWithColor(
                            text: "Login to my account",
                            onPressed: () async {
                              await _loginNow();
                            },
                            width: widgetWidth,
                            height: widgetHeight,
                            backgroundColor: APP_BAR_COLOR,
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style: SMALL_DISABLED_TEXT,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  );
                                },
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterScreen(),
                                      )),
                                  child: Text(
                                    "Register",
                                    style: SMALL_BLUE_TEXT_STYLE,
                                  ),
                                ),
                              ),
                            ],
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

class RoundedButtonWithColor extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final Function onPressed;
  const RoundedButtonWithColor({
    this.text,
    this.textColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        // ignore: deprecated_member_use
        child: FlatButton(
          color: backgroundColor != null
              ? backgroundColor
              : Color.fromRGBO(8, 87, 171, 1),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: textColor != null ? textColor : Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
