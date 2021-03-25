import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';

class CodeConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const backPicture = 'assets/images/confirm.jpg';
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: CustomBackground(backPicture: backPicture)),
              Positioned.fill(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomBackIcon(),
                        Text(
                          "Next",
                          style: MEDIUM,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SMS CODE",
                      style: TITLE,
                    ),
                    Text(
                      "To unlock last step of authorization",
                      style: SMALL,
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    Text(
                      "Code from SMS",
                      style: SMALL_WITH_BLACK,
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      // color:Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomCodeInput(),
                            CustomCodeInput(),
                            CustomCodeInput(),
                            CustomCodeInput()
                          ]),
                    ),
                    SizedBox(height: 150),
                    Center(child: Text('Resend Code',style: UNDERLINED_TEXT,))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
