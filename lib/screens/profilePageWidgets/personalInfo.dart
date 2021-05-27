import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../Providers/edit_profile_provider.dart';

// ignore: must_be_immutable
class PersonalInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  PersonalInfo({@required this.formKey});

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void updateProfileSections() async {
    UserAuthProvider userObj = Provider.of<UserAuthProvider>(context);
    userObj.setEmail = _emailController.value.text;
    userObj.setUserName = _emailController.value.text;
  }

  void _updateInfo() async {
    if (widget.formKey.currentState.validate()) {
      // TODO: update user here and then show snack thats its done
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Profile Updated successfully"),
          ],
        ),
      ));
      return;
    }
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
          Text("Please fill all required fields"),
        ],
      ),
    ));
  }

  void _cancelUpdate() {
    User user = Provider.of<UserAuthProvider>(context, listen: false).authUser;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
    Provider.of<EditProfileProvider>(context, listen: false).edit = false;
  }

  @override
  void initState() {
    super.initState();
    User user = Provider.of<UserAuthProvider>(context, listen: false).authUser;
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _addressController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final edit = Provider.of<EditProfileProvider>(context);
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (!Validator.isEmail(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                style: MEDIUM_DISABLED_TEXT,
                controller: _emailController,
                enabled: edit.edit,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  icon: Text(
                    "EMAIL: ",
                    style: LABEL_TEXT_STYLE,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.length < 10) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
                style: MEDIUM_DISABLED_TEXT,
                controller: _phoneController,
                enabled: edit.edit,
                decoration: InputDecoration(
                    icon: Text(
                  "PHONE: ",
                  style: LABEL_TEXT_STYLE,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: MEDIUM_DISABLED_TEXT,
                controller: _addressController,
                enabled: edit.edit,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    icon: Text(
                  "ADDRESS: ",
                  style: LABEL_TEXT_STYLE,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    disabledColor: Colors.green.withOpacity(0.5),
                    color: Colors.green,
                    child:
                        Text("UPDATE INFO", style: NORMAL_WHITE_BUTTON_LABEL),
                    onPressed: edit.edit != null ? _updateInfo : null,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    disabledColor: Colors.red.withOpacity(0.5),
                    color: Colors.red,
                    child: Text("CANCEL", style: NORMAL_WHITE_BUTTON_LABEL),
                    onPressed: edit.edit != null ? _cancelUpdate : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
