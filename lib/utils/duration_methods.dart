import 'package:cloud_firestore/cloud_firestore.dart';

class DurationMethods {
  static bool allowUsertoCompete(Timestamp end, Duration compDuration) {
    var timeLeft = end.toDate().difference(DateTime.now());
    //if(timeLeft.inMilliseconds < compDuration.inMilliseconds~/2)return false;
    return true;
  }
}
