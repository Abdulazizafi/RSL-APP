import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:football_app/screens/Team_details.dart';

import '../services/table_service.dart';
import 'package:football_app/api/api_manager.dart';

class Standings {
  List<TeamStanding> standings;

  Standings({required this.standings});

  factory Standings.fromJson(Map<String, dynamic> json) {
    var standingsList = json['standings'] as List;
    List<TeamStanding> standings =
        standingsList.map((i) => TeamStanding.fromJson(i)).toList();
    return Standings(standings: standings);
  }
}

class TeamStanding {
  final String teamName;
  final String logoUrl;
  final int position;
  final int points;

  final int wins;
  final int draws;
  final int losses;
  final int playedGames;

  final String teamId;

  TeamStanding({
    required this.teamName,
    required this.logoUrl,
    required this.position,
    required this.points,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.playedGames,
    required this.teamId,
  });
  final List<TeamStanding> standings = [];
  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      teamName: json['team']['name'] as String,
      logoUrl: json['team']['logo'] as String,
      position: json['rank'] as int,
      points: json['points'] as int,
      playedGames: json['all']['played'] as int,
      wins: json['all']['win'] as int,
      draws: json['all']['draw'] as int,
      losses: json['all']['lose'] as int,
      teamId: json['team']['id'].toString(),
    );
  }
}

class SoccerApp extends StatefulWidget {
  @override
  _SoccerAppState createState() => _SoccerAppState();
}

class _SoccerAppState extends State<SoccerApp> {
  late Future<List<TeamStanding>> futureStandings;

  @override
  void initState() {
    super.initState();
    // Assuming fetchTeamStandings is correctly implemented in your service
    futureStandings = SoccerApiii().fetchTeamStandings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeamStanding>>(
      future: futureStandings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFe70066),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        } else {
          final standings = snapshot.data!;
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const CachedNetworkImageProvider(
                    "https://resources.saudi-pro-league.pulselive.com/saudi-pro-league/photo/2024/01/23/4752c67c-73ba-4794-b293-dc8c1a1d267d/Announcement.jpg",
                  ),
                  fit: BoxFit
                      .cover, // Ensures the image covers the whole container
                  // Adjust opacity without making the background too dark
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.5), // A light overlay
                    BlendMode.lighten,
                    // Lighten blend mode to keep it brightis blend mode applies the color filter by darkening
                  ),
                ),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PL',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'W',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'D',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'L',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'GD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Pts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  buildTable(standings),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildTable(List<TeamStanding> standings) {
    return Column(
      children: List.generate(
        standings.length,
        (index) {
          final TeamStanding standing = standings[index];
          return InkWell(
            onTap: () {
              // Create a TeamInfo object from the selected team's data

              _navigateToTeamDetails(context, standing as TeamStanding);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          standing.position.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        CachedNetworkImage(
                          imageUrl: standing.logoUrl,
                          height: 30,
                          width: 30,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(width: 5),
                        Text(
                          standing.teamName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(standing.playedGames.toString()),
                        Text(standing.wins.toString()),
                        Text(standing.draws.toString()),
                        Text(standing.losses.toString()),
                        Text((standing.wins - standing.losses)
                            .toString()), // Goal difference, adjust if necessary
                        Text(standing.points.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void _navigateToTeamDetails(
    BuildContext context, TeamStanding teamStanding) async {
  try {
    print('Navigating to details for team ID: ${teamStanding.teamId}');
    TeamInfo teamInfo =
        await SoccerApi().fetchTeamDetailsById(int.parse(teamStanding.teamId));
    print('Fetched team details: $teamInfo');

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamDetailPage(teamInfo: teamInfo),
        ));
  } catch (e) {
    print('Error fetching team details: $e');
  }
}
