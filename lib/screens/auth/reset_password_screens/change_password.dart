import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';

// ignore: must_be_immutable
class ChangePassword extends StatelessWidget {
  //img path
  String imagePath = "assets/images/enter_password.png";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //controller for textfields
  TextEditingController _firstCtl = TextEditingController();
  TextEditingController _secondCtl = TextEditingController();

  //change focusNode
  void _changeNodeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  //focus nodes
  final FocusNode _firstNode = FocusNode();
  final FocusNode _secondNode = FocusNode();

  //button click
  void _onChangePassword(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      //check if password is valid
      //change Password
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            Text("Password Changed")
          ],
        ),
        duration: Duration(milliseconds: 500),
      ));
      //navigate to different screen after password is changed
      return;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text("Please complete form with required values")
        ],
      ),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: CustomBackground()),
            Positioned.fill(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildImage(imagePath),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) => _changeNodeFocus(
                                context, _firstNode, _secondNode),
                            focusNode: _firstNode,
                            validator: (val) {
                              if (val.length < 6) {
                                return "password can't be lesser than 6";
                              }
                              return null;
                            },
                            controller: _firstCtl,
                            decoration: InputDecoration(
                                hintText: "Enter new password",
                                hintStyle: MEDIUM_DISABLED_TEXT),
                          ),
                          Builder(
                            builder: (BuildContext context) => TextFormField(
                              style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                              textInputAction: TextInputAction.send,
                              focusNode: _secondNode,
                              validator: (val) {
                                if (_secondCtl.text != _firstCtl.text) {
                                  return "passwords should be same";
                                }
                                return null;
                              },
                              onFieldSubmitted: (field) =>
                                  _onChangePassword(context),
                              controller: _secondCtl,
                              decoration: InputDecoration(
                                  hintText: "Confirm password",
                                  hintStyle: MEDIUM_DISABLED_TEXT),
                            ),
                          ),
                          SizedBox(
                            height: 0.05 * deviceSize.height,
                          ),
                          Builder(
                            builder: (BuildContext context) => Container(
                              width: double.infinity,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: APP_BAR_COLOR,
                                  onPressed: () => _onChangePassword(context),
                                  child: Text(
                                    "Change Password",
                                    style: MEDIUM_WHITE_BUTTON_TEXT,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) => Image.asset(
        path,
        fit: BoxFit.cover,
      );
}
