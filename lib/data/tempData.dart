import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypes/paymentTypes.dart';
var db = FirebaseFirestore.instance;

class PaymentMethodData {

  final String name;
  final String number;
  final DateTime date;
  final String provider;
  final PaymentType paymentType;

  PaymentMethodData({this.name, this.number, this.date, this.provider, this.paymentType});



}

//List<PaymentMethodData> paymentMethodData = [];
