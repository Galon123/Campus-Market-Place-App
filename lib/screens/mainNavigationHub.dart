import 'package:e_commerce_refactor/providers/NotificationProvider.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/screens/bidScreen.dart';
import 'package:e_commerce_refactor/screens/createListing.dart';
import 'package:e_commerce_refactor/screens/feedScreen.dart';
import 'package:e_commerce_refactor/screens/listingScreen.dart';
import 'package:e_commerce_refactor/screens/notificationScreen.dart';
import 'package:e_commerce_refactor/screens/profileScreen.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {

  int _currentIndex = 0;


  late final List<Widget> _pages =[
    FeedScreen(),
    CreateListing(),
    NotificationScreen(),
    ProfileScreen()
  ];

  @override
  void initState(){
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {

      final notify = Provider.of<NotificationProvider>(context, listen: false);

      notify.initSSEConnection();

    });
  }

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
                  icon: Icon(Icons.add_outlined), 
                  selectedIcon: Icon(Icons.add, color: colors.primary),
                  label: "Create"
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications), 
                  selectedIcon: Icon(Icons.notifications_active, color: colors.primary),
                  label: "Notifications"
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