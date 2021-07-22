import 'package:flutter/material.dart';

import 'package:gamie/screens/homeScreenNavs/lecture_notes.dart';

class Videos extends StatelessWidget {
  final String courseName;
  final String semester;
  Videos(this.courseName, this.semester);
  @override
  Widget build(BuildContext context) {
    return LectureNotes(
      courseName: courseName,
      materialType: 'videos',
      semester: semester,
      imagePath: 'assets/images/videoicon.jpg',
    );
  }
}
