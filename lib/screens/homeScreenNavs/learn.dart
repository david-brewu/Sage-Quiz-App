import 'package:flutter/material.dart';
import 'package:gamie/screens/Knowledge/knowledge_flash_cards_screen.dart';

class LearningNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: KnowledgeFlashCards(),
      ),
    );
  }
}