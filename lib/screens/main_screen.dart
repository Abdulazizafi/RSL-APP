import 'package:flutter/material.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/screens/Combined_Standings_Sta-tistics_Screen.dart';
import 'package:football_app/screens/home_screen.dart';
import 'package:football_app/screens/news_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:football_app/screens/favorite_teams.dart';
import 'package:football_app/screens/profile_screen.dart';

const IconData article = IconData(0xe0a2, fontFamily: 'MaterialIcons');

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  List screens = [
    HomeScreen(),
    FavoriteTeamsPage(),
    const CombinedStandingsStatisticsScreen(),
    NewsPage(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: kbackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.grey.shade200),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavItem(
              title: "Home",
              icon: Iconsax.home,
              isActive: currentTab == 0,
              onTap: () {
                setState(() {
                  currentTab = 0;
                });
              },
            ),
            BottomNavItem(
              title: "Favorite",
              icon: Iconsax.star,
              isActive: currentTab == 1,
              onTap: () {
                setState(() {
                  currentTab = 1;
                });
              },
            ),
            BottomNavItem(
              title: "Standing",
              icon: Iconsax.cup,
              isActive: currentTab == 2,
              onTap: () {
                setState(() {
                  currentTab = 2;
                });
              },
              activeColor: currentTab == 2
                  ? Colors.amber[700]
                  : null, // Use gold color when the "Standing" tab is active
            ),
            BottomNavItem(
              title: "News",
              icon: article,
              isActive: currentTab == 3,
              onTap: () {
                setState(() {
                  currentTab = 3;
                });
              },
            ),
            BottomNavItem(
              title: "Settings",
              icon: Iconsax.setting_2,
              isActive: currentTab == 4,
              onTap: () {
                setState(() {
                  currentTab = 4;
                });
              },
            ),
          ],
        ),
      ),
      body: screens[currentTab],
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function() onTap;
  final IconData icon;
  final Color? activeColor; // Optional color parameter for active state

  const BottomNavItem({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
    required this.icon,
    this.activeColor, // Initialize the optional active color parameter
  });

  @override
  Widget build(BuildContext context) {
    // Determine the icon color based on the active state and the provided active color
    Color iconColor = isActive
        ? (activeColor ??
            Colors
                .white) // Use provided activeColor if available, otherwise default to white
        : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? kprimaryColor : kbackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            isActive
                ? Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
