import 'package:flutter/material.dart';
import 'package:football_app/screens/Team_details.dart';
import 'package:football_app/screens/Player_profile.dart';

import 'package:football_app/services/Player_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<TeamInfo> _teams = [];
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final teams = await SoccerApi10().fetchTeams();
      final players = await SoccerApi12().fetchtopscorers(_searchQuery);
      setState(() {
        _teams = teams;
        _players = players;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  void _updateSearchQuery(String query) {
  setState(() {
    _searchQuery = query;
    _fetchData(); 
  });
}


  List<TeamInfo> _searchTeams(String query) {
    return _teams.where((team) => team.teamName.toLowerCase().contains(query.trim().toLowerCase())).toList();
  }

  List<Player> _searchPlayers(String query) {
  return _players.where((player) => player.name.toLowerCase().contains(query.trim().toLowerCase())).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Search for a team or player',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return const Center(
        child: Text('Enter a search term to start searching.'),
      );
    }

    final List<TeamInfo> filteredTeams = _searchTeams(_searchQuery);
    final List<Player> filteredPlayers = _searchPlayers(_searchQuery);

    if (filteredTeams.isNotEmpty || filteredPlayers.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredTeams.length + filteredPlayers.length,
        itemBuilder: (context, index) {
          if (index < filteredTeams.length) {
            final team = filteredTeams[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(team.logoUrl),
              ),
              title: Text(team.teamName),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TeamDetailPage(teamInfo: team,),
                ));
              },
            );
          } else {
            final player = filteredPlayers[index - filteredTeams.length];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(player.picture),
              ),
              title: Text(player.name),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Player_profile_screen(player: player),
                ));
              },
            );
          }
        },
      );
    } else {
      return const Center(
        child: Text('No results found.'),
      );
    }
  }
}
