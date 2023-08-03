import 'package:flutter/material.dart';

class BottomNavbarApp extends StatelessWidget {
  const BottomNavbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BottomNavbar());
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  static List link = [
    '/',
    '/search',
  ];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _wigetOptions = <Widget>[
    Text(
      'Index 0: ホーム',
      style: optionStyle,
    ),
    Text(
      'Index 1: 検索',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
    // Navigator.pushNamed(context, '/search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _wigetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
