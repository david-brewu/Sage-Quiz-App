import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'emailConfirmation.dart';

// ignore: must_be_immutable
class EmailEntry extends StatefulWidget {
  @override
  _EmailEntryState createState() => _EmailEntryState();
}

class _EmailEntryState extends State<EmailEntry> {
  TextEditingController _mycontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String image = "assets/images/forgot_password.png";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _onProceed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _verysend();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: CustomBackground()),
            Positioned.fill(
                child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildImage(image),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (val) {
                            //valid form here
                            if (!(val.contains('@') || val.contains('.'))) {
                              return 'Enter a valid email address';
                            }
                            //else return null
                            return null;
                          },
                          controller: _mycontroller,
                          decoration: InputDecoration(
                            focusColor: APP_BAR_COLOR,
                            icon: Icon(
                              Icons.email,
                              color: APP_BAR_COLOR,
                            ),
                            hintText: "Enter email here",
                            hintStyle: MEDIUM_DISABLED_TEXT,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        child: Builder(
                          // ignore: deprecated_member_use
                          builder: (BuildContext context) => FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: APP_BAR_COLOR,
                              onPressed: () => _verysend(),
                              child: Text(
                                "Proceed",
                                style: MEDIUM_WHITE_BUTTON_TEXT,
                              )),
                        ))
                  ],
                ),
              ),
            )),
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ))
          ],
        ),
      ),
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reset Password"),
          content:
              new Text("Link to reset password has been sent to your email"),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                //toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verysend() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _auth.sendPasswordResetEmail(email: _mycontroller.text);
        _formKey.currentState.reset();
        _showVerifyEmailSentDialog();
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Error"),
              content: new Text(e.message),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text("Dismiss"),
                  onPressed: () {
                    _formKey.currentState.reset();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // print(e.message);

        _formKey.currentState.reset();
      }
    }
  }

  Widget _buildImage(String imagePath) =>
      Image.asset(imagePath, fit: BoxFit.cover);
}
