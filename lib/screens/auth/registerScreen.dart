import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/ErrorHandler.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/auth/registerSteps/personalInfo_on_register.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../Providers/authUserProvider.dart';

//fixed the continue problem by importing the right file
import 'registerSteps/emailStep.dart';
import 'registerSteps/passwordStep.dart';
import 'registerSteps/termsStep.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String errorMessage = "Please enter valid inputs to continue";
  FirebaseAuth _auth = FirebaseAuth.instance;
  List states = List.generate(4, (index) => StepState.indexed);
  BuildContext openContext;
  int _currentStep = 0;
  bool isBusy = false;
  final _emailFormkey = GlobalKey<FormState>();
  final _personalInfoFormkey = GlobalKey<FormState>();
  final _passwordFormkey = GlobalKey<FormState>();
  List keys;

  void initializeKeys() {
    keys = [_personalInfoFormkey, _emailFormkey, _passwordFormkey];
  }

  SnackBar _buildSnackBar() {
    return SnackBar(
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text(errorMessage),
          ],
        ));
  }

  List<Step> _steps() {
    return [
      Step(
        state: states[0],
        isActive: true,
        title: Text("Personal Info", style: LABEL_TEXT_STYLE_MEDIUM),
        content: PersonalInfoOnRegister(
          formKey: keys[0],
        ),
      ),
      Step(
          state: states[1],
          isActive: this._currentStep >= 1,
          title: Text(
            "Email And Phone Number",
            style: LABEL_TEXT_STYLE_MEDIUM,
          ),
          content: EmailStep(formKey: keys[1])),
      Step(
          state: states[2],
          isActive: this._currentStep >= 2,
          title: Text(
            "Password",
            style: LABEL_TEXT_STYLE_MEDIUM,
          ),
          content: PasswordStep(formKey: keys[2])),
      Step(
          state: states[3],
          isActive: this._currentStep >= 3,
          title: Text(
            "Terms And Conditions",
            style: LABEL_TEXT_STYLE_MEDIUM,
          ),
          content: TermsStep()),
    ];
  }

  void _onStepContinue(BuildContext context) async {
    openContext = context;
    //print("Current: ${_currentStep} steps: ${_steps().length}");

    if (_currentStep == _steps().length - 1) {
      print("should sign up.. Terms: ${TermsStep().createState().hasAgreed()}");
      if (TermsStep().createState().hasAgreed()) {
        _signUp();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Row(
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Please agree in order to continue"),
            ],
          ),
        ));
      }
    }
    if (_currentStep < _steps().length - 1) {
      if (keys[_currentStep].currentState.validate()) {
        setState(() {
          states[_currentStep] = StepState.complete;
          _currentStep++;
          states[_currentStep] = StepState.editing;
        });
      } else {
        setState(() {
          states[_currentStep] = StepState.error;
        });
        Scaffold.of(context).showSnackBar(_buildSnackBar());
      }
    }
    if (_currentStep > _steps().length - 1) {
      print("Strayed away to ${_steps().length}");
      // This should not happen so do nothing...
      // But I hate to see magic in this code so...
      // let's return the user back to terms
      // if they somehow find themselves here
      _currentStep = _steps().length - 1;
    }
    return;
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future _signUp() async {
    FocusScope.of(openContext).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = await jsonDecode(
      prefs.get(PREFS_PERSONAL_INFO),
    );

    // WANTED TO DO ONE MORE VERIFICATION LIKE: data.keys.length
    setState(() {
      isBusy = true;
    });
    await _auth
        .createUserWithEmailAndPassword(
            email: data["email_address"], password: data["password"])
        .then((user) {
      data.remove("password");
      user.user.updateProfile(displayName: data["full_name"]);
      data["uid"] = user.user.uid;
      return FirebaseFirestore.instance
          .collection("users")
          .add(data)
          .then((resp) {
        data["userid"] = resp.id;
        prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));
        setState(() {
          isBusy = false;
        });
        Navigator.of(context).pop();
        Provider.of<UserAuthProvider>(context, listen: false).setAuthUser =
            user.user;

        user.user.sendEmailVerification();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Confirm Email"),
              content: new Text(
                  'Verification email has been sent to your email. Kindly verify your email address and login into your new account'),
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
        /* return Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => HomeScreen()),(predicate)=>false); */
      });
    }).catchError((error) {
      setState(() {
        errorMessage = errorHandler(error.code);
        isBusy = false;
      });

      return Scaffold.of(openContext).showSnackBar(SnackBar(
        action: SnackBarAction(
          textColor: APP_BAR_COLOR,
          label: "Reset password",
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        duration: Duration(seconds: 15),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: Text(errorMessage)),
          ],
        ),
      ));
    });
    return;
  }

  Widget _buildControls(context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _currentStep != 0
              // ignore: deprecated_member_use
              ? FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.red,
                  onPressed: onStepCancel,
                  child:
                      Text("Previous Step", style: NORMAL_WHITE_BUTTON_LABEL))
              : SizedBox(
                  width: 3,
                  height: 3,
                ),
          // ignore: deprecated_member_use
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.green,
              onPressed: onStepContinue,
              child: Text(
                "Continue",
                style: NORMAL_WHITE_BUTTON_LABEL,
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeKeys();
    isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceSize.height,
          color: MAIN_BACK_COLOR,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: CustomBackground()),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        visible: isBusy == true,
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
                                "Getting your account.\nPlease hold a sec",
                                style: NORMAL_HEADER,
                              )
                            ],
                          ),
                        ),
                      ), //The loading box
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Please fill out the form to sign up",
                            style: SMALL_DISABLED_TEXT,
                          )
                        ],
                      ),
                      Builder(builder: (context) {
                        return Stepper(
                            controlsBuilder: _buildControls,
                            currentStep: _currentStep,
                            onStepCancel: _onStepCancel,
                            onStepContinue: () {
                              _onStepContinue(context);
                            },
                            physics: BouncingScrollPhysics(),
                            type: StepperType.vertical,
                            steps: _steps());
                      })
                    ],
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
