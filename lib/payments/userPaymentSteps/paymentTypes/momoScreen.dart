import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';
import '../../../Methods/database.dart';

class MomoScreen extends StatefulWidget {
  final Function nextStep;
  final Function previousStep;
  MomoScreen({this.nextStep, this.previousStep});
  @override
  _MomoScreenState createState() => _MomoScreenState();
}

class _MomoScreenState extends State<MomoScreen> {
  static List<String> _networkProviders = ["MTN", "VODAFONE", "TIGO"];
  String _currentCountry = "+233";
  String _currentProvider = _networkProviders[0];
  final formKey = GlobalKey<FormState>();

  void _onProceedPressed(context) {
    formKey.currentState.validate()
        ? _add_data_then_proceed(context)
        : Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Please complete the form to proceed",
                )
              ],
            )));
  }

  // ignore: non_constant_identifier_names
  void _add_data_then_proceed(BuildContext context) {
    //add data
    Map<String, String> data = {
        "paymentType": "MOMO",
        "number": "${_number.text}",
        "name": _name.text,
        "provider": _currentProvider,
        "userId": Provider.of<UserAuthProvider>(context, listen: false).authUser.uid,
        };
    addData("cards", data).then((value) => widget.nextStep()).catchError((onError) =>{
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("There was and error"),
          duration: Duration(seconds: 3),

        ))
    });

    //proceed

  }

  TextEditingController _number = TextEditingController();
  TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          child: Text(
            "MOBILE MONEY",
            style: LABEL_TEXT_STYLE,
          ),
        ),
        Divider(color: Colors.black54),
        Text(
          "Choose your country",
          style: SMALL_BLUE_LABEL_TEXTSTYLE,
        ),
        CountryCodePicker(
          onChanged: (CountryCode code) {
            setState(() {
              _currentCountry = code.dialCode;
            });
          },
          initialSelection: 'GH',
          favorite: ['GH', 'NG'],
          showCountryOnly: true,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Network Provider",
          style: SMALL_BLUE_LABEL_TEXTSTYLE,
        ),
        Container(
          height: 40,
          child: DropdownButton(
              value: _currentProvider,
              items: _networkProviders
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: SMALL_WITH_BLACK,
                      )))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _currentProvider = val;
                });
              }),
        ),
        SizedBox(height: 20),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Phone Number",
                style: SMALL_BLUE_LABEL_TEXTSTYLE,
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _number,

                  validator: (value) {
                    if (value.length != 10 || !Validator.isNumber(value, allowSymbols: false)) {
                      return "Enter a 10-digit phone number";
                    }
                    return null;
                  },
                  style: INPUT_TEXT_STYLE,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Eg: 0554XXXXXX",
                    contentPadding: EdgeInsets.only(bottom: 5),
                    icon: Text(
                      "($_currentCountry)",
                      style: MEDIUM_DISABLED_TEXT,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Account Name",
                style: SMALL_BLUE_LABEL_TEXTSTYLE,
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _name,
                  validator: (value) {
                    if (value.isEmpty || value.split(" ").length < 2) {
                      return "Enter the name on your MOMO account";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  style: INPUT_TEXT_STYLE,
                ),
              ),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
              builder: (context) => FlatButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => _onProceedPressed(context),
                child: Text(
                  "Proceed",
                  style: NORMAL_WHITE_BUTTON_LABEL,
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
