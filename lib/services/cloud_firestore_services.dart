import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/dbkeys.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreServices {
  static Stream<QuerySnapshot> getCompetitionStream() async* {
    yield* FirebaseFirestore.instance
        .collection('competitions')
        .where("end", isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> stremCourses() async* {
    yield* FirebaseFirestore.instance
        .collection('courses')
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<DocumentSnapshot> getCompetitionStream2(String id) async* {
    yield* FirebaseFirestore.instance
        .collection('competitions')
        .doc(id)
        .snapshots();
  }

  static Stream<QuerySnapshot> userStream(String userID) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userID)
        .snapshots();
  }

  static getCourses() async {
    final QuerySnapshot results =
        await FirebaseFirestore.instance.collection('courses').get();
    final documents = results.docs.toList();
    return documents;
  }

  //static Stream<DocumentSnapshot> getCourses() async* {
  //yield* FirebaseFirestore.instance.collection('courses ').doc().snapshots();
  // }

  static Stream<QuerySnapshot> getEnrolledStream(User user) async* {
    yield* FirebaseFirestore.instance
        .collection(ENROLMENTS)
        .where("userId", isEqualTo: user.uid)
        .where("end", isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> getCorrectAnswers(
      User user, String competitionId) async* {
    yield* FirebaseFirestore.instance
        .collection('results')
        .where("userId", isEqualTo: user.uid)
        .where('competitionId', isEqualTo: competitionId)
        .where("comEnd", isLessThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> personalCourses(User user) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> schoolCourses() async* {
    yield* FirebaseFirestore.instance.collection('school_info').snapshots();
  }

  static Stream<QuerySnapshot> getHistoryStream(User user) async* {
    yield* FirebaseFirestore.instance
        .collection("results")
        .where("userId", isEqualTo: user.uid)
        .orderBy("dateTaken")
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> getRankingStream(String competitionId) async* {
    yield* FirebaseFirestore.instance
        .collection("results")
        .where("competitionId", isEqualTo: competitionId)
        .orderBy("score", descending: true)
        .orderBy("time")
        .orderBy("dateTaken")
        .snapshots(includeMetadataChanges: true);
  }
}
