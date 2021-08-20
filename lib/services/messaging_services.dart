import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/screens/competition/enrolledCompetions.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (Platform.isAndroid) {
          PushNotificationMessage notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
          showSimpleNotification(
            Container(child: Text(notification.body)),
            position: NotificationPosition.top,
          );
        }
        //  _route(message, context)
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (Platform.isAndroid) {
          PushNotificationMessage notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
          showSimpleNotification(
            Container(child: Text(notification.body)),
            position: NotificationPosition.top,
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if (Platform.isAndroid) {
          PushNotificationMessage notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
          showSimpleNotification(
            Container(child: Text(notification.body)),
            position: NotificationPosition.top,
          );
        }
      },
    );
  }

  void _route(Map<String, dynamic> message, BuildContext context) {
    var notification = message['data'];
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EnrolledCompetitions()));
  }
}

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}
