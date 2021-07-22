import 'package:flutter/material.dart';

import 'package:gamie/screens/homeScreenNavs/lecture_notes.dart';

class Books extends StatelessWidget {
  final String courseName;
  final String semester;
  Books(this.courseName, this.semester);
  @override
  Widget build(BuildContext context) {
    return LectureNotes(
      courseName: courseName,
      materialType: 'books',
      semester: semester,
      imagePath: 'assets/images/bookicon.png',
    );
  }
}
