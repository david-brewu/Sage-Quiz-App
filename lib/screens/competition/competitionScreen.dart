import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/competition/competitionScoreScreen.dart';
import '../../models/competition_data_model.dart';
import '../../services/cloud_firestore_services.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:timer_count_down/timer_count_down.dart';

bool hasSubmit;

class CompetitionScreen1 extends StatefulWidget {
  final CompetitionDataModel dataModel;
  final User user;

  CompetitionScreen1(
    this.dataModel,
    this.user,
  );

  @override
  _CompetitionScreen1State createState() => _CompetitionScreen1State();
}

class _CompetitionScreen1State extends State<CompetitionScreen1> {
  /* int time = 14;
  Color _color = Colors.yellow;
  CountdownTimerController cpontroller = CountdownTimerController(
    onEnd: () {
      __compScreenState.routeMe();
    }, //routeMe(),
    endTime: __compScreenState.widget.dataModel.end.millisecondsSinceEpoch,
  );
  @override
  void setState(VoidCallback fn) {
    time = 15;
    _color = Colors.red;
  }
*/
  void initState() {
    // __compScreenState;
    super.initState();
  }

  PreferredSize _prf() {
    return PreferredSize(
        child: Container(
            child: CountdownTimer(
          controller: CountdownTimerController(
            onEnd: () {
              hasSubmit
                  ? null
                  : __compScreenState._navigateToCompetitionScore();
              print(hasSubmit);
            }, //routeMe(),
            endTime: DateTime.now()
                .add(Duration(seconds: widget.dataModel.duration.inSeconds))
                .millisecondsSinceEpoch,
            // DateTime.now()
            //   .add(Duration(seconds: time))
            // .millisecondsSinceEpoch,
          ),
          widgetBuilder: (_, time) => Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Time left",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: time == null || time.min == null || time.min < 5
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text("${time == null || time.min == null ? '0' : time.min}",
                        // '0',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color:
                                time == null || time.min == null || time.min < 5
                                    ? Colors.red
                                    : Colors.white,
                            fontFamily: "Montserrat")),
                    Text(":", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD),
                    Text("${time == null || time.sec == null ? '0' : time.sec}",
                        // '15',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color:
                                time == null || time.min == null || time.min < 5
                                    ? Colors.red
                                    : Colors.white,
                            fontFamily: "Montserrat")),
                  ],
                )
              ],
            ),
          ),
        )),
        preferredSize: Size(MediaQuery.of(context).size.width, 50));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.dataModel.title,
            style: APP_BAR_TEXTSTYLE,
          ),
          backgroundColor: APP_BAR_COLOR,
          bottom: _prf()),
      body: CompetitionScreen(dataModel: widget.dataModel, user: widget.user),
    );
  }
}

_CompetitionScreenState __compScreenState;

class CompetitionScreen extends StatefulWidget {
  final User user;
  final CompetitionDataModel dataModel;

  CompetitionScreen({this.dataModel, this.user});

  @override
  //_CompetitionScreenState createState() => _CompetitionScreenState();
  _CompetitionScreenState createState() {
    __compScreenState = _CompetitionScreenState();
    return __compScreenState;
  }
}

int min = 0;
int sec = 0;

class _CompetitionScreenState extends State<CompetitionScreen> {
  int _current = 0;
  int startTime = Timestamp.now().millisecondsSinceEpoch;
  // bool hasSubmit;
  // ignore: unused_element
  _showDialog() async {
    return showDialog(
        context: context,
        // child: Container(),
        builder: (context) => AlertDialog(
              title: Text("Are you sure you want to submit?"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      _popReplaceScore();
                      setState(() {
                        hasSubmit = true;
                      });
                    },
                    child: Text("Yes")),
                Text('                  '),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                )
              ],
            ));
  }

  void _popReplaceHome() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => HomeScreen()));
  }

  void _popReplaceScore() {
    Navigator.of(context).pop();
    _navigateToCompetitionScore();
  }
/* 
  @override
  void dispose() {
    super.dispose();
  } */

  _onWillPop() async {
    return showDialog(
        context: context,
        // child: Container(),
        builder: (context) => AlertDialog(
              title: Text(
                  "Your data will not be saved when you exit. Do you still want to exit?"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () => _popReplaceHome(), child: Text("Yes")),
                Text('                  '),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                )
              ],
            ));
  }

  List<String> _letters = ["A", "B", "C", "D"];
  List<int> trackPrevious = [for (var i = 0; i < 60; i += 1) 10];

  List<int> scores = [for (var i = 0; i < 60; i += 1) 0];
  void resetUserAnswer() {
    for (int i = 0; i < checked.length; i++) {
      checked[i] = false;
    }
  }

  int giveTime(int time) {
    return time;
  }

  int _stream() {
    int duuu;
    StreamBuilder(
        stream:
            CloudFirestoreServices.getCompetitionStream2(widget.dataModel.id),
        // ignore: missing_return
        builder: (
          context,
          snapshot,
        ) {
          List<DocumentSnapshot> needed = snapshot.data.docuements;
          if (needed != null) {
            try {
              var b = CompetitionDataModel.fromMap(needed[0], 0);
              int duuu = DateTime.now()
                  .add(Duration(minutes: b.duration.inMinutes))
                  .millisecondsSinceEpoch;
              print('myduu is');
              print(duuu);
            } catch (e) {
              return null;
            }
          } else {
            print('I found nothing');
          }
        });
    return duuu;
  }

  void onTapped(String e, String answer) {
    List alternatives = widget.dataModel.documents[_current]["alternatives"];
    int idx = alternatives.indexOf(e);
    print(idx);

    bool equal = widget.dataModel.documents[_current]["alternatives"][idx]
            .toUpperCase() ==
        answer.toUpperCase();
    scores[_current] = equal ? 1 : 0;
    trackPrevious[_current] = idx;
    if (e == widget.dataModel.documents[_current]["alternatives"][0]) {
      setState(() {
        resetUserAnswer();
        checked[0] = true;
      });
    } else if (e == widget.dataModel.documents[_current]["alternatives"][1]) {
      setState(() {
        resetUserAnswer();
        checked[1] = true;
      });
    } else if (e == widget.dataModel.documents[_current]["alternatives"][2]) {
      setState(() {
        resetUserAnswer();
        checked[2] = true;
      });
    } else if (e == widget.dataModel.documents[_current]["alternatives"][3]) {
      setState(() {
        resetUserAnswer();
        checked[3] = true;
      });
    }
  }

  List<bool> checked = [false, false, false, false];

  bool endOfQuestion = false;
  _navigateToCompetitionScore() async {
    String id;
    double score =
        scores.reduce((value, element) => value + element).toDouble();
    int timeNow = Timestamp.now().millisecondsSinceEpoch;
    int totalTime = timeNow - startTime;
    Map<String, dynamic> data = {
      "competitionId": widget.dataModel.id,
      "title": widget.dataModel.title,
      "dateTaken": DateTime.now(),
      "time": totalTime,
      "startTime": startTime,
      "endTime": startTime + totalTime,
      "score": score,
      "documents": widget.dataModel.documents,
      "userId": widget.user.uid,
      "userName": widget.user.displayName,
      "userResponse": trackPrevious,
      "comEnd": widget.dataModel.end,
    };
    Map<String, dynamic> userScore = {
      'Name': widget.user.displayName,
      'email': widget.user.email,
      'score': score,
      'total': widget.dataModel.documents.length
    };

    await FirebaseFirestore.instance
        .collection("results")
        .add(data)
        .then((value) => id = value.id);
    await FirebaseFirestore.instance
        .collection(widget.dataModel.title)
        .add(userScore);
    setState(() {
      hasSubmit = true;
    });

    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                CompetitionScoreScreen(score, widget.dataModel)),
        (route) => false);
//    dispose();
  }

  void routeMe() {
    _onNextTapped();
  }

  void _onNextTapped() {
    print(trackPrevious);
    print(scores);
    //endOfQuestion ? _showDialog() : null;

    if (_current == widget.dataModel.documents.length - 1) {
      _showDialog();
      setState(() {
        endOfQuestion = true;
      });
      return;
    }
    setState(() {
      _current++;
      resetUserAnswer();
      if (trackPrevious[_current] < 10) checked[trackPrevious[_current]] = true;
    });
  }

  void _onPreviousTapped() {
    resetUserAnswer();
    if (_current == 0) {
      return;
    }
    setState(() {
      _current--;
      if (trackPrevious[_current] < 10) checked[trackPrevious[_current]] = true;

      endOfQuestion = false;
    });
  }

  void initState() {
    hasSubmit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int duration = widget.dataModel.duration.inMinutes;
    int questionNumber = _current + 1;
    int _alt = 0;
    var alternatives = widget.dataModel.documents[_current]["alternatives"];
    var question = widget.dataModel.documents[_current]["question"];
    String answer = widget.dataModel.documents[_current]["answer"];
    final Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          //appBar: myAppBar(),

          /* appBar: AppBar(
            title: Text(
              widget.dataModel.title,
              style: APP_BAR_TEXTSTYLE,
            ),
            backgroundColor: APP_BAR_COLOR,
            bottom: PreferredSize(
                child: CountdownTimer(
                  controller: CountdownTimerController(
                    onEnd: () {
                      setState(() {});
                      __compScreenState.routeMe();
                    }, //routeMe(),
                    endTime: DateTime.now()
                        .add(Duration(
                            seconds: widget.dataModel.duration.inSeconds))
                        .millisecondsSinceEpoch,
                  ),
                  widgetBuilder: (_, time) => Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Time left",
                          style: TextStyle(color: Colors.red),
                        ),
                        Row(
                          children: [
                            Text(
                                "${time == null || time.min == null ? '0' : time.min}",
                                // '0',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: time == null ||
                                            time.min == null ||
                                            time.min < 5
                                        ? Colors.red
                                        : Colors.white,
                                    fontFamily: "Montserrat")),
                            Text(":", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD),
                            Text(
                                "${time == null || time.sec == null ? '0' : time.sec}",
                                // '15',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: time == null ||
                                            time.min == null ||
                                            time.min < 5
                                        ? Colors.red
                                        : Colors.white,
                                    fontFamily: "Montserrat")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                preferredSize: Size(deviceSize.width, 50)),
          ), */

          body: Container(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      QuestionCard(
                        questionNumber: questionNumber,
                        devSize: deviceSize,
                        questionData: question,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: alternatives.map<Widget>((e) {
                          _alt++;
                          return AnswerCard(
                            color: Colors.black,
                            devSize: deviceSize,
                            isChecked: checked[_alt - 1],
                            letter: _letters[_alt - 1],
                            option: e,
                            onAnswerTapped: () => onTapped(e, answer),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 55,
                    width: deviceSize.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PageControls(
                            buttonColor: Colors.green,
                            children: [
                              Text(
                                endOfQuestion ? "Submit" : "Next",
                                style: NORMAL_WHITE_BUTTON_LABEL,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                            alignment: MainAxisAlignment.end,
                            devSize: deviceSize,
                            onTap: () => _onNextTapped(),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class PageControls extends StatelessWidget {
  const PageControls(
      {Key key,
      @required this.devSize,
      @required this.alignment,
      @required this.children,
      @required this.buttonColor,
      @required this.onTap})
      : super(key: key);

  final Function onTap;
  final Color buttonColor;
  final Size devSize;
  final MainAxisAlignment alignment;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: devSize.width / 2,
      // ignore: deprecated_member_use
      child: FlatButton(
        color: buttonColor,
        onPressed: onTap,
        child: Row(mainAxisAlignment: alignment, children: children),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String questionData;
  final int questionNumber;

  QuestionCard({this.devSize, this.questionData, this.questionNumber});
  final Size devSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: EdgeInsets.all(5),
        width: devSize.width,
        decoration: BoxDecoration(
            color: APP_BAR_COLOR,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.2))
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 15, 15),
              child: Text(
                "Question $questionNumber",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                "$questionData",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: "Montserrat"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  final Size devSize;
  final Color color;
  final bool isChecked;

  const AnswerCard({
    Key key,
    this.devSize,
    this.onAnswerTapped,
    this.color,
    this.letter,
    this.option,
    this.isChecked,
  }) : super(key: key);
  final Function onAnswerTapped;
  final String letter;
  final String option;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: InkWell(
        onTap: onAnswerTapped,
        child: Container(
          //width: 3270,
          //height: 120,
          width: devSize.width,
          // height: 60,
          decoration: BoxDecoration(
              color: isChecked ? APP_BAR_COLOR : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: isChecked
                  ? null
                  : Border.all(color: Colors.black, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "$letter.\t\t",
                      style: isChecked
                          ? MEDIUM_WHITE_BUTTON_TEXT_BOLD
                          : LABEL_TEXT_STYLE_MEDIUM_BLACK,
                    ),
                    TextSpan(
                        text: option,
                        style: isChecked
                            ? NORMAL_WHITE_BUTTON_LABEL
                            : NORMAL_BLACK_BUTTON_TEXT)
                  ])),
                ),
                isChecked
                    ? Icon(
                        FontAwesome.check,
                        color: Colors.white,
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
