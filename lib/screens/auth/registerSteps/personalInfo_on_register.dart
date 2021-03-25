import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoOnRegister extends StatefulWidget {
  final formKey;

  PersonalInfoOnRegister({Key key, this.formKey}) : super(key: key);

  @override
  _PersonalInfoOnRegisterState createState() => _PersonalInfoOnRegisterState();
}

class _PersonalInfoOnRegisterState extends State<PersonalInfoOnRegister> {


  Map<String, dynamic> data = {};


  void _onNameChange(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data["full_name"] = value;
    prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));
  }

  void _onSchoolChange(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data["school"] = value;
    prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
            key: widget.formKey,
            // ignore: deprecated_member_use
            autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  onChanged: _onNameChange,
                  style: INPUT_TEXT_STYLE,
                  decoration: InputDecoration(
                      labelText: "Full Name", labelStyle: LABEL_TEXT_STYLE),
                  validator: (value) {
                    if (value.isEmpty) {
                      // errorMessage = "Please complete the fields above to continue";
                      return "Your name can't be empty";
                    } else if (value.split(" ").length < 2) {
                      return "Please input a full name as appears on your Id";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: _onSchoolChange,
                  style: INPUT_TEXT_STYLE,
                  decoration: InputDecoration(
                      labelText: "Your School", labelStyle: LABEL_TEXT_STYLE),
                  validator: (value) {
                    if (value.isEmpty) {
                      // errorMessage = "Please complete the fields above to continue";
                      return "Please enter your school name";
                    } else if (value.split(" ").length < 2) {
                      return "Please input a full name of your school";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )));
  }
}
