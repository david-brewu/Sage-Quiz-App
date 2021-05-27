// ignore: implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Methods/MonthConversions.dart';

class EnrolmentDataModel {
  String id;
  String title;
  Timestamp start;
  Timestamp end;
  Duration duration;
  String competitionId;
  int index;
  bool ended;
  int numberOfQuestions;

  EnrolmentDataModel(
      {this.title,
      this.start,
      this.end,
      this.duration,
      this.competitionId,
      this.index,
      this.numberOfQuestions,
      this.id,
      this.ended});
  EnrolmentDataModel.fromMap(DocumentSnapshot data, int index) {
    this.id = data.id;
    this.numberOfQuestions = data.data()["numberOfQuestions"];
    this.title = data.data()["title"];
    this.start = data.data()["start"];
    this.end = data.data()["end"];
    this.duration = Duration(minutes: data.data()["duration"]);
    this.competitionId = data.data()["competitionId"];
    this.index = index;
    this.ended = data.data()["ended"];
  }

  String formatStart() {
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
  }
}
