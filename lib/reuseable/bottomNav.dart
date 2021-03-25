import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../Providers/bottomNav_provider.dart';
import '../config/config.dart';

class BottomNav extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavProvider>(context);
    return BottomNavigationBar(
          onTap:(i)=>provider.index = i,
          currentIndex: provider.index,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: provider.index == 0
                  ? _activeNav(
                      Octicons.home,
                    )
                  : Icon(Octicons.home),
    // ignore: deprecated_member_use
    title: Text("Competitions"),
            ),
            BottomNavigationBarItem(

                icon: provider.index == 1
                    ? _activeNav(
                    Icons.event_available
                      )
                    : Icon(Icons.event_available),
                    //ignore: deprecated_member_use
              title: Text("Enrolled"),),
            BottomNavigationBarItem(
                icon: provider.index == 2
                    ? _activeNav(Icons.history)
                    : Icon(Icons.history),
              // ignore: deprecated_member_use
              title: Text("History"),),
            BottomNavigationBarItem(
                icon: provider.index == 3
                    ? _activeNav(Octicons.book)
                    : Icon(Octicons.book),
                // ignore: deprecated_member_use
                title: Text("Learn"),)
          ])
    ;
  }

}

Widget _activeNav(IconData data) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: APP_BAR_COLOR.withOpacity(0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
        child: Icon(data, color: Colors.white),
      ));
