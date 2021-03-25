import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth _auth = FirebaseAuth.instance;
Future<bool> sendEmailVerification()async{
  var user = _auth.currentUser;
  bool sent = await user.sendEmailVerification().then((value) => true).catchError((onError)=>onError);
  return sent == true;
}