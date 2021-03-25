import 'package:flutter/material.dart';
import 'package:gamie/screens/competition/competitions.dart';

class DashboardNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SafeArea(child: Competitions()),
      ),
    );
  }
}