import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';
import 'make_payments.dart';
import 'payments_history.dart';

class Payments extends StatelessWidget {
  //app bar title
  final String _title = "Payments";

  //methods for navigating to respective pages
  void _makePayments(BuildContext context) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => MakePayments()));
  }

  void _paymentHistory(BuildContext context) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => PaymentHistory()));
  }

  //list of items
  List<Map<String, dynamic>> _options() => [
        {"title": "Make payments", "func": _makePayments,"iconData":FontAwesome.money},
        {"title": "Payments history", "func": _paymentHistory,"iconData":Icons.history}
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR_COLOR,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () =>Navigator.pop(context)),
        title: Text(
          _title,
          style: APP_BAR_TEXTSTYLE,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _options().length,
          itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(_options()[index]["iconData"]),
                    onTap: () => _options()[index]["func"](context),
                    title: Text(
                      _options()[index]["title"],
                      style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                    ),
                  ),
                  Divider(
                    height: 0,
                  )
                ],
              )),
    );
  }
}
