import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';

import '../../user/terms_and_conditions.dart';

class TermsStep extends StatefulWidget {

  @override
  _TermsStepState createState() => _TermsStepState();
}

class _TermsStepState extends State<TermsStep> {
  static bool hasAgree  = true;

  bool hasAgreed(){
    return hasAgree;
  }
  void _onChanged(val){
    setState(() {
      hasAgree = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 5,),
          InkWell(
            onTap: (){
              showDialog(context: context,builder: (context)=>TermsAndConditions());
            },
              child: Text(
            "READ TERMS",
            style: LABEL_TEXT_STYLE,
          )),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Checkbox(value: hasAgree, onChanged:(val){_onChanged(val);}),
              Text(
                "I AGREE TO ALL THE TERMS ABOVE",
                style: SMALL_WITH_BLACK,
              )
            ],
          ),
        ],
      ),
    );
  }
}
