import 'package:flutter/material.dart';

import 'package:gamie/screens/homeScreenNavs/lecture_notes.dart';

class Questions extends StatelessWidget {
  final String courseName;
  final String semester;
  Questions(this.courseName, this.semester);
  @override
  Widget build(BuildContext context) {
    return LectureNotes(
      courseName: courseName,
      materialType: 'questions',
      semester: semester,
      imagePath: 'assets/images/sampleQuestions.png',
    );
  }
}
