import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_validator/the_validator.dart';

class PasswordStep extends StatefulWidget {
  final formKey;
  PasswordStep({Key key, this.formKey}) : super(key: key);

  @override
  _PasswordStepState createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  String password;
  Map<String, dynamic> data;

  Future getPrefInScope(prefs) async {
    var record = await jsonDecode(prefs.getString(PREFS_PERSONAL_INFO));
    setState(() {
      data = record;
    });
  }

  //two bool to handle 2 textfields
  bool _showPassword1 = false;
  bool _showPassword2 = false;

  void _obscureField(int field) {
    if (field == 1) {
      setState(() {
        _showPassword1 = !_showPassword1;
      });
      return;
    }
    setState(() {
      _showPassword2 = !_showPassword2;
    });
  }

  void _savePassword(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getPrefInScope(prefs);
    if (value.length > 5) {
      data["password"] = value.trim();
      prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                password = value;
                _savePassword(value);
              },
              obscureText: _showPassword1,
              keyboardType: TextInputType.text,
              style: INPUT_TEXT_STYLE,
              decoration: InputDecoration(
                  suffix: IconButton(
                      icon: Icon(_showPassword1
                          ? AntDesign.eye
                          : FontAwesome.eye_slash),
                      onPressed: () => _obscureField(1)),
                  labelText: "Password",
                  labelStyle: LABEL_TEXT_STYLE),
              validator: FieldValidator.password(
                  minLength: 6,
                  maxLength: 28,
                  errorMessage: "Minimum length should be 6"),
            ),
            TextFormField(
              obscureText: _showPassword2,
              keyboardType: TextInputType.text,
              style: INPUT_TEXT_STYLE,
              decoration: InputDecoration(
                  suffix: IconButton(
                      icon: _showPassword2
                          ? Icon(AntDesign.eye)
                          : Icon(FontAwesome.eye_slash),
                      onPressed: () => _obscureField(2)),
                  labelText: "Confirm password",
                  labelStyle: LABEL_TEXT_STYLE),
              validator: (value) {
                if (value != password) {
                  // errorMessage = "Please complete the fields above";
                  return "Please, field should be the same above";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
