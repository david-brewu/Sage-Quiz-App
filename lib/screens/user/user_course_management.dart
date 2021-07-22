import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/models/schooModelData.dart';
import 'package:gamie/models/user_model.dart';
import 'package:gamie/reuseable/empty_items.dart';
import 'package:gamie/reuseable/network_error_widget.dart';
import 'package:gamie/reuseable/no_connectivity_widget.dart';
import 'package:gamie/screens/homeScreen.dart';
import 'package:gamie/services/cloud_firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:simple_connectivity/simple_connectivity.dart';

class UserCourses extends StatefulWidget {
  @override
  _UserCoursesState createState() => _UserCoursesState();
}

class _UserCoursesState extends State<UserCourses> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? personalCourseStream(user)
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget personalCourseStream(User user) {
  return StreamBuilder(
      stream: CloudFirestoreServices.personalCourses(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: NetworkErrorWidget(),
            ),
          );
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> data = snapshot.data.docs;
          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no courses available. Please check back later',
              ),
            );
          return AddRemoveCourse(UserDataModel.fromMap(data[0], 0), user,
              UserDataModel.fromMap(data[0], 0).courses);
        } else
          return Text('has not data');
      });
}

_AddRemoveCourseState _addRemoveCourseState;

class AddRemoveCourse extends StatefulWidget {
  final UserDataModel userData;
  final User user;
  final List courseList;
  AddRemoveCourse(this.userData, this.user, this.courseList);

  @override
  _AddRemoveCourseState createState() {
    _addRemoveCourseState = _AddRemoveCourseState();
    return _addRemoveCourseState;
  }
}

class _AddRemoveCourseState extends State<AddRemoveCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              iconSize: 28,
              onPressed: () {
                Navigator.of(context).pushNamed(CourseResgistration.routeName);
              },
              icon: Icon(Icons.add_box_outlined)),
        ],
        backgroundColor: APP_BAR_COLOR,
        title: Text(
          'My courses',
          style: APP_BAR_TEXTSTYLE,
        ),
      ),
      body: widget.userData.courses.isEmpty
          ? Center(
              child: Text('You have no courses. Click here to add a course'),
            )
          : ListView.builder(
              itemCount: widget.userData.courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: InkWell(
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text(
                                    'Remove Course',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  content: Text(
                                      "Do you want to remove ${widget.userData.courses[index]}?"),
                                  actions: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color.fromRGBO(
                                                      47, 154, 186, 1))),
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Map<String, dynamic> id = jsonDecode(
                                            prefs.getString(
                                                PREFS_PERSONAL_INFO));
                                        widget.courseList.remove(
                                            widget.userData.courses[index]);
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(id['userid'])
                                            .update(
                                                {'courses': widget.courseList});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Text('                           '),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromRGBO(
                                                          47, 154, 186, 1))),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No')),
                                    )
                                  ]);
                            });
                      },
                      child: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      )),
                  title: Text(
                    widget.userData.courses[index],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }),
    );
  }
}

/* class GoToRegistration extends StatelessWidget{
  @override 
  Widget build(BuildContext context){return MaterialApp(home: MultiProvider(providers: [ChangeNotifierProvider(
          create: (_) => NetworkProvider(this.widget.connection),
        ),],))}
} */

class CourseResgistration extends StatefulWidget {
  static final String routeName = 'CourseRegistration';
  @override
  _ResgistrationState createState() => _ResgistrationState();
}

class _ResgistrationState extends State<CourseResgistration> {
  bool status;
  ConnectivityResult con;
  bool isClicked = false;

  Future checkConnection() async {
    con = await Connectivity().checkConnectivity();
    if (con == ConnectivityResult.mobile || con == ConnectivityResult.wifi) {
      status = true;
    } else {
      status = false;
    }
  }

  @override
  void setState(VoidCallback fn) async {
    checkConnection();
    super.setState(fn);
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Widget build(BuildContext context) {
    // User user = FirebaseAuth.instance.currentUser;
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: networkProvider.connectionStatus
            ? schooCourseStream(user)
            : Center(child: NoConnectivityWidget()));
  }
}

Widget schooCourseStream(User user) {
  UserDataModel _userData;
  List myList;
  return StreamBuilder(
      stream: CloudFirestoreServices.schoolCourses(),
      //stream: FirebaseFirestore.instance.collection("competitions").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: NetworkErrorWidget(),
            ),
          );
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> data = snapshot.data.docs;
          myList = data;
          //print(data.length);
          //print(data.toString());

          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no courses available. Please check back later',
              ),
            );
          return Register(SchoolDataModel.fromMap(data[0], 0), user);
        } else
          return Text('has not data');
      });
}

class Register extends StatefulWidget {
  final SchoolDataModel schoolData;
  final User user;

  Register(this.schoolData, this.user);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    final List schoolCourselist = widget.schoolData.courses;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: APP_BAR_COLOR,
        centerTitle: true,
        title: Text(
          'Courses Offered',
          style: APP_BAR_TEXTSTYLE,
        ),
      ),
      body: widget.schoolData.courses.isEmpty
          ? Center(
              child: Text('There are no available courses for registration'),
            )
          : ListView.builder(
              itemCount: widget.schoolData.courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: _addRemoveCourseState.widget.courseList
                          .contains(widget.schoolData.courses[index])
                      ? null
                      : InkWell(
                          onTap: () {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(
                                        'Add Course',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      content: Text(
                                          "Do you want to add ${widget.schoolData.courses[index]}?"),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromRGBO(
                                                          47, 154, 186, 1))),
                                          child: Text('Yes'),
                                          onPressed: () {
                                            setState(() {
                                              isAdded = true;
                                            });
                                            Map<String, dynamic> id =
                                                jsonDecode(prefs.getString(
                                                    PREFS_PERSONAL_INFO));
                                            print(id['userid']);

                                            _addRemoveCourseState
                                                .widget.courseList
                                                .add(widget
                                                    .schoolData.courses[index]);
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(id['userid'])
                                                .update({
                                              'courses': _addRemoveCourseState
                                                  .widget.courseList
                                            });

                                            //Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            _UserCoursesState();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.black,
                                                    content: Text(
                                                        '${widget.schoolData.courses[index]} added')));
                                          },
                                        ),
                                        Text('                           '),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromRGBO(47,
                                                              154, 186, 1))),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('No')),
                                        )
                                      ]);
                                });
                          },
                          child: Icon(
                            Icons.add,
                            color: APP_BAR_COLOR,
                            size: 30,
                          )),
                  title: Text(
                    widget.schoolData.courses[index],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }),
    );
  }
}
