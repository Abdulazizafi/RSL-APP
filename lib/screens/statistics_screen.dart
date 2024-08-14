import 'package:flutter/material.dart';
import 'package:football_app/screens/Player_profile.dart';
import 'package:football_app/services/Player_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:football_app/constants.dart'; // Ensure kPrimaryColor is defined here

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool showAllGoalScorers = false;
  bool showAllAssistLeaders = false;
  bool showAllCleanSheetLeaders = false;
  bool showAllRedCards = false;
  bool showAllYellowCards = false;

  Widget statisticCard(Player statistic, String category) {
    String value = 'N/A'; // Default value if none found
    switch (category) {
      case 'Goals':
        value = statistic.goals.toString();
        break;
      case 'Assists':
        value = statistic.assists.toString();
        break;
      case 'Yellow Cards':
        value = statistic.yellowcards.toString();
        break;
      case 'Red Cards':
        value = statistic.redcards.toString();
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Player_profile_screen(player: statistic),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        color: kprimaryColor, // Use kPrimaryColor for card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(statistic.picture),
          ),
          title: Text(statistic.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text('$category: $value',
              style: const TextStyle(color: Colors.white)),
          trailing: CircleAvatar(
            backgroundColor: kprimaryColor, // Fallback color
            backgroundImage: CachedNetworkImageProvider(statistic.teampic),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Statistics'),
            Icon(Icons.bar_chart,
                color: kprimaryColor), // Icon next to the AppBar title
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategorySection('Goals', showAllGoalScorers,
                SoccerApi4().fetchtopscorers, Icons.sports_soccer_outlined),
            _buildCategorySection('Assists', showAllAssistLeaders,
                SoccerApi5().fetchtopassisters, Icons.handshake),
            _buildCategorySection('Yellow Cards', showAllYellowCards,
                SoccerApi6().fetchtopyellowcards, Icons.warning),
            _buildCategorySection('Red Cards', showAllRedCards,
                SoccerApi7().fetchtopredcards, Icons.remove_circle_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, bool showAll,
      Future<List<Player>> Function() fetchFunction, IconData icon) {
    return ExpansionTile(
      initiallyExpanded: showAll,
      title: Row(
        children: [
          Icon(icon, color: kprimaryColor), // Set icon color to kPrimaryColor
          const SizedBox(width: 10),
          Text(category,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor)), // Text color to kPrimaryColor
        ],
      ),
      children: [
        FutureBuilder<List<Player>>(
          future: fetchFunction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white)));
            } else if (snapshot.hasData) {
              var widgets = snapshot.data!
                  .take(showAll ? snapshot.data!.length : 3)
                  .map((player) => statisticCard(player, category))
                  .toList();
              if (snapshot.data!.length > 3) {
                widgets.add(
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() => toggleShowAll(category)),
                      child: Text(showAll ? 'Show Less' : 'See All',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                );
              }
              return Column(children: widgets);
            } else {
              return const Center(
                  child: Text('No data available',
                      style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ],
    );
  }

  void toggleShowAll(String category) {
    setState(() {
      switch (category) {
        case 'Goals':
          showAllGoalScorers = !showAllGoalScorers;
          break;
        case 'Assists':
          showAllAssistLeaders = !showAllAssistLeaders;
          break;
        case 'Yellow Cards':
          showAllYellowCards = !showAllYellowCards;
          break;
        case 'Red Cards':
          showAllRedCards = !showAllRedCards;
          break;
      }
    });
  }
}
