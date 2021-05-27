// ignore: implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Methods/MonthConversions.dart';

class ResultDataModel {
  String id;
  String competitionId;
  String title;
  Timestamp dateTaken;
  Timestamp time;
  Timestamp startTime;
  Timestamp endTime;
  String score;
  List documents;
  String userId;
  String userName;
  List userResponse;
  Timestamp comEnd;

  ResultDataModel(
      {this.id,
      this.competitionId,
      this.title,
      this.dateTaken,
      this.time,
      this.startTime,
      this.endTime,
      this.score,
      this.documents,
      this.userId,
      this.userName,
      this.userResponse,
      this.comEnd});
  ResultDataModel.fromMap(
    DocumentSnapshot data,
  ) {
    this.id = data.id;
    this.competitionId = data.data()["competitionId"];
    this.title = data.data()["title"];
    this.documents = data.data()["documents"];
    this.userId = data.data()["userId"];
    //this.duration = Duration(minutes: data.data()["duration"]);
    this.userResponse = data.data()["userResponse"];
    this.comEnd = data.data()["comEnd"];
    //this.index = index;
    //this.ended = data.data()["ended"];
  }

  /* String formatStart() {
    DateTime startTime = this.start.toDate();
    var startDay = startTime.day;
    var startMonth = startTime.month;
    var startYear = startTime.year;
    var startHour = startTime.hour.toString().length == 1
        ? "0${startTime.hour}"
        : startTime.hour;
    var startMin = startTime.minute.toString().length == 1
        ? "0${startTime.minute}"
        : startTime.minute;
    var starts =
        "Starts: ${monthNumber2Name(startMonth)} $startDay, $startYear | $startHour:$startMin";
    return starts;
  }

  String formatEnd() {
    DateTime endTime = this.end.toDate();
    var endDay = endTime.day;
    var endMonth = monthNumber2Name(endTime.month);
    var endYear = endTime.year;
    var endHour =
        endTime.hour.toString().length == 1 ? "0${endTime.hour}" : endTime.hour;
    var endMin = endTime.minute.toString().length == 1
        ? "0${endTime.minute}"
        : endTime.minute;
    var ending = "End: $endMonth $endDay, $endYear | $endHour:$endMin";
    return ending;
  }

  String formatDuration() {
    var dur = "Duration: ${this.duration.inMinutes} mins";
    return dur;
  } */
}
