import 'package:flutter/material.dart';
import 'package:gamie/screens/competition/competitionHistory.dart';

class HistoryNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CompetitionHistory(),
      ),
    );
  }
}