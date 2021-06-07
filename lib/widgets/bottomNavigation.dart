import 'package:flutter/material.dart';
import 'package:theorderguy/screens/Favourite.dart';
import 'package:theorderguy/screens/Search.dart';
import 'package:theorderguy/screens/homepage.dart';

class bottomNavbar extends StatefulWidget {
  @override
  _bottomNavbarState createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar>
    with SingleTickerProviderStateMixin {
  double width = 100.0, height = 100.0;
  Offset position;
  int _currentIndex = 0;

  final tabs = [
    BuilderScreen1(),
    searchPage(),
    Favrouit(),
  ];

  @override
  void initState() {
    super.initState();
    position = Offset(0.0, height - 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 12,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.black, offset: Offset(1, 3))
        ]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          // backgroundColor: Colors.grey,
          iconSize: 20,
          selectedFontSize: 10,
          selectedItemColor: Colors.amber,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),

              title: Text('Restaurant'),
              //    backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              //    backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('Favourite'),
              //  backgroundColor: Colors.blue
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
