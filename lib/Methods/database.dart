import 'package:cloud_firestore/cloud_firestore.dart';



Future<DocumentReference> addData(String collectionName, Map<dynamic, dynamic> data) => FirebaseFirestore.instance.collection(collectionName).add(data);


Future<void> removeItem(String collectionName, String docid) => FirebaseFirestore.instance.collection(collectionName).doc(docid).delete();
