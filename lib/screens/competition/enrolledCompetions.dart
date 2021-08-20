import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gamie/Methods/CompetitionQueue.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/config/dbkeys.dart';
import 'package:gamie/reuseable/network_error_widget.dart';
import 'package:gamie/screens/competition/competitionStartConfirmation.dart';
import 'package:provider/provider.dart';

import '../../models/enrolment_data_model.dart';
import '../../services/cloud_firestore_services.dart';
import '../../Providers/network_provider.dart';
import '../../reuseable/no_connectivity_widget.dart';
import '../../reuseable/empty_items.dart';

class EnrolledCompetitions extends StatefulWidget {
  @override
  _EnrolledCompetitionsState createState() => _EnrolledCompetitionsState();
}

class _EnrolledCompetitionsState extends State<EnrolledCompetitions> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserAuthProvider>(context).authUser;
    final networkProvider = Provider.of<NetworkProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: networkProvider.connectionStatus
            ? competitionStream(user)
            : Center(child: NoConnectivityWidget()),
      ),
    );
  }
}

Widget competitionStream(User user) {
  var competitionIds = <String>[];
  return StreamBuilder(
      stream: CloudFirestoreServices.getHistoryStream(user),
      builder: (context, snapshot) {
        print('something');
        competitionIds = [];
        if (snapshot.connectionState == ConnectionState.waiting)
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        if (snapshot.hasError)
          return Scaffold(
            body: Center(
              child: Text(
                "There was an error",
                style: DISABLED_TEXT,
              ),
            ),
          );
        if (snapshot.hasData) {
          List<DocumentSnapshot> enrolledData = snapshot.data.documents;
          enrolledData.forEach((element) {
            competitionIds.add(element.data()["competitionId"]);
          });
        }
        return StreamBuilder(
          stream: CloudFirestoreServices.getEnrolledStream(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Scaffold(
                body: Center(
                  child: NetworkErrorWidget(),
                ),
              );
            }
            List<DocumentSnapshot> data = snapshot.data.docs;

            bool con = data.every((element) =>
                competitionIds.contains(element.data()["competitionId"]));
            if (con)
              return Center(
                child: EmptyWidget(
                  msg: 'You have no enrolled competitions',
                ),
              );
            if (data.length == 0)
              return Center(
                child: EmptyWidget(
                  msg: 'You have no enrolled competitions',
                ),
              );
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (competitionIds.contains(
                      data[index].data()['competitionId'])) return Container();
                  return CompetitionCard(
                      EnrolmentDataModel.fromMap(data[index], index));
                });
          },
        );
      });
}

class CompetitionCard extends StatelessWidget {
  final EnrolmentDataModel dataModel;
  CompetitionCard(this.dataModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (_) => CompetitionStartConfirmation(dataModel)));
        showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => CupertinoAlertDialog(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 28.0, horizontal: 5),
                        child: CountdownTimer(
                          controller: CountdownTimerController(
                              endTime:
                                  this.dataModel.start.millisecondsSinceEpoch),
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              return Text("Competition has started already!");
                            }
                            return Column(
                              children: [
                                Text(
                                  "Till competition starts",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                        visible: true,
                                        child: TimeBlock(
                                            main: time.days ?? 0,
                                            subText: "Days")),
                                    TimeBlock(
                                        main:
                                            time == null ? 0 : time.hours ?? 0,
                                        subText: "Hrs"),
                                    TimeBlock(
                                        main: time == null ? 0 : time.min ?? 0,
                                        subText: "Mins"),
                                    TimeBlock(
                                        main: time == null ? 0 : time.sec ?? 0,
                                        subText: "Sec"),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  insetAnimationDuration: Duration(milliseconds: 200),
                ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: APP_BAR_COLOR,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey, blurRadius: 1, spreadRadius: .1),
            ]),
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              dataModel.title,
              style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
            ),
            Text(dataModel.formatStart(), style: MEDIUM_DISABLED_TEXT),
            Text(
              dataModel.formatEnd(),
              style: MEDIUM_DISABLED_TEXT,
            ),
            Text(
              dataModel.formatDuration(),
              style: MEDIUM_DISABLED_TEXT,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              alignment: Alignment.bottomRight,
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: _removeUserFromCompetition,
                  child: Text(
                    "Drop off",
                    style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
                  )),
            )
          ],
        ),
      ),
    );
  }

  _removeUserFromCompetition() async {
    await FirebaseFirestore.instance
        .collection(ENROLMENTS)
        .doc(dataModel.id)
        .delete()
        .whenComplete(() => {
              competitionQueue.remove(dataModel.competitionId),
            })
        .catchError((onError) => null);
  }
}

class TimeBlock extends StatelessWidget {
  const TimeBlock({
    Key key,
    @required this.main,
    @required this.subText,
  }) : super(key: key);

  final int main;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 18, 5, 0),
          child: Text(
            "$main",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w200),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
          child: Text(
            "$subText",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
