import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String title;
  String id;
  String courseCode;

  CourseModel({this.title, this.id, this.courseCode});
  CourseModel.fromMap(DocumentSnapshot data, int index) {
    this.title = data.data()["title"];
    this.id = data.id;
    this.courseCode = data.data()["courseCode"];
  }
}
