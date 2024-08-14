// Correct import path for TeamDetail
import 'package:football_app/screens/Team_details.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SoccerApii {
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

class SoccerApi2i {
  // Add parameters for league, season, and teamId to make the function more flexible
  Future<TeamStatistics> fetchTeamStatistics(
      {required int league, required int season, required int teamId}) async {
    final String url =
        'https://v3.football.api-sports.io/teams/statistics?league=$league&season=$season&team=$teamId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key here
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return TeamStatistics.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load team statistics');
    }
  }
}

class SoccerApi3i {
  Future<List<PlayerSquad>> fetchTeamSquad({required int teamId}) async {
    // Adjusted URL to the correct endpoint
    final String url =
        'https://v3.football.api-sports.io/players/squads?team=$teamId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Ensure the parsing logic matches the API response structure
      final List<dynamic> playersList = jsonResponse['response'][0]['players'];
      return playersList
          .map<PlayerSquad>((json) => PlayerSquad.fromJson(json))
          .toList();
    } else {
      // Log the error or handle it as you see fit
      throw Exception(
          'Failed to load team squad with status code: ${response.statusCode}');
    }
  }
}

class SoccerApi4i {
  Future<List<Transfer>> fetchTeamTransfers({required int teamId}) async {
    // Adjust the URL to the correct endpoint for transfers. This is just an example URL.
    final String url =
        'https://v3.football.api-sports.io/transfers?team=$teamId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Adjust the parsing logic according to the actual structure of the transfer data in the API response
      final List<dynamic> transfersList = jsonResponse['response'];
      return transfersList
          .map<Transfer>((json) => Transfer.fromJson(json))
          .toList();
    } else {
      // Log the error or handle it as you see fit
      throw Exception(
          'Failed to load team transfers with status code: ${response.statusCode}');
    }
  }
}

class SoccerApi5i {
  Future<List<Match>> fetchTeamMatches({
    required int teamId,
  }) async {
    // Adjust the URL to the correct endpoint for matches. This is an example URL.
    final String url =
        'https://v3.football.api-sports.io/fixtures?team=$teamId&season=2023';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Adjust the parsing logic according to the actual structure of the match data in the API response
      final List<dynamic> matchesList = jsonResponse['response'];
      return matchesList.map<Match>((json) => Match.fromJson(json)).toList();
    } else {
      // Handle errors appropriately
      throw Exception(
          'Failed to load team matches with status code: ${response.statusCode}');
    }
  }
}

class SoccerApi6i {
  Future<List<PlayerStatistic>> fetchPlayerStatistics(
      {required int teamId, required int season}) async {
    final String url =
        'https://v3.football.api-sports.io/players?team=$teamId&season=$season';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList
          .map<PlayerStatistic>((json) => PlayerStatistic.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class SoccerApi7i {
  Future<List<TeamStanding>> fetchTeamStandings(
      {required int leagueId, required int season}) async {
    final String url =
        'https://v3.football.api-sports.io/standings?league=$leagueId&season=$season';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> standingsList =
          jsonResponse['response'][0]['league']['standings'][0];
      return standingsList
          .map<TeamStanding>((json) => TeamStanding.fromJson(json))
          .toList();
    } else {
      // Optional: for debugging
      throw Exception('Failed to load team standings');
    }
  }
}class soccerApi13{
Future<TeamInfo> fetchTeamDetailsById(int teamId) async {
    final String url = 'https://v3.football.api-sports.io/teams?id=$teamId';
    final response = await http.get(Uri.parse(url), headers: {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final result = body['response']
          [0]; // Assuming the team details are in the first element
      return TeamInfo.fromJson(result);
    } else {
      throw Exception('Failed to load team details');
    }
  }}
  class SoccerApi9 {
   Future<TeamInfo> fetchMatchDetailsById(int matchid) async {
    final String url = 'https://v3.football.api-sports.io/teams?id=$matchid';
    final response = await http.get(Uri.parse(url), headers: {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final result = body['response']
          [0]; // Assuming the team details are in the first element
      return TeamInfo.fromJson(result);
    } else {
      throw Exception('Failed to load team details');
    }
  }
 
}
  

  