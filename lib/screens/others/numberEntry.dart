import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/auth/codeConfirmation.dart';

class PhoneNumberEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const backPicture = "assets/images/sms.png";
    return Scaffold(
          body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: CustomBackground(
              backPicture: backPicture,
            )),
            Positioned.fill(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CodeConfirmationScreen()));
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Next", style: DISABLED_TEXT)),
                  ),
                  SizedBox(height: 15),
                  SubtitledTitle(
                    title: "Your Phone",
                    subtitle: "We will send you a verification code",
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 200),
                  Container(
                      height: 30,
                      child: Row(
                        children: <Widget>[
                        
                          SizedBox(width: 5),
                          Expanded(
                            child: PhoneNumberInput(),
                          )
                        ],
                      ))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
