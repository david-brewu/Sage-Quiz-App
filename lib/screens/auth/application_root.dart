import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/auth/gettingStartedScreen.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:provider/provider.dart';

class ApplicationRoot extends StatelessWidget {
  static const String routeName = "application_root";
  @override
  Widget build(BuildContext context) {
    return InitializeApp();
  }
}

class UserAuthStateWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserAuthProvider userAuthData =
        Provider.of<UserAuthProvider>(context, listen: false);
    return Builder(builder: (
      BuildContext context,
    ) {
      return userAuthData.authUser != null ? MyClass() : GettingStartedScreen();
    });
  }
}

class InitializeApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  "Sorry, we couldn't start the app")); //something went wrong
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return UserAuthStateWatch();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
              child: Column(
            children: [
              Center(
                child: Text(
                  "Getting you ready...",
                  style: DISABLED_TEXT,
                ),
              ),
              CircularProgressIndicator()
            ],
          )),
        );
      },
    );
  }
}
