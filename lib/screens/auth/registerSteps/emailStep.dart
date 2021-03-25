import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_validator/the_validator.dart';

class EmailStep extends StatefulWidget {
  final formKey;

  const EmailStep({Key key, this.formKey}) : super(key: key);

  @override
  _EmailStepState createState() => _EmailStepState();
}

class _EmailStepState extends State<EmailStep> {
  Map<String, dynamic> data;

  void _savePhone(val) async {
    var value = val.toString().trim();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getPrefInScope(prefs);
    if (Validator.isNumber(value) && value.length == 10) {
      data["phone_number"] = value.toString();
      prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));
    }
  }
  void _saveEmail(val) async {
    var value = val.toString().toLowerCase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getPrefInScope(prefs);
    if(Validator.isEmail(value)){
        data["email_address"] = value;
        prefs.setString(PREFS_PERSONAL_INFO, jsonEncode(data));}
  }

  @override
  void initState(){
    super.initState();
  }

  Future getPrefInScope(prefs)async{
    var record = await jsonDecode(prefs.getString(PREFS_PERSONAL_INFO));
    setState(() {
      data = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: widget.formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: _saveEmail,
                keyboardType: TextInputType.emailAddress,
                style: INPUT_TEXT_STYLE,
                decoration: InputDecoration(
                    labelText: "Email", labelStyle: LABEL_TEXT_STYLE),
                validator: FieldValidator.email(
                    message: "Please enter a valid email address"),
              ),
              TextFormField(
                onChanged: _savePhone,
                keyboardType: TextInputType.phone,
                style: INPUT_TEXT_STYLE,
                decoration: InputDecoration(
                    labelText: "Phone Number", labelStyle: LABEL_TEXT_STYLE),
                validator: (val){
                  var err = "";
                    if(!Validator.isNumber(val)){err =  "Please enter a valid number";}
                    else if(val.length != 10){err = "Please enter a 10-digit number";}
                    return err.length == 0 ? null: err;
                     },


              ),
              SizedBox(height: 20,)
            ],
          )),
    );
  }
}
