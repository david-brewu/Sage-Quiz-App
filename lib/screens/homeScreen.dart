
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/homeScreenNavs/dashboard.dart';
import 'package:gamie/screens/homeScreenNavs/enrolled.dart';
import 'package:gamie/screens/homeScreenNavs/history.dart';
import 'package:gamie/screens/homeScreenNavs/learn.dart';
import 'package:provider/provider.dart';
import '../reuseable/drawer.dart';
import '../reuseable/bottomNav.dart';
import '../Providers/bottomNav_provider.dart';
import 'package:connectivity_widget/connectivity_widget.dart';


// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static String routeName = "home_screen";
  List<Widget> _navbody = [DashboardNav(), EnrolledNav(), HistoryNav(), LearningNav(),];
  Widget _buildHome(int index) => (_navbody[index]);

  @override
  Widget build(BuildContext context) {
  final net =  Provider.of<NetworkProvider>(context);
        return SafeArea(
            child:Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              APP_NAME,
              style: APP_BAR_TEXTSTYLE,
            ),
            leading: Builder(
                builder: (context) => IconButton(
                      icon: IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        padding: EdgeInsets.all(0),
                        iconSize: 45,
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    )),
            backgroundColor: APP_BAR_COLOR,
          ),
          drawer:CustomDrawer(),
          body: ConnectivityWidget(
            onlineCallback: ()=> net.setInternet = true,
            offlineCallback: ()=>net.setInternet = false,
            builder: (context, snapshot) {
            // print(snapshot);
                  return SafeArea(child: Consumer<BottomNavProvider>(
                        builder: (context, snapshot,widget) {
                          return _buildHome(snapshot.index);
                        }
                      )
                  );
            }
          ),
          bottomNavigationBar: BottomNav()
        ));
      }
}
