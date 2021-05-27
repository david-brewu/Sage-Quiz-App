// ignore: implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamie/Methods/MonthConversions.dart';

class CompetitionDataModel {
  String title;
  Timestamp start;
  Timestamp end;
  Duration duration;
  String id;
  double price;
  int index;
  List documents;

  CompetitionDataModel(
      {this.price,
      this.title,
      this.start,
      this.end,
      this.duration,
      this.id,
      this.index,
      this.documents});
  CompetitionDataModel.fromMap(QueryDocumentSnapshot data, int index) {
    this.title = data.data()["title"];
    this.start = data.data()["start"];
    this.end = data.data()["end"];
    this.duration = Duration(minutes: data.data()["duration"]);
    this.price = data.data()["price"].toDouble();
    this.id = data.id;
    this.index = index;
    this.documents = data.data()["documents"];
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

  String formatPrice() {
    var cost = "Price: GHS ${this.price}";
    return cost;
  }
}
