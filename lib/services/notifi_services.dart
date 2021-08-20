import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifiacationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialie() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print('onMessage:$message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onMessage:$message');
    }, onResume: (Map<String, dynamic> message) async {
      print('onMessage:$message');
    });
  }
}
