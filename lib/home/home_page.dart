import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_study_companion/notes/screens/notes_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // selected index
  int selectedIndex = 0;

  // Pages list
  final List<Widget> pages = const <Widget>[
    // later replace the text with whole screen for individual pages
    NotesScreen(),
    Text('Tasks'),
    Text('Library'),
    Text('Profile'),
  ];

  // Navigation handler
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,

        title: Text('Hello, Madhur', style: GoogleFonts.poppins()),
        actions: [
          // menu button
          IconButton(
            icon: FaIcon(FontAwesomeIcons.bars),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],

        // user icon
        leading: Icon(FontAwesomeIcons.user),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [Center(child: pages.elementAt(selectedIndex))],
          ),
        ),
      ),
      bottomNavigationBar: GNav(
        style: GnavStyle.google,
        onTabChange: (value) => onItemTapped(value),
        curve: Curves.easeInOut,
        selectedIndex: selectedIndex,
        activeColor: Colors.white,
        backgroundColor: Colors.black,
        tabMargin: EdgeInsetsGeometry.all(8),
        tabActiveBorder: Border.all(color: Colors.white, width: 2),
        tabs: [
          GButton(
            onPressed: () => onItemTapped(0),
            icon: FontAwesomeIcons.noteSticky,
            iconColor: Colors.grey,
            iconActiveColor: Colors.white,
          ),
          GButton(
            onPressed: () => onItemTapped(1),
            icon: FontAwesomeIcons.circleCheck,
            iconColor: Colors.grey,
            iconActiveColor: Colors.white,
          ),
          GButton(
            onPressed: () => onItemTapped(2),
            icon: FontAwesomeIcons.book,
            iconColor: Colors.grey,
            iconActiveColor: Colors.white,
          ),
          GButton(
            onPressed: () => onItemTapped(3),
            icon: FontAwesomeIcons.userAstronaut,
            iconColor: Colors.grey,
            iconActiveColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
