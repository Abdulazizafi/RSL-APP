import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:football_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:football_app/screens/Team_details.dart';

class SoccerApi {
  Future<List<TeamInfo>> fetchTeams() async {
    const String apiUrl =
        'https://v3.football.api-sports.io/teams?league=307&season=2023';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key':
          "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Replace with your actual API key
    };

    final response = await http.get(
        Uri.parse(
          apiUrl,
        ),
        headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Assuming the structure of the response is such that the teams' information
      // is under `response` key and directly accessible
      List<dynamic> teamsData = body['response'];

      // Map each team's JSON data to a TeamInfo object
      return teamsData
          .map<TeamInfo>((json) => TeamInfo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load team information');
    }
  }
}

class SoccerApi9 {
  Future<List<TeamInfo>> fetchTeams({required int teamId}) async {
    String apiUrl = 'https://v3.football.api-sports.io/teams?id=$teamId';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key':
          "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Replace with your actual API key
    };

    final response = await http.get(
        Uri.parse(
          apiUrl,
        ),
        headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Assuming the structure of the response is such that the teams' information
      // is under `response` key and directly accessible
      dynamic teamsData = body['response'];

      // Map each team's JSON data to a TeamInfo object
      List<TeamInfo> teamList = List<TeamInfo>.from(
          (teamsData as List).map((teamData) => TeamInfo.fromJson(teamData)));
      return teamList;
    } else {
      throw Exception(response.statusCode);
    }
  }
}

class FavoriteTeamsPage extends StatefulWidget {
  @override
  _FavoriteTeamsPageState createState() => _FavoriteTeamsPageState();
}

class _FavoriteTeamsPageState extends State<FavoriteTeamsPage> {
  List<TeamInfo> _favoriteTeams = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteTeams();
  }

  Future<void> _loadFavoriteTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeamIds = prefs.getStringList('favorites') ?? [];
    List<TeamInfo> teams = [];
    for (String teamId in favoriteTeamIds) {
      List<TeamInfo> team =
          await SoccerApi9().fetchTeams(teamId: int.parse(teamId));
      if (team.isNotEmpty) {
        teams.add(team.first);
      }
    }
    setState(() {
      _favoriteTeams = teams;
    });
  }

  Future<void> _toggleFavorite(int teamId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(teamId.toString())) {
      // Remove team from favorites
      favorites.remove(teamId.toString());
    } else {
      // Add team to favorites
      favorites.add(teamId.toString());
    }

    await prefs.setStringList('favorites', favorites);
    await _loadFavoriteTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png", // Replace with your actual logo asset
              height: 60,
              width: 60,
            ),
            const Text('Favorite Teams', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              // Navigate to a screen where user can add favorite teams
              await _showAddFavoriteDialog();
            },
          ),
        ],
        backgroundColor: kprimaryColor,
      ),
      body: ListView.builder(
        itemCount: _favoriteTeams.length,
        itemBuilder: (context, index) {
          TeamInfo teamInfo = _favoriteTeams[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(teamInfo.logoUrl),
            ),
            title: Text(
              teamInfo.teamName,
              style: TextStyle(fontSize: 18.0),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await _toggleFavorite(int.parse(teamInfo.teamId));
              },
            ),
            onTap: () {
              // Navigate to team details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamDetailPage(teamInfo: teamInfo),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddFavoriteDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeamIds = prefs.getStringList('favorites') ?? [];
    List<String> selectedTeamIds = List.from(
        favoriteTeamIds); // Initialize selectedTeamIds with the current favorites

    List<TeamInfo> allTeams = await SoccerApi().fetchTeams();

    await showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelectedTeamIds = List.from(
            selectedTeamIds); // Create a temporary list to track changes

        return AlertDialog(
          title: Text("Select Favorite Teams"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: allTeams.map((teamInfo) {
                    bool isSelected = tempSelectedTeamIds
                        .contains(teamInfo.teamId.toString());
                    return CheckboxListTile(
                      title: Text(teamInfo.teamName),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            tempSelectedTeamIds.add(teamInfo.teamId.toString());
                          } else {
                            tempSelectedTeamIds
                                .remove(teamInfo.teamId.toString());
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                // Update selectedTeamIds with the changes from tempSelectedTeamIds
                selectedTeamIds = List.from(tempSelectedTeamIds);
                await prefs.setStringList('favorites', selectedTeamIds);
                await _loadFavoriteTeams();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
