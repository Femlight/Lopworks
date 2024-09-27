import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mail_list/src/app/features/coming_soon.dart';
import 'mail_list_screen.dart';


class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MailListScreen(),
    ComingSoonScreen(title: 'Chat'),
    ComingSoonScreen(title: 'Calendar'),
    ComingSoonScreen(title: 'Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/mail.svg', height: 24),
            label: 'Mail',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/chat.svg', height: 24),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/calendar.svg', height: 24),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/settings.svg', height: 24),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,  // Ensure all items have labels
        selectedItemColor: Colors.blue,       // Highlight color for selected item
        unselectedItemColor: Colors.grey,     // Color for unselected items
      ),
    );
  }
}
