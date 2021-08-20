import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/competition/ScoreBoard.dart';
import 'package:gamie/screens/competition/show_answers.dart';
import 'package:provider/provider.dart';
import '../../services/cloud_firestore_services.dart';
import '../../Providers/network_provider.dart';
import '../../reuseable/no_connectivity_widget.dart';
import '../../reuseable/empty_items.dart';
import '../../reuseable/network_error_widget.dart';

class CompetitionHistory extends StatefulWidget {
  _CompetitionHistoryState createState() => _CompetitionHistoryState();
}

final newHisList = <String>[];

class _CompetitionHistoryState extends State<CompetitionHistory> {
  bool hasOccur;

  @override
  void initState() {
    hasOccur = true;
    super.initState();
  }

  String onError() {
    print('error');
    return 'error';
  }

  @override
  Widget build(BuildContext context) {
    int detectNum = 0;
    User user = Provider.of<UserAuthProvider>(context).authUser;
    final networkProvider = Provider.of<NetworkProvider>(context);
    return networkProvider.connectionStatus
        ? StreamBuilder(
            stream: CloudFirestoreServices.getHistoryStream(user)
                .handleError(onError),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.hasError) return NetworkErrorWidget();

              List<DocumentSnapshot> docs = snapshot.data.documents;
              if (docs.length == 0)
                return Center(
                    child: EmptyWidget(
                        msg: "You haven't participated in any competitions"));
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  Map<String, dynamic> document = docs[index].data();
                  final hisList = <String>[];
                  final title = document["title"];
                  final dateTaken = document["dateTaken"];
                  final score = document["score"];
                  final total = document["documents"].length;
                  final competitionId = document["competitionId"];
                  final id = document['userId'];
                  hisList.add(id);
                 
                  return
                     
                      HistoryCard(
                    title: title,
                    dateTaken: dateTaken,
                    score: score,
                    total: total,
                    competitionId: competitionId,
                    id: id,
                  );
               
                },
              );
            },
          )
        : NoConnectivityWidget();
  }
}

class HistoryCard extends StatelessWidget {
  final User user;
  final String title;
  final Timestamp dateTaken;
  final score;
  final total;
  final competitionId;
  final id;
  const HistoryCard(
      {Key key,
      this.user,
      this.title,
      this.dateTaken,
      this.score,
      this.total,
      this.competitionId,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (hisList.contains(id)) newHisList.add(id);
    final DateTime date = dateTaken.toDate();
    final month = date.month;
    final day = date.day;
    final year = date.year;
    final hour = date.hour;
    final min = date.minute;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => ShowAnswer(
                  competitionId,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(
              color: APP_BAR_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            children: [
              Text(
                "$title",
                style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Text("Date: $day-$month-$year | $hour:$min",
                    style: MEDIUM_DISABLED_TEXT),
              ),
              Text("Your score: ${(100 * score / total).round()}%",
                  style: MEDIUM_DISABLED_TEXT),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog() async {
    return AlertDialog(
      title: Text("Are you sure you want to submit?"),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () => ScoreBoard(competitionId), child: Text("Ranking")),
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () => ShowAnswer(competitionId),
          child: Text("Answers"),
        )
      ],
    );
  }
}
