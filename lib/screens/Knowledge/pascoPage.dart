import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/Knowledge/PastQuestionsScreen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PascoPage extends StatefulWidget {
  static String routeName = "pasco_page";
  @override
  _PascoPageState createState() => _PascoPageState();
}

class _PascoPageState extends State<PascoPage> {
  String course = "JAVA BASICS";

  final animPath = 'assets/lottie_animations/learning.zip';

  String year = DateFormat.yMMMd().format(DateTime.now());

  List<String> _courses = [
    "JAVA BASICS",
    "MACHINE LEARNING",
    "CALCULUS I",
    "BIOLOGY",
    "MECHANICAL PHYSICS",
  ];

  void _changeCourse(BuildContext context) {
    showModalBottomSheet(
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 5,
            child: CupertinoPicker(
                itemExtent: 30.0,
                onSelectedItemChanged: (int val) {
                  setState(() {
                    course = _courses[val].toString();
                  });
                },
                children: _courses.map((e) => Text(e)).toList())),
        context: context);
  }

  void _changeYear(BuildContext context) {
    showModalBottomSheet(
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 5,
            child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) {
                  setState(() {
                    year = DateFormat.yMMMd().format(val);
                  });
                })),
        context: context);
  }

  void _checkOutQuestion() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => PastQuestions(
              course: course,
              date: year,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // iconSize: 45,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "PAST QUESTIONS",
          style: APP_BAR_TEXTSTYLE,
        ),
        backgroundColor: APP_BAR_COLOR,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Lottie.asset(animPath),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        course,
                        style: SMALL_WITH_BLACK,
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: APP_BAR_COLOR,
                      child: Text(
                        "Change",
                        style: MEDIUM_WHITE_BUTTON_TEXT,
                      ),
                      onPressed: () => _changeCourse(context),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        year,
                        style: SMALL_WITH_BLACK,
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: APP_BAR_COLOR,
                      child: Text(
                        "Change",
                        style: MEDIUM_WHITE_BUTTON_TEXT,
                      ),
                      onPressed: () {
                        _changeYear(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        // ignore: deprecated_member_use
        child: FlatButton(
          disabledColor: APP_BAR_COLOR.withOpacity(0.6),
          color: APP_BAR_COLOR,
          child: Text(
            "CHECKOUT QUESTIONS",
            style: NORMAL_WHITE_BUTTON_LABEL,
          ),
          onPressed: _checkOutQuestion,
        ),
      ),
    );
  }
}
