import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/screens/user/about_this_app.dart';
import 'package:gamie/screens/user/privacy_screen.dart';
import 'package:gamie/screens/user/terms_and_conditions.dart';

import '../../config/config.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool soundOn = false;
  bool notificationsOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: APP_BAR_COLOR,
        title: Text(
          "SETTINGS",
          style: APP_BAR_TEXTSTYLE,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: Text("Sound",style: LABEL_TEXT_STYLE_MEDIUM_BLACK,),
              // subtitle: Text("allow app to play sound"),
              trailing: Switch(value: soundOn, onChanged: (val) {
               setState(() {
                 soundOn = val;
               });
              }),
            ),
            ListTile(
              title: Text("Notifications",style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
              trailing: Switch(value: notificationsOn, onChanged: (val) {
                setState(() {
                  notificationsOn = val;
                });
              }),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: APP_BAR_COLOR,
              thickness: 1,
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PrivacyScreen()));
              },
              title: Text("Privacy Statement",style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
            ),

            ListTile(
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TermsAndConditions()));
              },
              title: Text("Terms and Conditions",style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
            ),

            ListTile(
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AboutThisApp()));
              },
              title: Text("About $APP_NAME",style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
            ),

          ],
        ),
      ),
    );
  }
}
