import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/config/secret_keys.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';


// ignore: must_be_immutable
class RaveRequest extends StatefulWidget {
  static const  routeName = "rave_request_page";
  final String amount;
  // ignore: non_constant_identifier_names
  String cc_number;

  String currency  = "GHS";
  String email = "someone@example.com";
  // ignore: non_constant_identifier_names
  String transaction_ref = Uuid().v4();
  // ignore: non_constant_identifier_names
  String phone_number;
  String network;
  String fullname;
  String cvv;
  String expMonth;
  String expYear;

  final String momoURL = "https://api.flutterwave.com/v3/charges?type=mobile_money_ghana";
  RaveRequest.momo({
    @required this.amount,
    // ignore: non_constant_identifier_names
    @required this.phone_number,
    @required this.network,
  }){
    this.email = email;
    this.transaction_ref = transaction_ref;
  }

  // ignore: non_constant_identifier_names
  RaveRequest.card({Key, key,
    @required this.amount,
    @required this.currency,
    // ignore: non_constant_identifier_names
    @required this.cc_number,
    @required this.cvv,
    @required this.expMonth,
    @required this.expYear,
    this.email,
    // ignore: non_constant_identifier_names
    this.transaction_ref,
  }):super(key:key);

  @override
  _RaveRequestState createState() => _RaveRequestState();
}

class _RaveRequestState extends State<RaveRequest> {
  bool isBusy = true;
  String redirectURL = "";
  var isSuccess;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headers = {"Authorization": "Bearer $FLUTTER_WAVE_API_KEY"};
    Map payload = {"amount":widget.amount, "tx_ref":widget.transaction_ref, "currency":widget.currency, "network":widget.network,"email":widget.email, "phone_number":widget.phone_number, };
    if (isSuccess == null){
      makeRequest(payload: payload, headers:headers, url: widget.momoURL);
    }
    return ViewSelector(isBusy: isBusy, isSuccess: isSuccess, redirectURL: redirectURL);
  }

  makeRequest({@required Map payload, @required Map headers, @required String url})async{

    var resp = await http.post(url, headers: headers, body:payload);
    var statusCode = resp.statusCode;
    // ignore: unused_local_variable
    var message = jsonDecode(resp.body)["message"];
    var status = jsonDecode(resp.body)["status"];

    if(statusCode == 200 && status == "success" && isSuccess == null) {
       setState(() {
         redirectURL = jsonDecode(resp.body)["meta"]["authorization"]["redirect"];
         isSuccess = true;
         isBusy = false;
       });
    }else if(isSuccess == true){

    }else{
      setState(() {
        isBusy = false;
        isSuccess = false;
      });
    }
  }
}

class ViewSelector extends StatelessWidget {
  const ViewSelector({
    Key key,
    @required this.isBusy,
    @required this.isSuccess,
    @required this.redirectURL,
  }) : super(key: key);

  final bool isBusy;
  final bool isSuccess;
  final String redirectURL;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
          child: isBusy == true && isSuccess == null ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 10,),
                SizedBox(height: 10,),
                Text("Processing your payment...", style: MEDIUM_DISABLED_TEXT,),
              ],
            ),
          )
               :
              isBusy == false && isSuccess == true ?
          WebView(initialUrl:redirectURL, javascriptMode: JavascriptMode.unrestricted,)
            :
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.sms_failed, size:100, color: Colors.deepOrange,),
                    SizedBox(height: 15,),
                    Text("Transaction failed", style: MEDIUM_DISABLED_TEXT,),
                  ],
                ),
              ),
        )
    );
  }
}

