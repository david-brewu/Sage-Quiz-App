import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/competition/competitionScoreScreen.dart';
import '../../models/competition_data_model.dart';


class CompetitionScreen extends StatefulWidget {
  final User user;
  final CompetitionDataModel dataModel;

  CompetitionScreen({this.dataModel, this.user});


  @override
  _CompetitionScreenState createState() => _CompetitionScreenState();
}
class _CompetitionScreenState extends State<CompetitionScreen> {
  int _current = 0;
  int startTime = Timestamp.now().millisecondsSinceEpoch;



  // ignore: unused_element
  _showDialog() async {
    return showDialog(
        context: context,
        // child: Container(),
        builder: (context) => AlertDialog(
              title: Text("Are you sure you want to submit?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: _navigateToCompetitionScore, child: Text("Yes")),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                )
              ],
            ));
  }


  List<String> _letters = ["A", "B", "C", "D"];
  List<int> scores = [for(var i=0; i<60; i+=1) 0];
  void resetUserAnswer() {
    for (int i = 0; i < checked.length; i++) {
      checked[i] = false;
    }
  }

  void onTapped(String e, String answer) {
      List alternatives = widget.dataModel.documents[_current]["alternatives"];
      int idx = alternatives.indexOf(e);
      String chosen = _letters[idx];
      bool equal = chosen.toUpperCase()==answer.toUpperCase();
      scores[_current] = equal?1:0;
    if (e ==widget.dataModel.documents[_current]
            ["alternatives"][0]) {
      setState(() {
        resetUserAnswer();
        checked[0] = true;
      });
    } else if (e ==
        widget.dataModel.documents[_current]
            ["alternatives"][1]) {
      setState(() {
        resetUserAnswer();
        checked[1] = true;
      });
    } else if (e ==
        widget.dataModel.documents[_current]
            ["alternatives"][2]) {
      setState(() {
        resetUserAnswer();
        checked[2] = true;
      });
    } else if (e ==
        widget.dataModel.documents[_current]
            ["alternatives"][3]) {
      setState(() {
        resetUserAnswer();
        checked[3] = true;
      });
    }
  }

  List<bool> checked = [false, false, false, false];

  bool endOfQuestion = false;
  void _navigateToCompetitionScore() async{
    double score = scores.reduce((value, element) => value+element).toDouble();
    int timeNow = Timestamp.now().millisecondsSinceEpoch;
    int totalTime = timeNow - startTime;
    Map<String, dynamic> data = {
      "competitionId": widget.dataModel.id,
      "title": widget.dataModel.title,
      "dateTaken": DateTime.now(),
      "time": totalTime,
      "startTime": startTime,
      "endTime": startTime+totalTime,
      "score": score,
      "documents": widget.dataModel.documents,
      "userId": widget.user.uid,
      "userName": widget.user.displayName,
    };
    
    await FirebaseFirestore.instance.collection("results").add(data);

    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => CompetitionScoreScreen(score,widget.dataModel)));
  }
  void _onNextTapped() {
    //endOfQuestion ? _showDialog() : null;


    if (_current == widget.dataModel.documents.length - 1) {
      _navigateToCompetitionScore();
      setState(() {
        endOfQuestion = true;
      });
      return;
    }
    setState(() {
      _current++;
      resetUserAnswer();
    });
  }

  void _onPreviousTapped() {
    if (_current == 0) {
      return;
    }
    setState(() {
      _current--;
      endOfQuestion = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String competitionTitle = widget.dataModel.title;
    int duration = widget.dataModel.duration.inMinutes;
    int questionNumber = _current+1;
    int _alt = 0;
    var alternatives = widget.dataModel.documents[_current]["alternatives"];
    var question = widget.dataModel.documents[_current]["question"];
    String answer = widget.dataModel.documents[_current]["answer"];
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          competitionTitle,
          style: APP_BAR_TEXTSTYLE,
        ),
        backgroundColor: APP_BAR_COLOR,
        bottom: PreferredSize(
            child: Container(
              child: CountdownTimer(
                endTime: DateTime.now().add(Duration(minutes: duration)).millisecondsSinceEpoch,
                widgetBuilder: (_, time)=>
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Time left", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,),
                          Row(
                            children: [
                              Text("${time.min}", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD),
                              Text(":", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD),
                              Text("${time.sec}", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD),
                            ],
                          )
                        ],
                      ),
                    ),
              )
            ),
            preferredSize: Size(deviceSize.width, 50)),
      ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PageControls(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Previous",
                            style: NORMAL_WHITE_BUTTON_LABEL,
                          ),
                        ],
                        alignment: MainAxisAlignment.start,
                        devSize: deviceSize,
                        buttonColor: Colors.red,
                        onTap: () => _onPreviousTapped(),
                      ),
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
    );
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
              child: Text("Question $questionNumber", style: MEDIUM_WHITE_BUTTON_TEXT,),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: Text("$questionData", style: MEDIUM_WHITE_BUTTON_TEXT,),
            ),
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
                RichText(
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
