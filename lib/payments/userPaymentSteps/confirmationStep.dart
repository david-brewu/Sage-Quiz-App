import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:flutter/cupertino.dart';
import '../make_payments.dart';

class ConfirmationStep extends StatelessWidget {
  // bool _paymentConfirmed = false;
  ConfirmationStep({Key key}) : super(key: key);
  void _onContinuePressed(BuildContext context) {
    //pop the current screen
    Navigator.pop(context);

    //replace old make payments with updated one
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => MakePayments()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height - 250,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Payment Method added successfully!", style:SMALL_DISABLED_TEXT),
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.green,
                    child: Text(
                      'Continue',
                      style: NORMAL_WHITE_BUTTON_LABEL,
                    ),
                    onPressed: () => _onContinuePressed(context),
                  ),
                )
              ])),
    );
  }
}
