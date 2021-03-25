import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:provider/provider.dart';
import 'package:gamie/services/cloud_firestore_services.dart';
import '../../Providers/authUserProvider.dart';

class ScoreBoard extends StatelessWidget {
  final competitionId;

  ScoreBoard(this.competitionId,);


  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Rankings',
              style: APP_BAR_TEXTSTYLE,
            ),
            leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.all(0),
                        iconSize: 45,
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
            backgroundColor: APP_BAR_COLOR,
                    ),
      body: rankingStream(this.competitionId,userAuth),
    ); 
  }
}

Widget rankingStream(String competitionId,UserAuthProvider userAuth)=>StreamBuilder(
      stream: CloudFirestoreServices.getRankingStream(competitionId),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else if(snapshot.hasError)
          return Text("there was an error, please try later", style: DISABLED_TEXT,);

        List<DocumentSnapshot> docs = snapshot.data.documents;
        if(docs.length == 0)
          return Text("You haven't participated in any competitions", style: DISABLED_TEXT,);
        return Container(
          color: Colors.white,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index){
              Map<String, dynamic> document  = docs[index].data();
              final title = document["title"];
              final dateTaken = document["dateTaken"];
              final score = document["score"];
              final total = document["documents"].length;
              final username = document["userName"];
              final userId = document['userId'];
              final rank = index+1;
              final time = document["time"];

              return HistoryCard(
                isUser: userId == userAuth.authUser.uid,
                title: title, dateTaken: dateTaken, score: score, total: total, username: username, rank:rank, time: time,);
            },
          ),
        );
      },
    );



class HistoryCard extends StatelessWidget {
  final String title;
  final Timestamp dateTaken;
  final bool isUser;
  final score;
  final total;
  final competitionId;
  final username;
  final rank;
  final int time;
  const HistoryCard({
    Key key,
    this.isUser,
    this.title,
    this.dateTaken,
    this.score,
    this.total,
    this.competitionId,
    this.username,
    this.rank,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(time);
    final DateTime date = dateTaken.toDate();
    final month = date.month;
    final day = date.day;
    final year = date.year;
    final hour = date.hour;
    final min = date.minute;
    final timeSpent = DateTime.fromMillisecondsSinceEpoch(time);
    // print(timeSpent.hour);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Container(

        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),

        decoration: BoxDecoration(color: isUser?Colors.lightBlue:APP_BAR_COLOR, borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12,0,20,0),
              child: Text("$rank", style: TextStyle(
                color: isUser?Colors.white:Colors.black,
                fontSize: 50, fontWeight: FontWeight.w200),),
            ),
            Center(
              child: Column(children: [
                Text("$username", style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Text("Date: $day-$month-$year | $hour:$min", style: MEDIUM_DISABLED_TEXT),
                ),
                Text("Score: ${(100*score/total).round()}%  |  time: ${timeSpent.minute??'0'}mins ${timeSpent.second??'0'}sec", style: MEDIUM_DISABLED_TEXT),
              ],),
            ),
          ],
        ),
      ),
    );
  }
}

