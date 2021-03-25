import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/payments/userPaymentSteps/confirmationStep.dart';
import 'package:gamie/payments/userPaymentSteps/paymentDetailsStep.dart';
import 'package:gamie/payments/userPaymentSteps/paymentTypeStep.dart';

class UserPaymentScreen extends StatefulWidget {
  static String routeName = "payment_screen";
  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  var _paymentType;
  void _onCardTapped(paymentType) {
    this._paymentType = paymentType;
    _nextStep();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _paymentSteps().length - 1) {
        stepStates[_currentStep] = StepState.complete;
        _currentStep++;
        stepStates[_currentStep] = StepState.editing;
      }
    });
    print(_currentStep);
  }

  List stepStates = List.generate(3, (index) => StepState.indexed);

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        stepStates[_currentStep] = StepState.indexed;
        _currentStep--;
        stepStates[_currentStep] = StepState.editing;
      }
    });
    print(_currentStep);
  }

  int _currentStep = 0;

  List<Step> _paymentSteps() {
    return [
      Step(
          state: stepStates[0],
          isActive: _currentStep == 0,
          title: _currentStep == 0
              ? Text(
                  "Payment Type",
                  style: SMALL_WITH_BLACK,
                )
              : SizedBox.shrink(),
          content: PaymentTypeStep(
            onCardTap: _onCardTapped,
          )),
      Step(
          state: stepStates[1],
          isActive: _currentStep == 1,
          title: _currentStep == 1
              ? Text(
                  "Payment Details",
                  style: SMALL_WITH_BLACK,
                )
              : SizedBox.shrink(),
          content: PaymentDetailsStep(
              paymentType: this._paymentType,
              nextStep: _nextStep,
              previousStep: _previousStep)),
      Step(
          state: stepStates[2],
          isActive: _currentStep == 2,
          title: _currentStep == 2
              ? Text(
                  "Confirmation",
                  style: SMALL_WITH_BLACK,
                )
              : SizedBox.shrink(),
          content: ConfirmationStep())
    ];
  }

  Widget _buildControls(context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR_COLOR,
        centerTitle: true,
        title: Text("Payment Method", style: APP_BAR_TEXTSTYLE),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        height: deviceSize.height,
        color: Colors.white,
        child: Stepper(
            controlsBuilder: _buildControls,
            currentStep: _currentStep,
            type: StepperType.horizontal,
            steps: _paymentSteps()),
      ),
    );
  }
}
