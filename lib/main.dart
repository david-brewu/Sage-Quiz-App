import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/Providers/first_lunch.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/auth/application_root.dart';
import 'package:gamie/screens/auth/emailConfirmScreen.dart';
import 'package:gamie/screens/auth/gettingStartedScreen.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/Knowledge/pascoPage.dart';
import 'package:gamie/screens/profilePageWidgets/personalInfo.dart';
import 'package:gamie/payments/userPaymentScreen.dart';
import 'package:gamie/screens/user/user_course_management.dart';
import 'package:gamie/services/messaging_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Providers/bottomNav_provider.dart';
import './Providers/network_provider.dart';
import './Providers/edit_profile_provider.dart';
import 'package:simple_connectivity/simple_connectivity.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
  if (await FirstLaunchSharedPreference.getLaunch() != true)
    runApp(Start(
      function: await FirstLaunchSharedPreference.setNotiStatus(true),
    ));
  else {
    runApp(App(
      connection: status,
    ));
  }
}

class Start extends StatelessWidget {
  final Future<void> function;
  Start({@required this.function});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    var con = await Connectivity().checkConnectivity();
    bool status = false;
    if (con == ConnectivityResult.mobile || con == ConnectivityResult.wifi) {
      status = true;
    } else {
      status = false;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => App(
                connection: status,
              )),
    );
    await FirstLaunchSharedPreference.setLaunch(true);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,

      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Welcome to Sage Educational App, ',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Enrollments",
          body:
              "Checkout upcoming competitions under the competition tap to enroll.",
          image: _buildImage('assets/images/enroll.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Competition Start",
          body:
              "Once enrolled in a competition, be minded of when the competition will start",
          image: _buildImage('assets/images/start.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Competition End",
          body:
              "Once a competition is done, check out your performance under the history tab",
          image: _buildImage('assets/images/results.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Profile and Contact",
          body:
              "Don't forget to update your profile with a profile picture, phone number and address",
          image: _buildImage('assets/images/contact.jpg'),
          decoration: pageDecoration,
        ),
      ],

      onDone: () => _onIntroEnd(context),

      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text(
        'Skip',
      ),
      next: const Icon(
        Icons.arrow_forward_ios,
      ),
      done: const Text('Done',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // This widget is the root of your application.
  // Will only provide theme data here once we are
  final bool connection;
  const App({Key key, this.connection}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String none = '';
  bool notiStatus;
  SharedPreferences prefs;
  void setState(VoidCallback vb) async {
    notiStatus = await FirstLaunchSharedPreference.getNotiStatus();
    super.setState(() {});
  }

  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService =
        PushNotificationService(App._firebaseMessaging);
    if (notiStatus != false) {
      pushNotificationService.initialise();
    } else {}
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
          create: (_) => NetworkProvider(this.widget.connection),
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
          UserPaymentScreen.routeName: (context) => UserPaymentScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          PascoPage.routeName: (context) => PascoPage(),
          PersonalInfo.routeName: (context) =>
              PersonalInfo(formKey: GlobalKey<FormState>()),
          CourseResgistration.routeName: (context) => CourseResgistration(),
          MyClass.routeName: (context) => MyClass()
        },
      ),
    );
  }
}
