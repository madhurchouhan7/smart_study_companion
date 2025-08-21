import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_study_companion/notes/screens/detailed_notes.dart';
import 'package:smart_study_companion/notes/screens/notes_screen.dart';

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
        child: pages.elementAt(selectedIndex),
      ),
      // Floating Action Button - only show on Notes tab (index 0)
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailedNotes()),
                );
              },
              tooltip: 'Add New Note',
              child: Icon(FontAwesomeIcons.plus),
            )
          : null, // Hide FAB on other tabs
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GNav(
            style: GnavStyle.google,
            onTabChange: (value) => onItemTapped(value),
            curve: Curves.easeInOut,
            selectedIndex: selectedIndex,
            activeColor: Colors.white,
            backgroundColor: Colors.black,
            tabMargin: EdgeInsetsGeometry.all(5),
            tabActiveBorder: Border.all(color: Colors.white, width: 2),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.noteSticky,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: FontAwesomeIcons.circleCheck,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: FontAwesomeIcons.book,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: FontAwesomeIcons.userAstronaut,
                iconColor: Colors.grey,
                iconActiveColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
