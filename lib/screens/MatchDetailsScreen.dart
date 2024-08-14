import 'package:flutter/material.dart';
import 'package:football_app/api/api_manager.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:football_app/widgets/matchstatistics.dart';
import 'package:football_app/widgets/lineup.dart';
import 'package:football_app/widgets/head_to_head.dart';
import 'package:football_app/widgets/matchInfo.dart';
import 'package:football_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:football_app/widgets/Event.dart';
import 'package:iconsax/iconsax.dart';
import 'package:football_app/widgets/voteData.dart';
import 'package:football_app/screens/Team_details.dart';
import 'package:football_app/screens/profile_screen.dart';
import 'package:football_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:football_app/widgets/stats_chart.dart';
import 'package:football_app/services/prediction_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:football_app/screens/player_profile.dart';
import 'package:football_app/services/Player_services.dart';

class MatchDetailsScreen extends StatefulWidget {
  final int fixtureId;
  final bool isUserSignedIn;
  const MatchDetailsScreen({
    Key? key,
    required this.fixtureId,
    this.isUserSignedIn = false, // Default to false
  }) : super(key: key);

  @override
  _MatchDetailsScreenState createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  late Future<MatchInfo> matchInfoFuture;
  String currentLineupView = 'home';

  late Future<SoccerMatch> matchDetailsFuture;
  late Future<List<Event>> eventsFuture;
  Future<MatchStatistics>? matchStatsFuture;
  late Future<List<PlayerRating>> playerRatingsFuture;
  late Future<Prediction> predictionsFuture;
  late Future<HeadToHead> headToHeadFuture;
  late Future<List<Lineup>> lineupFuture;
  bool additionalDataFetched = false;
  String currentSection = 'info';
  String currentStatsView = 'team';

  @override
  void initState() {
    super.initState();
    matchDetailsFuture =
        SoccerApi.getMatchDetails(widget.fixtureId).then((matchDetails) {
      fetchAdditionalData(matchDetails);
      return matchDetails;
    });
    matchInfoFuture = SoccerApi.getMatchInfo(widget.fixtureId);
    eventsFuture = SoccerApi.getFixtureEvents(
        widget.fixtureId); // Implement this method in your API class.
  }

  void fetchAdditionalData(SoccerMatch matchDetails) {
    if (!additionalDataFetched) {
      matchStatsFuture = SoccerApi.getMatchStatistics(widget.fixtureId);
      headToHeadFuture =
          SoccerApi.getHeadToHead(matchDetails.home.id, matchDetails.away.id);
      lineupFuture = SoccerApi.getMatchLineup(widget.fixtureId);
      playerRatingsFuture =
          SoccerApi.getPlayersRatings(widget.fixtureId); // Added line
      additionalDataFetched = true;
      predictionsFuture = SoccerApi.getFixturePrediction(widget.fixtureId);
    }
  }

  Widget _buildMatchHeader(SoccerMatch match) {
    bool matchNotStarted = match.fixture.status.short == 'NS' ||
        match.fixture.status.short == 'TBD';
    String elapsedTime = match.fixture.status.elapsedTime.toString();
    String displayText;
    if (matchNotStarted) {
      DateTime ksaDateTime =
          DateTime.parse(match.fixture.date).add(const Duration(hours: 3));
      String matchStartTime = DateFormat('HH:mm').format(ksaDateTime);
      displayText = 'Kickoff at $matchStartTime';
    } else {
      String homeGoals = match.goal.home.toString();
      String awayGoals = match.goal.away.toString();

      displayText = '$homeGoals - $awayGoals';

      // Add elapsed time next to the access_time icon if the match is live
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 300,
      width: 400,
      decoration: BoxDecoration(
        color: kboxColor,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage(
              "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png"),
          opacity: 0.99,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _navigateToTeamDetails(context, match.home),
                    child: Image.network(
                      match.home.logoUrl,
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 60);
                      },
                    ),
                  ),
                  Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToTeamDetails(context, match.away),
                    child: Image.network(
                      match.away.logoUrl,
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 60);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (match.fixture.status.short == '1H' ||
              match.fixture.status.short == 'HT' ||
              match.fixture.status.short == '2H')
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$elapsedTime\'',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToTeamDetails(BuildContext context, Team team) async {
    try {
      // Fetch team details from API
      TeamInfo teamInfo = await SoccerApi().fetchTeamDetailsById(team.id);
      // Navigate to the team details page with the fetched teamInfo
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetailPage(teamInfo: teamInfo),
          ));
    } catch (e) {
      // You can optionally handle errors differently or log them
      print('Error fetching team details: $e');
    }
  }

  Widget _buildStatsViewToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentStatsView = 'team';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: currentStatsView == 'team'
                ? kboxColor
                : ksecondryBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const Text('Match Statistics',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              )),
        ),
        const SizedBox(width: 10), // Spacing between buttons
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentStatsView = 'player';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: currentStatsView == 'player'
                ? kboxColor
                : ksecondryBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const Text('Player Ratings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget buildStatsChartForStrings(
      String title, String? homeStat, String? awayStat) {
    bool isHomeWinner =
        false; // This might be determined by comparing percentages if applicable
    return StatsChart(
      homeStats: homeStat ?? 'N/A',
      awayStats: awayStat ?? 'N/A',
      statsTitle: title,
      homeStatsCount:
          0, // Since it's a string, setting visual indicators might need a different logic
      awayStatsCount: 0,
      isHomeWinner: isHomeWinner,
      color: Colors.blueGrey, // Use a neutral color for string-based stats
    );
  }

  double calculateBarLength(int? stat, int maxStat) {
    // Return 0 if stat is null, maxStat is 0, or stat is 0 to avoid incorrect proportions.
    if (stat == null || maxStat == 0) return 0.0;

    // Calculate the bar length as a percentage of the maximum statistic.
    return (stat / maxStat) * 100.0;
  }

  Widget buildStatsChart(String title, int? homeStat, int? awayStat) {
    // Find the maximum stat to use as a base for proportion calculations.
    int maxStat = max(homeStat ?? 0, awayStat ?? 0);

    // Calculate the proportional bar lengths.
    double homeBarLength = calculateBarLength(homeStat, maxStat);
    double awayBarLength = calculateBarLength(awayStat, maxStat);

    // Determine which team has the higher stat.
    bool isHomeWinner = (homeStat ?? 0) > (awayStat ?? 0);
    Color barColor = isHomeWinner ? Colors.green : Colors.red;

    return StatsChart(
      homeStats: homeStat?.toString() ?? 'N/A',
      awayStats: awayStat?.toString() ?? 'N/A',
      statsTitle: title,
      homeStatsCount: awayBarLength,
      awayStatsCount: homeBarLength,
      isHomeWinner: isHomeWinner,
      color: barColor,
    );
  }

  Widget _buildStatisticsContent(MatchStatistics matchStats) {
    switch (currentStatsView) {
      case 'team':
        return _buildStatisticsWidget(matchStats);
      case 'player':
        return Container(
          height: 300, // Set a fixed height
          child: FutureBuilder<List<PlayerRating>>(
            future: playerRatingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Sort players by rating in descending order, pushing N/A to the bottom
                var players = snapshot.data!;
                players.sort((a, b) {
                  var aRating = a.rating;
                  var bRating = b.rating;
                  if ((aRating == 'N/A') && (bRating != 'N/A')) {
                    return 1; // a goes after b
                  } else if ((bRating == 'N/A') && (aRating != 'N/A')) {
                    return -1; // a goes before b
                  } else {
                    // Fallback to comparing by numerical value if both ratings are valid
                    double aRatingNum =
                        double.tryParse(aRating) ?? double.infinity;
                    double bRatingNum =
                        double.tryParse(bRating) ?? double.infinity;
                    return bRatingNum.compareTo(aRatingNum);
                  }
                });
                return ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    PlayerRating player = players[index];

                    return _buildPlayerRatingBox(
                      player,
                    );
                  },
                );
              } else {
                return const Text('No player ratings available');
              }
            },
          ),
        );
      default:
        return const SizedBox.shrink(); // Handles undefined views gracefully
    }
  }

  Widget _buildStatisticsWidget(MatchStatistics matchStats) {
    return Container(
      padding: const EdgeInsets.all(19.0),
      decoration: BoxDecoration(
        color: Colors.white, // Choose a suitable color for the background.
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow direction: bottom right.
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          buildStatsChart("Shots on Goal", matchStats.homeTeam.shotsOnGoal,
              matchStats.awayTeam.shotsOnGoal),
          buildStatsChart("Shots off Goal", matchStats.homeTeam.shotsOffGoal,
              matchStats.awayTeam.shotsOffGoal),
          buildStatsChart("Total Shots", matchStats.homeTeam.totalShots,
              matchStats.awayTeam.totalShots),
          buildStatsChart("Blocked Shots", matchStats.homeTeam.blockedShots,
              matchStats.awayTeam.blockedShots),
          buildStatsChart(
              "Shots inside Box",
              matchStats.homeTeam.shotsInsideBox,
              matchStats.awayTeam.shotsInsideBox),
          buildStatsChart(
              "Shots outside Box",
              matchStats.homeTeam.shotsOutsideBox,
              matchStats.awayTeam.shotsOutsideBox),
          buildStatsChart(
              "Fouls", matchStats.homeTeam.fouls, matchStats.awayTeam.fouls),
          buildStatsChart("Corner Kicks", matchStats.homeTeam.cornerKicks,
              matchStats.awayTeam.cornerKicks),
          buildStatsChart("Offsides", matchStats.homeTeam.offsides,
              matchStats.awayTeam.offsides),
          buildStatsChartForStrings(
              "Ball Possession",
              matchStats.homeTeam.ballPossession,
              matchStats.awayTeam.ballPossession),
          buildStatsChart("Yellow Cards", matchStats.homeTeam.yellowCards,
              matchStats.awayTeam.yellowCards),
          buildStatsChart("Red Cards", matchStats.homeTeam.redCards,
              matchStats.awayTeam.redCards),
          buildStatsChart(
              "Goalkeeper Saves",
              matchStats.homeTeam.goalkeeperSaves,
              matchStats.awayTeam.goalkeeperSaves),
          buildStatsChart("Total Passes", matchStats.homeTeam.totalPasses,
              matchStats.awayTeam.totalPasses),
          buildStatsChart("Passes Accurate", matchStats.homeTeam.passesAccurate,
              matchStats.awayTeam.passesAccurate),
          buildStatsChartForStrings(
              "Passes %",
              matchStats.homeTeam.passesPercentage,
              matchStats.awayTeam.passesPercentage),
        ],
      ),
    );
  }

  Widget _buildPlayerRatingBox(PlayerRating player) {
    // Determine the color based on the rating
    Color ratingColor =
        Colors.white70; // Default color for unknown or non-numeric ratings
    double? rating = double.tryParse(player.rating);
    if (rating != null) {
      if (rating >= 7) {
        ratingColor = Colors.green;
      } else if (rating >= 5 && rating < 7) {
        ratingColor = Colors.orange;
      } else if (rating < 5) {
        ratingColor = Colors.red;
      }
    }

    return InkWell(
      onTap: () async {
        try {
          // Assuming SoccerApi22 has a method to fetch player details
          SoccerApi22 api = SoccerApi22();
          Player playerDetails = await api.fetchPlayerDetails(
              playerid: player.playerId,
              season:
                  2023 // Assuming you are fetching details for the current season
              );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Player_profile_screen(player: playerDetails),
            ),
          );
        } catch (e) {
          print("Failed to load player details: $e");
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kprimaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kprimaryColor,
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(player.photo), // Player's photo
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(
                    player.position, // Player's position
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Shirt No: ${player.jerseyNumber.toString()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Rating: ${player.rating}',
                  style: TextStyle(
                      color:
                          ratingColor), // Apply dynamic color based on rating
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineupViewToggleButtons(
      String homeTeamName, String awayTeamName) {
    Color selectedColor = kboxColor; // Use color from your constants
    Color unselectedColor =
        ksecondryBackgroundColor; // Use color from your constants

    const TextStyle buttonTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentLineupView = 'home';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentLineupView == 'home' ? selectedColor : unselectedColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(homeTeamName, style: buttonTextStyle),
        ),
        const SizedBox(width: 10), // Spacing between buttons
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentLineupView = 'away';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentLineupView == 'away' ? selectedColor : unselectedColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(awayTeamName, style: buttonTextStyle),
        ),
      ],
    );
  }

  Widget _buildSectionButtons(SoccerMatch match) {
    // Determine if the match has not started or is scheduled (status: 'NS' or 'TBD')
    bool matchNotStarted = match.fixture.status.short == 'NS' ||
        match.fixture.status.short == 'TBD';

    // Check if score is null, indicating the match has not been played yet
    bool isScoreNull = match.goal.home == null && match.goal.away == null;

    List<Widget> buttons = [
      _sectionButton('info', 'Info'),
      if (!matchNotStarted) _sectionButton('events', 'Events'),
      if (!matchNotStarted) _sectionButton('stats', 'Match Statistics'),
      _sectionButton('h2h', 'Head to Head'),
      if (!matchNotStarted) _sectionButton('lineup', 'Lineup'),
      if (matchNotStarted || isScoreNull) // Add this line
        _sectionButton('predictions', 'Predictions'),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: buttons,
        ),
      ),
    );
  }

  Widget _sectionButton(String section, String title) {
    bool isSelected = currentSection == section;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? kboxColor : ksecondryBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            currentSection = section;
          });
        },
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent(SoccerMatch match) {
    switch (currentSection) {
      case 'info':
        return FutureBuilder<MatchInfo>(
          future: matchInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return _buildMatchInfoBox(snapshot.data!);
            } else {
              return const Text('No match information available');
            }
          },
        );
      case 'predictions':
        return FutureBuilder<Prediction>(
          future: predictionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading predictions: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Ensure you pass the 'match' object along with the 'snapshot.data!'
              return _buildPredictionDetails(snapshot.data!, match);
            } else {
              return const Text('No predictions available');
            }
          },
        );

      case 'events':
        return SizedBox(
          height: 500, // Define an appropriate height based on your UI needs
          child: _eventsSection(match),
        );

      case 'stats':
        return FutureBuilder<MatchStatistics>(
          future: matchStatsFuture,
          builder: (context, statsSnapshot) {
            if (statsSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (statsSnapshot.hasError) {
              return Text('Error: ${statsSnapshot.error}');
            } else if (statsSnapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize
                    .min, // Use the smallest space possible for the Column
                children: [
                  _buildStatsViewToggleButtons(), // Toggle buttons
                  // Instead of Expanded, just let the content take the space it needs
                  _buildStatisticsContent(statsSnapshot.data!), // Stats content
                ],
              );
            } else {
              return const Text('No statistics available');
            }
          },
        );

      case 'h2h':
        return FutureBuilder<HeadToHead>(
          future: headToHeadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return _buildHeadToHeadWidget(snapshot.data!);
            } else {
              return const Text('No Head-to-Head Data Available');
            }
          },
        );
      case 'lineup':
        return FutureBuilder<List<Lineup>>(
          future: lineupFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              Lineup homeLineup = snapshot.data![0];
              Lineup awayLineup = snapshot.data![1];
              return Column(
                children: [
                  _buildLineupViewToggleButtons(
                      homeLineup.teamName, awayLineup.teamName),
                  currentLineupView == 'home'
                      ? _buildTeamLineupBox(homeLineup)
                      : _buildTeamLineupBox(awayLineup),
                ],
              );
            } else {
              return const Text('No Lineup Available');
            }
          },
        );
      default:
        return const SizedBox.shrink(); // Handles undefined sections gracefully
    }
  }

  Widget _eventsSection(SoccerMatch match) {
    return FutureBuilder<List<Event>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var homeTeamId = match.home.id;
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey[300]),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Event event = snapshot.data![index];
              bool isHomeEvent = event.team.id == homeTeamId;

              // Assist details if available
              String assistInfo =
                  event.assist != null && event.assist!.name.isNotEmpty
                      ? 'Assist by ${event.assist!.name}'
                      : '';

              // Substitution details if available
              String substitutionInfo =
                  event.type == "subst" && event.assist != null
                      ? 'In: ${event.player.name}, Out: ${event.assist!.name}'
                      : '';

              // Construct the title string
              String title =
                  event.type == "Goal" && event.detail == "Normal Goal"
                      ? "Goal"
                      : event.detail;
              if (event.type == "subst") {
                title = substitutionInfo;
              }

              // Construct the subtitle string
              String subtitle = '${event.time.elapsed}\' ${event.player.name}';
              if (event.type == "Goal" && assistInfo.isNotEmpty) {
                subtitle += ', $assistInfo';
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isHomeEvent)
                      Expanded(
                        child: ListTile(
                          leading: Image.network(event.team.logo,
                              width: 24, height: 24),
                          title: Text(title),
                          subtitle: Text(subtitle),
                        ),
                      ),
                    if (!isHomeEvent)
                      Expanded(
                        child: ListTile(
                          trailing: Image.network(event.team.logo,
                              width: 24, height: 24),
                          title: Text(title, textAlign: TextAlign.right),
                          subtitle: Text(subtitle, textAlign: TextAlign.right),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Text('No events available');
        }
      },
    );
  }

  Widget _buildPredictionDetails(Prediction prediction, SoccerMatch match) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kboxColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ListTile(
            leading:
                Icon(Iconsax.percentage_circle, color: Colors.white, size: 24),
            title: Text('Match Odds',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            tileColor: kboxColor,
          ),
          const Divider(color: Colors.white54),
          ListTile(
            title: Text('Match Winner: ${prediction.winnerName ?? "Unknown"}',
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Win or Draw: ${prediction.winOrDraw ? "Yes" : "No"}',
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Over/Under Goals: ${prediction.underOver ?? "N/A"}',
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Goals Home Team: ${prediction.goalsHome ?? "N/A"}',
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Goals Away Team: ${prediction.goalsAway ?? "N/A"}',
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: const Text('Winning Percentages:',
                style: TextStyle(color: Colors.white)),
            subtitle: Text(
                'Home: ${prediction.percentages['home'] ?? "N/A"}%, '
                'Draw: ${prediction.percentages['draw'] ?? "N/A"}%, '
                'Away: ${prediction.percentages['away'] ?? "N/A"}%',
                style: const TextStyle(color: Colors.white70)),
          ),
          _buildVoteButtons(match),
        ],
      ),
    );
  }

  Widget _buildVoteButtons(SoccerMatch match) {
    String matchId = match.fixture.id.toString();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _voteButton('Home Win', match.home.name, matchId),
          const SizedBox(width: 10),
          _voteButton('Draw', 'Draw', matchId),
          const SizedBox(width: 10),
          _voteButton('Away Win', match.away.name, matchId),
        ],
      ),
    );
  }

  Widget _voteButton(String label, String team, String matchId) {
    PredictionService predictionService = PredictionService();

    return FutureBuilder<User?>(
      future: AuthService().getCurrentUser(),
      builder: (context, userSnapshot) {
        bool isLoggedIn = userSnapshot.hasData;
        String userId = userSnapshot.data?.uid ?? '';

        Stream<VoteData> combinedStream = isLoggedIn
            ? Rx.combineLatest2(
                predictionService.getVotesStream(matchId, team),
                predictionService.getCurrentVoteStream(matchId, userId),
                (int votes, String? userVote) =>
                    VoteData(votes, userVote == team),
              )
            : predictionService.getVotesStream(matchId, team).map((votes) =>
                VoteData(votes, false)); // User is not logged in, no vote

        return StreamBuilder<VoteData>(
          stream: combinedStream,
          builder: (context, snapshot) {
            int currentVotes = snapshot.data?.votes ?? 0;
            bool isVoted = snapshot.data?.isVoted ?? false;

            return ElevatedButton(
              onPressed: () {
                if (isLoggedIn) {
                  predictionService.togglePrediction(matchId, team, userId);
                } else {
                  _promptSignIn();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isVoted ? Colors.green : Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('${label} ($currentVotes)',
                  style: const TextStyle(color: Colors.white)),
            );
          },
        );
      },
    );
  }

  void _promptSignIn() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authentication Required'),
          content: const Text(
              'You must sign in to cast a vote. Would you like to sign in now?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sign In'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProfileScreen())); // Navigate to the sign-in page
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () =>
                  Navigator.of(context).pop(), // Just close the dialog
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeadToHeadWidget(HeadToHead headToHead) {
    headToHead.pastMatches.sort((a, b) => b.date.compareTo(a.date));
    TextStyle titleStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    const TextStyle dateStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );

    const TextStyle scoreStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    );

    double teamNameWidth =
        MediaQuery.of(context).size.width * 0.25; // 25% of screen width

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: headToHead.pastMatches.length,
      itemBuilder: (context, index) {
        var h2hMatch = headToHead.pastMatches[index];
        var formattedDate = DateFormat('EEE, MMM d, yyyy')
            .format(DateTime.parse(h2hMatch.date));
        var score =
            '${h2hMatch.score.home ?? '-'} - ${h2hMatch.score.away ?? '-'}';
        return GestureDetector(
            onTap: () {
              // Pushing the MatchDetailsScreen onto the Navigation stack with the fixtureId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MatchDetailsScreen(fixtureId: h2hMatch.fixtureId),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: const AssetImage(
                        "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      kboxColor.withOpacity(0.98), // Adjust opacity
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(formattedDate, style: dateStyle),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Home team column with fixed width
                          Container(
                            width: teamNameWidth,
                            child: Column(
                              children: [
                                Image.network(h2hMatch.teamHome.logo,
                                    width: 40, height: 40),
                                const SizedBox(height: 8),
                                Text(h2hMatch.teamHome.name,
                                    style: titleStyle,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          // Score column
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0), // Ensure some space around the score
                            child: Text(score, style: scoreStyle),
                          ),
                          // Away team column with fixed width
                          Container(
                            width: teamNameWidth,
                            child: Column(
                              children: [
                                Image.network(h2hMatch.teamAway.logo,
                                    width: 40, height: 40),
                                const SizedBox(height: 8),
                                Text(h2hMatch.teamAway.name,
                                    style: titleStyle,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  String getPositionIndicator(String? position) {
    switch (position) {
      case 'G':
        return 'G';
      case 'D':
        return 'D';
      case 'M':
        return 'M';
      case 'F':
        return 'F';
      default:
        return '';
    }
  }

  // Inside the MatchDetailsScreen class

  Widget _buildPlayerRow(Players player) {
    return ListTile(
      onTap: () async {
        try {
          // Create an instance of SoccerApi22
          SoccerApi22 api = SoccerApi22();
          // Use the instance to call fetchPlayerDetails
          Player playerDetails = await api.fetchPlayerDetails(
              playerid: player.id,
              season:
                  2023 // Assuming you are fetching details for the current season
              );
          // Navigate to the player profile screen with the fetched details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Player_profile_screen(player: playerDetails),
            ),
          );
        } catch (e) {
          print("Failed to load player details: $e");
          // Optionally show an error message to the user
        }
      },
      leading: CircleAvatar(
        backgroundColor: Colors.white24, // Adjust as needed for your design
        child: Text(getPositionIndicator(player.position),
            style: const TextStyle(color: Colors.white)),
      ),
      title: Text(
        player.name ?? 'Unknown',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Text(
        player.number?.toString() ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

// Builds the section for the coach, including their photo
  Widget _buildCoachSection({required Coach coach}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(coach.photo),
      ),
      title: Text(
        coach.name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        'Coach',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildTeamLineupBox(Lineup lineup) {
    // Define the color for the starting XI box
    Color startingBoxColor = kboxColor; // Defined in your constants

    // Define the color for the substitutes box
    Color substitutesBoxColor = ksecondBoxColor; // Defined in your constants

    // Starting XI box including the coach
    Widget startingXIBox = Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: startingBoxColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Display the coach
          _buildCoachSection(coach: lineup.coach),
          const Divider(color: Colors.white54),
          Text(
            lineup.formation, // Display the team formation
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          ...lineup.startXI.map(
              (player) => _buildPlayerRow(player)), // List of starting players
        ],
      ),
    );

    // Substitutes box
    Widget substitutesBox = Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: substitutesBoxColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Substitutes', // Title for substitutes box
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const Divider(color: Colors.white54),
          ...lineup.substitutes.map((player) =>
              _buildPlayerRow(player)), // List of substitute players
        ],
      ),
    );

    // Combine the two boxes into one column to return as the lineup
    return Column(
      children: [
        startingXIBox,
        substitutesBox,
      ],
    );
  }

  Widget _buildMatchInfoBox(MatchInfo matchInfo) {
    // Format dateTime to a readable string
    String formattedDate =
        DateFormat('EEE d MMM yyyy').format(matchInfo.dateTime);
    String formattedTime = DateFormat('HH:mm').format(matchInfo.dateTime);
    // Extracting only the number from the round information
    RegExp regExp = RegExp(r'\d+');
    String roundNumber = regExp.firstMatch(matchInfo.round)?.group(0) ?? "N/A";

    // Combining league name with the extracted round number
    String leagueAndRound = "${matchInfo.league.name}, Round: $roundNumber";
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today, formattedDate),
          _buildInfoRow(Icons.access_time, formattedTime),
          _buildInfoRow(Icons.sports_soccer, leagueAndRound),
          _buildInfoRow(Icons.stadium,
              matchInfo.stadium.name + ', ' + matchInfo.stadium.city),
          if (matchInfo.referee != null)
            _buildInfoRow(Icons.sports, matchInfo.referee!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(
            "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png", // Replace with your actual logo asset
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 8),
          const Text(
            'Match Details',
            style: TextStyle(color: Colors.white),
          )
        ]),
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<SoccerMatch>(
        future: matchDetailsFuture,
        builder: (context, matchSnapshot) {
          if (matchSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (matchSnapshot.hasError) {
            return Center(child: Text('Error: ${matchSnapshot.error}'));
          } else if (matchSnapshot.hasData) {
            SoccerMatch match = matchSnapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildMatchHeader(match),
                  _buildSectionButtons(match),
                  _buildSectionContent(match), // Pass the match data here
                ],
              ),
            );
          } else {
            return const Center(child: Text('No match data available'));
          }
        },
      ),
    );
  }
}
