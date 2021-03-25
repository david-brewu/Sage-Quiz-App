
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/data/tempData.dart';
import 'package:gamie/payments/raveRequest.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/paymentTypes.dart';
import 'package:the_validator/the_validator.dart';

class ProceedToPayment extends StatefulWidget {
  final PaymentMethodData item;
  ProceedToPayment({Key key, @required this.item}) : super(key: key);

  @override
  _ProceedToPaymentState createState() => _ProceedToPaymentState();
}

class _ProceedToPaymentState extends State<ProceedToPayment> {
  TextEditingController _number;
  TextEditingController _name;
  TextEditingController _date;
  TextEditingController _amount;
  GlobalKey<FormState> _formKey;
  bool _isProcessing = false;
  bool _paymentConfirmed = false;
  @override
  void initState() {
    _number = TextEditingController(text: widget.item.number);
    _name = TextEditingController(text: widget.item.name);
    //also use this controller for network when is momo
    _date = TextEditingController(
        text: widget.item.paymentType == PaymentType.MOMO
            ? widget.item.provider
            : "${widget.item.date}");
    _amount = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void _onProceed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      //process payment
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => RaveRequest.momo(amount: _amount.text,phone_number: widget.item.number, network: widget.item.provider)));
      return;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text("Invalid amount"),
        ],
      ),
      duration: Duration(seconds: 3),
    ));
  }

  Widget _processing() => _paymentConfirmed
      ? _confirmedWidget()
      : Center(
          //will show the custom loading widget when branches are merged
          child: CircularProgressIndicator());

  Widget _confirmedWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Payment successful",
            style: MEDIUM_DISABLED_TEXT,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Okay",
                    style: MEDIUM_WHITE_BUTTON_TEXT,
                  )),
            ),
          )
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Proceed to payment",
          style: APP_BAR_TEXTSTYLE,
        ),
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: _isProcessing
            ? _processing()
            : SingleChildScrollView(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.item.paymentType == PaymentType.MOMO
                          ? "Mobile Number"
                          : "CC Number",
                      style: SMALL_BLUE_TEXT_STYLE,
                    ),
                    TextField(
                      controller: _number,
                      readOnly: true,
                      style: MEDIUM_DISABLED_TEXT,
                      // enabled: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Name",
                      style: SMALL_BLUE_TEXT_STYLE,
                    ),
                    TextField(
                      controller: _name,
                      readOnly: true,
                      style: MEDIUM_DISABLED_TEXT,
                      // enabled: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.item.paymentType == PaymentType.MOMO
                          ? "Network"
                          : "Expiry Date",
                      style: SMALL_BLUE_TEXT_STYLE,
                    ),
                    TextField(
                      controller: _date,
                      readOnly: true,
                      style: MEDIUM_DISABLED_TEXT,
                      // enabled: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Amount", style: SMALL_BLUE_TEXT_STYLE),
                    Form(
                        key: _formKey,
                        child: Builder(
                          builder: (BuildContext context) => TextFormField(
                            onFieldSubmitted: (String term) =>
                                _onProceed(context),
                            validator: (
                                String value) {
                                print(_amount.text);
                                var val = _amount.text;
                              if ( val == null || !Validator.isNumber(val) || double.tryParse(val) == null || double.tryParse(val) < 1) {
                                return "Please enter a valid amount";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.send,
                            keyboardType: TextInputType.number,
                            controller: _amount,
                            style: MEDIUM_DISABLED_TEXT,
                            // enabled: false,
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Builder(
                      builder: (BuildContext context) => Container(
                          width: double.infinity,
                          child: FlatButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () => _onProceed(context),
                              child: Text(
                                "Proceed",
                                style: NORMAL_WHITE_BUTTON_LABEL,
                              ))),
                    )
                  ],
                ),
              )),
      ),
    );
  }
}
