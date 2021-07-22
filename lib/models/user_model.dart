import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String fullName;
  String photoURL;
  String phoneNumber;
  String address;
  String email;
  String id;
  String uid;
  String school;
  List courses;
  // String docID;

  UserDataModel({
    this.fullName,
    this.photoURL,
    this.phoneNumber,
    this.address,
    this.email,
    this.id,
    this.uid,
    this.school,
    this.courses, //this.docID
  });

  UserDataModel.fromMap(DocumentSnapshot data, int index) {
    this.fullName = data.data()["full_name"];
    this.photoURL = data.data()["photURL"];
    this.phoneNumber = data.data()["phone_number"];
    this.address = data.data()["address"];
    this.email = data.data()["email_address"];
    this.id = data.id;
    this.uid = data.data()["uid"];
    this.school = data.data()["school"];
    this.courses = data.data()['courses'];
    //  this.courses = data.data()['courses'];
  }
}
