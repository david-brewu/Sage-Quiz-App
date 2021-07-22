import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Methods/CompetitionQueue.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/config/dbkeys.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:provider/provider.dart';

import '../../models/competition_data_model.dart';
import '../../services/cloud_firestore_services.dart';
import '../../Providers/authUserProvider.dart';
import '../../Providers/network_provider.dart';
import '../../reuseable/no_connectivity_widget.dart';
import '../../reuseable/empty_items.dart';
import '../../reuseable/network_error_widget.dart';

class Competitions extends StatefulWidget {
  @override
  _CompetitionsState createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  @override
  void initState() {
    getUser(FirebaseAuth.instance.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? competionStream(user)
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget competionStream(User user) {
  var enrolledIds = <String>[];
  return StreamBuilder(
    stream: CloudFirestoreServices.getEnrolledStream(user),
    //stream:  FirebaseFirestore.instance.collection('enrolments').snapshots(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
        List<DocumentSnapshot> enrolledData = snapshot.data.docs;
        print('enrolled data is');
        print(enrolledData.length);
        enrolledData.forEach((element) {
          print(element);
          enrolledIds.add(element.data()["competitionId"]);
        });
      }
      return StreamBuilder(
          stream: CloudFirestoreServices.getCompetitionStream(),
          //stream: FirebaseFirestore.instance.collection("competitions").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: NetworkErrorWidget(),
                ),
              );
            }
            if (snapshot.hasData) {
              List<DocumentSnapshot> data = snapshot.data.docs;
              print(data.length);
              print(data.toString());
              bool con =
                  data.every((element) => enrolledIds.contains(element.id));
              if (con)
                return Center(
                  child: EmptyWidget(
                    msg:
                        'There are no competitions available. Please check back later',
                  ),
                );
              if (data.length == 0)
                return Center(
                  child: EmptyWidget(
                    msg:
                        'There are no competitions available. Please check back later',
                  ),
                );
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    if (enrolledIds.contains(data[index].id))
                      return Container();
                    return CompetitionCard(
                        CompetitionDataModel.fromMap(data[index], index));
                  });
            } else
              return Text('has not data');
          });
    },
  );
}

class CompetitionCard extends StatelessWidget {
  final CompetitionDataModel dataModel;
  CompetitionCard(this.dataModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: APP_BAR_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          //backgroundBlendMode: BlendMode.color,
          boxShadow: [
            BoxShadow(color: Colors.blueGrey, blurRadius: 1, spreadRadius: .1),
          ]),

      //color: APP_BAR_COLOR,
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
          Text(
            dataModel.formatPrice(),
            style: MEDIUM_DISABLED_TEXT,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .9,
            alignment: Alignment.bottomRight,
            // ignore: deprecated_member_use
            child: FlatButton(
                onPressed: _enrollUserInCompetition,
                child: Text(
                  "Enroll Now",
                  style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
                )),
          )
        ],
      ),
    );
  }

  _enrollUserInCompetition() async {
    User user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> payload = {
      COMPETITION_ID: dataModel.id,
      COMPETITION_TITLE: dataModel.title,
      COMPETITION_START: dataModel.start,
      COMPETITION_DURATION: dataModel.duration.inMinutes,
      COMPETITION_END: dataModel.end,
      USER_ID: user.uid,
      "ended": false,
      "numberOfQuestions": dataModel.documents.length,
      USER_NAME: user.displayName,
    };
    var document = await FirebaseFirestore.instance
        .collection(ENROLMENTS)
        .where(COMPETITION_ID, isEqualTo: dataModel.id)
        .where(USER_ID, isEqualTo: user.uid)
        .limit(1)
        .get();
    if (document.docs.length == 1) return;
    print('onit');
    // create the doc
    FirebaseFirestore.instance
        .collection(ENROLMENTS)
        .add(payload)
        .whenComplete(() async {
      print('done');
      competitionQueue.add(dataModel.id);
      // documents.removeAt(index);
      //Trigger firebase reload
      await FirebaseFirestore.instance
          .collection(COMPETITIONS)
          .doc(dataModel.id)
          .update(
              {"last_accessed": "${Timestamp.now().millisecondsSinceEpoch}"});
      print(competitionQueue);
    }).catchError((onError) => null);
  }
}
