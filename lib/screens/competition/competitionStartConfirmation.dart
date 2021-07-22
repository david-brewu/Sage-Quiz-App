import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/competition/competitionScreen.dart';
import 'package:gamie/screens/competition/enrolledCompetions.dart';
import 'package:gamie/utils/duration_methods.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../models/enrolment_data_model.dart';
import '../../models/competition_data_model.dart';
import '../../Providers/network_provider.dart';
import '../../screens/homeScreen.dart';

class CompetitionStartConfirmation extends StatefulWidget {
  final EnrolmentDataModel dataModel;

  CompetitionStartConfirmation(this.dataModel);

  @override
  _CompetitionStartConfirmationState createState() =>
      _CompetitionStartConfirmationState();
}

class _CompetitionStartConfirmationState
    extends State<CompetitionStartConfirmation> {
  // bool hasStarted;
  void _unEnrollUser(context) {
    FirebaseFirestore.instance
        .collection("enrolments")
        .doc(widget.dataModel.id)
        .delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (_) => HomeScreen()))),
          title: Text(
            "${widget.dataModel.title}",
            style: APP_BAR_TEXTSTYLE,
          ),
          backgroundColor: APP_BAR_COLOR,
        ),
        body: WillPopScope(
          onWillPop: () => Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (_) => HomeScreen())),
          child: Container(
            width: deviceSize.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      CountdownTimer(
                        controller: CountdownTimerController(
                          endTime:
                              widget.dataModel.start.millisecondsSinceEpoch,
                          onEnd: () {},
                        ),
                        widgetBuilder: (_, time) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimeBlock(
                                main: time == null ? 0 : time.days ?? 0,
                                subText: "days",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.hours ?? 0,
                                subText: "Hrs",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.min ?? 0,
                                subText: "mins",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.sec ?? 0,
                                subText: "sec",
                              ),
                            ],
                          );
                        },
                      ),
                      Text(
                        "Till Competition Starts ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Opened on:\t ",
                        style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(
                        text: "${widget.dataModel.formatStart()}\n",
                        style: LABEL_TEXT_STYLE),
                    TextSpan(
                        text: "\nCloses on:\t",
                        style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(
                        text: "${widget.dataModel.formatEnd()}\n",
                        style: LABEL_TEXT_STYLE),
                    TextSpan(
                        text: "\nMax duration:\t",
                        style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(
                        text:
                            "${widget.dataModel.duration.inSeconds} seconds\n",
                        style: LABEL_TEXT_STYLE),
                    TextSpan(
                        text: "\nNumber of Questions:\t",
                        style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(
                        text: "${widget.dataModel.numberOfQuestions} \n",
                        style: LABEL_TEXT_STYLE),
                  ])),
                  Column(
                    children: [
                      CountdownTimer(
                        controller: CountdownTimerController(
                          endTime: widget.dataModel.end.millisecondsSinceEpoch,
                          onEnd: () {
                            _unEnrollUser(context);
                          },
                        ),
                        widgetBuilder: (_, time) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimeBlock(
                                main: time == null ? 0 : time.days ?? 0,
                                subText: "days",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.hours ?? 0,
                                subText: "Hrs",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.min ?? 0,
                                subText: "mins",
                              ),
                              TimeBlock(
                                main: time == null ? 0 : time.sec ?? 0,
                                subText: "sec",
                              ),
                            ],
                          );
                        },
                      ),
                      Text(
                        "Till Competition Closes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomRoundedButton(
                      height: 70,
                      radius: 20.0,
                      color: LIGHT_BLUE_BUTTON_COLOR,
                      textColor: Colors.white,
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text("Start Competition?"),
                            actions: [
                              // ignore: deprecated_member_use
                              FlatButton(
                                onPressed: () {
                                  //pops the dialog before navigating
                                  Navigator.pop(context);
                                  if (widget.dataModel.start
                                          .compareTo(Timestamp.now()) <=
                                      0) {
                                    if (!DurationMethods.allowUsertoCompete(
                                        widget.dataModel.end,
                                        widget.dataModel.duration)) {
                                      Toast.show(
                                          'You can\'t participate due to the time left',
                                          context,
                                          gravity: Toast.LENGTH_LONG);
                                      return;
                                    }
                                    if (!networkProvider.connectionStatus) {
                                      Toast.show(
                                          'Please connect to internet to proceed',
                                          context,
                                          duration: Toast.LENGTH_SHORT);
                                      return;
                                    }
                                    FirebaseFirestore.instance
                                        .collection("competitions")
                                        .doc(widget.dataModel.competitionId)
                                        .get()
                                        .then((doc) {
                                      final data =
                                          CompetitionDataModel.fromMap(doc, 0);
                                      if (data.documents.length > 0) {
                                        User user =
                                            Provider.of<UserAuthProvider>(
                                                    context,
                                                    listen: false)
                                                .authUser;
                                        Navigator.of(context).pushReplacement(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    CompetitionScreen1(
                                                        data, user)));
                                      }
                                    }).catchError((err) {
                                      print(err);
                                    }).timeout(Duration(seconds: 30),
                                            onTimeout: () {});
                                  } else {
                                    //when current time exceeds start time
                                  }
                                },
                                child: Text(
                                  "Go",
                                  style: TextStyle(fontSize: 22),
                                ),
                              )
                            ],
                            content: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              child: Text(
                                "\nReady to compete? tap go!\n\nElse tap anywhere outside",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                      text: "Start competition",
                    ),
                  )
                ]),
          ),
        ));
  }
}
