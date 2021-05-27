import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/config/config.dart';
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

  //List<CourseModel> courseList = CourseModel.fromMap(data, index)
  int index;
  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
      body: networkProvider.connectionStatus
          ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(data[index].id);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Browse courses",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(child: competionStream(user))
            ])
          : Center(child: NoConnectivityWidget()),
    ));
  }

  void filterSearchResults(
    String query,
  ) {
    List<String> dummySearchList = <String>[];
    //dummySearchList.addAll(data.);
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

//User user;
Widget competionStream(User user) {
  // List<DocumentSnapshot> data;
  final TextEditingController editingController = TextEditingController();
  var enrolledIds = <String>[];
  return StreamBuilder(
      stream: CloudFirestoreServices.stremCourses(),
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
          data = snapshot.data.docs;
          print(data.length);
          print(data.toString());
          bool con = data.every((element) => enrolledIds.contains(element.id));
          if (con)
            return Center(
              child: EmptyWidget(
                msg: 'There are no courses available. Please check back later',
              ),
            );
          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no courses available. Please check back later',
              ),
            );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return BuildCourseList(CourseModel.fromMap(data[index], index));
              });
        } else
          return Text('has not data');
      });
}

class BuildCourseList extends StatelessWidget {
  final CourseModel dataModel;
  BuildCourseList(this.dataModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(dataModel.title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(dataModel.courseCode),
          leading: Image.asset(
            'assets/images/courses.jpg',
            scale: 6,
          ),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CoursePage(dataModel),
                ));
          },
        ),
      ],
    );
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
                            model: model,
                            materialType: 'lecture_slides',
                            title: 'Lecture Slides',
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
                            model: model,
                            materialType: 'lecture_videos',
                            title: 'Lecture Videos',
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
                            model: model,
                            materialType: 'course_books',
                            title: 'Course Books',
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
                          model: model,
                          materialType: 'sample_questions',
                          title: 'Sample Questions Questions',
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
