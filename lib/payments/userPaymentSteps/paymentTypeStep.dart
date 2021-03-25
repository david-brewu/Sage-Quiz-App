import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';

// ignore: must_be_immutable
class PaymentTypeStep extends StatelessWidget {
  Function onCardTap;

  PaymentTypeStep({this.onCardTap});

  List<Map<String, dynamic>> paymentTypes = [
    {"type": "Mobile Money", "icon": Icons.phone_iphone},
    {
      "type": "Credit or Debit Card",
      "icon": FontAwesome.credit_card,
    },
    // {"type": "Paypal",
    //   "icon":FontAwesome.paypal,
    //   "color":Colors.blue
    // },
    // {"type": "Net Banking",
    //   "icon":FontAwesome.bank,
    // },
    // {"type": "Bitcoin",
    //   "icon":FontAwesome.bitcoin,
    //   "color":Color.fromRGBO(234, 183, 0, 1)
    // },
    // {"type":"Paytm",
    // "icon": FontAwesome.money,
    // "color":Colors.green
    // }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: paymentTypes
          .map(
            (e) => Container(
              decoration: BoxDecoration(
                  // color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        onCardTap(e["type"]);
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                      leading: Icon(
                        e["icon"],
                        color: e["color"] == null ? Colors.black : e["color"],
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        "${e["type"]}",
                        style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                      )),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          )
          .toList(),
    ));
  }
}
