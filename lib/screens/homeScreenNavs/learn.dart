import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/models/user_model.dart';
import 'package:gamie/screens/homeScreenNavs/semester_folders.dart';
import 'package:gamie/services/cloud_firestore_services.dart';
import '../../reuseable/no_connectivity_widget.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../../services/cloud_firestore_services.dart';
import '../../Providers/authUserProvider.dart';
import '../../Providers/network_provider.dart';

import '../../reuseable/empty_items.dart';
import '../../reuseable/network_error_widget.dart';
import 'lecture_notes.dart';

class LearningNav extends StatefulWidget {
  @override
  _LearningNavState createState() => _LearningNavState();
}

List<DocumentSnapshot> data;
var items = List<String>();

class _LearningNavState extends State<LearningNav> {
  final TextEditingController editingController = TextEditingController();

  int index;
  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
      body: networkProvider.connectionStatus
          ? coursesStream(user)
          : Center(child: NoConnectivityWidget()),
    ));
  }

  void filterSearchResults(
    String query,
  ) {
    List<String> dummySearchList = <String>[];

    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        // items.addAll(data);
      });
    }
  }
}

Widget coursesStream(User user) {
  var enrolledIds = <String>[];
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
          return BuildCourseList(
            UserDataModel.fromMap(data[0], 0),
          );
        } else
          return Text('has not data');
      });
}

class BuildCourseList extends StatelessWidget {
  final UserDataModel userData;
  BuildCourseList(this.userData);

  @override
  Widget build(BuildContext context) {
    return userData.courses.isEmpty
        ? Center(
            child: Text(
              'You have no course. Add a course from the course management in the drawer',
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: userData.courses.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset(
                  'assets/images/courses.jpg',
                  scale: 6,
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => SemesterFolders(
                            userData.courses[index],
                          )));
                },
                title: Text(
                  userData.courses[index],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              );
            });
  }
}

class CoursePage extends StatelessWidget {
  final CourseModel model;
  CoursePage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text(
            model.title,
            style: APP_BAR_TEXTSTYLE,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LectureNotes(
                            materialType: 'lecture_slides',
                            imagePath: 'assets/images/lecturenotes.jpg',
                          ),
                        ));
                  },
                  child: courseColumn(
                      'assets/images/lectureSlide.jpg', 'Lecture Notes')),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LectureNotes(
                            //       model: model,
                            materialType: 'lecture_videos',

                            imagePath: 'assets/images/videoicon.jpg',
                          ),
                        ));
                  },
                  child: courseColumn(
                      'assets/images/lectureVideo.png', 'Lecture Videos')),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LectureNotes(
                            materialType: 'course_books',
                            imagePath: 'assets/images/bookicon.png',
                          ),
                        ));
                  },
                  child: courseColumn(
                      'assets/images/courseBooks.jpg', 'Course Books')),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LectureNotes(
                          materialType: 'sample_questions',
                          imagePath: 'assets/images/questionsicon.png',
                        ),
                      ));
                },
                child: courseColumn(
                    'assets/images/sampleQuestions.png', 'Sample Questions'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget courseColumn(String path, name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 20,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 15,
        ),
        Image.asset(
          path,
          scale: 4,
          width: 120,
          height: 100,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
