import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/customKnowledgeCards.dart';

class PastQuestions extends StatefulWidget {
  final String date;
  final String course;

  PastQuestions({Key key, this.date, this.course}) : super(key: key);

  @override
  _PastQuestionsState createState() => _PastQuestionsState();
}

class _PastQuestionsState extends State<PastQuestions> {
  PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  List<Map<String, dynamic>> questions = [
    {
      "question": "Who is the president of Ghana?",
      "answer": "Nana Akuffo Addo"
    },
    {"question": "Who is the vice president of Ghana? ", "answer": "Bawumia"},
    {
      "question": "What is the first element on the periodic table?",
      "answer": "Hydrogen"
    },
    {"question": "What is the SI unit for force?", "answer": "N"},
    {
      "question": "What is the name of the first man to walk on moon?",
      "answer": "Neil Armstrong"
    },
    {
      "question": "Who was the first Black president of America?",
      "answer": "Barack Obama"
    }
  ];

  String data =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged";

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          title: Text(
            widget.course,
            style: APP_BAR_TEXTSTYLE,
          ),
          backgroundColor: APP_BAR_COLOR,
          bottom: PreferredSize(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Container(
                    child: Text(
                  widget.date,
                  style: NORMAL_WHITE_BUTTON_LABEL,
                )),
              ),
              preferredSize: Size(deviceSize.width, 20)),
        ),
        body: Container(
            child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                controller: _pageController,
                itemCount: questions.length,
                itemBuilder: (context, index) => Container(
                      child: FlipCard(
                        back: CustomKnowledgeCards(
                          currentPageColor: APP_BAR_COLOR,
                          otherPagesColor: Colors.blueGrey.withOpacity(0.3),
                          currentPage: _currentPage,
                          i: index,
                          header: questions[index]["answer"],
                        ),
                        front: CustomKnowledgeCards(
                          currentPageColor: APP_BAR_COLOR,
                          otherPagesColor: Colors.blue.withOpacity(0.6),
                          currentPage: _currentPage,
                          i: index,
                          header: "",
                          info: questions[index]["question"],
                        ),
                      ),
                    ))));
  }
}
