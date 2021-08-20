import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/homeScreenNavs/course_materials.dart';

class SemesterFolders extends StatelessWidget {
  final String courseName;
  SemesterFolders(this.courseName);
  final Container _container = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: APP_BAR_COLOR.withOpacity(0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
        child: Icon(Icons.folder, color: Colors.white),
      ));
  final TextStyle _style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 28,
            )),
        backgroundColor: APP_BAR_COLOR,
        title: Text(
          courseName,
          style: APP_BAR_TEXTSTYLE,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 150.0, 15.0, 15.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        CourseMaterials(courseName, ' (sem 1)', 'Semester 1')));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _container,
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Semester 1',
                    style: _style,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        CourseMaterials(courseName, ' (sem 2)', 'Semester 2')));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _container,
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Semester 2',
                    style: _style,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        CourseMaterials(courseName, ' (sem 3)', 'Semester 3')));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _container,
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Semester 3',
                    style: _style,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
