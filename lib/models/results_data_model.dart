// ignore: implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
    
    this.userResponse = data.data()["userResponse"];
    this.comEnd = data.data()["comEnd"];
   
  }

  
}
