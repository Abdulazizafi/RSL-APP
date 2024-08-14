import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images with cache

import 'package:football_app/screens/MatchDetailsScreen.dart';

import 'package:football_app/services/Team_services.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../services/Player_services.dart';
import 'Player_profile.dart';

class TeamDetailPage extends StatefulWidget {
  final TeamInfo teamInfo;

  TeamDetailPage({
    Key? key,
    required this.teamInfo,
  }) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this); // Updated length from 4 to 5
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: kprimaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(0),
              title: _buildTitleWidget(context),
            ),
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Matches'),
              Tab(text: 'Squad'),
              Tab(text: 'Transfers'),
              Tab(
                text: 'Standing',
              ),
            ]),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildMatchesTab(),
                _buildSquadTab(),
                _buildTransfersTab(),
                _buildStandingsTab()
                // Placeholder for the Line Ups content
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingsTab() {
    int leagueId = 307;
    int season = 2023;
    int teamId = int.tryParse(widget.teamInfo.teamId) ?? 0;

    // FutureBuilder to asynchronously fetch and display team standings
    return FutureBuilder<List<TeamStanding>>(
      future:
          SoccerApi7i().fetchTeamStandings(leagueId: leagueId, season: season),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error fetching standings: ${snapshot.error}"));
        } else if (snapshot.data?.isEmpty ?? true) {
          return const Center(
              child: Text("No standings information available."));
        } else {
          // Display the standings if data is available
          final standings = snapshot.data!;
          return ListView.separated(
            itemCount: standings.length,
            itemBuilder: (context, index) {
              final standing = standings[index];
              bool isHighlighted = standing.teamId == teamId.toString();
              return Container(
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? Colors.black.withOpacity(0.5)
                      : Colors.transparent,
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text('${standing.position}.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                          const SizedBox(width: 10),
                          CachedNetworkImage(
                            imageUrl: standing.logoUrl,
                            height: 24,
                            width: 24,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(standing.teamName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isHighlighted
                                          ? Colors.white
                                          : Colors.black))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(standing.playedGames.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                          Text(standing.wins.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                          Text(standing.draws.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                          Text(standing.losses.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                          Text(standing.points.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isHighlighted
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade800),
          );
        }
      },
    );
  }

  Widget _buildTitleWidget(BuildContext context) {
    return Container(
      height: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.teamInfo.logoUrl),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.teamInfo.teamName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 64,
            right: 0,
            child: FutureBuilder<bool>(
              future: isFavorite(widget.teamInfo.teamId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  final isFavorite = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () async {
                      await toggleFavorite(widget.teamInfo.teamId);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

//function for the widget

  Future<void> toggleFavorite(String teamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(teamId)) {
      // Remove team from favorites
      favorites.remove(teamId);
    } else {
      // Add team to favorites
      favorites.add(teamId);
    }

    await prefs.setStringList('favorites', favorites);
  }

  Future<bool> isFavorite(String teamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.contains(teamId);
  }

  Widget _buildOverviewTab() {
    int teamId = int.tryParse(widget.teamInfo.teamId) ?? 0;
    int leagueId = 307;
    int season = 2023;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        SoccerApi2i().fetchTeamStatistics(
            teamId: teamId, league: leagueId, season: season),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          TeamStatistics teamStats = snapshot.data![0];
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // General Team Information using _statisticGridItem
                  const Text(
                    'Team Information',
                  ),
                  const SizedBox(height: 10),
                  _statisticGridItem(
                      "City", widget.teamInfo.city, Icons.location_city),
                  _statisticGridItem(
                      "Stadium", widget.teamInfo.stadium, Icons.stadium),
                  _statisticGridItem("Founded",
                      widget.teamInfo.founded.toString(), Icons.event),
                  _statisticGridItem("Capacity",
                      widget.teamInfo.capacity.toString(), Icons.people),
                  const Divider(height: 20, thickness: 2),
                  // Team Statistics
                  const Text(
                    "Team Statistics",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _infoRow("Games Played",
                              teamStats.totalGamesPlayed.toString())),
                      Expanded(
                          child:
                              _infoRow("Wins", teamStats.totalWins.toString())),
                      Expanded(
                          child: _infoRow(
                              "Draws", teamStats.totalDraws.toString())),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _infoRow(
                              "Losses", teamStats.totalLosses.toString())),
                      Expanded(
                          child: _infoRow(
                              "Goals For", teamStats.totalGoalsFor.toString())),
                      Expanded(
                          child: _infoRow("Goals Against",
                              teamStats.totalGoalsAgainst.toString())),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _statisticGridItem(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(value,
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        subtitle: Text(title),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Container(
      child: Card(
        color: Colors.transparent, // Make the Card widget itself transparent
        elevation: 0, // Remove any existing elevation shadow
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Match outer Container borderRadius
        ),
        child: Container(
          alignment: Alignment.center, // Ensure the container centers its child
          padding: const EdgeInsets.all(5.0), // Padding inside the card
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Use minimum space required by children
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              Text(
                value,
                textAlign: TextAlign.center, // Center text horizontally
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center, // Center text horizontally
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquadTab() {
    int teamId = int.tryParse(widget.teamInfo.teamId) ?? 0;

    return FutureBuilder<List<PlayerSquad>>(
      future: SoccerApi3i().fetchTeamSquad(teamId: teamId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching squad: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var player = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: player.photoUrl.isNotEmpty
                      ? CachedNetworkImageProvider(player.photoUrl)
                      : const AssetImage("assets/placeholder_image.png")
                          as ImageProvider,
                ),
                title: Text(player.playerName),
                subtitle: Text('${player.position}, Age: ${player.age}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Player_profile_screen(
                        player: Player(
                          id: player.id,
                          name: player.playerName,
                          picture: player.photoUrl.isNotEmpty
                              ? player.photoUrl
                              : 'assets/placeholder_image.png',
                          position: player.position,
                          age: player.age,
                          teamName: widget.teamInfo
                              .teamName, // Use the actual team name from the team info
                          nationality: 'N/A', // Placeholder
                          weight: 'N/A', // Placeholder
                          birthdate: '2000-01-01', // Example placeholder
                          goals: player.goals,
                          assists: player.assists,
                          height: 'N/A',
                          rating: player.rating,
                          matches: player.matches,
                          started: 0,
                          minutesplayed: 0,
                          teampic: widget.teamInfo
                              .logoUrl, // Use the actual team logo from the team info
                          teamid: teamId,
                          yellowcards: player.yellowcards,
                          redcards: 0,
                          shirt: 0,
                          injury: false,
                          team: TeamInfo(
                              teamId: widget.teamInfo.teamId,
                              teamName: widget.teamInfo.teamName,
                              logoUrl: widget.teamInfo.logoUrl,
                              city: widget.teamInfo.city,
                              stadium: widget.teamInfo.stadium,
                              founded: widget.teamInfo.founded,
                              capacity: widget.teamInfo.capacity),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No squad information available"));
        }
      },
    );
  }

  Widget _buildTransfersTab() {
    int teamId = int.tryParse(widget.teamInfo.teamId) ?? 0;

    return FutureBuilder<List<Transfer>>(
      future:
          SoccerApi4i().fetchTeamTransfers(teamId: teamId).then((transfers) {
        // Sort transfers based on date, from newer to older
        transfers.sort((a, b) {
          var dateA = a.transfers.isNotEmpty
              ? DateTime.parse(a.transfers.first.date)
              : DateTime(0000, 01, 01);
          var dateB = b.transfers.isNotEmpty
              ? DateTime.parse(b.transfers.first.date)
              : DateTime(0000, 01, 01);
          return dateB.compareTo(
              dateA); // Reverse the order here by swapping dateB and dateA
        });
        return transfers;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
                  "Error fetching transfers: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              var transfer = snapshot.data![index];
              var transferDetail = transfer.transfers.isNotEmpty
                  ? transfer.transfers.first
                  : null;
              var fromTeamLogo = transferDetail?.outTeam.logo ??
                  'assets/placeholder_image.png';
              var toTeamLogo =
                  transferDetail?.inTeam.logo ?? 'assets/placeholder_image.png';

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    // From and To Team Logos
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.network(fromTeamLogo,
                              width: 40,
                              errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/placeholder_image.png',
                                  width: 40)),
                          const SizedBox(width: 5),
                          const Text('→', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 5),
                          Image.network(toTeamLogo,
                              width: 40,
                              errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/placeholder_image.png',
                                  width: 40)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Transfer Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(transfer.player.name ?? 'Unknown Player',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${transferDetail?.outTeam.name ?? "Unknown"} To ${transferDetail?.inTeam.name ?? "Unknown"}'),
                          Text(
                              'Transfer Date: ${DateFormat('MMM d, yyyy').format(DateTime.parse(transferDetail?.date ?? '0000-01-01'))}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("No transfer information available"));
        }
      },
    );
  }

  Widget _buildMatchesTab() {
    int teamId = int.tryParse(widget.teamInfo.teamId) ?? 0;

    if (teamId == 0) {
      return const Center(child: Text('Invalid team ID'));
    }

    // The FutureBuilder is now the main content of your method
    return FutureBuilder<List<Match>>(
      future: SoccerApi5i().fetchTeamMatches(teamId: teamId),
      builder: (BuildContext context, AsyncSnapshot<List<Match>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint('Error fetching matches: ${snapshot.error}');
          return const Center(child: Text('Error fetching matches'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Match> allMatches = snapshot.data!;
          allMatches.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

          final now = DateTime.now();
          List<Match> upcomingMatches = allMatches
              .where((m) => DateTime.parse(m.date).isAfter(now))
              .toList();
          List<Match> pastMatches = allMatches
              .where((m) => DateTime.parse(m.date).isBefore(now))
              .toList();
          return DefaultTabController(
            length: 2, // Number of tabs
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // Reduce the toolbar height to minimize space, adjust this value as needed.
                toolbarHeight:
                    0, // Default is 56.0 for mobile, adjust according to your needs
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Upcoming Matches'),
                    Tab(text: 'Past Matches'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // These widgets are your custom method for building match lists
                  _buildMatchList(upcomingMatches, 'Upcoming Matches'),
                  _buildMatchList(pastMatches, 'Past Matches'),
                ],
              ),
            ),
          );
        } else {
          return const Center(
              child: Text("No matches available for the selected team"));
        }
      },
    );
  }

  Widget _buildMatchList(List<Match> matches, String title) {
    if (matches.isEmpty) {
      return Center(child: Text('$title: None'));
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return _buildMatchTile(context, matches[index]);
      },
    );
  }

// _buildMatchTile remains the same

  Widget _buildMatchTile(BuildContext context, Match match) {
    DateTime utcMatchDateTime = DateTime.parse(match.date).toUtc();
    DateTime localMatchDateTime = utcMatchDateTime
        .add(const Duration(hours: 3)); // Adjust for local time zone if needed
    String formattedDate = DateFormat('EEE, d MMM').format(localMatchDateTime);
    String formattedTime = DateFormat('h:mm a').format(localMatchDateTime);
    bool isUpcomingMatch =
        localMatchDateTime.isAfter(DateTime.now()); // Makkah time assumed

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailsScreen(fixtureId: match.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: match.homeTeamLogo,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.homeTeamName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(color: Colors.black),
                      ),
                      if (!isUpcomingMatch)
                        Text(
                          '${match.homeGoals} - ${match.awayGoals}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      match.awayTeamName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CachedNetworkImage(
                    imageUrl: match.awayTeamLogo,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamInfo {
  final String teamId;
  final String teamName;
  final String logoUrl;
  final String city;
  final String stadium;
  final int founded;
  final int capacity;

  TeamInfo({
    required this.teamId,
    required this.teamName,
    required this.logoUrl,
    required this.city,
    required this.stadium,
    required this.founded,
    required this.capacity,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      teamId: json['team']['id']
          .toString(), // Assuming ID is a numeric value, converting to String
      teamName: json['team']['name'],
      logoUrl: json['team']['logo'],
      city: json['venue']['city'],
      stadium: json['venue']['name'],
      founded: json['team']['founded'] is int ? json['team']['founded'] : 0,
      capacity:
          json['venue']['capacity'] is int ? json['venue']['capacity'] : 0,
    );
  }

  fromJson(json) {}
}

class TeamStatistics {
  final int totalGamesPlayed;
  final int totalWins;
  final int totalDraws;
  final int totalLosses;
  final int totalGoalsFor;
  final int totalGoalsAgainst;

  // You can add more fields as needed based on the response data

  TeamStatistics({
    required this.totalGamesPlayed,
    required this.totalWins,
    required this.totalDraws,
    required this.totalLosses,
    required this.totalGoalsFor,
    required this.totalGoalsAgainst,
  });

  factory TeamStatistics.fromJson(Map<String, dynamic> json) {
    final fixtures = json['response']['fixtures'];
    final goals = json['response']['goals']['for']['total'];

    return TeamStatistics(
      totalGamesPlayed: int.parse(fixtures['played']['total'].toString()),

      totalWins: fixtures['wins']['total'] as int,
      totalDraws: fixtures['draws']['total'] as int,
      totalLosses: fixtures['loses']['total'] as int,
      totalGoalsFor: goals['total'] as int,
      totalGoalsAgainst: goals['total']
          as int, // Ensure this is correct; you may need to adjust based on actual JSON structure
    );
  }
}

class PlayerSquad {
  final int id;
  final String playerName;
  final int age;
  final String position;
  final String photoUrl;
  final int goals;
  final int assists;
  final String? rating;
  final int matches;
  final int yellowcards;
  final int minutesplayed;
  PlayerSquad({
    required this.id,
    required this.playerName,
    required this.age,
    required this.position,
    required this.photoUrl,
    required this.goals,
    required this.assists,
    required this.rating,
    required this.matches,
    required this.minutesplayed,
    required this.yellowcards,
  });

  factory PlayerSquad.fromJson(Map<String, dynamic> json) {
    return PlayerSquad(
      id: json['id'] as int,
      playerName: json['name'] as String,
      age: json['age'] as int,
      position: json['position'] as String,
      photoUrl: json['photo'] as String,
      goals: json['statistics']?[0]['goals']?['total'] as int? ?? 0,
      assists: json['statistics']?[0]['goals']?['assists'] as int? ?? 0,
      rating: json['statistics']?[0]['games']?['rating'] as String? ?? '0.0',
      matches: json['statistics']?[0]['games']?['appearences'] as int? ?? 0,
      minutesplayed: json['statistics']?[0]['games']['minutes'] as int? ?? 0,
      yellowcards: json['statistics']?[0]['cards']?['yellow'] as int? ?? 0,
    );
  }
}

class Transfer {
  final PlayerT player;
  final String update; // Assuming you might need the update timestamp
  final List<TransferDetail> transfers;

  Transfer({
    required this.player,
    required this.update,
    required this.transfers,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    var transferList = json['transfers'] as List;
    List<TransferDetail> transferDetails =
        transferList.map((i) => TransferDetail.fromJson(i)).toList();
    return Transfer(
      player: PlayerT.fromJson(json['player']),
      update: json['update'],
      transfers: transferDetails,
    );
  }
}

class PlayerT {
  final int? id;
  final String? name; // Making name nullable
  final String? photoUrl;
  PlayerT({
    this.id,
    this.name,
    required this.photoUrl,
  });

  factory PlayerT.fromJson(Map<String, dynamic> json) {
    return PlayerT(
      id: json['id'] as int?,
      name: json['name'] as String?,
      photoUrl: json['photo'] as String?,
    );
  }
}

class TransferDetail {
  final String date;
  final String? type; // Making type nullable
  final Teams inTeam;
  final Teams outTeam;

  TransferDetail(
      {required this.date,
      this.type,
      required this.inTeam,
      required this.outTeam});

  factory TransferDetail.fromJson(Map<String, dynamic> json) {
    return TransferDetail(
      date: json['date'],
      type: json['type'] as String?,
      inTeam: Teams.fromJson(json['teams']['in']),
      outTeam: Teams.fromJson(json['teams']['out']),
    );
  }
}

class Teams {
  final int? id;
  final String? name; // Making name nullable
  final String? logo; // Making logo nullable

  Teams({this.id, this.name, this.logo});

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      id: json['id'] as int?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
    );
  }
}

class Match {
  final int id;
  final String date;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeGoals;
  final int awayGoals;

  Match({
    required this.id,
    required this.date,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeGoals,
    required this.awayGoals,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['fixture']['id'] as int,
      date: json['fixture']['date'] as String,
      homeTeamName: json['teams']['home']['name'] as String,
      awayTeamName: json['teams']['away']['name'] as String,
      homeTeamLogo: json['teams']['home']['logo'] as String,
      awayTeamLogo: json['teams']['away']['logo'] as String,
      homeGoals: json['goals']['home'] ??
          0, // Handles null by providing a default value
      awayGoals: json['goals']['away'] ??
          0, // Handles null by providing a default value
    );
  }
}

class PlayerStatistic {
  final String playerName;
  final String teamName;
  final String? rating;

  PlayerStatistic({
    required this.playerName,
    required this.teamName,
    this.rating,
  });

  factory PlayerStatistic.fromJson(Map<String, dynamic> json) {
    final player = json['player'];
    final stats = json['statistics']?[0] ?? {};

    return PlayerStatistic(
      playerName: player['name'],
      teamName: stats['team'] != null ? stats['team']['name'] : 'N/A',
      rating: stats['games']?['rating'],
    );
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
  final String teamId; // Make sure this exists

  // Include teamId in your constructor and JSON parsing
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
