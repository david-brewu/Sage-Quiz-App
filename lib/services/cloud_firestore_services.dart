import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/dbkeys.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreServices{


  static Stream<QuerySnapshot> getCompetitionStream()async*{
    yield* FirebaseFirestore.instance.collection(COMPETITIONS).where("end", isGreaterThan:Timestamp.now())
    .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> getEnrolledStream(User user)async*{
    yield* FirebaseFirestore.instance.collection(ENROLMENTS).where("userId", isEqualTo: user.uid).where("end", isGreaterThan: Timestamp.now()).snapshots();
  }

  static Stream<QuerySnapshot> getHistoryStream(User user)async*{
    yield* FirebaseFirestore.instance.collection("results")
        .where("userId", isEqualTo: user.uid).orderBy("dateTaken")
    .snapshots(includeMetadataChanges: true);
  }
  static Stream<QuerySnapshot> getRankingStream(String competitionId)async*{
    yield* FirebaseFirestore.instance.collection("results")
        .where("competitionId", isEqualTo: competitionId).orderBy("score").orderBy("time").orderBy("dateTaken")
        .snapshots(includeMetadataChanges: true);
  }
  
}