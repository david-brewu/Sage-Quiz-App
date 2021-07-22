import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/bottomNav_provider.dart';
import 'package:gamie/Providers/course_bottomNav_provider.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/course_bottomNav.dart';
import 'package:gamie/reuseable/drawer.dart';
import 'package:gamie/screens/homeScreenNavs/lecture_notes.dart';
import 'package:gamie/screens/homeScreenNavs/questions.dart';
import 'package:gamie/screens/homeScreenNavs/slides.dart';
import 'package:gamie/screens/homeScreenNavs/books.dart';
import 'package:gamie/screens/homeScreenNavs/videos.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CourseMaterials extends StatelessWidget {
  final String courseName;
  final String sem;
  final String semester;

  CourseMaterials(this.courseName, this.sem, this.semester);
  // static String routeName = "home_screen";

  @override
  Widget build(BuildContext context) {
    List<Widget> _navbody = [
      Slides(courseName, semester),
      Videos(courseName, semester),
      Books(courseName, semester),
      Questions(courseName, semester)
    ];
    Widget _coursebuildHome(int index) => (_navbody[index]);
    final net = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 28,
            )),
        backgroundColor: APP_BAR_COLOR,
        centerTitle: true,
        title: Text(
          courseName + sem,
          style: APP_BAR_TEXTSTYLE,
        ),
      ),
      // drawer: CustomDrawer(),
      body: ConnectivityWidget(
          onlineCallback: () => net.setInternet = true,
          offlineCallback: () => net.setInternet = false,
          builder: (context, snapshot) {
            // print(snapshot);
            return SafeArea(child: Consumer<BottomNavProvider>(
                builder: (context, snapshot, widget) {
              return _coursebuildHome(snapshot.index);
            }));
          }),
      bottomNavigationBar: CourseBottomNav(),
    );
  }
}
