import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_study_companion/notes/screens/detailed_notes.dart';
import 'package:smart_study_companion/notes/screens/notes_screen.dart';
import 'package:smart_study_companion/todo/screens/todo_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// TODO: Add GetX State Management instead of Stateful
class _HomePageState extends State<HomePage> {
  // selected index
  int selectedIndex = 0;

  // Pages list
  final List<Widget> pages = const <Widget>[
    // later replace the text with whole screen for individual pages
    NotesScreen(),
    TodoScreen(),
    Text('Book'),
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
        title: Text(
          'Hello, Madhur',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        actionsPadding: EdgeInsets.only(right: 18),
        actions: [
          // menu button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.bars),
              onPressed: () {},
            ),
          ),
        ],

        // user icon
        leading: Icon(FontAwesomeIcons.user),
      ),
      body: SafeArea(
        // load the pages based on selected index
        child: pages.elementAt(selectedIndex),
      ),
      // Floating Action Button - only show on Notes tab (index 0), otherwise show nothing
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.grey[600],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailedNotes()),
                );
              },
              tooltip: 'Add New Note',
              child: Icon(FontAwesomeIcons.plus, color: Colors.white),
            )
          : null, // Hide FAB on other tabs
      // given container because to round the corners of the bottom navigation bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 24, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.transparent,
        ),

        // ClipRRect is used to round the corners of the bottom navigation bar
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: GNav(
            style: GnavStyle.google,
            onTabChange: (value) => onItemTapped(value),
            curve: Curves.easeInOut,
            selectedIndex: selectedIndex,
            activeColor: Colors.white,
            backgroundColor: Colors.black,
            gap: 2,
            tabMargin: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 8),
            tabActiveBorder: Border.all(color: Colors.white, width: 2),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.noteSticky,
                iconColor: Colors.grey,
                text: 'Note',
                semanticLabel: 'Note',
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: FontAwesomeIcons.circleCheck,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
                text: 'ToDo',
              ),
              GButton(
                icon: FontAwesomeIcons.book,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
                text: 'Book',
              ),
              GButton(
                icon: FontAwesomeIcons.userAstronaut,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
                text: 'User',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
