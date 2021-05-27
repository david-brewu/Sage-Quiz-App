import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/database.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/paymentTypes.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:provider/provider.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({Key key, this.nextStep, this.previousStep})
      : super(key: key);

  final Function nextStep;
  final Function previousStep;

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  DateTime date = DateTime.now();
  final formKey = GlobalKey<FormState>();

  // var _expiryDate;

  void _onProceedPressed(context) {
    formKey.currentState.validate()
        ? add_data_then_proceed()
        : Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text("Please complete the form to continue")
              ],
            ),
            duration: Duration(milliseconds: 500),
          ));
  }

  //add data
  // ignore: non_constant_identifier_names
  void add_data_then_proceed() {
    //add data to temp data list
    Map<String, String> data = {
      "paymentType": PaymentType.CREDIT_CARD.toString(),
      "number": _number.text,
      "name": _name.text,
      "userId":
          Provider.of<UserAuthProvider>(context, listen: false).authUser.uid,
      "expiry": date.toIso8601String(),
    };

    addData("cards", data)
        .then((value) => {
              //then navigate to next stp
              widget.nextStep()
            })
        .catchError((onError) => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("There was an error"),
                duration: Duration(seconds: 3),
              ),
            ));
  }

  TextEditingController _number = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _secureNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        CustomCreditCard(
            cardNumber: _number.text, expiryDate: date, name: _name.text),
        SizedBox(height: 20),
        Text("CARD DETAILS", style: LABEL_TEXT_STYLE_MEDIUM),
        Divider(
          color: Colors.black54,
        ),
        Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Card Number",
                      style: SMALL_BLUE_LABEL_TEXTSTYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      child: TextFormField(
                        controller: _number,
                        style: INPUT_TEXT_STYLE,
                        validator: (value) {
                          Map<String, dynamic> cardData =
                              CreditCardValidator.getCard(value);
                          print(cardData);
                          if (!cardData[CreditCardValidator.isValidCard]) {
                            return "Your card number is invalid";
                          }
                          return null;
                        },
                        maxLength: 16,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Name on card",
                      style: SMALL_BLUE_LABEL_TEXTSTYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      child: TextFormField(
                        controller: _name,
                        maxLength: 35,
                        style: INPUT_TEXT_STYLE,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field cannot be empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Expiry Date",
                      style: SMALL_BLUE_LABEL_TEXTSTYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${date.day} - ${date.month} - ${date.year}",
                              style: LABEL_TEXT_STYLE_MEDIUM,
                            ),
                            Builder(
                                // ignore: deprecated_member_use
                                builder: (context) => FlatButton(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () => showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  initialDateTime:
                                                      DateTime.now(),
                                                  onDateTimeChanged:
                                                      (DateTime val) {
                                                    setState(() {
                                                      date = val;
                                                    });
                                                  }),
                                            )),
                                    child: Text(
                                      "Change Date",
                                      style: NORMAL_WHITE_BUTTON_LABEL,
                                    )))
                          ],
                        )),
                    SizedBox(height: 10),
                    Text(
                      "Secure Code",
                      style: SMALL_BLUE_LABEL_TEXTSTYLE,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      child: TextFormField(
                        controller: _secureNumber,
                        style: INPUT_TEXT_STYLE,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field cannot be empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: widget.previousStep,
                      child: Text(
                        "Go Back",
                        style: NORMAL_WHITE_BUTTON_LABEL,
                      ),
                    ),
                    Builder(
                        // ignore: deprecated_member_use
                        builder: (context) => FlatButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () => _onProceedPressed(context),
                              child: Text(
                                "Proceed",
                                style: NORMAL_WHITE_BUTTON_LABEL,
                              ),
                            ))
                  ],
                )
              ],
            )),
        SizedBox(height: 30)
      ],
    ));
  }
}
