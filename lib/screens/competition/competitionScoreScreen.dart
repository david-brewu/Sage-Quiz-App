import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import '../../models/competition_data_model.dart';
import './ScoreBoard.dart';

// ignore: must_be_immutable
class CompetitionScoreScreen extends StatelessWidget {
  final double score;
  final CompetitionDataModel dataModel;

  CompetitionScoreScreen(this.score, this.dataModel);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ScoreBoard(dataModel.id))),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(imagePath),
                  Column(
                    children: [
                      Text("Thanks for participating in...",
                          style: MEDIUM_DISABLED_TEXT),
                      Text(
                        "${this.dataModel.title}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${(score.toInt())}" +
                              '/' +
                              dataModel.documents.length.toString(),
                          style: TextStyle(
                              fontSize: 90, fontWeight: FontWeight.w100)),
                      Text("Your score", style: NORMAL_BLACK_BUTTON_TEXT),
                    ],
                  ),
                  CustomRoundedButton(
                    textSize: 20.0,
                    text: "Go to Rankings",
                    height: 70,
                    radius: 20.0,
                    color: LIGHT_BLUE_BUTTON_COLOR,
                    textColor: Colors.white,
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ScoreBoard(dataModel.id))),
                  ),
                  Text(
                    'Rankings may change',
                    style: MEDIUM_DISABLED_TEXT,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
