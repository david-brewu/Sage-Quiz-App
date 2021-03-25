import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatelessWidget {

   final String _title = "Payment History";
  @override
  Widget build(BuildContext context) {
    User authUser = Provider.of<UserAuthProvider>(context).authUser;
    return Scaffold(
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("payments").where("userId", isEqualTo: authUser.uid).snapshots(includeMetadataChanges: true),
          builder: (context, snapshot){
    print("USER_ID: ${authUser.uid}");
    if(snapshot.connectionState == ConnectionState.waiting){
    return Scaffold(body: Center(child: CircularProgressIndicator()),);
    }else if(snapshot.hasError){
    return Scaffold(body: Center(child: Text("There was an error, please try later", style: DISABLED_TEXT,),),);
    }
    List<DocumentSnapshot> _data = snapshot.data.documents;

    if(_data.length == 0) return Center(child: Text("No payment history", style: DISABLED_TEXT,),);

    return ListView.builder(
    physics: BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: _data.length,
    itemBuilder: (BuildContext context, int index){
    Timestamp timestamp = _data[index].data()["date"];
    return HistoryCard(
    transId: _data[index].data()["transactionId"],
    amount: double.tryParse(_data[index].data()["amount"].toString()),
    cardNumber: _data[index].data()["cardNumber"],
    date: timestamp.toDate(),
    method: _data[index].data()["method"]);
    });
    },));
  }
}

class HistoryCard extends StatelessWidget {
  final String transId;
  final String cardNumber;
  final DateTime date;
  final double amount;
  final String method;
  HistoryCard({
    @required this.transId,
    @required this.amount,
    @required this.cardNumber,
    @required this.date,
    @required this.method,
  });

  //navigate to more details about the trans
  void _navigateToDetails(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //trans id
          InkWell(
            onTap: () => _navigateToDetails(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "ID: \t",
                          style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                          children: [
                            TextSpan(
                                text: transId, style: SMALL_BLUE_TEXT_STYLE)
                          ])),

                  //amount paid
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Amount Paid: \t",
                          style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                          children: [
                            TextSpan(
                                text: "GHC $amount",
                                style: SMALL_BLUE_TEXT_STYLE)
                          ])),

                  //payment method
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Payment Method: \t",
                          style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                          children: [
                            TextSpan(
                                text:"$method",
                                style: SMALL_BLUE_TEXT_STYLE)
                          ])),

                  // //card or mobile number
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Card Number: \t",
                          style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                          children: [
                            TextSpan(
                                text: cardNumber, style: SMALL_BLUE_TEXT_STYLE)
                          ])),

                  //date paid
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Date: \t",
                          style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                          children: [
                            TextSpan(
                                text:
                                    "${date.day} - ${date.month} - ${date.year}",
                                style: SMALL_BLUE_TEXT_STYLE)
                          ])),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              height: 0,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
