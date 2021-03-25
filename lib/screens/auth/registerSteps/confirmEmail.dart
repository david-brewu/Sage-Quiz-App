import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_validator/the_validator.dart';

class ConfirmEmailStep extends StatefulWidget {
  final formKey;

  ConfirmEmailStep({Key key, this.formKey}) : super(key: key);

  @override
  _ConfirmEmailStepState createState() => _ConfirmEmailStepState();
}

class _ConfirmEmailStepState extends State<ConfirmEmailStep> {
  bool isCorrect = false;
 Map<String, dynamic> data;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var record = await jsonDecode(prefs.get("personal_info"));
    data = record;

  }
  @override
  Widget build(BuildContext context) {
    Column column = Column(
            children: <Widget>[
              Form(
                  key: widget.formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: INPUT_TEXT_STYLE,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: "Enter Verification Code",
                          labelStyle: LABEL_TEXT_STYLE),
                      validator: FieldValidator.number(
                          noSymbols: true, message: "Please enter Numbers only"),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: isCorrect ? Icon(Icons.check) : CircularProgressIndicator(),
              ),
              SizedBox(height: 10),
              InkWell(
                  onTap: () {},
                  child: Text("RESEND CODE", style: UNDERLINED_TEXT_SM)),
              SizedBox(height: 10)
            ],
          );
        return Container(
          child: column,
    );
  }
}
