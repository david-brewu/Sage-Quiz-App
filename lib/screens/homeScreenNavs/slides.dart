import 'package:flutter/material.dart';

import 'package:gamie/screens/homeScreenNavs/lecture_notes.dart';

class Slides extends StatelessWidget {
  final String courseName;
  final String semester;
  Slides(this.courseName, this.semester);
  @override
  Widget build(BuildContext context) {
    return LectureNotes(
      courseName: courseName,
      materialType: 'slides',
      semester: semester,
      imagePath: 'assets/images/lecturenotes.jpg',
    );
  }
}
