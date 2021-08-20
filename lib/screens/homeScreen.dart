
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/Providers/first_lunch.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/auth/login.dart';
import 'package:gamie/screens/homeScreenNavs/dashboard.dart';
import 'package:gamie/screens/homeScreenNavs/enrolled.dart';
import 'package:gamie/screens/homeScreenNavs/history.dart';
import 'package:gamie/screens/homeScreenNavs/learn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reuseable/drawer.dart';
import '../reuseable/bottomNav.dart';
import '../Providers/bottomNav_provider.dart';
import 'package:connectivity_widget/connectivity_widget.dart';


Map<String, dynamic> data1;
SharedPreferences prefs;
bool noti;
SharedPreferences preferences;
String docNum;

class MyClass extends StatefulWidget {
  static final routeName = 'myClass';
  const MyClass({Key key}) : super(key: key);

  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  @override
  void setState(VoidCallback vb) async {
    preferences = await SharedPreferences.getInstance();
    noti = await FirstLaunchSharedPreference.getNotiStatus();
    prefs = await SharedPreferences.getInstance();
    

    super.setState(() {});
  }

  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getUser(FirebaseAuth.instance.currentUser);
  }
}


class HomeScreen extends StatefulWidget {
  static String routeName = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void setState(VoidCallback vb) async {
    preferences = await SharedPreferences.getInstance();
    noti = await FirstLaunchSharedPreference.getNotiStatus();
    prefs = await SharedPreferences.getInstance();
    

    super.setState(() {});
  }

  void initState() {
    setState(() {});
    super.initState();
  }

  List<Widget> _navbody = [
    DashboardNav(),
    EnrolledNav(),
    HistoryNav(),
   // LearningNav(),
  ];

  Widget _buildHome(int index) => (_navbody[index]);

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final net = Provider.of<NetworkProvider>(context);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                APP_NAME,
                style: APP_BAR_TEXTSTYLE,
              ),
              leading: Builder(
                  builder: (context) => IconButton(
                        icon: IconButton(
                          onPressed: () async {
                            Scaffold.of(context).openDrawer();
                          },
                          padding: EdgeInsets.all(0),
                          iconSize: 45,
                          icon: Icon(Icons.menu, color: Colors.white),
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )),
              backgroundColor: APP_BAR_COLOR,
            ),
            drawer: CustomDrawer(),
           
            body: DoubleBackToCloseApp(
              snackBar:
                  const SnackBar(content: Text('Tab back again to leave app')),
              child: ConnectivityWidget(
                  onlineCallback: () => net.setInternet = true,
                  offlineCallback: () => net.setInternet = false,
                  builder: (context, snapshot) {
                   
                    return SafeArea(child: Consumer<BottomNavProvider>(
                        builder: (context, snapshot, widget) {
                      return _buildHome(snapshot.index);
                    }));
                  }),
            ),
            bottomNavigationBar: BottomNav()));
  }
}
