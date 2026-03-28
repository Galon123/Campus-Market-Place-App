import 'package:e_commerce_refactor/screens/bidScreen.dart';
import 'package:e_commerce_refactor/screens/feedScreen.dart';
import 'package:e_commerce_refactor/screens/listingScreen.dart';
import 'package:e_commerce_refactor/screens/profileScreen.dart';
import 'package:flutter/material.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {

  int _currentIndex = 0;

  void _navigateTo(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  late final List<Widget> _pages =[
    FeedScreen(),
    MyBids(),
    MyListings(),
    ProfileScreen(onNavigate : _navigateTo)
  ];

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: NavigationBar(
              height: 65,
              elevation: 4,
              shadowColor: Colors.black,
              backgroundColor: colors.secondary,
              indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10.0)),
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined), 
                  selectedIcon: Icon(Icons.home_filled, color: colors.primary),
                  label: "Feed"
                ),
                NavigationDestination(
                  icon: Icon(Icons.gavel_outlined), 
                  selectedIcon: Icon(Icons.gavel, color: colors.primary),
                  label: "My Bids"
                ),
                NavigationDestination(
                  icon: Icon(Icons.book_outlined), 
                  selectedIcon: Icon(Icons.book, color: colors.primary),
                  label: "My Listings"
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_outlined), 
                  selectedIcon: Icon(Icons.person_2, color: colors.primary),
                  label: "Profile"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}