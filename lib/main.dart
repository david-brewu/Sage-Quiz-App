import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/auth/application_root.dart';
import 'package:gamie/screens/auth/emailConfirmScreen.dart';
import 'package:gamie/screens/auth/gettingStartedScreen.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/Knowledge/pascoPage.dart';
import 'package:gamie/screens/user/profilePageScreen.dart';
import 'package:gamie/payments/userPaymentScreen.dart';
import 'package:provider/provider.dart';
import './Providers/bottomNav_provider.dart';
import './Providers/network_provider.dart';
import './Providers/edit_profile_provider.dart';
import 'package:simple_connectivity/simple_connectivity.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var con = await Connectivity().checkConnectivity();
  bool status = false;
  if (con == ConnectivityResult.mobile || con == ConnectivityResult.wifi) {
    status = true;
  } else {
    status = false;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: APP_BAR_COLOR, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.light, //status barIcon Brightness
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: APP_BAR_COLOR //navigation bar icon
      ));
  runApp(App(connection: status));
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  // Will only provide theme data here once we are
  final bool connection;

  const App({Key key, this.connection}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NetworkProvider(this.connection),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: PRIMARY_COLOR),
        title: APP_NAME,
        home: ApplicationRoot(),
        routes: {
          ApplicationRoot.routeName: (context) => ApplicationRoot(),
          GettingStartedScreen.routeName: (context) => GettingStartedScreen(),
          EmailConfirmScreen.routeName: (context) => EmailConfirmScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          ProfilePage.routeName: (context) => ProfilePage(),
          UserPaymentScreen.routeName: (context) => UserPaymentScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          PascoPage.routeName: (context) => PascoPage(),
        },
      ),
    );
  }
}
