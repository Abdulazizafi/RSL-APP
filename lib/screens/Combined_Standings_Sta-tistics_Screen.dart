import 'package:flutter/material.dart';
import 'package:football_app/screens/statistics_screen.dart';
//import 'package:football_app/screens/standing_screen.dart';
import 'package:football_app/screens/table_leags.dart';
// Assume this is your standings screen
import 'package:football_app/constants.dart';

class CombinedStandingsStatisticsScreen extends StatefulWidget {
  const CombinedStandingsStatisticsScreen({Key? key}) : super(key: key);

  @override
  _CombinedStandingsStatisticsScreenState createState() =>
      _CombinedStandingsStatisticsScreenState();
}

class _CombinedStandingsStatisticsScreenState
    extends State<CombinedStandingsStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimaryColor, // Set AppBar background color
        leading: Image.asset(
            'assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png'), // Add your icon
        title: const Text(
          'Standings & Statistics',
          style:
              TextStyle(color: Colors.white), // Set title text color to white
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // Set selected tab label color to white
          unselectedLabelColor: Colors
              .white, // Optional: Set unselected tab label color to slightly transparent white
          tabs: const [
            Tab(
              text: 'Standings',
            ),
            Tab(text: 'Statistics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SoccerApp(), // Your standings content
          StatisticsScreen() // Your statistics content
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
