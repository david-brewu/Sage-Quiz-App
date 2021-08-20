import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gamie/config/config.dart';
import '../../models/results_data_model.dart';

class CorrectAnswers extends StatefulWidget {
  final User user;
  final ResultDataModel dataModel;

  CorrectAnswers({this.dataModel, this.user});

  @override
  _CorrectAnswers createState() => _CorrectAnswers();
}

class _CorrectAnswers extends State<CorrectAnswers> {
  int _current = 0;
  List<String> _letters = ["A", "B", "C", "D"];

  void _onNextTapped() {
    if (_current == widget.dataModel.documents.length - 1) {
      setState(() {});
      return;
    }
    setState(() {
      _current++;
    });
  }

  void _onPreviousTapped() {
    if (_current == 0) {
      return;
    }
    setState(() {
      _current--;
    });
  }

  Widget build(BuildContext context) {
    String competitionTitle = widget.dataModel.title;

    int questionNumber = _current + 1;
    int _alt = 0;
    var alternatives = widget.dataModel.documents[_current]["alternatives"];
    var question = widget.dataModel.documents[_current]["question"];

    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          competitionTitle + "Answers",
          style: APP_BAR_TEXTSTYLE,
        ),
        backgroundColor: APP_BAR_COLOR,
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
                        letter: _letters[_alt - 1],
                        option: e,
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
                            widget.dataModel.documents.length - 1 == _current
                                ? ""
                                : "Next",
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
              child: Text(
                "Question $questionNumber",
                style: MEDIUM_WHITE_BUTTON_TEXT,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                "$questionData",
                style: MEDIUM_WHITE_BUTTON_TEXT,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  final int index;
  final String answer;

  final Size devSize;
  final Color color;
  final bool isChecked;

  const AnswerCard({
    Key key,
    this.index,
    this.answer,
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
                        style: answer == option
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
