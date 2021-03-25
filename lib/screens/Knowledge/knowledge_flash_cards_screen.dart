import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/customKnowledgeCards.dart';
import 'package:provider/provider.dart';
import '../../reuseable/no_connectivity_widget.dart';
import '../../Providers/network_provider.dart';
import '../../reuseable/empty_items.dart';
import '../../reuseable/network_error_widget.dart';

class KnowledgeFlashCards extends StatefulWidget {
  @override
  _KnowledgeFlashCardsState createState() => _KnowledgeFlashCardsState();
}

class _KnowledgeFlashCardsState extends State<KnowledgeFlashCards> {
  int _currentPage = 0;

  int _nextPage = 1;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(
        body: 
        networkProvider.connectionStatus?StreamBuilder(
          stream: FirebaseFirestore.instance.collection('lessons').snapshots(),
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Center(child: NetworkErrorWidget());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Just a moment..."),
                  ],
                ),
              );
            }
            var items = snapshot.data.documents;
            var _itemCount = items.length;
            if (_itemCount == 0) return Center(child:EmptyWidget(msg: "No lessons found"),);
            return PageView.builder(
                controller: _pageController,
                // allowImplicitScrolling: true,
                itemCount: _itemCount,
                physics: ScrollPhysics(),
                onPageChanged: (page) {
                  if (page == _itemCount - 1) {
                    _nextPage = 0;
                    return;
                  }
                  _nextPage = page + 1;
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard(index, _itemCount, items[index].data());
                });
          },
        ): NoConnectivityWidget()
    );
  }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

  Widget _buildCard(int index, int itemCount, Map<dynamic, dynamic> data) {

    return InkWell(
      onTap: () {
        //prevent user from clicking the other cards
        if (_currentPage != index) {
          return;
        }
        setState(() {
          //set the current page to the first one when user reaches the last one
          index == itemCount - 1 ? _currentPage = 0 : _currentPage = index + 1;
          _pageController.animateToPage(_nextPage,
              curve: Interval(0.0, 1.0, curve: Curves.bounceOut),
              duration: Duration(milliseconds: 1500));
        });
      },
      child: CustomKnowledgeCards(
        i: index,
        currentPage: _currentPage,
        header: data["title"] != null ? data["title"] : "",
        info: data["text"] != null ? data["text"] : "",
        currentPageColor: APP_BAR_COLOR,
        otherPagesColor: APP_BAR_COLOR.withOpacity(0.6),
      ),
    );
  }
}

