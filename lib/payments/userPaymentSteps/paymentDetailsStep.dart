import 'package:flutter/material.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/creditCardScreen.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/momoScreen.dart';



// ignore: must_be_immutable
class PaymentDetailsStep extends StatelessWidget {
  var paymentType;
  Function nextStep;
  Function previousStep;
  PaymentDetailsStep({this.paymentType,this.nextStep,this.previousStep});
  @override
  Widget build(BuildContext context) {
    switch (paymentType) {
      case "Mobile Money":
        return MomoScreen(nextStep: nextStep,previousStep: previousStep);
        break;
      case "Credit or Debit Card":
        return CreditCardScreen(nextStep: nextStep,previousStep: previousStep);
      default:
        return Container(child: Text("$paymentType"));
    }
  }
}
