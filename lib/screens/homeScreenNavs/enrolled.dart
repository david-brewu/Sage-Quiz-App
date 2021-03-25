import 'package:flutter/material.dart';
import 'package:gamie/screens/competition/enrolledCompetions.dart';

class EnrolledNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: EnrolledCompetitions(),
      ),
    );
  }
}