
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamie/Methods/authMethods.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/homeScreen.dart';

class EmailConfirmScreen extends StatefulWidget {
  static String routeName = "email_confirm_screen";
  @override
  _EmailConfirmScreenState createState() => _EmailConfirmScreenState();
}

class _EmailConfirmScreenState extends State<EmailConfirmScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

 Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Want to exit?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "No",
              style: NORMAL_HEADER,
            ),
          ),
          SizedBox(
            width: .001,
          ),
          FlatButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              "Yes",
              style: NORMAL_HEADER,
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    Size deviceSize = MediaQuery.of(context).size;
    final double widgetHeight =
        0.07 * deviceSize.height;
    final double widgetWidth = deviceSize.width * 0.9;
    return WillPopScope(
      onWillPop:_onBackPressed,
      child: SafeArea(
        child: Scaffold(
          body: Builder( builder: (context) =>
           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               SizedBox(height: widgetHeight,),
               Column(
                 children: [
                   Text(
                     "Account confirmation",
                     style: NORMAL_HEADER,
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Text(
                     "Please confirm your account to continue",
                     style: SMALL_DISABLED_TEXT,
                   ),
                 ],
               ),
               SizedBox(height: widgetHeight,),
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("We have sent a confirmation email to your inbox.\nPlease click on the link in the email to confirm",
                      style: LABEL_TEXT_STYLE_MEDIUM,),
                    SizedBox(
                      height: widgetHeight,
                    ),
                    CustomOutlinedButton(
                      buttonWidth: widgetWidth,
                      borderHighlightColor: Colors.green,
                      buttonHeight: widgetHeight,
                      imageSize: 24.0,
                      borderColor: Colors.black38,
                      borderRadius: 10.0,
                      text: "I already clicked on the link, let me in",
                      onPressed: ()async {
                               User user =  _auth.currentUser;

                                 if(user.emailVerified){
                                   Navigator.of(context).push(CupertinoPageRoute(builder: (context) => HomeScreen()));
                                 }else{
                                   Scaffold.of(context).showSnackBar(SnackBar(
                                     content:Text("Doesn't seem like you like you did"),
                                     backgroundColor: APP_BAR_COLOR,
                                     action: SnackBarAction(
                                       label: "Resend",
                                       onPressed: ()async{
                                         await sendEmailVerification();
                                         Scaffold.of(context).showSnackBar(SnackBar(
                                           backgroundColor: APP_BAR_COLOR,
                                           content:Text("New verification sent! Please check you inbox"),
                                         ));
                                         },
                                     ),
                               ));
                                 }
                               })
                       ]),
                    SizedBox(
                      height: widgetHeight,
                    ),
                    RoundedButtonWithColor(
                      width: widgetWidth,
                      height: widgetHeight,
                      text: "Didn't Receive Email",
                      onPressed: ()async{
                        var sent = await sendEmailVerification();
                        if(sent == true){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content:Text("Email sent! Please check your inbox again"),
                          ));
                        }else{
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: APP_BAR_COLOR,
                            content:Text("We are having issues verifying you"),
                          ));
                        }
                      },
                    )
                  ],
                ),

           ),
          ),
        ),
      );
  }
}