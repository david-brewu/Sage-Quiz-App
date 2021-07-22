import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolDataModel {
  List courses;
  String id;

  SchoolDataModel({this.courses, this.id});
  SchoolDataModel.fromMap(DocumentSnapshot data, int index) {
    this.courses = data.data()["courses"];
    this.id = data.id;
  }
}
