import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';

import 'change_password.dart';

// ignore: must_be_immutable
class EmailConfirmation extends StatelessWidget {
  String imagePath = "assets/images/new_mail.png";

  //calc remaining width
  double remaining(BuildContext context) =>
      MediaQuery.of(context).size.width - 80;

  //text controller
  TextEditingController _firstCtl = TextEditingController();
  TextEditingController _secondCtl = TextEditingController();
  TextEditingController _thirdCtl = TextEditingController();
  TextEditingController _fourthCtl = TextEditingController();

  //focus nodes for textfields
  final FocusNode firstNode = FocusNode();
  final FocusNode secondNode = FocusNode();
  final FocusNode thirdNode = FocusNode();
  final FocusNode fourthNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //change focusNode
  void _changeNodeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      //check if code matches
      //then proceed to change password
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => ChangePassword()));
      return;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text("Please all fields needs to be full")
        ],
      ),
      duration: Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Enter the code sent to your email",
                    style: MEDIUM_DISABLED_TEXT,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                              child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: _firstCtl,
                            focusNode: firstNode,
                            onFieldSubmitted: (term) {
                              _changeNodeFocus(context, firstNode, secondNode);
                            },
                            textInputAction: TextInputAction.next,
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            keyboardType: TextInputType.number,
                          )),
                          SizedBox(
                            width: 0.2 * remaining(context),
                          ),
                          Expanded(
                              child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: _secondCtl,
                            focusNode: secondNode,
                            onFieldSubmitted: (term) => _changeNodeFocus(
                                context, secondNode, thirdNode),
                            textInputAction: TextInputAction.next,
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            keyboardType: TextInputType.number,
                          )),
                          SizedBox(
                            width: 0.2 * remaining(context),
                          ),
                          Expanded(
                              child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: _thirdCtl,
                            focusNode: thirdNode,
                            onFieldSubmitted: (term) => _changeNodeFocus(
                                context, thirdNode, fourthNode),
                            textInputAction: TextInputAction.next,
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            keyboardType: TextInputType.number,
                          )),
                          SizedBox(
                            width: 0.2 * remaining(context),
                          ),
                          Expanded(
                              child: Builder(
                            builder: (BuildContext context) => TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              controller: _fourthCtl,
                              focusNode: fourthNode,
                              onFieldSubmitted: (term) => _onSubmit(context),
                              textInputAction: TextInputAction.send,
                              style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Builder(
                      builder: (BuildContext context) => Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: APP_BAR_COLOR,
                            onPressed: () => _onSubmit(context),
                            child: Text(
                              "Submit",
                              style: MEDIUM_WHITE_BUTTON_TEXT,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            )),
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
