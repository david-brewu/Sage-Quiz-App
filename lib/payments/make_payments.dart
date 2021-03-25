import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/database.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/paymentTypes.dart';
import 'package:gamie/payments/userPaymentSteps/proceed_to_payment.dart';
import 'package:gamie/payments/userPaymentScreen.dart';
import 'package:provider/provider.dart';
import '../data/tempData.dart';

class MakePayments extends StatelessWidget {
  static const String _title = "Make Payment";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserAuthProvider>(context).authUser;
    Query cards = FirebaseFirestore.instance.collection("cards").where("userId", isEqualTo: user.uid);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop()),
          title: Text(
            _title,
            style: APP_BAR_TEXTSTYLE,
          ),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => UserPaymentScreen())),
          tooltip: "add payment method",
          backgroundColor: APP_BAR_COLOR,
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: cards.snapshots(),
          builder:(context, snapshot){
            if(snapshot.hasError) {

              return Center(child: Text(
                "An error occurred",
                style: LABEL_TEXT_STYLE_MEDIUM,));
            }
            else if(snapshot.connectionState ==  ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(strokeWidth: 10,backgroundColor: APP_BAR_COLOR));

            else if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator(strokeWidth: 10, backgroundColor: APP_BAR_COLOR,));

            else if(snapshot.data.documents.length == 0)
              return Center(child: Text("You have no payment Methods", style: LABEL_TEXT_STYLE_MEDIUM,));

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                DocumentSnapshot doc = snapshot.data.documents[index];
                print(snapshot.data);
                PaymentMethodData item = PaymentMethodData(name: doc.data()["name"], number: doc.data()["number"], date: doc.data()["date"], provider: doc.data()["provider"], paymentType: doc.data()["paymentType"] == "MOMO"? PaymentType.MOMO : PaymentType.CREDIT_CARD);
                return MethodCard(inheritedContext: context,item: item, id: doc.id, number: doc.data()["number"], name: doc.data()["name"], paymentType: doc.data()["paymentType"], expDate: doc.data()["date"], network: doc.data()["provider"]);
                },
            );
          },
        )
      ),
    );
  }
}

class MethodCard extends StatelessWidget {
  final String id;
  final BuildContext inheritedContext;
  final String number;
  final String name;
  final String expDate;
  final String network;
  final String paymentType;
  final PaymentMethodData item;

  const MethodCard(
      {Key key,
      @required this.item,
      @required this.id,
        @required this.inheritedContext,
      @required this.number,
      @required this.name,
      @required this.expDate,
      @required this.network,
      @required this.paymentType,
      })
      : super(key: key);

  void _proceedToPayment(PaymentMethodData item, BuildContext context) {
    //proceed to payment screen
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => ProceedToPayment(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(

      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.black, size: 50,),
      ),
      onDismissed: (DismissDirection dir) {

        //remove payment method
          removeItem("cards", id).then((value) =>
              Scaffold.of(inheritedContext).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text("Payment method deleted"),
                  ],
                ),
                duration: Duration(milliseconds: 500),
              )),
          ).catchError((onError) =>
              Scaffold.of(inheritedContext).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text("Couldn't Delete"),
                  ],
                ),
                duration: Duration(seconds: 3),
              )),
          );

      },
      key: Key(id.toString()),
      child: InkWell(
        onTap: () => _proceedToPayment(item, context),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            // ignore: unrelated_type_equality_checks
                            text: paymentType == PaymentType.CREDIT_CARD
                                ? "Card Number: \t"
                                : "Mobile Number: \t",
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            children: [
                              TextSpan(
                                  text: number, style: SMALL_BLUE_TEXT_STYLE)
                            ])),
                    RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "Name: \t",
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            children: [
                              TextSpan(text: name, style: SMALL_BLUE_TEXT_STYLE)
                            ])),
                    RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            // ignore: unrelated_type_equality_checks
                            text: paymentType == PaymentType.CREDIT_CARD
                                ? "Date: \t"
                                : "Network: \t",
                            style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                            children: [
                              TextSpan(
                                  // ignore: unrelated_type_equality_checks
                                  text: paymentType == PaymentType.CREDIT_CARD
                                      ? "$expDate"
                                      : network,
                                  style: SMALL_BLUE_TEXT_STYLE)
                            ])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
