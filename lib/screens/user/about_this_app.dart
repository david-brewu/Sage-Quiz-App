import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';

// ignore: must_be_immutable
class AboutThisApp extends StatelessWidget {
  String _terms = '''
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur interdum leo a tempus feugiat. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec et interdum purus. In hac habitasse platea dictumst. Morbi tempus vulputate velit. Cras dignissim tristique ultricies. Nunc elementum erat erat, sed bibendum orci consequat in. Aliquam bibendum nulla ac magna vehicula, sit amet tristique ligula lacinia.

Duis non pulvinar libero, molestie a nibh. Etiam in semper ex. Mauris maximus quis turpis vitae pellentesque. Integer dapibus turpis sit amet nisi dictum imperdiet. Morbi pretium feugiat orci accumsan euismod. Nulla consequat enim eget libero ornare, ac laoreet neque suscipit. Morbi neque turpis, ultrices id vehicula eget, posuere scelerisque lectus.
  ''';

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR_COLOR,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "About $APP_NAME",
          style: APP_BAR_TEXTSTYLE,
        ),
        centerTitle: true,
      ),
      body: Theme(
              data: ThemeData(
                highlightColor: Colors.blue[300],
              ),
              child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
            children: <Widget>[Text(_terms,style: PARAGRAPH_TEXTSTYLE,),],
          ),
              )),
        ),
      ),
    );
  }
}
